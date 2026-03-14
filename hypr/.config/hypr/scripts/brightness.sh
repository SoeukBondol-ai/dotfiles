#!/bin/bash
set -euo pipefail

# Prefer real backlight devices only (not LEDs, not weird entries)
BRIGHTNESS_DEVICE="$(
  brightnessctl -l -c backlight \
  | sed -n "s/.*Device '\([^']*\)'.*/\1/p" \
  | head -n 1
)"

# If nothing found, fallback to first device from all classes
if [[ -z "${BRIGHTNESS_DEVICE}" ]]; then
  BRIGHTNESS_DEVICE="$(
    brightnessctl -l \
    | sed -n "s/.*Device '\([^']*\)'.*/\1/p" \
    | head -n 1
  )"
fi

# Quick sanity check (avoids division by 0 + bad notify)
if ! brightnessctl -d "$BRIGHTNESS_DEVICE" m >/dev/null 2>&1; then
  notify-send -u critical "Brightness" "No usable brightness device found. Try: brightnessctl -l -c backlight"
  exit 1
fi

get_brightness() {
  local current max
  current="$(brightnessctl -d "$BRIGHTNESS_DEVICE" g)"
  max="$(brightnessctl -d "$BRIGHTNESS_DEVICE" m)"

  # guard
  if [[ -z "$max" || "$max" -eq 0 ]]; then
    echo 0
    return
  fi

  echo $(( current * 100 / max ))
}

notify_user() {
  local bright_percent
  bright_percent="$(get_brightness)"
  notify-send \
    -h string:x-canonical-private-synchronous:sys-notify \
    -u low \
    -h int:value:"$bright_percent" \
    "Brightness: ${bright_percent}%"
}

case "${1:-}" in
  up)
    brightnessctl -d "$BRIGHTNESS_DEVICE" -e4 -n2 set 5%+
    notify_user
    ;;
  down)
    brightnessctl -d "$BRIGHTNESS_DEVICE" -e4 -n2 set 5%-
    notify_user
    ;;
  *)
    echo "Usage: $0 {up|down}"
    exit 2
    ;;
esac

