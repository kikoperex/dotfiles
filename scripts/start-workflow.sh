#!/bin/bash

# Esperamos un poco para asegurarnos de que Hyprland ya está completamente listo
sleep 2

# Hyprland 0.57 usa despachadores Lua en `hyprctl dispatch`. Una sesión que
# todavía corre la config vieja necesita la sintaxis clásica, así que se intenta
# Lua primero y se cae al despachador clásico si no está disponible.
dispatch() {
    local lua="$1" legacy="$2"
    if hyprctl dispatch "$lua" 2>&1 | grep -qx 'ok'; then
        return 0
    fi
    hyprctl dispatch "$legacy"
}

# Workspace 10 y lanzar Zen Browser
dispatch 'hl.dsp.focus({ workspace = 10 })' 'workspace 10'
sleep 1
zen-browser &

# Workspace 8 y lanzar Spotify
sleep 1
dispatch 'hl.dsp.focus({ workspace = 8 })' 'workspace 8'
sleep 1
spotify &

# Volver a Workspace 10
sleep 1
dispatch 'hl.dsp.focus({ workspace = 10 })' 'workspace 10'

# Esperar a que las ventanas terminen de cargar
sleep 5

# Mover ventana de WhatsApp al workspace 9
WHATSAPP_WINDOW=$(hyprctl clients | grep -B5 "title:.*WhatsApp" | grep "address" | awk '{print $2}')
if [ -n "$WHATSAPP_WINDOW" ]; then
    dispatch \
        "hl.dsp.window.move({ workspace = 9, follow = false, window = 'address:$WHATSAPP_WINDOW' })" \
        "movetoworkspacesilent 9,address:$WHATSAPP_WINDOW"
fi

# Conectar Bluetooth
echo -e "connect B0:F0:0C:30:75:EC\nexit" | bluetoothctl
