#!/usr/bin/env bash
msg="Type an expression, e.g. 15% of 240, 3 ft to cm, 2^10"
while true; do
    input=$(rofi -dmenu -p $' Calc' -mesg "$msg" -theme-str 'listview {lines: 0;}') || exit 0
    [[ -z "$input" ]] && exit 0
    result=$(qalc -t -- "$input" 2>&1)
    printf '%s' "$result" | xclip -selection clipboard
    msg="$input = $result   (copied)"
done
