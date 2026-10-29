# info.yazi

Shows detailed metadata of the hovered file in a floating window.

## Usage

Add to `keymap.toml`:

```toml
[mgr]
keymap = [
	{ on = "i", run = "plugin info", desc = "Show file metadata" },
]
```

Keys inside the popup:

| Key | Action |
| --- | --- |
| `q`, `<Esc>`, `i` | Close |
| `y` | Copy the whole report to the clipboard |

## What it shows

- Name, path, type, `file` description, size, MIME, permissions, owner/group, hard links
- Modified, accessed, changed and created timestamps
- Symlink target
- Media details for images (EXIF: dimensions, camera, lens, date) and audio/video (ffprobe: resolution, codecs, duration, bitrate)

`file`, `exiftool` and `ffprobe` are optional: fields are hidden when the tool is missing.

## License

GPL-3.0-or-later. See [LICENSE](LICENSE).
