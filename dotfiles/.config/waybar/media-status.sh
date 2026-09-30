#!/usr/bin/env bash

status="$(playerctl status 2>/dev/null)"

if [ -z "$status" ]; then
    echo "♪"
    exit 0
fi

artist="$(playerctl metadata artist 2>/dev/null)"
title="$(playerctl metadata title 2>/dev/null)"

if [ "$status" = "Playing" ]; then
    icon="▶"
else
    icon="Ⅱ"
fi

if [ -n "$artist" ] && [ -n "$title" ]; then
    echo "$icon $artist — $title"
elif [ -n "$title" ]; then
    echo "$icon $title"
else
    echo "$icon Media"
fi
