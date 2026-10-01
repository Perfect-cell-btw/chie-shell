#!/usr/bin/env bash
set -u

CACHE="$HOME/.cache/chie-shell"
RAW="$CACHE/album-art-raw"
OUT="$CACHE/album-art-rounded.png"
KEYFILE="$CACHE/album-art.key"

mkdir -p "$CACHE"

url="$(playerctl metadata --format '{{mpris:artUrl}}' 2>/dev/null | head -n1)"

if [[ -z "$url" ]]; then
    rm -f "$KEYFILE"
    exit 0
fi

key="$(printf '%s' "$url" | sha256sum | awk '{print $1}')"

if [[ -s "$OUT" && -f "$KEYFILE" && "$(cat "$KEYFILE")" == "$key" ]]; then
    printf '%s\n' "$OUT"
    exit 0
fi

tmp_raw="$RAW.$$"
tmp_out="$CACHE/album-art-rounded.$$.png"

cleanup() {
    rm -f "$tmp_raw" "$tmp_out"
}
trap cleanup EXIT

case "$url" in
    file://*)
        path="${url#file://}"
        cp -f "$path" "$tmp_raw" 2>/dev/null || exit 0
        ;;
    http://*|https://*)
        curl -LfsS "$url" -o "$tmp_raw" 2>/dev/null || exit 0
        ;;
    *)
        [[ -f "$url" ]] || exit 0
        cp -f "$url" "$tmp_raw" || exit 0
        ;;
esac

magick "$tmp_raw" \
    -resize 128x128^ \
    -gravity center \
    -extent 128x128 \
    \( -size 128x128 xc:none -fill white \
       -draw "roundrectangle 0,0 127,127 22,22" \) \
    -alpha off \
    -compose CopyOpacity \
    -composite \
    "$tmp_out" || exit 0

mv -f "$tmp_out" "$OUT"
printf '%s\n' "$key" > "$KEYFILE"
printf '%s\n' "$OUT"
