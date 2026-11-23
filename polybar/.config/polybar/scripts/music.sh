#!/usr/bin/env bash
trap 'kill 0' EXIT
note=$''
prev=$''
play=$''
pause=$''
next=$''
green="#a6e3a1"
cyan="#94e2d5"
dim="#6c7086"

if ! command -v playerctl >/dev/null; then
    echo "%{F$dim}$note%{F-} install playerctl"
    exec sleep infinity
fi

render() {
    local status=$1 title=$2
    if [[ -z "$status" || "$status" == "Stopped" ]]; then
        echo "%{F$dim}$note%{F-} Nothing playing"
        return
    fi
    (( ${#title} > 25 )) && title="${title:0:24}…"
    local toggle=$play
    [[ "$status" == "Playing" ]] && toggle=$pause
    echo "%{F$green}$note%{F-} $title  %{F$cyan}%{A1:playerctl previous:}$prev%{A} %{A1:playerctl play-pause:}$toggle%{A} %{A1:playerctl next:}$next%{A}%{F-}"
}

render "$(playerctl status 2>/dev/null)" "$(playerctl metadata title 2>/dev/null)"
playerctl --follow metadata --format $'{{status}}\t{{title}}' 2>/dev/null | while IFS=$'\t' read -r status title; do
    render "$status" "$title"
done
