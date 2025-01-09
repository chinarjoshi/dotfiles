#!/bin/sh

while true; do
    # Get battery status
    battery=$(cat /sys/class/power_supply/BAT*/capacity 2>/dev/null)
    battery_status=$(cat /sys/class/power_supply/BAT*/status 2>/dev/null)
    if [[ $battery_status == "Charging" ]]; then
        battery="$battery%*"
    else
        battery="$battery%"
    fi

    # Get volume percentage
    volume=$(pactl get-sink-volume @DEFAULT_SINK@ | grep -oP '\d+%' | head -1)
    muted=$(pactl get-sink-mute @DEFAULT_SINK@ | grep -o "yes")

    if [[ $muted == "yes" ]]; then
        volume="M"
    fi

    time=$(date "+%I:%M")

    # Combine into one line
    echo "$battery | $volume | $time"

    # Update every second
    sleep 5
done

