-- Hyprland 0.57+ configuration.
-- The legacy hyprland.conf is deliberately kept beside this file as a backup.
--
-- Restart Hyprland after changing this file. A live `hyprctl reload` only works
-- once the session was started with this Lua config; a session started from
-- hyprland.conf keeps using the legacy parser until it is restarted.

local terminal = "kitty"
local fileManager = "dolphin"
local menu = "wofi --show drun"
local browser = "zen-browser"

-- These are the two palette values consumed by Hyprland itself.  The full
-- Hyprlang palette remains in ../theme/colors-hyprland.conf for hyprlock.
local colors = {
    accent = "rgb(d8e6ea)",
    color8 = "rgb(3a4348)",
}

------------------
---- MONITORS ----
------------------

hl.monitor({
    output = "",
    mode = "preferred",
    position = "auto",
    scale = "1",
})

-------------------
---- AUTOSTART ----
-------------------

hl.on("hyprland.start", function()
    hl.exec_cmd("hyprpaper")
    hl.exec_cmd("bluetoothctl connect B0:F0:0C:30:75:EC")
    hl.exec_cmd("waybar")
end)

-------------------------------
---- ENVIRONMENT VARIABLES ----
-------------------------------

hl.env("XCURSOR_THEME", "Vimix-cursors")
hl.env("XCURSOR_SIZE", "12")
hl.env("QT_QPA_PLATFORM", "wayland")
hl.env("QT_QPA_PLATFORMTHEME", "gtk3")

-----------------------
---- LOOK AND FEEL ----
-----------------------

hl.config({
    general = {
        gaps_in = 2,
        gaps_out = 4,
        border_size = 2,
        col = {
            active_border = { colors = { colors.accent, colors.color8 }, angle = 45 },
            inactive_border = "rgba(333c41aa)",
        },
        resize_on_border = false,
        allow_tearing = false,
        layout = "dwindle",
    },

    decoration = {
        rounding = 5,
        rounding_power = 2,
        active_opacity = 0.9,
        inactive_opacity = 0.6,
        shadow = {
            enabled = false,
            range = 4,
            render_power = 3,
            color = "rgba(000000ee)",
        },
        blur = {
            enabled = true,
            size = 8,
            passes = 3,
            vibrancy = 0.2696,
        },
    },

    animations = { enabled = true },

    master = { new_status = "master" },

    misc = {
        force_default_wallpaper = -1,
        disable_hyprland_logo = true,
    },

    input = {
        kb_layout = "latam,latam",
        kb_variant = ",dvorak",
        kb_model = "",
        kb_options = "",
        kb_rules = "",
        follow_mouse = 1,
        sensitivity = -0.1,
        accel_profile = "flat",
        touchpad = {
            disable_while_typing = false,
            natural_scroll = true,
        },
    },

    cursor = { no_hardware_cursors = true },
})

------------------
---- ANIMATIONS ---
------------------

hl.curve("linear", { type = "bezier", points = { { 0, 0 }, { 1, 1 } } })
hl.curve("md3_standard", { type = "bezier", points = { { 0.2, 0 }, { 0, 1 } } })
hl.curve("md3_decel", { type = "bezier", points = { { 0.1, 0.6 }, { 0.2, 1 } } })
hl.curve("md3_accel", { type = "bezier", points = { { 0.3, 0 }, { 0.8, 0.1 } } })
hl.curve("overshot", { type = "bezier", points = { { 0.05, 0.85 }, { 0.1, 1.05 } } })
hl.curve("crazyshot", { type = "bezier", points = { { 0.1, 1.25 }, { 0.72, 0.9 } } })
hl.curve("hyprnostretch", { type = "bezier", points = { { 0.05, 0.85 }, { 0.1, 1.0 } } })
hl.curve("menu_decel", { type = "bezier", points = { { 0.12, 0.9 }, { 0.1, 1 } } })
hl.curve("menu_accel", { type = "bezier", points = { { 0.35, 0.05 }, { 1, 0.05 } } })
hl.curve("easeInOutCirc", { type = "bezier", points = { { 0.83, 0 }, { 0.17, 1 } } })
hl.curve("easeOutCirc", { type = "bezier", points = { { 0, 0.55 }, { 0.45, 1 } } })
hl.curve("easeOutExpo", { type = "bezier", points = { { 0.16, 1 }, { 0.3, 1 } } })
hl.curve("softAcDecel", { type = "bezier", points = { { 0.25, 0.25 }, { 0.15, 1 } } })
hl.curve("md2", { type = "bezier", points = { { 0.4, 0 }, { 0.2, 1 } } })

