#!/usr/bin/env bash

#chack to see if waybar is running
if pgrep -x "waybar" >/dev/null; then
    killall -s SIGKILL -q waybar
else
    waybar &>/dev/null &
fi
