#!/usr/bin/env bash
set -euo pipefail

BACKUP_ROOT="$HOME/.chie-shell-backups"

if [[ ! -d "$BACKUP_ROOT" ]]; then
    echo "No Chie Shell backups found."
    exit 1
fi

LATEST="$(find "$BACKUP_ROOT" -mindepth 1 -maxdepth 1 -type d | sort | tail -n1)"

if [[ -z "$LATEST" ]]; then
    echo "No Chie Shell backups found."
    exit 1
fi

echo "Latest backup:"
echo "  $LATEST"
echo

read -r -p "Restore this backup? [y/N]: " answer

case "$answer" in
    y|Y|yes|YES) ;;
    *)
        echo "Cancelled."
        exit 0
        ;;
esac

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

echo
echo "Removing current Chie Shell configs..."

for name in "${CONFIG_DIRS[@]}"; do
    rm -rf "$HOME/.config/$name"
done

rm -f "$HOME/.zshrc"
rm -f "$HOME/.gtkrc-2.0"

CURSOR_NAME="Chie-Cursor"
rm -rf "$HOME/.local/share/icons/$CURSOR_NAME" "$HOME/.icons/$CURSOR_NAME"
rm -f "$HOME/.local/share/icons/default/index.theme" "$HOME/.icons/default/index.theme"

echo "Restoring backup..."

if [[ -d "$LATEST/.config" ]]; then
    mkdir -p "$HOME/.config"

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
echo "✓ Backup restored"
echo
echo "Log out and back in to reload your session."
