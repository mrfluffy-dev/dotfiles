#!/bin/sh

# list all the files in the current directory in rofi
FILE=$(ls -1 | rofi -dmenu -i -p "Select file to open")
#coly ro crl v xclip
URL=$(curl -k https://oshi.at -F f=@"$FILE" | tail -n 1 | cut -d ' ' -f 2)
echo "$URL"
echo "$URL" | wl-copy
