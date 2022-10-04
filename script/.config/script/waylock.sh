#!/bin/sh

swayidle -w \
    timeout 600 'systemctl suspend' \
    before-sleep 'swaylock -i $HOME/Pictures/Wallpapers/133.png --ring-color 8218c4 --key-hl-color 3e0c60'
