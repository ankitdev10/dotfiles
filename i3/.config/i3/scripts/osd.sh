#!/usr/bin/env bash
sink=@DEFAULT_AUDIO_SINK@
source=@DEFAULT_AUDIO_SOURCE@

show() {
    local glyph=$1 pct=$2 title=$3 label=$4 width=20
    local filled=$(( (pct > 100 ? 100 : pct) * width / 100 ))
    local on off
    printf -v on '%*s' "$filled" ''
    printf -v off '%*s' $(( width - filled )) ''
    local bar="<span foreground='#cba6f7'>${on// /━}</span><span foreground='#45475a'>${off// /━}</span>"
    dunstify -a osd -u low -t 1500 -h string:x-dunst-stack-tag:osd \
        "$title" "<span foreground='#cba6f7'>$glyph</span>  $bar  $label"
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
        show $'\uf131' 0 "Microphone" "Muted"
    else
        v=$(level "$source")
        show $'\uf130' "$v" "Microphone" "$v%"
    fi
else
    v=$(level "$sink")
    if muted "$sink"; then
        show $'\U000f075f' 0 "Volume" "Muted"
    else
        glyph=$'\U000f057e'
        (( v < 66 )) && glyph=$'\U000f0580'
        (( v < 33 )) && glyph=$'\U000f057f'
        show "$glyph" "$v" "Volume" "$v%"
    fi
fi
