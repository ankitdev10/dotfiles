#!/usr/bin/env bash
if ! i3-msg -t get_tree | grep -q '"class":"dropdown"'; then
    kitty --class dropdown -o confirm_os_window_close=0 &
    for _ in $(seq 30); do
        i3-msg -t get_tree | grep -q '"class":"dropdown"' && break
        sleep 0.1
    done
    sleep 0.2
fi
i3-msg '[class="^dropdown$"] scratchpad show, move position center' >/dev/null
