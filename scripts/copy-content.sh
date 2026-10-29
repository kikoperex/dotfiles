#!/bin/bash

# Copia al portapapeles el CONTENIDO de un archivo, no su ruta.
# El texto se anuncia como text/plain para que se pegue en cualquier sitio,
# y las imágenes conservan su MIME real (image/png, image/jpeg, ...).
# Uso: copy-content.sh <archivo>

if [ $# -lt 1 ]; then
    notify-send "Copiar contenido" "Uso: $(basename "$0") <archivo>"
    exit 1
fi

target=$1

if [ ! -e "$target" ]; then
    notify-send "Copiar contenido" "No existe: $target"
    exit 1
fi

if ! command -v wl-copy > /dev/null; then
    notify-send "Copiar contenido" "wl-copy no está disponible (¿sesión Wayland?)"
    exit 1
fi

# Directorios y otros no-ficheros: se copia la ruta
if [ ! -f "$target" ]; then
    printf '%s' "$target" | wl-copy --type text/plain
    exit 0
fi

if [ ! -s "$target" ]; then
    notify-send "Copiar contenido" "El archivo está vacío: $(basename "$target")"
    exit 1
fi

mime=$(file --brief --mime-type -- "$target")

case $mime in
    text/* | application/json | application/xml | application/*javascript | \
        application/x-shellscript | application/rtf)
        mime=text/plain
        ;;
esac

if ! wl-copy --type "$mime" < "$target"; then
    notify-send "Copiar contenido" "No se pudo copiar: $(basename "$target")"
    exit 1
fi
