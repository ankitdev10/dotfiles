#!/usr/bin/env bash

# Get the volume level and mute status
vol_output=$(timeout 5s wpctl get-volume @DEFAULT_AUDIO_SINK@ || echo "Volume: 0 [MUTED]")

# Initialize variables
icon=" "  # Default icon for active volume
vol=0       # Default volume

# Determine if muted and extract volume level
if [[ "$vol_output" == *"[MUTED]"* ]]; then
    icon="󰖁 "  # Mute icon
else
    vol=${vol_output#Volume: }  # Clean up the volume oUtput
fi

# Clean up volume output
vol=$(echo "$vol" | tr -cd '[:digit:]')

# Ensure volume is an integer
vol=$(printf "%.0f" "$vol")

# Output the final result
if [[ "$icon" == "🔇 " ]]; then
    echo "$icon"  # Show muted icon only
else
    echo "$icon $vol%"  # Show active speaker icon with volume percentage
fi

