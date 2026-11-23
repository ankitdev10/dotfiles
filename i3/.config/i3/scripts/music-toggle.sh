#!/usr/bin/env bash
has() { i3-msg -t get_tree | grep -q "\"class\":\"$1\""; }

launched=0
if ! has music-viz && command -v cava >/dev/null; then
    kitty --class music-viz -o confirm_os_window_close=0 -o background_opacity=0.9 -o window_padding_width=12 -e cava &
    launched=1
fi
if ! has music-panel; then
    kitty --class music-panel -o confirm_os_window_close=0 -o background_opacity=0.9 -o window_padding_width=8 -e ~/.config/i3/scripts/nowplaying.sh &
    launched=1
fi

if (( launched )); then
    for _ in $(seq 20); do
        has music-panel && { ! command -v cava >/dev/null || has music-viz; } && break
        sleep 0.1
    done
    sleep 0.2
fi

visible=$(i3-msg -t get_tree | python3 -I -c '
import json, sys
def walk(n, ws=None):
    if n.get("type") == "workspace":
        ws = n.get("name")
    if (n.get("window_properties") or {}).get("class", "").startswith("music-") and ws != "__i3_scratch":
        print("yes")
    for c in n.get("nodes", []) + n.get("floating_nodes", []):
        walk(c, ws)
walk(json.load(sys.stdin))')

if [[ -n "$visible" ]]; then
    i3-msg '[class="^music-"] move scratchpad' >/dev/null
else
    i3-msg '[class="^music-viz$"] scratchpad show, move position 1480 600; [class="^music-panel$"] scratchpad show, move position 1280 860' >/dev/null
fi
