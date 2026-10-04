#!/usr/bin/env bash
set -u

# Keep a lightweight text clipboard history for the Chie clipboard menu.
# Hyprland starts this once per session.
exec wl-paste --type text --watch cliphist store
