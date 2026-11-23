#!/usr/bin/env bash
if [[ "$(dunstctl is-paused 2>/dev/null)" == "true" ]]; then
    echo "%{F#6c7086}󰂛%{F-}"
else
    echo "󰂚"
fi
