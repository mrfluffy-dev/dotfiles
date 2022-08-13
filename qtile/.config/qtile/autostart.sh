#!/usr/bin/env bash

#pipewire & /usr/bin/pipewire-pulse & /usr/bin/pipewire-media-session &
#xss-lock /home/$USER/.config/script/betterlockscreen.sh  &
#fcitx -d &
#copyq --start-server &
#dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP=qtile
#xset +fp /home/mrfluffy/.local/share/fonts
#xset fp rehash
#xsetroot -cursor_name left_ptr
#eval "$(gnome-keyring-daemon --start)"
#export SSH_AUTH_SOCK
#mkdir -p "$HOME"/.local/share/keyrings
#/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
#~/.azotebg
nitrogen --restore &
xss-lock -- /home/mrfluffy/.config/script/betterlockscreen.sh &
picom --backend glx &
sxhkd &

#/home/mrfluffy/.config/script/waylock.sh &
