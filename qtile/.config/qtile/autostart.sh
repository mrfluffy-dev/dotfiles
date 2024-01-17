#!/usr/bin/env bash

~/.config/script/theme-fix &
systemctl --user restart xdg-desktop-portal &
dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP &
~/.config/script/waylock.sh &
foot -s &
/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1 &
#run wlr-randr --output DP-3 --pos 1920,0 --output HDMI-A-1 --pos 0,0 after sleeping for 0.5 seconds
sleep 0.5 && wlr-randr --output DP-3 --pos 1920,0 --output HDMI-A-1 --pos 0,0 && ~/.azotebg &
