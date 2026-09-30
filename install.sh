#!/usr/bin/env bash

set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SOURCE="$ROOT/dotfiles"

DRY_RUN=false
if [[ "${1:-}" == "--dry-run" ]]; then
    DRY_RUN=true
fi

echo
echo "╭──────────────────────────────────╮"
echo "│          ☻ CHIE SHELL            │"
echo "│      Lightweight Hyprland        │"
echo "╰──────────────────────────────────╯"
echo

# ---------------------------------------------------------
# Basic checks
# ---------------------------------------------------------

if [[ ! -f /etc/arch-release ]]; then
    echo "This installer currently targets Arch Linux."
    exit 1
fi

if [[ ! -d "$SOURCE/.config" ]]; then
    echo "Error: dotfiles directory not found:"
    echo "  $SOURCE"
    exit 1
fi

USERNAME_VALUE="$(id -un)"
HOSTNAME_VALUE="$(uname -n)"
HOME_VALUE="$HOME"

echo "User:     $USERNAME_VALUE"
echo "Host:     $HOSTNAME_VALUE"
echo "Home:     $HOME_VALUE"
echo

# ---------------------------------------------------------
# Font detection
# ---------------------------------------------------------

if fc-match -f '%{family}\n' "Google Sans Flex" 2>/dev/null | grep -qi "Google Sans Flex"; then
    UI_FONT="Google Sans Flex"
    UI_FONT_BOLD="Google Sans Flex"
elif fc-match -f '%{family}\n' "Inter" 2>/dev/null | grep -qi "Inter"; then
    UI_FONT="Inter"
    UI_FONT_BOLD="Inter"
else
    UI_FONT="Noto Sans"
    UI_FONT_BOLD="Noto Sans"
fi

echo "UI font:  $UI_FONT"

# ---------------------------------------------------------
# Keyboard
# ---------------------------------------------------------

DEFAULT_KEYBOARD="us"

echo
echo "Keyboard layouts"
echo "Examples:"
echo "  us"
echo "  fr"
echo "  fr,us,ru"
echo "  de,us"
echo

if [[ -n "${CHIE_KEYBOARD:-}" ]]; then
    KEYBOARD="$CHIE_KEYBOARD"
elif $DRY_RUN; then
    KEYBOARD="$DEFAULT_KEYBOARD"
else
    read -r -p "Keyboard layout(s) [$DEFAULT_KEYBOARD]: " KEYBOARD
    KEYBOARD="${KEYBOARD:-$DEFAULT_KEYBOARD}"
fi

echo "Keyboard: $KEYBOARD"

# Workspace number-row keys
#
# French AZERTY exposes symbols such as ampersand/eacute on the
# unshifted number row. Most other layouts expose 1..9 directly.

PRIMARY_LAYOUT="${KEYBOARD%%,*}"

if [[ "$PRIMARY_LAYOUT" == "fr" ]]; then
    WS1_KEY="ampersand"
    WS2_KEY="eacute"
    WS3_KEY="quotedbl"
    WS4_KEY="apostrophe"
    WS5_KEY="parenleft"
    WS6_KEY="minus"
    WS7_KEY="egrave"
    WS8_KEY="underscore"
    WS9_KEY="ccedilla"
else
    WS1_KEY="1"
    WS2_KEY="2"
    WS3_KEY="3"
    WS4_KEY="4"
    WS5_KEY="5"
    WS6_KEY="6"
    WS7_KEY="7"
    WS8_KEY="8"
    WS9_KEY="9"
fi


# ---------------------------------------------------------
# Dependencies
# ---------------------------------------------------------

REQUIRED_PACKAGES=(
    hyprland
    hyprpaper
    hyprlock
    hypridle
    waybar
    rofi-wayland
    swaync
    fastfetch
    playerctl
    pipewire
    wireplumber
    xdg-desktop-portal
    xdg-desktop-portal-hyprland
    grim
    slurp
    wl-clipboard
    pavucontrol
    curl
    imagemagick
    jq
    libnotify
    zsh
    kitty
)

OPTIONAL_PACKAGES=(
    kitty
    dolphin
    thunar
    alacritty
    foot
    wezterm
)

MISSING_PACKAGES=()

for pkg in "${REQUIRED_PACKAGES[@]}"; do
    if ! pacman -Q "$pkg" >/dev/null 2>&1; then
        MISSING_PACKAGES+=("$pkg")
    fi
done

