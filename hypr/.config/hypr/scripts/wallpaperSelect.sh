#!/usr/bin/env bash

wallpaperDir="$HOME/Wallpaper/"
themesDir="$HOME/.config/rofi/themes"

# Ensure directory exists
mkdir -p "$wallpaperDir"

# swww transition settings
FPS=60
TYPE="any"
DURATION=3
BEZIER="0.4,0.2,0.4,1.0"
SWWW_PARAMS="--transition-fps ${FPS} --transition-type ${TYPE} --transition-duration ${DURATION} --transition-bezier ${BEZIER}"

# Stop swaybg if running
pkill swaybg 2>/dev/null

# Load wallpapers
mapfile -t PICS < <(find -L "$wallpaperDir" -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' -o -iname '*.gif' \) | sort)

if [[ ${#PICS[@]} -eq 0 ]]; then
  echo "No images found in $wallpaperDir"
  exit 1
fi

# Random
randomPicture="${PICS[$RANDOM % ${#PICS[@]}]}"
randomChoice="[${#PICS[@]}] Random"

# Start swww-daemon if needed
if command -v swww &>/dev/null; then
    if ! pgrep -x "swww-daemon" >/dev/null; then
        swww-daemon &
        sleep 0.5
    fi
fi

rofiCommand="rofi -show -dmenu -theme ${themesDir}/wallpaper-select.rasi"

menu() {
    printf "%s\n" "$randomChoice"
    for file in "${PICS[@]}"; do
        name=$(basename "$file")
        printf "%s\0icon\037%s\n" "${name%.*}" "$file"
    done
}

executeCommand() {
    img="$1"
    if command -v swww &>/dev/null; then
        swww img "$img" ${SWWW_PARAMS}
    elif command -v swaybg &>/dev/null; then
        swaybg -i "$img" &
    else
        echo "Neither swww nor swaybg installed."
        exit 1
    fi
    ln -sf "$img" "$HOME/.current_wallpaper"
}

main() {
    choice=$(menu | $rofiCommand)

    [[ -z "$choice" ]] && exit 0

    if [[ "$choice" == "$randomChoice" ]]; then
        executeCommand "$randomPicture"
        exit 0
    fi

    for file in "${PICS[@]}"; do
        if [[ "$(basename "$file" | cut -d. -f1)" == "$choice" ]]; then
            executeCommand "$file"
            exit 0
        fi
    done

    echo "Image not found."
    exit 1
}

# Prevent multiple rofi instances
pkill rofi 2>/dev/null && exit 0

main

