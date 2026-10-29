--- @since 26.9.1

-- Show detailed metadata of the hovered file in a floating window.
-- q / <Esc> / i: close, y: copy everything to the clipboard.

local toggle_ui = ya.sync(function(self)
	if self.children then
		Modal:children_remove(self.children)
		self.children = nil
	else
		self.children = Modal:children_add(self, 10)
	end
	ui.render()
end)

local update = ya.sync(function(self, title, data, text)
	self.title, self.data, self.text = title, data, text
	ui.render()
end)

local snapshot = ya.sync(function()
	local h = cx.active.current.hovered
	if not h then
		return nil
	end

	local cha = h.cha
	return {
		name = h.name,
		path = tostring(h.url),
		link_to = h.link_to and tostring(h.link_to) or nil,
		is_dir = cha.is_dir,
		is_link = cha.is_link,
		len = cha.len,
		size = h:size(),
		mime = h:mime(),
		perm = cha:perm(),
		mode = cha.mode,
		uid = cha.uid,
		gid = cha.gid,
		nlink = cha.nlink,
		atime = cha.atime,
		mtime = cha.mtime,
		btime = cha.btime,
		ctime = cha.ctime,
	}
end)

-- ---------------------------------------------------------------------------
-- Helpers
-- ---------------------------------------------------------------------------

-- Thousands separator for the current locale (es: 1.234.567).
local function thousands(n)
	local s = tostring(math.floor(n))
	local out = s:reverse():gsub("(%d%d%d)", "%1."):reverse()
	return (out:gsub("^%.", ""))
end

local function human_size(n)
	if not n then
		return nil
	end

	local units = { "B", "KiB", "MiB", "GiB", "TiB", "PiB" }
	local i, v = 1, n
	while v >= 1024 and i < #units do
		v, i = v / 1024, i + 1
	end

	if i == 1 then
		return string.format("%d B", n)
	end
	return string.format("%.2f %s (%s bytes)", v, units[i], thousands(n))
end

local function date(ts)
	if not ts or ts <= 0 then
		return nil
	end
	return os.date("%Y-%m-%d %H:%M:%S", math.floor(ts))
end

local function duration(secs)
	secs = tonumber(secs)
	if not secs then
		return nil
	end

	local h = math.floor(secs / 3600)
	local m = math.floor(secs % 3600 / 60)
	local s = math.floor(secs % 60)
	if h > 0 then
		return string.format("%d:%02d:%02d", h, m, s)
	end
	return string.format("%02d:%02d", m, s)
end

local function mode_octal(mode)
	if not mode then
		return nil
	end
	return string.format("0%o", mode % 4096)
end

-- Run a command and return its stdout, or nil when it is unavailable/failed.
local function run(program, args)
	local output, err = Command(program):arg(args):output()
	if not output then
		return nil, err
	end
	if not output.status.success then
		return nil, output.stderr
	end
	return output.stdout
end

-- Human description produced by `file`, e.g. "PNG image data, 1920 x 1080".
local function file_description(path)
	local out = run("file", { "-bL", "--", path })
	if not out then
		return nil
	end
	return (out:gsub("%s+$", ""))
end

