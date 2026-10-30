#!/usr/bin/env bash
# ============================================================================
# install.sh — instala los dotfiles de este repositorio
#
#   ~/.dotfiles/install.sh              enlaza (symlinks) los dotfiles
#   ~/.dotfiles/install.sh --copy       copia en vez de enlazar
#   ~/.dotfiles/install.sh --dry-run    muestra lo que haría, sin tocar nada
#   ~/.dotfiles/install.sh --packages   instala también los paquetes de Arch
#   ~/.dotfiles/install.sh --nvim       instala los plugins de Neovim (Packer)
#
# Cualquier archivo que ya exista se mueve a ~/.dotfiles-backup/<fecha>/,
# nunca se borra. El script es idempotente: se puede volver a ejecutar.
# ============================================================================
set -Eeuo pipefail

REPO="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" >/dev/null 2>&1 && pwd -P)"
MODE="link"
DRY_RUN=0
WITH_PACKAGES=0
WITH_NVIM=0
ASSUME_YES=0
BACKUP_ROOT="$HOME/.dotfiles-backup"
BACKUP_DIR="$BACKUP_ROOT/$(date +%Y%m%d-%H%M%S)-$$"

# --- Salida con color -------------------------------------------------------
if [[ -t 1 ]]; then
    C_RESET=$'\e[0m'
    C_BOLD=$'\e[1m'
    C_DIM=$'\e[2m'
    C_GREEN=$'\e[38;2;159;188;165m'
    C_YELLOW=$'\e[38;2;216;194;155m'
    C_RED=$'\e[38;2;209;122;114m'
    C_BLUE=$'\e[38;2;155;182;201m'
else
    C_RESET='' C_BOLD='' C_DIM='' C_GREEN='' C_YELLOW='' C_RED='' C_BLUE=''
fi

info() { printf '%s→%s %s\n' "$C_BLUE" "$C_RESET" "$*"; }
ok()   { printf '%s✓%s %s\n' "$C_GREEN" "$C_RESET" "$*"; }
skip() { printf '%s=%s %s\n' "$C_DIM" "$C_RESET" "$*"; }
warn() { printf '%s!%s %s\n' "$C_YELLOW" "$C_RESET" "$*" >&2; }
die()  { printf '%s✗%s %s\n' "$C_RED" "$C_RESET" "$*" >&2; exit 1; }

usage() {
    cat <<EOF
${C_BOLD}Uso:${C_RESET} ${0##*/} [opciones]

Instala la configuración de ~/.dotfiles en el sistema.

  --link        crea enlaces simbólicos (opción por defecto)
  --copy        copia los archivos en vez de enlazarlos
  -n, --dry-run muestra las acciones sin ejecutarlas
  --packages    instala los paquetes necesarios (Arch / AUR)
  --nvim        instala/actualiza los plugins de Neovim con Packer
  -y, --yes     no pide confirmación
  -h, --help    muestra esta ayuda

Los archivos existentes se respaldan en ~/.dotfiles-backup/<fecha>/.
EOF
}

# --- Argumentos -------------------------------------------------------------
while (($#)); do
    case "$1" in
        --link)      MODE="link" ;;
        --copy)      MODE="copy" ;;
        -n|--dry-run) DRY_RUN=1 ;;
        --packages)  WITH_PACKAGES=1 ;;
        --nvim)      WITH_NVIM=1 ;;
        -y|--yes)    ASSUME_YES=1 ;;
        -h|--help)   usage; exit 0 ;;
        *)           die "Opción desconocida: $1 (usa --help)" ;;
    esac
    shift
done

[[ -f "$REPO/.bashrc" && -d "$REPO/hypr" && -d "$REPO/theme" ]] \
    || die "No parece que $REPO sea el repositorio de dotfiles."

