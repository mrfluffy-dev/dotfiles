#!/usr/bin/env sh

# This scrip is ment to resord the screen with desktop audio and no mic audio using wf-recorder

# make a directory to store the videos in HOME/Videos/recordings
mkdir -p $HOME/Videos/recordings
make a variable for the directory
DIR=$HOME/Videos/recordings
#use rofi to enter the a name for the video in the directory
cd $DIR
NAME=$(rofi -dmenu -p "Name of the video")
cd ..
# record the screen with wf-recorder
wf-recorder --device=/dev/dri/renderD128 --audio=alsa_output.pci-0000_05_00.6.analog-stereo.monitor --file=$DIR/$NAME
