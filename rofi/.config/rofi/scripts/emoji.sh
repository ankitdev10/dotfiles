#!/usr/bin/env bash
data="$HOME/.config/rofi/scripts/emoji.txt"
choice=$(rofi -dmenu -i -p $' Emoji' -theme-str 'window {width: 600px;} listview {lines: 12;}' < "$data") || exit 0
emoji=${choice%% *}
[[ -n "$emoji" ]] && printf '%s' "$emoji" | xclip -selection clipboard && dunstify -t 2000 "Copied $emoji"