if (( ${#MISSING_PACKAGES[@]} > 0 )); then
    echo
    echo "Missing required packages:"
    printf '  %s\n' "${MISSING_PACKAGES[@]}"

    if $DRY_RUN; then
        echo
        echo "Dry run: dependencies would be installed with:"
        printf 'sudo pacman -S --needed'
        printf ' %q' "${MISSING_PACKAGES[@]}"
        printf '\n'
    else
        echo
        read -r -p "Install missing packages now? [Y/n]: " answer
        answer="${answer:-Y}"

        case "$answer" in
            y|Y|yes|YES)
                sudo pacman -S --needed "${MISSING_PACKAGES[@]}"
                ;;
            *)
                echo "Cannot continue without required dependencies."
                exit 1
                ;;
        esac
    fi
else
    echo
    echo "✓ Required packages installed"
fi

# ---------------------------------------------------------
# Application detection
# ---------------------------------------------------------

if [[ -n "${CHIE_TERMINAL:-}" ]]; then
    TERMINAL="$CHIE_TERMINAL"
elif command -v kitty >/dev/null 2>&1; then
    TERMINAL="kitty"
elif command -v foot >/dev/null 2>&1; then
    TERMINAL="foot"
elif command -v alacritty >/dev/null 2>&1; then
    TERMINAL="alacritty"
elif command -v wezterm >/dev/null 2>&1; then
    TERMINAL="wezterm"
else
    TERMINAL="kitty"
fi

case "$TERMINAL" in
    kitty)
        TERMINAL_CLASS="kitty"
        ;;
    foot)
        TERMINAL_CLASS="foot"
        ;;
    alacritty)
        TERMINAL_CLASS="Alacritty"
        ;;
    wezterm)
        TERMINAL_CLASS="org.wezfurlong.wezterm"
        ;;
    *)
        TERMINAL_CLASS="${CHIE_TERMINAL_CLASS:-$TERMINAL}"
        ;;
esac

if [[ -n "${CHIE_FILE_MANAGER:-}" ]]; then
    FILE_MANAGER="$CHIE_FILE_MANAGER"
elif command -v dolphin >/dev/null 2>&1; then
    FILE_MANAGER="dolphin"
elif command -v thunar >/dev/null 2>&1; then
    FILE_MANAGER="thunar"
elif command -v nautilus >/dev/null 2>&1; then
    FILE_MANAGER="nautilus"
elif command -v nemo >/dev/null 2>&1; then
    FILE_MANAGER="nemo"
else
    FILE_MANAGER="xdg-open ."
fi

echo "Terminal: $TERMINAL"
echo "Files:    $FILE_MANAGER"

# ---------------------------------------------------------
# Stage files
# ---------------------------------------------------------

STAGE="$(mktemp -d -t chie-shell-XXXXXX)"
trap 'rm -rf "$STAGE"' EXIT

mkdir -p "$STAGE/home"

cp -a "$SOURCE/." "$STAGE/home/"

echo
echo "Generating configuration..."

TOKEN_REGEX='@HOME@|@USERNAME@|@HOSTNAME@|@KEYBOARD@|@TERMINAL@|@TERMINAL_CLASS@|@FILE_MANAGER@|@UI_FONT@|@UI_FONT_BOLD@|@WS1_KEY@|@WS2_KEY@|@WS3_KEY@|@WS4_KEY@|@WS5_KEY@|@WS6_KEY@|@WS7_KEY@|@WS8_KEY@|@WS9_KEY@'

while IFS= read -r -d '' file; do
    if grep -qE "$TOKEN_REGEX" "$file" 2>/dev/null; then
        sed -i \
            -e "s|@HOME@|$HOME_VALUE|g" \
            -e "s|@USERNAME@|$USERNAME_VALUE|g" \
            -e "s|@HOSTNAME@|$HOSTNAME_VALUE|g" \
            -e "s|@KEYBOARD@|$KEYBOARD|g" \
            -e "s|@TERMINAL@|$TERMINAL|g" \
            -e "s|@TERMINAL_CLASS@|$TERMINAL_CLASS|g" \
            -e "s|@FILE_MANAGER@|$FILE_MANAGER|g" \
            -e "s|@WS1_KEY@|$WS1_KEY|g" \
            -e "s|@WS2_KEY@|$WS2_KEY|g" \
            -e "s|@WS3_KEY@|$WS3_KEY|g" \
            -e "s|@WS4_KEY@|$WS4_KEY|g" \
            -e "s|@WS5_KEY@|$WS5_KEY|g" \
            -e "s|@WS6_KEY@|$WS6_KEY|g" \
            -e "s|@WS7_KEY@|$WS7_KEY|g" \
            -e "s|@WS8_KEY@|$WS8_KEY|g" \
            -e "s|@WS9_KEY@|$WS9_KEY|g" \
            -e "s|@UI_FONT_BOLD@|$UI_FONT_BOLD|g" \
            -e "s|@UI_FONT@|$UI_FONT|g" \
            "$file"
    fi
