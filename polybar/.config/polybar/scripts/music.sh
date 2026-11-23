#!/usr/bin/env bash
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
    exit 0
fi

status=$(playerctl status 2>/dev/null)
if [[ -z "$status" || "$status" == "Stopped" ]]; then
    echo "%{F$dim}$note%{F-} Nothing playing"
    exit 0
fi

title=$(playerctl metadata --format '{{ title }}' 2>/dev/null)
(( ${#title} > 25 )) && title="${title:0:24}…"
toggle=$play
[[ "$status" == "Playing" ]] && toggle=$pause

echo "%{F$green}$note%{F-} $title  %{F$cyan}%{A1:playerctl previous:}$prev%{A} %{A1:playerctl play-pause:}$toggle%{A} %{A1:playerctl next:}$next%{A}%{F-}"
