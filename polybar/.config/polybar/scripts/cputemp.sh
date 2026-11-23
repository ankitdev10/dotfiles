#!/usr/bin/env bash
for name in k10temp coretemp zenpower cpu_thermal; do
    for d in /sys/class/hwmon/hwmon*; do
        if [[ "$(cat "$d/name" 2>/dev/null)" == "$name" ]]; then
            echo "$(( $(cat "$d/temp1_input") / 1000 ))°C"
            exit 0
        fi
    done
done
if [[ -r /sys/class/thermal/thermal_zone0/temp ]]; then
    echo "$(( $(cat /sys/class/thermal/thermal_zone0/temp) / 1000 ))°C"
else
    echo "--°C"
fi
