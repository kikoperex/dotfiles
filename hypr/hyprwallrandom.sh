#!/usr/bin/env bash

WALLPAPER_DIR="$HOME/wallpapers/"
CURRENT_WALL=$(hyprctl hyprpaper listloaded)

# Get a random wallpaper that is not the current one
WALLPAPER=$(find "$WALLPAPER_DIR" -type f ! -name "$(basename "$CURRENT_WALL")" | shuf -n 1)

# Apply the selected wallpaper
wal -i "$WALLPAPER" --cols16 --backend haishoku --saturate 0.5 -b 000000 -n
hyprctl hyprpaper reload ,"$WALLPAPER"
