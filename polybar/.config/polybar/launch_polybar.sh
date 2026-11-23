#!/usr/bin/env bash
export WLAN=$(ls /sys/class/net | grep -m1 '^wl')
export BATTERY=$(ls /sys/class/power_supply | grep -m1 '^BAT')
export ADAPTER=$(ls /sys/class/power_supply | grep -m1 -E '^(AC|ADP|ACAD)')
if type xrandr >/dev/null 2>&1; then
    for m in $(xrandr --query | grep " connected" | cut -d" " -f1); do
        MONITOR=$m polybar --reload toph &
    done
else
    polybar --reload toph &
fi
