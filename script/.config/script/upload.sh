#!/bin/sh

FILE=$(fd -t f|fzf)
LINK=$(curl -# "https://oshi.at" -F "f=@$FILE"|awk '/DL/ {print $2}')
printf "$LINK"|xclip -selection c
printf "$LINK\n"
