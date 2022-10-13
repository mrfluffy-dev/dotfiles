#!/bin/sh

# list all the files in the current directory in rofi
FILE=$(ls -1 | rofi -dmenu -i -p "Select file to open")
URL=$(curl -F "file=@$FILE" https://0x0.st)
printf "$URL" | wl-copy -n
