#!/bin/bash

# Function to get current volume
get_volume() {
    pamixer --get-volume
}

# Function to send notification
notify_user() {
    vol=$(get_volume)
    # This specific format (-h int:value:$vol) allows SwayNC to show a progress bar
    notify-send -h string:x-canonical-private-synchronous:sys-notify -u low -h int:value:$vol "Volume: ${vol}%"
}

# Handle options
case $1 in
    up)
        pamixer -i 5
        notify_user
        ;;
    down)
        pamixer -d 5
        notify_user
        ;;
    mute)
        pamixer -t
        if $(pamixer --get-mute); then
            notify-send -h string:x-canonical-private-synchronous:sys-notify -u low "Muted"
        else
            notify_user
        fi
        ;;
esac
