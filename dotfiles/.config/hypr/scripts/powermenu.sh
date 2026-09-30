#!/usr/bin/env bash

choice=$(printf "LOCK\nLOG OUT\nREBOOT\nSHUTDOWN" | \
    rofi -dmenu -i -p "SYSTEM")

case "$choice" in
    "LOCK")
        hyprlock
        ;;
    "LOG OUT")
        hyprctl dispatch 'hl.dsp.exit()'
        ;;
    "REBOOT")
        systemctl reboot
        ;;
    "SHUTDOWN")
        systemctl poweroff
        ;;
esac