-- Compact EXIF summary for images.
local function image_info(path)
	local out = run("exiftool", {
		"-j",
		"-ImageWidth",
		"-ImageHeight",
		"-Make",
		"-Model",
		"-LensModel",
		"-DateTimeOriginal",
		"--",
		path,
	})
	if not out then
		return nil
	end

	local ok, t = pcall(ya.json_decode, out)
	if not ok or type(t) ~= "table" or type(t[1]) ~= "table" then
		return nil
	end

	local d = t[1]
	local parts = {}
	if d.ImageWidth and d.ImageHeight then
		parts[#parts + 1] = string.format("%sx%s px", d.ImageWidth, d.ImageHeight)
	end
	if d.Make or d.Model then
		parts[#parts + 1] = (table.concat({ d.Make or "", d.Model or "" }, " "):gsub("^%s+", ""))
	end
	if d.LensModel then
		parts[#parts + 1] = d.LensModel
	end
	if d.DateTimeOriginal then
		parts[#parts + 1] = (d.DateTimeOriginal:gsub("^(%d+):(%d+):(%d+)", "%1-%2-%3"))
	end

	if #parts == 0 then
		return nil
	end
	return table.concat(parts, " · ")
end

-- Compact audio/video summary via ffprobe.
local function av_info(path)
	local out = run("ffprobe", {
		"-v",
		"quiet",
		"-print_format",
		"json",
		"-show_format",
		"-show_streams",
		"--",
		path,
	})
	if not out then
		return nil
	end

	local ok, t = pcall(ya.json_decode, out)
	if not ok or type(t) ~= "table" then
		return nil
	end

	local parts = {}
	local video, audio
	for _, s in ipairs(t.streams or {}) do
		if s.codec_type == "video" and not video then
			video = s
		elseif s.codec_type == "audio" and not audio then
			audio = s
		end
	end

	if video then
		if video.width and video.height then
			parts[#parts + 1] = string.format("%dx%d px", video.width, video.height)
		end
		if video.codec_name then
			parts[#parts + 1] = video.codec_name
		end
	end
	if audio then
		local a = audio.codec_name or "audio"
		if audio.channels then
			a = a .. string.format(" %dch", audio.channels)
		end
		if audio.sample_rate then
			a = a .. string.format(" %gkHz", tonumber(audio.sample_rate) / 1000)
		end
		parts[#parts + 1] = a
	end

	local fmt = t.format or {}
	if fmt.duration then
		parts[#parts + 1] = duration(fmt.duration)
	end
	if fmt.bit_rate then
		local br = tonumber(fmt.bit_rate)
		if br >= 1e6 then
			parts[#parts + 1] = string.format("%.1f Mbps", br / 1e6)
		else
			parts[#parts + 1] = string.format("%d kbps", math.floor(br / 1e3))
		end
	end

	if #parts == 0 then
		return nil
	end
	return table.concat(parts, " · ")
end

-- ---------------------------------------------------------------------------
-- Component
-- ---------------------------------------------------------------------------

local M = {
	title = "Info",
	data = {},
	text = "",
	keys = {
		{ on = "q", run = "quit" },
		{ on = "<Esc>", run = "quit" },
		{ on = "i", run = "quit" },
		{ on = "y", run = "copy" },
	},
}

function M:new(area)
	local w = math.min(area.w - 2, math.max(30, math.floor(area.w * 0.7)))
	local h = math.min(area.h - 2, math.max(8, math.floor(area.h * 0.7)))
	self._area = ui.Rect {
		x = math.floor((area.w - w) / 2),
		y = math.floor((area.h - h) / 2),
		w = w,
		h = h,
	}
	return self
end

function M:reflow() return { self } end

function M:redraw()
	local lines = {}
	for _, row in ipairs(self.data or {}) do
		if row[1] == 0 then
			lines[#lines + 1] = ui.Line { ui.Span(row[2]):bold():fg("yellow") }
		elseif row[1] == 2 then
			lines[#lines + 1] = ui.Line("")
		else
			lines[#lines + 1] = ui.Line {
				ui.Span(string.format("%-13s", row[2])):fg("blue"),
				ui.Span(row[3]),
			}
		end
	end

	lines[#lines + 1] = ui.Line("")
	lines[#lines + 1] = ui.Line {
		ui.Span("q/Esc"):bold():fg("green"),
		ui.Span(" close   "):dim(),
		ui.Span("y"):bold():fg("green"),
		ui.Span(" copy"):dim(),
	}

	return {
		ui.Clear(self._area),
		ui.Border(ui.Edge.ALL):area(self._area):type(ui.Border.ROUNDED):title(
			ui.Line(" " .. (self.title or "Info") .. " "):align(ui.Align.CENTER)
		),
		ui.Text(lines):area(self._area:pad(ui.Pad(1, 2, 1, 2))):wrap(ui.Wrap.YES),
	}
end

function M:click() end
function M:scroll() end
function M:touch() end

-- ---------------------------------------------------------------------------
-- Entry
-- ---------------------------------------------------------------------------

function M:entry()
	local st = snapshot()
	if not st then
		ya.notify { title = "Info", content = "No file hovered", timeout = 3, level = "warn" }
		return
	end

	local data, text = {}, {}
	local function section(name)
		data[#data + 1] = { 0, name }
		text[#text + 1] = "[" .. name .. "]"
	end
	local function blank() data[#data + 1] = { 2 } end
	local function field(label, value)
		if value == nil or value == "" then
			return
		end
		data[#data + 1] = { 1, label, tostring(value) }
		text[#text + 1] = label .. ": " .. tostring(value)
	end

	section("File")
	field("Name", st.name)
	field("Path", st.path)
	if st.link_to then
		field("Symlink", st.link_to)
	end
	if st.is_dir then
		field("Type", "Directory")
	elseif st.is_link then
		field("Type", "Symbolic link")
	else
		field("Type", "File")
	end
	field("Description", file_description(st.path))
	if st.is_dir then
		field("Size", human_size(st.size))
		local files = fs.read_dir(Url(st.path), { limit = 1000 })
		if files then
			field("Entries", #files >= 1000 and "1000+" or tostring(#files))
		end
	else
		field("Size", human_size(st.len))
	end
	field("MIME", st.mime)
	field("Permissions", string.format("%s (%s)", st.perm or "-", mode_octal(st.mode) or "-"))
	field("Owner", string.format(
		"%s:%s (%s:%s)",
		ya.user_name(st.uid) or "-",
		ya.group_name(st.gid) or "-",
		tostring(st.uid or "-"),
		tostring(st.gid or "-")
	))
	field("Hard links", st.nlink)

	blank()
	section("Times")
	field("Modified", date(st.mtime))
	field("Accessed", date(st.atime))
	field("Changed", date(st.ctime))
	field("Created", date(st.btime))

	local media
	if st.mime then
		if st.mime:match("^image/") then
			media = image_info(st.path)
		elseif st.mime:match("^video/") or st.mime:match("audio/") then
			media = av_info(st.path)
		end
	end

	if media then
		blank()
		section("Media")
		field("Details", media)
	end

	update(st.name, data, table.concat(text, "\n"))
	toggle_ui()

	while true do
		local idx = ya.which { cands = self.keys, silent = true }
		local action = idx and self.keys[idx].run
		if not action or action == "quit" then
			break
		elseif action == "copy" then
			local ok, err = pcall(ya.clipboard, self.text)
			ya.notify {
				title = "Info",
				content = ok and "Metadata copied to clipboard" or ("Copy failed: " .. tostring(err)),
				timeout = 3,
				level = ok and "info" or "error",
			}
		end
	end

	toggle_ui()
end

return M
