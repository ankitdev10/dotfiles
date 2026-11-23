#!/usr/bin/env bash
img=$(mktemp --suffix=.png)
trap 'rm -f "$img"' EXIT

import -window root "$img"
convert "$img" -scale 10% -blur 0x2 -resize 1000% -fill '#11111b' -colorize 45% "$img"

opts=(-i "$img" -e -f)

if [[ -e /dev/fd/${XSS_SLEEP_LOCK_FD:--1} ]]; then
    kill_i3lock() { pkill -xu "$EUID" "$@" i3lock; }
    trap 'kill_i3lock; rm -f "$img"' TERM INT
    i3lock "${opts[@]}" {XSS_SLEEP_LOCK_FD}<&-
    exec {XSS_SLEEP_LOCK_FD}<&-
    while kill_i3lock -0; do
        sleep 0.5
    done
else
    trap 'kill %%; rm -f "$img"' TERM INT
    i3lock -n "${opts[@]}" &
    wait
fi
