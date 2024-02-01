#!/usr/bin/env sh

source ~/Documents/python/wisper/activate
nix-shell -p openai-whisper ffmpeg python3 python311Packages.pyaudio python311Packages.whisper python311Packages.pyperclip --command "python ~/Documents/python/wisper/main.py"
