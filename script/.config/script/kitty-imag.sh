#!/bin/sh

fzf --cycle --preview="kitty +kitten icat --clear --transfer-mode file; kitty +kitten icat --place "190x12@10x10" --scale-up --transfer-mode file {}"
