#!/bin/bash

LAPTOP="eDP-1"
EXTERNAL="HDMI-A-1"

# Native laptop mode
LAPTOP_NATIVE="2560x1600@165,0x0,1.25"

# External monitor mode (extend)
EXT_MODE="1920x1080@60"

# Mirror mode resolution (must match both screens)
MIRROR_MODE="1920x1080@60"

choice=$(printf "Extend\nMirror\nExternal Only\nLaptop Only" | rofi -dmenu -p "Display Mode")

case "$choice" in

    "Extend")
        # Laptop left, external right
        hyprctl keyword monitor "$LAPTOP,$LAPTOP_NATIVE"
        hyprctl keyword monitor "$EXTERNAL,$EXT_MODE,2560x0,1"
        ;;

    "Mirror")
        # Both use same resolution at same position
        hyprctl keyword monitor "$LAPTOP,$MIRROR_MODE,0x0,1"
        hyprctl keyword monitor "$EXTERNAL,$MIRROR_MODE,0x0,1"
        ;;

    "External Only")
        hyprctl keyword monitor "$LAPTOP,disable"
        hyprctl keyword monitor "$EXTERNAL,$EXT_MODE,0x0,1"
        ;;

    "Laptop Only")
        hyprctl keyword monitor "$LAPTOP,$LAPTOP_NATIVE"
        hyprctl keyword monitor "$EXTERNAL,disable"
        ;;
esac