# --- Qué se instala ---------------------------------------------------------
# Directorios completos: ~/.config/<nombre> -> repositorio/<nombre>
CONFIG_DIRS=(
    hypr
    kitty
    nvim
    scripts
    swaync
    theme
    tmux
    waybar
    wofi
    yazi
    zathura
)

# Archivos sueltos (origen en el repo | destino absoluto). Se usa enlace por
# archivo cuando el directorio de destino también guarda cosas ajenas al repo
# (por ejemplo ~/.config/gtk-3.0/bookmarks).
FILE_LINKS=(
    "kdeglobals|$HOME/.config/kdeglobals"
    "mimeapps.list|$HOME/.config/mimeapps.list"
    "btop/btop.conf|$HOME/.config/btop/btop.conf"
    "btop/themes/haz.theme|$HOME/.config/btop/themes/haz.theme"
    "cava/config|$HOME/.config/cava/config"
    "cava/themes/haz|$HOME/.config/cava/themes/haz"
    "environment.d/90-haz.conf|$HOME/.config/environment.d/90-haz.conf"
    "gtk-3.0/gtk.css|$HOME/.config/gtk-3.0/gtk.css"
    "gtk-3.0/settings.ini|$HOME/.config/gtk-3.0/settings.ini"
    "gtk-4.0/gtk.css|$HOME/.config/gtk-4.0/gtk.css"
    "spotify-player/app.toml|$HOME/.config/spotify-player/app.toml"
    "spotify-player/theme.toml|$HOME/.config/spotify-player/theme.toml"
    "spicetify/config-xpui.ini|$HOME/.config/spicetify/config-xpui.ini"
    "spicetify/Themes/Haz/color.ini|$HOME/.config/spicetify/Themes/Haz/color.ini"
    "spicetify/Themes/Haz/user.css|$HOME/.config/spicetify/Themes/Haz/user.css"
    "color-schemes/Haz.colors|$HOME/.local/share/color-schemes/Haz.colors"
)

# Archivos que van directamente al HOME
HOME_LINKS=(
    ".bashrc|$HOME/.bashrc"
)

# Recursos: fondo de pantalla esperado por hyprpaper.conf
ASSETS=(
    "assets/wallhaven-xe5pxo_3840x2160.png|$HOME/wallpapers/wallhaven-xe5pxo_3840x2160.png"
)

# --- Paquetes ---------------------------------------------------------------
PACMAN_PKGS=(
    # Base del escritorio
    hyprland hyprpaper hyprlock hyprsunset
    waybar wofi swaync
    # Terminal / editor / utilidades
    kitty neovim tmux btop cava yazi zathura zathura-pdf-poppler
    dolphin gnome-calculator
    wl-clipboard grim slurp gpu-screen-recorder
    playerctl brightnessctl
    # Audio, red, bluetooth, notificaciones
    pipewire pipewire-audio pipewire-pulse wireplumber
    networkmanager bluez bluez-utils libnotify pavucontrol
    # Temas, fuentes y portales
    python-pywal16
    ttf-jetbrains-mono ttf-jetbrains-mono-nerd noto-fonts-emoji
    vimix-cursors
    xdg-desktop-portal xdg-desktop-portal-gtk xdg-desktop-portal-hyprland
    # Herramientas de desarrollo y previsualización
    base-devel git tree nodejs npm go python
    tree-sitter-cli clang rust-analyzer
    imagemagick poppler ffmpegthumbnailer mediainfo perl-image-exiftool
    mpv imv w3m
    # Música
    spotify-launcher spotify-player
    # LaTeX (vimtex)
    texlive-latexrecommended texlive-fontsrecommended texlive-mathscience
    texlive-bin texlive-binextra
    zip unzip
)

AUR_PKGS=(
    tty-clock
    light
    zen-browser-bin
    spicetify-bin
)

# --- Utilidades -------------------------------------------------------------
ensure_backup_dir() {
    [[ -d "$BACKUP_DIR" ]] && return 0
    mkdir -p -- "$BACKUP_DIR"
}

