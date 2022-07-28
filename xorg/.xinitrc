#!/usr/bin/env bash

xset +fp /home/mrfluffy/.local/share/fonts
xset fp rehash
anamnesis --start
numlockx on
xsetroot -cursor_name left_ptr
xrandr --output eDP --mode 1920x1080 --pos 0x0 --rotate normal --output HDMI-A-0 --primary --mode 1920x1080 --pos 1920x0 --rotate normal
xrandr --output HDMI-A-0 --set TearFree on &
xrandr --output eDP --set TearFree on &
#exec /home/mrfluffy/.local/bin/xmonad
#exec qtile start
source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh
eval "$(gnome-keyring-daemon --start)"
export SSH_AUTH_SOCK
mkdir -p "$HOME"/.local/share/keyrings

#exec dbus-launch leftwm
#polybar barbase &
/home/mrfluffy/.config/hentaiwm/target/release/hentaiwm &> ~/.penrose.log
#-----------------------------------------------------
#gome session
#export XDG_SESSION_TYPE=x11
#export GDK_BACKEND=x11
#exec gnome-session

