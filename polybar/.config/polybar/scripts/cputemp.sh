#!/usr/bin/env bash
for d in /sys/class/hwmon/hwmon*; do
    if [[ "$(cat "$d/name" 2>/dev/null)" == "k10temp" ]]; then
        echo "$(( $(cat "$d/temp1_input") / 1000 ))°C"
        exit 0
    fi
done
echo "--°C"
