#!/usr/bin/env sh

DIR=$(xdg-user-dir VIDEOS)/recordings
mkdir -p "$DIR"
NAME=$(ls "$DIR" | rofi -dmenu -p "Name of the video")
# record the screen with wf-recorder and encode it
wf-recorder -t --device=/dev/dri/renderD128 -c libx264 --audio=alsa_output.pci-0000_05_00.6.analog-stereo.monitor --file=$DIR/$NAME.mp4