backup_path() {
    local dst="$1" rel target
    if [[ ! -e "$dst" && ! -L "$dst" ]]; then
        return 0
    fi

    rel="${dst#"$HOME"/}"
    target="$BACKUP_DIR/$rel"

    if [[ "$DRY_RUN" -eq 1 ]]; then
        info "[dry-run] respaldaría ~/$rel"
        return 0
    fi

    if [[ -L "$dst" && "$(readlink -f -- "$dst" 2>/dev/null || true)" == "$REPO"* ]]; then
        rm -f -- "$dst"
        skip "enlace anterior eliminado: ~/$rel"
        return 0
    fi

    ensure_backup_dir
    mkdir -p -- "$(dirname -- "$target")"
    mv -- "$dst" "$target"
    info "respaldo: ~/$rel -> ${target#"$HOME"/}"
}

install_path() {
    local src="$1" dst="$2"
    local rel_src="${src#"$REPO"/}" rel_dst="${dst#"$HOME"/}"

    if [[ ! -e "$src" ]]; then
        warn "no existe en el repositorio: $rel_src"
        return 1
    fi

    if [[ "$MODE" == "link" ]]; then
        if [[ -L "$dst" ]] && \
           [[ "$(readlink -f -- "$dst" 2>/dev/null || true)" == "$(readlink -f -- "$src" 2>/dev/null || true)" ]]; then
            skip "~/$rel_dst (ya enlazado)"
            return 0
        fi

        if [[ "$DRY_RUN" -eq 1 ]]; then
            info "[dry-run] ~/$rel_dst -> $rel_src"
            [[ -e "$dst" || -L "$dst" ]] && info "[dry-run] respaldaría ~/$rel_dst"
            return 0
        fi

        backup_path "$dst"
        mkdir -p -- "$(dirname -- "$dst")"
        ln -s -- "$src" "$dst"
        ok "~/$rel_dst -> $rel_src"
        return 0
    fi

    # Modo copia
    if [[ -d "$src" ]]; then
        if [[ ! -L "$dst" && -d "$dst" ]] && diff -rq -- "$src" "$dst" >/dev/null 2>&1; then
            skip "~/$rel_dst (idéntico)"
            return 0
        fi
        if [[ "$DRY_RUN" -eq 1 ]]; then
            info "[dry-run] copiaría $rel_src -> ~/$rel_dst"
            return 0
        fi
        backup_path "$dst"
        mkdir -p -- "$dst"
        cp -a -- "$src/." "$dst/"
        ok "~/$rel_dst copiado desde $rel_src"
        return 0
    fi

    if [[ ! -L "$dst" && -f "$dst" ]] && cmp -s -- "$src" "$dst"; then
        skip "~/$rel_dst (idéntico)"
        return 0
    fi
    if [[ "$DRY_RUN" -eq 1 ]]; then
        info "[dry-run] copiaría $rel_src -> ~/$rel_dst"
        return 0
    fi
    backup_path "$dst"
    mkdir -p -- "$(dirname -- "$dst")"
    cp -a -- "$src" "$dst"
    ok "~/$rel_dst copiado desde $rel_src"
}

# --- Plan -------------------------------------------------------------------
show_plan() {
    local mode_txt="enlaces simbólicos"
    [[ "$MODE" == "copy" ]] && mode_txt="copias"
    [[ "$DRY_RUN" -eq 1 ]] && mode_txt+=" (dry-run)"

    printf '%sRepositorio:%s %s\n' "$C_BOLD" "$C_RESET" "$REPO"
    printf '%sModo:%s        %s\n\n' "$C_BOLD" "$C_RESET" "$mode_txt"

    printf '%sDirectorios en ~/.config:%s\n' "$C_BOLD" "$C_RESET"
    printf '  %s\n' "${CONFIG_DIRS[@]}"
    printf '\n%sArchivos individuales:%s\n' "$C_BOLD" "$C_RESET"
    local pair dst
    for pair in "${FILE_LINKS[@]}" "${HOME_LINKS[@]}" "${ASSETS[@]}"; do
        dst="${pair#*|}"
        printf '  ~/%s\n' "${dst#"$HOME"/}"
    done
    printf '\n'
}

