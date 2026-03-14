#!/usr/bin/env bash
set -euo pipefail

# Kill old instances
pkill waybar || true

# Small delay helps on some systems
sleep 0.2

# Start with your user config + style
waybar -c "$HOME/.config/waybar/config.jsonc" -s "$HOME/.config/waybar/style.css" &

