#!/usr/bin/env bash
mic=$''
mic_off=$''
out=$(timeout 3 wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null)
if [[ -z "$out" ]]; then
    echo "%{F#6c7086}$mic_off%{F-} none"
elif [[ "$out" == *MUTED* ]]; then
    echo "%{F#f38ba8}$mic_off%{F-} muted"
else
    vol=$(awk '{printf "%d", $2*100}' <<< "$out")
    echo "%{F#cba6f7}$mic%{F-} $vol%"
fi
