#!/usr/bin/env bash

CACHE="$HOME/.cache/chie-shell"
RAW="$CACHE/album-art-raw"
OUT="$CACHE/album-art-rounded.png"

mkdir -p "$CACHE"

url="$(playerctl metadata mpris:artUrl 2>/dev/null | head -n1)"

[ -z "$url" ] && exit 0

case "$url" in
    file://*)
        path="${url#file://}"
        cp -f "$path" "$RAW" 2>/dev/null || exit 0
        ;;

    http://*|https://*)
        curl -LfsS "$url" -o "$RAW" 2>/dev/null || exit 0
        ;;

    *)
        [ -f "$url" ] || exit 0
        cp -f "$url" "$RAW"
        ;;
esac

magick "$RAW" \
    -resize 128x128^ \
    -gravity center \
    -extent 128x128 \
    \( -size 128x128 xc:none -fill white \
       -draw "roundrectangle 0,0 127,127 22,22" \) \
    -alpha off \
    -compose CopyOpacity \
    -composite \
    "$OUT"

printf '%s\n' "$OUT"
