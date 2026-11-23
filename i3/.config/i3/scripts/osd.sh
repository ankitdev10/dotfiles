#!/usr/bin/env bash
sink=@DEFAULT_AUDIO_SINK@
source=@DEFAULT_AUDIO_SOURCE@

show() {
    dunstify -a osd -u low -t 1500 -i "$1" -h string:x-dunst-stack-tag:osd -h "int:value:$2" "$3" "$4"
}

level() { wpctl get-volume "$1" | awk '{printf "%d", $2*100}'; }
muted() { wpctl get-volume "$1" | grep -q MUTED; }

case "$1" in
    up) wpctl set-mute "$sink" 0; wpctl set-volume -l 1.5 "$sink" 5%+ ;;
    down) wpctl set-volume "$sink" 5%- ;;
    mute) wpctl set-mute "$sink" toggle ;;
    mic) wpctl set-mute "$source" toggle ;;
esac

if [[ "$1" == "mic" ]]; then
    if muted "$source"; then
        show microphone-sensitivity-muted 0 "Microphone" "Muted"
    else
        v=$(level "$source")
        show microphone-sensitivity-high "$v" "Microphone" "$v%"
    fi
else
    v=$(level "$sink")
    if muted "$sink"; then
        show audio-volume-muted 0 "Volume" "Muted"
    else
        icon=audio-volume-high
        (( v < 66 )) && icon=audio-volume-medium
        (( v < 33 )) && icon=audio-volume-low
        show "$icon" "$(( v > 100 ? 100 : v ))" "Volume" "$v%"
    fi
fi
