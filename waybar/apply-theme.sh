#!/usr/bin/env bash
# Cambia el tema visual de waybar en vivo, ajustando height/spacing por tema.
#
#   apply-theme.sh                 lista los temas
#   apply-theme.sh 1-flat          aplica ese tema
#   apply-theme.sh next            siguiente tema (para ir comparando)
#   apply-theme.sh prev            anterior
#   apply-theme.sh restore         vuelve a tu configuración original
#
#   KEEP_CONFIG=1 apply-theme.sh 1-flat   → solo toca el CSS, no el config
set -euo pipefail

DIR="$HOME/.config/waybar"
THEMES="$DIR/themes"
CSS="$DIR/style.css"
CONF="$DIR/config"
STATE="$THEMES/.current"

# nombre → "height spacing" (alturas medidas con la advertencia de waybar)
settings_for() {
    case "$1" in
        1-flat)      echo "16 4" ;;
        2-islas)     echo "24 0" ;;
        3-subrayado) echo "18 4" ;;
        4-chips)     echo "22 5" ;;
        5-hibrido)   echo "14 0" ;;
        5-hibrido-mini) echo "12 0" ;;
        *)           echo "" ;;
    esac
}

list_themes() {
    local f
    for f in "$THEMES"/[0-9]*.css; do
        printf '  %-14s %s\n' "$(basename "$f" .css)" \
            "$(sed -n 's/.*ALTERNATIVA [0-9]* *— *//p' "$f" | head -1 | tr -d '"')"
    done
}

apply() {
    local name="$1" h s
    local theme="$THEMES/$name.css"
    [[ -f "$theme" ]] || { echo "No existe: $theme" >&2; exit 1; }

    # respaldos prístinos (solo la primera vez)
    [[ -f "$CONF.orig" ]] || cp "$CONF" "$CONF.orig"
    [[ -f "$CSS.orig"  ]] || cp "$CSS"  "$CSS.orig"

    cp "$theme" "$CSS"

    if [[ "${KEEP_CONFIG:-0}" != "1" ]]; then
        read -r h s <<<"$(settings_for "$name")"
        # partir siempre del config original → cambios idempotentes
        cp "$CONF.orig" "$CONF"
        [[ -n "$h" ]] && sed -i "s/\"height\"[[:space:]]*:[[:space:]]*[0-9]\+/\"height\": $h/" "$CONF"
        [[ -n "$s" ]] && sed -i "s/\"spacing\"[[:space:]]*:[[:space:]]*[0-9]\+/\"spacing\": $s/" "$CONF"
    fi

    echo "$name" > "$STATE"

    # SIGUSR2 recarga config + CSS sin matar el proceso
    pkill -SIGUSR2 -x waybar 2>/dev/null || true
    sleep 0.3
    pgrep -x waybar >/dev/null || { echo "waybar no está corriendo; inícialo con: waybar &" >&2; exit 1; }

    echo "→ $name  (height $(sed -n 's/.*"height"[[:space:]]*:[[:space:]]*\([0-9]\+\).*/\1/p' "$CONF"), spacing $(sed -n 's/.*"spacing"[[:space:]]*:[[:space:]]*\([0-9]\+\).*/\1/p' "$CONF"))"
}

restore() {
    [[ -f "$CSS.orig"  ]] && cp "$CSS.orig"  "$CSS"  || echo "Sin respaldo de style.css" >&2
    [[ -f "$CONF.orig" ]] && cp "$CONF.orig" "$CONF" || echo "Sin respaldo de config"    >&2
    rm -f "$STATE"
    pkill -SIGUSR2 -x waybar 2>/dev/null || true
    echo "→ configuración original restaurada"
}

case "${1:-}" in
    "")        echo "Temas disponibles:"; list_themes
               echo; echo "Uso: apply-theme.sh <tema> | next | prev | restore" ;;
    restore)   restore ;;
    next|prev)
        mapfile -t all < <(basename -s .css -a "$THEMES"/[0-9]*.css)
        cur="$(cat "$STATE" 2>/dev/null || echo "")"
        idx=0
        for i in "${!all[@]}"; do [[ "${all[$i]}" == "$cur" ]] && idx=$i; done
        if [[ "$1" == "next" ]]; then idx=$(( (idx + 1) % ${#all[@]} ))
        else idx=$(( (idx - 1 + ${#all[@]}) % ${#all[@]} )); fi
        apply "${all[$idx]}" ;;
    *)         apply "${1%.css}" ;;
esac
