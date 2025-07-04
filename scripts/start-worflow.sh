#!/bin/bash

# Esperamos un poco para asegurarnos de que Hyprland ya está completamente listo
sleep 2

# Workspace 10 y lanzar Zen Browser
hyprctl dispatch workspace 10
sleep 1
zen-browser &

# Workspace 8 y lanzar Spotify
sleep 1
hyprctl dispatch workspace 8
sleep 1
spotify &

# Volver a Workspace 10
sleep 1
hyprctl dispatch workspace 10

# Esperar a que las ventanas terminen de cargar
sleep 5

# Mover ventana de WhatsApp al workspace 9
WHATSAPP_WINDOW=$(hyprctl clients | grep -B5 "title:.*WhatsApp" | grep "address" | awk '{print $2}')
if [ -n "$WHATSAPP_WINDOW" ]; then
    hyprctl dispatch movetoworkspacesilent 9,address:$WHATSAPP_WINDOW
fi

# Conectar Bluetooth
echo -e "connect B0:F0:0C:30:75:EC\nexit" | bluetoothctl
