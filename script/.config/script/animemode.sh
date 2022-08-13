#!/usr/bin/env bash

chack to see if trackma is running
if pgrep -x "trackma" > /dev/null
then
    alacritty -e "$HOME"/Documents/Rust/kami/target/release/kami -a
else

    trackma
    alacritty -e "$HOME"/Documents/Rust/kami/target/release/kami -a
fi
