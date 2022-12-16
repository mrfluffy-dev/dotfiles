#!/usr/bin/env sh
#

# this script is to aulter the default settings in hyprland.conf
#
# read $HOME/.config/hypr/hyprland.conf and if the text after monitor= is "HDMI-A-1,1920x1080@60,0x0,1,mirror,DP-3"  change it to ",preferred,auto,1"
if [ -f $HOME/.config/hypr/hyprland.conf ]; then
    if grep -q "monitor=HDMI-A-1,1920x1080@60,0x0,1,mirror,HTMI-A-2" $HOME/.config/hypr/hyprland.conf; then
        sed -i 's/monitor=HDMI-A-1,1920x1080@60,0x0,1,mirror,HDMI-A-2/monitor=,preferred,auto,1/g' $HOME/.config/hypr/hyprland.conf
    else
        sed -i 's/monitor=,preferred,auto,1/monitor=HDMI-A-1,1920x1080@60,0x0,1,mirror,HTMI-A-2/g' $HOME/.config/hypr/hyprland.conf
    fi
fi
