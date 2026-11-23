#!/usr/bin/env bash
trap 'kill 0' EXIT
mic=$''
mic_off=$''

render() {
    local out
    out=$(timeout 3 wpctl get-volume @DEFAULT_AUDIO_SOURCE@ 2>/dev/null)
    if [[ -z "$out" ]]; then
        echo "%{F#6c7086}$mic_off%{F-} none"
    elif [[ "$out" == *MUTED* ]]; then
        echo "%{F#f38ba8}$mic_off%{F-} muted"
    else
        echo "%{F#cba6f7}$mic%{F-} $(awk '{printf "%d", $2*100}' <<< "$out")%"
    fi
}

render
pactl subscribe 2>/dev/null | grep --line-buffered -E "'change' on (source|server)" | while read -r _; do
    render
done
