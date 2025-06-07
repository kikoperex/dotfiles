#!/bin/bash

# Theme switcher script for wofi + pywal + hyprpaper
# Save as ~/.config/scripts/theme-switcher.sh

WALLPAPER_DIR="$HOME/wallpapers"
HYPRPAPER_CONFIG="$HOME/.config/hypr/hyprpaper.conf"

# Check if wallpaper directory exists
if [ ! -d "$WALLPAPER_DIR" ]; then
    notify-send "Theme Switcher" "Wallpaper directory not found: $WALLPAPER_DIR"
    exit 1
fi

# Get list of image files and show in wofi
selected_wallpaper=$(find "$WALLPAPER_DIR" -type f \( -iname "*.jpg" -o -iname "*.jpeg" -o -iname "*.png" -o -iname "*.webp" \) -exec basename {} \; | sort | wofi --show dmenu --prompt "Select wallpaper:")

# Exit if no selection made
if [ -z "$selected_wallpaper" ]; then
    exit 0
fi

# Full path to selected wallpaper
wallpaper_path="$WALLPAPER_DIR/$selected_wallpaper"

# Check if file exists
if [ ! -f "$wallpaper_path" ]; then
    notify-send "Theme Switcher" "Wallpaper file not found: $wallpaper_path"
    exit 1
fi

# Update hyprpaper config
cat > "$HYPRPAPER_CONFIG" << EOF
preload = $wallpaper_path
wallpaper = ,$wallpaper_path
EOF

# Kill existing hyprpaper and restart it
pkill hyprpaper
hyprpaper &

# Generate new pywal theme
wal -i "$wallpaper_path" --cols16 --saturate 0.7

# Restart services that use pywal colors (optional - uncomment what you use)
# pkill waybar && waybar &
# pkill dunst && dunst &

# Send notification
notify-send "Theme Switcher" "Theme changed to: $selected_wallpaper"