# --- Dependencias -----------------------------------------------------------
check_deps() {
    local spec cmd pkg
    local -a required=(
        "hyprctl:hyprland"
        "hyprpaper:hyprpaper"
        "hyprlock:hyprlock"
        "waybar:waybar"
        "wofi:wofi"
        "swaync:swaync"
        "kitty:kitty"
        "nvim:neovim"
        "tmux:tmux"
        "btop:btop"
        "cava:cava"
        "yazi:yazi"
        "zathura:zathura"
        "dolphin:dolphin"
        "wl-copy:wl-clipboard"
        "grim:grim"
        "slurp:slurp"
        "gpu-screen-recorder:gpu-screen-recorder"
        "playerctl:playerctl"
        "brightnessctl:brightnessctl"
        "wpctl:pipewire"
        "bluetoothctl:bluez-utils"
        "notify-send:libnotify"
        "wal:python-pywal16"
        "hyprsunset:hyprsunset"
        "zen-browser:zen-browser-bin"
        "spotify:spotify-launcher"
        "spicetify:spicetify-bin"
    )
    local -a optional=(
        "spotify_player:spotify-player"
        "imv:imv"
        "mpv:mpv"
        "exiftool:perl-image-exiftool"
        "magick:imagemagick"
        "pdftoppm:poppler"
        "ffmpegthumbnailer:ffmpegthumbnailer"
        "mediainfo:mediainfo"
        "w3m:w3m"
        "tty-clock:tty-clock"
        "light:light"
        "latexmk:texlive-bin"
        "arduino-cli:arduino-cli"
    )

    local -a missing=()
    for spec in "${required[@]}"; do
        cmd="${spec%%:*}"
        pkg="${spec#*:}"
        command -v "$cmd" >/dev/null 2>&1 || missing+=("$pkg")
    done

    if ((${#missing[@]})); then
        warn "Faltan dependencias obligatorias: ${missing[*]}"
        warn "Puedes instalarlas con: ${0##*/} --packages"
    else
        ok "Dependencias principales presentes."
    fi

    local -a missing_opt=()
    for spec in "${optional[@]}"; do
        cmd="${spec%%:*}"
        command -v "$cmd" >/dev/null 2>&1 || missing_opt+=("${spec#*:}")
    done
    if ((${#missing_opt[@]})); then
        warn "Opcionales no encontradas (funciones concretas): ${missing_opt[*]}"
    fi
}

# --- Paquetes ---------------------------------------------------------------
install_packages() {
    command -v pacman >/dev/null 2>&1 \
        || { warn "pacman no está disponible; omite --packages."; return 0; }

    info "Instalando paquetes oficiales..."
    if [[ "$DRY_RUN" -eq 1 ]]; then
        info "[dry-run] sudo pacman -S --needed --noconfirm ${PACMAN_PKGS[*]}"
    else
        sudo pacman -S --needed --noconfirm "${PACMAN_PKGS[@]}"
        ok "Paquetes oficiales instalados."
    fi

    local helper=""
    for candidate in yay paru trizen; do
        if command -v "$candidate" >/dev/null 2>&1; then
            helper="$candidate"
            break
        fi
    done

    if [[ -z "$helper" ]]; then
        warn "No hay ayudante de AUR (yay/paru/trizen)."
        warn "Instala manualmente: ${AUR_PKGS[*]}"
        return 0
    fi

    info "Instalando paquetes de AUR con $helper..."
    if [[ "$DRY_RUN" -eq 1 ]]; then
        info "[dry-run] $helper -S --needed --noconfirm ${AUR_PKGS[*]}"
        return 0
    fi

    case "$helper" in
        trizen) trizen -S --needed --noconfirm "${AUR_PKGS[@]}" ;;
        *)      "$helper" -S --needed --noconfirm "${AUR_PKGS[@]}" ;;
    esac
    ok "Paquetes de AUR instalados."
}

# --- Neovim -----------------------------------------------------------------
install_nvim_plugins() {
    command -v nvim >/dev/null 2>&1 \
        || { warn "nvim no está instalado; se omite PackerSync."; return 0; }

    info "Sincronizando plugins de Neovim (Packer)..."
    if [[ "$DRY_RUN" -eq 1 ]]; then
        info "[dry-run] nvim --headless -c 'autocmd User PackerComplete quitall' -c 'PackerSync'"
        return 0
    fi

    nvim --headless \
        -c 'autocmd User PackerComplete quitall' \
        -c 'PackerSync' >/dev/null 2>&1 \
        && ok "Plugins de Neovim listos." \
        || warn "PackerSync falló; ábrelo con: nvim +PackerSync"
}

# --- Principal --------------------------------------------------------------
main() {
    printf '\n%s══ Instalación de dotfiles ══%s\n\n' "$C_BOLD" "$C_RESET"
    show_plan

    if [[ "$DRY_RUN" -eq 0 && "$ASSUME_YES" -eq 0 ]]; then
        if [[ -t 0 ]]; then
            local answer
            read -r -p "¿Continuar? [s/N] " answer
            [[ "$answer" =~ ^[sSyY]$ ]] || { echo "Cancelado."; exit 0; }
        else
            die "Ejecución no interactiva: vuelve a lanzarlo con --yes."
        fi
        printf '\n'
    fi

    info "Instalando configuración..."
    local dir pair src dst
    for dir in "${CONFIG_DIRS[@]}"; do
        install_path "$REPO/$dir" "$HOME/.config/$dir" || true
    done
    for pair in "${FILE_LINKS[@]}" "${HOME_LINKS[@]}"; do
        src="$REPO/${pair%%|*}"
        dst="${pair#*|}"
        install_path "$src" "$dst" || true
    done

    info "Preparando recursos y directorios de trabajo..."
    for pair in "${ASSETS[@]}"; do
        src="$REPO/${pair%%|*}"
        dst="${pair#*|}"
        install_path "$src" "$dst" || true
    done

    if [[ "$DRY_RUN" -eq 0 ]]; then
        mkdir -p -- "$HOME/wallpapers" \
                    "$HOME/Imágenes/screenshot" \
                    "$HOME/Videos/Grabaciones de la pantalla"
        chmod +x -- "$REPO/scripts/"*.sh "$REPO/hypr/"*.sh "$REPO/waybar/apply-theme.sh" 2>/dev/null || true
        ok "Directorios de trabajo y permisos listos."
    fi

    printf '\n'
    check_deps

    if [[ "$WITH_PACKAGES" -eq 1 ]]; then
        printf '\n'
        install_packages
    fi

    if [[ "$WITH_NVIM" -eq 1 ]]; then
        printf '\n'
        install_nvim_plugins
    fi

    printf '\n'
    if [[ "$HOME" != "/home/kikoperex" ]]; then
        warn "Varias configuraciones usan rutas absolutas /home/kikoperex"
        warn "(kitty, zathura, hyprpaper, swaync, wofi, spicetify)."
        warn "Revísalas si este usuario no es 'kikoperex'."
    fi

    printf '%sListo.%s\n' "$C_BOLD$C_GREEN" "$C_RESET"
    echo "  • Reinicia la sesión de Hyprland para aplicar todo."
    echo "  • Spicetify (si lo usas): spicetify backup apply"
    echo "  • Wallpaper: ~/wallpapers/wallhaven-xe5pxo_3840x2160.png"
    [[ -d "$BACKUP_DIR" ]] && echo "  • Respaldos: ${BACKUP_DIR#"$HOME"/}"
    echo
}

main "$@"
