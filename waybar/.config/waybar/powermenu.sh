#!/usr/bin/env bash
set -e

options="Lock\nLogout\nReboot\nShutdown"
choice="$(printf "$options" | rofi -dmenu -p "Power")"

case "$choice" in
  Lock)     loginctl lock-session ;;
  Logout)   hyprctl dispatch exit ;;
  Reboot)   systemctl reboot ;;
  Shutdown) systemctl poweroff ;;
  *) exit 0 ;;
esac

