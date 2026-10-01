#!/usr/bin/env bash

choice=$(printf "LOCK\nLOG OUT\nREBOOT\nSHUTDOWN" | \
    rofi -dmenu -i -p "SYSTEM")

case "$choice" in
    "LOCK")
        hyprlock
        ;;
    "LOG OUT")
        if command -v hyprshutdown >/dev/null 2>&1; then
            hyprshutdown -t "Logging out..."
        else
            hyprctl dispatch exit
        fi
        ;;
    "REBOOT")
        systemctl reboot
        ;;
    "SHUTDOWN")
        systemctl poweroff
        ;;
esac
