#!/usr/bin/env bash

status="$(playerctl status 2>/dev/null)"
artist="$(playerctl metadata artist 2>/dev/null)"
title="$(playerctl metadata title 2>/dev/null)"

header="NO MEDIA"

if [ -n "$title" ]; then
    header="$artist — $title"
fi

choice="$(
    printf '⏮  Previous\n⏯  Play / Pause\n⏭  Next\n■  Stop\n' |
    rofi -dmenu -i -p "$header"
)"

case "$choice" in
    *Previous*)
        playerctl previous
        ;;
    *Play*)
        playerctl play-pause
        ;;
    *Next*)
        playerctl next
        ;;
    *Stop*)
        playerctl stop
        ;;
esac
