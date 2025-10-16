#
# ~/.bashrc
#

# npx oh-my-logo "kitty" 
# fastfetch
# echo "
#   _    _ _   _         
#  | | _(_) |_| |_ _   _ 
#  | |/ / | __| __| | | |
#  |   <| | |_| |_| |_| |
#  |_|\_\_|\__|\__|\__, |
#                  |___/
# "

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

HISTCONTROL=ignoreboth
shopt -s histappend
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s globstar
shopt -s checkwinsize

## PS1='[\u@\h \W]\$ '
export PATH="$HOME/.local/bin:$PATH"
export PATH="/home/patitomora/.local/bin:/sbin:/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/var/lib/flatpak/exports/bin:/usr/bin/site_perl:/usr/bin/vendor_perl:/usr/bin/core_perl"
export QT_QPA_PLATFORMTHEME=qt6ct
export PATH="$PATH:/home/patitomora/.local/share/spotify-launcher/install/usr/bin"

# Quality of life improvempts
alias ls='ls -hN --color=auto --group-directories-first'
alias grep='grep --color=auto'
alias setup='./.config/scripts/start-worflow.sh '
alias v=nvim
alias vf="v ."
alias i="sudo pacman -S --noconfirm"
alias remove="sudo pacman -Rns"
alias fullupdate="sudo pacman -Syu --noconfirm && yay -Syu --noconfirm"
alias light="sudo light -S"
alias matar="pkill -f"
alias clock="tty-clock -cs"
alias s="spotify_player"
alias xkill="hyprctl kill"
alias minecraft="flatpak run --env=QT_QPA_PLATFORM=xcb --nosocket=wayland --nosocket=fallback-x11 --socket=x11 io.mrarm.mcpelauncher"

alias escribir="sudo dd if=Downloads/debian-12.11.0-amd64-netinst.iso of=/dev/sda bs=4M status=progress oflag=sync"

# Minecraft Server facility
alias mcsv="     LD_LIBRARY_PATH=. ./bedrock_server "

# Arduino compile and upload
alias arduinoupload="arduino-cli upload -p /dev/ttyUSB0 --fqbn arduino:avr:uno"
alias arduinocompile="arduino-cli compile --fqbn arduino:avr:uno"

if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    alias grep='grep --color=auto'
fi

# Establece un prompt con colores si la terminal lo soporta
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

if [ "$color_prompt" = yes ]; then
    # Prompt colorido: usuario@host:~/directorio$
    # \u = usuario, \h = host, \w = directorio actual
    # Los códigos \[...\] definen los colores
    PS1='\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    # Prompt sin colores
    PS1='\u@\h:\w\$ '
fi
# --- Inicio: Autostart de tmux ---
# Solo si estamos en una terminal interactiva y no ya dentro de tmux
if [[ $- == *i* ]] && [ -z "$TMUX" ]; then
    SESSION_NAME="main"

    # Si no existe ninguna sesión de tmux activa (en todo el sistema)
    if ! pgrep -x tmux >/dev/null 2>&1; then
        # Crea una nueva sesión y conéctate a ella
        tmux new-session -s "$SESSION_NAME"
    fi
    # Si ya existe tmux corriendo, simplemente abre bash normal
fi
# --- Fin: Autostart de tmux ---