done < <(find "$STAGE/home" -type f -print0)

UNRESOLVED="$(
    grep -RniE "$TOKEN_REGEX" "$STAGE/home" 2>/dev/null || true
)"

if [[ -n "$UNRESOLVED" ]]; then
    echo
    echo "ERROR: unresolved Chie Shell template variables:"
    echo "$UNRESOLVED"
    exit 1
fi

echo "✓ Configuration generated"

# ---------------------------------------------------------
# Dry run ends here
# ---------------------------------------------------------

if $DRY_RUN; then
    echo
    echo "DRY RUN SUCCESSFUL"
    echo
    echo "Nothing in your home directory was changed."
    echo
    echo "Generated configuration:"
    find "$STAGE/home" -maxdepth 3 -type f | sed "s|$STAGE/home|~|"
    exit 0
fi

# ---------------------------------------------------------
# Backup
# ---------------------------------------------------------

TIMESTAMP="$(date +%Y%m%d-%H%M%S)"
BACKUP="$HOME/.chie-shell-backups/$TIMESTAMP"

mkdir -p "$BACKUP/.config"

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
echo "Backing up existing configuration..."

for name in "${CONFIG_DIRS[@]}"; do
    target="$HOME/.config/$name"

    if [[ -e "$target" || -L "$target" ]]; then
        echo "  $name"
        mv "$target" "$BACKUP/.config/$name"
    fi
done

for name in .zshrc .gtkrc-2.0; do
    target="$HOME/$name"

    if [[ -e "$target" || -L "$target" ]]; then
        echo "  $name"
        mv "$target" "$BACKUP/$name"
    fi
done

# ---------------------------------------------------------
# Automatic rollback
# ---------------------------------------------------------

INSTALL_COMMITTED=false

rollback_install() {
    status=$?

    if [[ "$INSTALL_COMMITTED" == true || "$status" -eq 0 ]]; then
        return
    fi

    echo
    echo "Installation failed."
    echo "Rolling back previous configuration..."

    for name in "${CONFIG_DIRS[@]}"; do
        rm -rf "$HOME/.config/$name"

        if [[ -e "$BACKUP/.config/$name" || -L "$BACKUP/.config/$name" ]]; then
            mv "$BACKUP/.config/$name" "$HOME/.config/$name"
        fi
    done

    rm -f "$HOME/.zshrc" "$HOME/.gtkrc-2.0"

    if [[ -e "$BACKUP/.zshrc" || -L "$BACKUP/.zshrc" ]]; then
        mv "$BACKUP/.zshrc" "$HOME/.zshrc"
    fi

    if [[ -e "$BACKUP/.gtkrc-2.0" || -L "$BACKUP/.gtkrc-2.0" ]]; then
        mv "$BACKUP/.gtkrc-2.0" "$HOME/.gtkrc-2.0"
    fi

    echo "✓ Previous configuration restored automatically."
}

trap rollback_install EXIT

# ---------------------------------------------------------
# Install
# ---------------------------------------------------------

echo
echo "Installing Chie Shell..."

mkdir -p "$HOME/.config"

for name in "${CONFIG_DIRS[@]}"; do
    if [[ -d "$STAGE/home/.config/$name" ]]; then
        cp -a "$STAGE/home/.config/$name" "$HOME/.config/$name"
    fi
done

[[ -f "$STAGE/home/.zshrc" ]] &&
    cp "$STAGE/home/.zshrc" "$HOME/.zshrc"

[[ -f "$STAGE/home/.gtkrc-2.0" ]] &&
    cp "$STAGE/home/.gtkrc-2.0" "$HOME/.gtkrc-2.0"

chmod +x "$HOME/.config/hypr/scripts/"*.sh 2>/dev/null || true
chmod +x "$HOME/.config/waybar/"*.sh 2>/dev/null || true

INSTALL_COMMITTED=true

echo
echo "╭──────────────────────────────────╮"
echo "│      CHIE SHELL INSTALLED ✓      │"
echo "╰──────────────────────────────────╯"
echo
echo "Backup:"
echo "  $BACKUP"
echo
echo "Log out of Hyprland and log back in"
echo "to start the complete configuration."
echo
