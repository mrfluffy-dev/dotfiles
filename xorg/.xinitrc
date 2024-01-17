#!/bin/sh

xset +fp /home/mrfluffy/.local/share/fonts
xset fp rehash
xset s 600 600
xset r rate 300 50
xrdb ~/.Xresources
numlockx on
xsetroot -cursor_name left_ptr
xrandr --output HDMI-A-0 --mode 1920x1080 --pos 0x0 --rotate normal --output DisplayPort-1 --primary --mode 2560x1440 --rate 144.00 --pos 1920x0 --rotate normal --output DisplayPort-2 --primary --mode 1920x1080 --pos 4480x0 --rotate left
xrandr --output HDMI-A-0 --set TearFree on &
xrandr --output DisplayPort-2 --set TearFree on &
#only turn on DisplayPort-1 and explicitly turn off the other two
#xrandr --output DisplayPort-1 --auto --primary --output DisplayPort-2 --off --output HDMI-A-0 --off &
xrandr --output DisplayPort-1 --set TearFree on &
source /etc/X11/xinit/xinitrc.d/50-systemd-user.sh
eval "$(gnome-keyring-daemon --start)"
export SSH_AUTH_SOCK
export XDG_DATA_DIRS=$HOME/.nix-profile/share:$HOME/.share:"${XDG_DATA_DIRS:-/usr/local/share/:/usr/share/}"
mkdir -p "$HOME"/.local/share/keyrings
#exec dbus-launch leftwm
#polybar barbase &
#exec qtile start
#steam &
#exec /home/mrfluffy/.local/bin/xmonad
#exec xmonad
exec bspwm
#/home/mrfluffy/.config/hentaiwm/target/release/hentaiwm &> ~/.penrose.log
#-----------------------------------------------------
#gome session
#export XDG_SESSION_TYPE=x11
#export GDK_BACKEND=x11
#exec gnome-session
