#!/usr/bin/env bash
sock="unix:${XDG_RUNTIME_DIR:-/tmp}/kitty-dropdown"

launch() {
    kitty --class dropdown --listen-on "$sock" -o allow_remote_control=socket-only \
        -o confirm_os_window_close=0 -o env=NO_FETCH=1 &
}

focused_dir() {
    local wid pid child comm
    wid=$(xdotool getwindowfocus 2>/dev/null) || return
    pid=$(xdotool getwindowpid "$wid" 2>/dev/null) || return
    [[ "$(cat "/proc/$pid/comm" 2>/dev/null)" == kitty ]] || return
    child=$(pgrep -P "$pid" | head -1) || return
    [[ -n "$child" ]] || return
    for grandchild in $(pgrep -P "$child"); do
        comm=$(cat "/proc/$grandchild/comm" 2>/dev/null)
        if [[ "$comm" == tmux* ]]; then
            tmux display -p '#{pane_current_path}' 2>/dev/null && return
        fi
    done
    readlink "/proc/$child/cwd"
}

dropdown_state() {
    kitty @ --to "$sock" ls 2>/dev/null | python3 -I -c '
import json, sys
try:
    w = json.load(sys.stdin)[0]["tabs"][0]["windows"][0]
except Exception:
    sys.exit(1)
procs = [p["cmdline"][0].rsplit("/", 1)[-1] for p in w.get("foreground_processes", []) if p.get("cmdline")]
idle = all(p in ("bash", "-bash", "zsh", "sh") for p in procs)
print(("idle" if idle else "busy") + "\t" + w.get("cwd", ""))
'
}

visible=$(i3-msg -t get_tree | python3 -I -c '
import json, sys
def walk(n, ws=None):
    if n.get("type") == "workspace":
        ws = n.get("name")
    if (n.get("window_properties") or {}).get("class") == "dropdown":
        print("visible" if ws != "__i3_scratch" else "hidden")
        sys.exit()
    for c in n.get("nodes", []) + n.get("floating_nodes", []):
        walk(c, ws)
walk(json.load(sys.stdin))
print("missing")')

if [[ "$visible" == "hidden" || "$visible" == "missing" ]]; then
    dir=$(focused_dir)
    if [[ "$visible" == "missing" ]]; then
        launch
        for _ in $(seq 30); do
            dropdown_state >/dev/null && break
            sleep 0.1
        done
    fi
    if [[ -n "$dir" && -d "$dir" ]]; then
        state=$(dropdown_state)
        if [[ "${state%%$'\t'*}" == "idle" && "${state#*$'\t'}" != "$dir" ]]; then
            printf -v quoted '%q' "$dir"
            kitty @ --to "$sock" send-text $'\x15'" cd -- $quoted"$'\r' >/dev/null 2>&1
        fi
    fi
fi

i3-msg '[class="^dropdown$"] scratchpad show, move position center' >/dev/null
