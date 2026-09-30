#!/usr/bin/env bash

WALLDIR="$HOME/.config/chie-shell/assets/wallpapers"

choice="$(
    find "$WALLDIR" -maxdepth 1 -type f \
        \( -iname '*.png' -o -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.webp' \) \
        -printf '%f\n' |
    sort |
    rofi -dmenu -i -p "WALLPAPER"
)"

[ -z "$choice" ] && exit 0

wall="$WALLDIR/$choice"

hyprctl monitors -j |
jq -r '.[].name' |
while read -r monitor; do
    hyprctl hyprpaper wallpaper "$monitor,$wall,cover"
done

notify-send "CHIE SHELL" "Wallpaper: $choice"
