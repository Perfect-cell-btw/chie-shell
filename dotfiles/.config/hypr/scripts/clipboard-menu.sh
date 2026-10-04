#!/usr/bin/env bash
set -u

THEME="$HOME/.config/rofi/themes/clipboard.rasi"

history="$(cliphist list 2>/dev/null | head -n 5)"

if [[ -z "$history" ]]; then
    notify-send "Chie Clipboard" "Clipboard history is empty."
    exit 0
fi

choice="$(
    printf '%s\n' "$history" |
        rofi -dmenu -i -p "CLIPBOARD" -theme "$THEME"
)"

[[ -n "$choice" ]] || exit 0

printf '%s\n' "$choice" | cliphist decode | wl-copy
