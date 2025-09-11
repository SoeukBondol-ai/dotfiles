#!/bin/bash
mkdir -p ~/Pictures/Screenshots

file=~/Pictures/Screenshots/$(date +'%Y-%m-%d_%H-%M-%S').png

# Take area screenshot, save to file AND copy to clipboard
grim -g "$(slurp)" - | tee "$file" | wl-copy