hl.animation({ leaf = "windows", enabled = true, speed = 3.2, bezier = "md3_decel", style = "popin 60%" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 3.2, bezier = "md3_decel", style = "popin 60%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 3.2, bezier = "md3_accel", style = "popin 60%" })
hl.animation({ leaf = "border", enabled = true, speed = 10, bezier = "linear" })
hl.animation({ leaf = "borderangle", enabled = true, speed = 100, bezier = "crazyshot", style = "loop" })
hl.animation({ leaf = "fade", enabled = true, speed = 3.2, bezier = "md3_decel" })
hl.animation({ leaf = "layersIn", enabled = true, speed = 3.2, bezier = "md3_standard", style = "fade" })
hl.animation({ leaf = "layersOut", enabled = true, speed = 2.0, bezier = "md3_standard", style = "fade" })
hl.animation({ leaf = "fadeLayersIn", enabled = true, speed = 2.5, bezier = "linear" })
hl.animation({ leaf = "fadeLayersOut", enabled = true, speed = 2.0, bezier = "linear" })
hl.animation({ leaf = "workspaces", enabled = true, speed = 5.5, bezier = "menu_decel", style = "slidefade" })
hl.animation({ leaf = "specialWorkspace", enabled = true, speed = 3.2, bezier = "md3_decel", style = "slidefade 15%" })

---------------
---- DEVICES ---
---------------

hl.device({ name = "sigmachip-usb-mouse", sensitivity = -0.25 })
hl.device({ name = "elan-touchpad", sensitivity = -0.1 })
hl.device({ name = "elan-trackpoint", sensitivity = 0.1 })

---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = "SUPER"

hl.bind(mainMod .. " + A", hl.dsp.exec_cmd(terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exit())
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(fileManager))
hl.bind(mainMod .. " + space", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + N", hl.dsp.exec_cmd("swaync-client -t -sw"))
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd("pkill wofi || " .. menu))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("pkill waybar && pkill swaync || waybar | swaync"))
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("pkill wofi || /home/kikoperex/.config/scripts/theme-switcher.sh"))
hl.bind(mainMod .. " + R", hl.dsp.exec_cmd("/home/kikoperex/.config/hypr/hyprwallrandom.sh"))
hl.bind(mainMod .. " + Y", hl.dsp.exec_cmd([[pkill gpu-screen || gpu-screen-recorder -w screen -f 60 -a default_output -c mp4 -ac aac -o ~/Videos/Grabaciones\ de\ la\ pantalla/"$(date +%Y-%m-%d_%H-%M-%S).mp4"]]))
hl.bind(mainMod .. " + SHIFT + Y", hl.dsp.exec_cmd([[pkill gpu-screen-recorder || gpu-screen-recorder -w region -region "$(slurp -w 0 | awk '{split($1,p,","); printf "%s+%s+%s\n",$2,p[1],p[2]}')" -f 60 -a default_output -c mp4 -ac aac -o ~/Videos/Grabaciones\ de\ la\ pantalla/"$(date +%Y-%m-%d_%H-%M-%S).mp4"]]))
hl.bind(mainMod .. " + CTRL + Y", hl.dsp.exec_cmd([[pkill gpu-screen || gpu-screen-recorder -w "screen|/dev/video0;halign=end;valign=end;hflip=true;width=30%;height=30%" -f 60 -a "default_output|default_input" -c mp4 -ac aac -o ~/Videos/Grabaciones\ de\ la\ pantalla/"$(date +%Y-%m-%d_%H-%M-%S).mp4"]]))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + S", hl.dsp.exec_cmd("hyprsunset -t 1000 || pkill hyprsunset"))
hl.bind(mainMod .. " + Z", hl.dsp.exec_cmd(browser))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("gnome-calculator"))
hl.bind(mainMod .. " + I", hl.dsp.exec_cmd("hyprlock"))
hl.bind("Print", hl.dsp.exec_cmd([[grim -g "$(slurp -w 0)" - | tee "/home/kikoperex/Imágenes/screenshot/screenshot-$(date +%Y%m%d-%H%M%S).png" | wl-copy]]))

hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + ntilde", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "down" }))

hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + ntilde", hl.dsp.window.move({ direction = "right" }))

for i = 1, 10 do
    local key = i % 10
    hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
    hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

hl.bind(mainMod .. " + O", hl.dsp.workspace.toggle_special("magic"))
hl.bind(mainMod .. " + SHIFT + O", hl.dsp.window.move({ workspace = "special:magic" }))
hl.bind(mainMod .. " + mouse_down", hl.dsp.focus({ workspace = "e-1" }))
hl.bind(mainMod .. " + mouse_up", hl.dsp.focus({ workspace = "e+1" }))
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+"), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-"), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd("wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%+"), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd("brightnessctl -e4 -n2 set 5%-"), { locked = true, repeating = true })
hl.bind(mainMod .. " + Next", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind(mainMod .. " + Prior", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind(mainMod .. " + SHIFT + space", hl.dsp.exec_cmd("playerctl play-pause"))

-------------------------------
---- WINDOW / LAYER RULES -----
-------------------------------

hl.window_rule({
    name = "terraria-opacity",
    match = { class = "Terraria.bin.x86_64" },
    opacity = "1.0 override 1.0 override 1.0 override",
})

hl.layer_rule({
    name = "swaync-control-center-blur",
    match = { namespace = "swaync-control-center" },
    blur = true,
    ignore_alpha = 0.5,
})

hl.layer_rule({
    name = "swaync-notification-window-blur",
    match = { namespace = "swaync-notification-window" },
    blur = true,
    ignore_alpha = 0.5,
})
