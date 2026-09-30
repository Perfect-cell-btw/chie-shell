# ☻ Chie Shell

A lightweight Chie Satonaka / Persona-inspired Hyprland setup for Arch Linux.

Built to be portable across machines: the installer detects the current user, hostname, font, terminal and file manager, and generates keyboard/workspace bindings automatically.

## What it installs

Chie Shell uses:

- Hyprland
- Waybar
- Rofi
- SwayNC
- Hyprpaper
- Hyprlock
- Hypridle
- Kitty
- Zsh
- Fastfetch
- PipeWire / WirePlumber
- xdg-desktop-portal-hyprland
- Grim + Slurp
- wl-clipboard
- playerctl

The installer checks required Arch packages and offers to install anything missing.

## Fresh Arch install

First install Git:

```bash
sudo pacman -S --needed git
```

Clone the repository:

```bash
git clone https://github.com/Perfect-cell-btw/chie-shell.git
cd chie-shell
```

Always test first:

```bash
./install.sh --dry-run
```

If the dry run succeeds, install:

```bash
./install.sh
```

The installer will ask for your keyboard layout. The default is:

```text
us
```

Examples:

```text
fr
fr,us,ru
de,us
```

You can also set it before launching the installer:

```bash
CHIE_KEYBOARD='fr,us,ru' ./install.sh
```

After installation, log out and back into Hyprland.

## What the installer does

Before changing your setup, Chie Shell backs up existing configs to:

```text
~/.chie-shell-backups/
```

It then generates machine-specific configuration from portable templates.

The repo itself does not hardcode:

- username
- home directory
- hostname
- monitor name
- GPU vendor
- keyboard layout

It also automatically selects a UI font in this order:

1. Google Sans Flex
2. Inter
3. Noto Sans

For applications it detects supported terminals and file managers automatically.

## Keyboard layouts

French layouts get AZERTY workspace bindings automatically.

For example, on French AZERTY the number row uses:

```text
& é " ' ( - è _ ç
```

On US and most other layouts it uses:

```text
1 2 3 4 5 6 7 8 9
```

## Main keybinds

| Key | Action |
| --- | --- |
| `SUPER + Q` | Terminal |
| `SUPER + E` | File manager |
| `SUPER + R` | Rofi launcher |
| `SUPER + A` | Close window |
| `SUPER + V` | Toggle floating |
| `SUPER + P` | Pseudo tile |
| `SUPER + F` | Fullscreen |
| `SUPER + N` | Notification center |
| `SUPER + W` | Wallpaper picker |
| `SUPER + L` | Lock screen |
| `SUPER + SPACE` | Next keyboard layout |
| `SUPER + SHIFT + E` | Power menu |
| `SUPER + SHIFT + X` | Area screenshot |
| `SUPER + PRINT` | Full screenshot |

Focus navigation:

| Key | Direction |
| --- | --- |
| `SUPER + SHIFT + Z` | Up |
| `SUPER + SHIFT + S` | Down |
| `SUPER + SHIFT + Q` | Left |
| `SUPER + SHIFT + D` | Right |

Workspace switching uses `SUPER + workspace key`.

Move the active window with:

```text
SUPER + SHIFT + workspace key
```

## Wallpaper picker

Press:

```text
SUPER + W
```

The wallpaper picker reads images from:

```text
~/.config/chie-shell/assets/wallpapers/
```

It applies the selected wallpaper to detected Hyprland monitors.

## Notifications

Open SwayNC with:

```text
SUPER + N
```

## Screenshots

Area screenshot:

```text
SUPER + SHIFT + X
```

Full screenshot:

```text
SUPER + PRINT
```

Screenshots are saved under:

```text
~/Pictures/Screenshots/
```

## Restore previous configuration

To restore the most recent backup:

```bash
./restore-backup.sh
```

## Uninstall

Run:

```bash
./uninstall.sh
```

The uninstall script can also restore the newest Chie Shell backup.

## Updating after a distro hop

Once cloned, update the repo with:

```bash
cd ~/chie-shell
git pull
```

Then test the current installer:

```bash
./install.sh --dry-run
```

and install:

```bash
./install.sh
```

## Updating your personal repo after changing configs

Edit the templates inside:

```text
~/chie-shell/dotfiles/
```

Then commit and push:

```bash
cd ~/chie-shell
git add .
git commit -m "Update Chie Shell"
git push
```

Do not copy machine-specific paths such as `/home/username` into the templates. Use the existing installer placeholders and portable shell paths instead.

## Troubleshooting

Check Hyprland configuration errors:

```bash
hyprctl configerrors
```

Check running shell components:

```bash
pgrep -a waybar
pgrep -a hyprpaper
pgrep -a swaync
pgrep -a hypridle
```

Restart Waybar:

```bash
pkill waybar
waybar &
```

Restart SwayNC:

```bash
pkill swaync
swaync &
```

Restart Hyprpaper:

```bash
pkill hyprpaper
hyprpaper &
```

## Notes

Chie Shell currently targets Arch Linux and modern Hyprland.

The repo intentionally avoids global NVIDIA, AMD or Intel GPU-specific environment variables so the base configuration remains portable.

Persona / Chie artwork included in this private repository is used as personal desktop artwork.
