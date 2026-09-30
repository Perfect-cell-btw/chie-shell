#!/usr/bin/env bash

mkdir -p "$HOME/Pictures/Screenshots"

file="$HOME/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png"

grim "$file"
wl-copy < "$file"

notify-send "CHIE SHELL" "Screenshot copied to clipboard."
