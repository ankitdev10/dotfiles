#!/usr/bin/env bash

# Get the microphone volume level and mute status
mic=$(timeout 5s wpctl get-volume @DEFAULT_AUDIO_SOURCE@ || echo "Volume: 0 [MUTED]")

# Initialize variables
icon=" "  # Default icon for active microphone

# Determine if muted and extract volume level
if [[ "$mic" == *"[MUTED]"* ]]; then
    icon=" "  # Mute icon
    mic=${mic//" [MUTED]"/}  # Remove the "[MUTED]" part
else
    mic=${mic#Volume: }  # Clean up the volume output
fi

# Clean up microphone output
mic=$(echo "$mic" | tr -cd '[:digit:]')

# Ensure microphone level is an integer
mic=$(printf "%.0f" "$mic")

# Output the final result
if [[ "$icon" == " " ]]; then
    echo "$icon muted"  # Show muted message without volume level
else
    echo "$icon $mic%"  # Show active microphone icon with volume percentage
fi

