#!/usr/bin/env bash
tput civis
trap 'tput cnorm; exit 0' INT TERM
bold=$'\e[1m'; reset=$'\e[0m'
text=$'\e[38;2;205;214;244m'; red=$'\e[38;2;243;139;168m'; blue=$'\e[38;2;137;180;250m'
dim=$'\e[38;2;108;112;134m'; green=$'\e[38;2;166;227;161m'

fmt() { local s=${1%.*}; printf '%d:%02d' $((s / 60)) $((s % 60)); }

while true; do
    cols=$(tput cols)
    out=""
    if ! command -v playerctl >/dev/null; then
        out="\n  ${dim}Install playerctl: sudo apt install playerctl${reset}"
    else
        status=$(playerctl status 2>/dev/null)
        if [[ -z "$status" || "$status" == "Stopped" ]]; then
            out="\n  ${dim}Nothing playing${reset}"
        else
            title=$(playerctl metadata title 2>/dev/null)
            artist=$(playerctl metadata artist 2>/dev/null)
            album=$(playerctl metadata album 2>/dev/null)
            pos=$(playerctl position 2>/dev/null || echo 0)
            len_us=$(playerctl metadata mpris:length 2>/dev/null || echo 0)
            len=$(( ${len_us:-0} / 1000000 ))
            vol=$(playerctl volume 2>/dev/null | awk '{printf "%d", $1*100}')
            player=$(playerctl metadata --format '{{ playerName }}' 2>/dev/null)
            p=${pos%.*}; p=${p:-0}
            width=$(( cols - 4 ))
            filled=0
            (( len > 0 )) && filled=$(( p * width / len ))
            printf -v done_part '%*s' "$filled" ''
            printf -v rest_part '%*s' $(( width - filled )) ''
            bar="${red}${done_part// /━}${dim}${rest_part// /━}${reset}"
            line2="${red}${artist}${reset}"
            [[ -n "$album" ]] && line2+=" ${dim}-${reset} ${blue}${album}${reset}"
            out="  ${text}$(fmt "$p")/$(fmt "$len")${reset}   ${bold}${text}♪ ${title}${reset}\n"
            out+="  ${dim}[${status,,}]${reset}   ${line2}\n"
            out+="  ${dim}${player}${reset}${vol:+   ${green}vol ${vol}%${reset}}\n\n"
            out+="  ${bar}"
        fi
    fi
    printf '\e[H\e[2J%b' "$out"
    sleep 1
done
