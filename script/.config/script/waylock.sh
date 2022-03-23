#!/bin/sh

swayidle -w \
    timeout 900 'sudo systemctl suspend' \
    before-sleep 'swaylock -i $HOME/Pictures/Wallpapers/15.jpg --ring-color 8218c4 --key-hl-color 3e0c60'
