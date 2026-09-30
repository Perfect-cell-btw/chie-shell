#!/usr/bin/env bash
set -euo pipefail

echo
echo "╭──────────────────────────────────╮"
echo "│       ☻ CHIE SHELL REMOVE        │"
echo "╰──────────────────────────────────╯"
echo

CONFIG_DIRS=(
    chie-shell
    hypr
    waybar
    rofi
    swaync
    kitty
    fastfetch
    gtk-3.0
    gtk-4.0
)

read -r -p "Remove Chie Shell configuration? [y/N]: " answer

case "$answer" in
    y|Y|yes|YES) ;;
    *)
        echo "Cancelled."
        exit 0
        ;;
esac

for name in "${CONFIG_DIRS[@]}"; do
    rm -rf "$HOME/.config/$name"
done

rm -f "$HOME/.zshrc"
rm -f "$HOME/.gtkrc-2.0"

echo
echo "Chie Shell configuration removed."

BACKUP_ROOT="$HOME/.chie-shell-backups"

if [[ -d "$BACKUP_ROOT" ]]; then
    LATEST="$(find "$BACKUP_ROOT" -mindepth 1 -maxdepth 1 -type d | sort | tail -n1)"

    if [[ -n "$LATEST" ]]; then
        echo
        read -r -p "Restore previous configuration from $LATEST ? [y/N]: " restore

        case "$restore" in
            y|Y|yes|YES)
                mkdir -p "$HOME/.config"

                if [[ -d "$LATEST/.config" ]]; then
                    for path in "$LATEST/.config/"*; do
                        [[ -e "$path" ]] || continue
                        cp -a "$path" "$HOME/.config/"
                    done
                fi

                [[ -e "$LATEST/.zshrc" ]] &&
                    cp -a "$LATEST/.zshrc" "$HOME/.zshrc"

                [[ -e "$LATEST/.gtkrc-2.0" ]] &&
                    cp -a "$LATEST/.gtkrc-2.0" "$HOME/.gtkrc-2.0"

                echo
                echo "✓ Previous configuration restored."
                ;;
        esac
    fi
fi

echo
echo "Done."
