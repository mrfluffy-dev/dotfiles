#!/bin/sh

eval $(/usr/bin/gnome-keyring-daemon --start --components=pkcs11,secrets,ssh)
export SSH_AUTH_SOCK
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
exec dbus-launch leftwm
#-----------------------------------------------------
#gome session
#export XDG_SESSION_TYPE=x11
#export GDK_BACKEND=x11
#exec gnome-session

