import os
import re
import subprocess
from pathlib import Path

HOME = Path.home()
CACHE = HOME / ".cache" / "cheatsheet"
I3_CONFIG = HOME / ".config" / "i3" / "config"
TMUX_CONFIG = HOME / ".tmux.conf"
NVIM_DIR = HOME / ".config" / "nvim"

I3_RULES = [
    (r"^kitty$", "Open terminal (kitty)"),
    (r"^kill$", "Close window"),
    (r"^focus (left|right|up|down)$", lambda m: f"Focus window {m[1]}"),
    (r"^move (left|right|up|down)$", lambda m: f"Move window {m[1]}"),
    (r"^focus output (left|right)$", lambda m: f"Focus monitor {m[1]}"),
    (r"^fullscreen toggle$", "Toggle fullscreen"),
    (r"^layout stacking$", "Layout: stacking"),
    (r"^layout tabbed$", "Layout: tabbed"),
    (r"^layout toggle split$", "Layout: toggle split direction"),
    (r"^floating toggle$", "Toggle floating"),
    (r"^focus parent$", "Focus parent container"),
    (r"^reload$", "Reload i3 config"),
    (r"^restart$", "Restart i3 (keeps windows)"),
    (r"^\"i3-nagbar.*$", "Exit i3 / log out"),
    (r"^mode \"resize\"$", "Resize mode (arrows/hjkl, Esc to leave)"),
    (r"^mode \"default\"$", "Leave resize mode"),
    (r".*rofi -show drun -theme .*keyit-full.*", "App launcher (fullscreen grid)"),
    (r".*rofi -show drun$", "App launcher"),
    (r".*rofi -show combi$", "Search apps, windows and commands"),
    (r".*rofi -show window$", "Switch window"),
    (r".*powermenu\.sh$", "Power menu"),
    (r".*emoji\.sh$", "Emoji picker"),
    (r".*calc\.sh$", "Calculator"),
    (r".*clipboard\.sh$", "Clipboard history (rofi)"),
    (r".*cheatsheet.*", "This cheatsheet"),
    (r".*copyq toggle$", "Clipboard manager (CopyQ)"),
    (r".*copyq quit$", "Quit CopyQ"),
    (r".*dunstctl history-pop$", "Show last notification"),
    (r".*dunstctl close-all$", "Dismiss all notifications"),
    (r".*class=\"\^dropdown\$\"\] scratchpad show.*", "Dropdown terminal"),
    (r".*dropdown-toggle\.sh$", "Dropdown terminal (show / hide)"),
    (r".*music-toggle\.sh$", "Music corner (visualizer + now playing)"),
    (r".*osd\.sh up$", "Volume up"),
    (r".*osd\.sh down$", "Volume down"),
    (r".*osd\.sh mute$", "Mute speakers"),
    (r".*osd\.sh mic$", "Mute microphone"),
    (r".*brightnessctl set \+.*", "Brightness up"),
    (r".*brightnessctl set .*-$", "Brightness down"),
    (r".*flameshot gui.*", "Screenshot: select area"),
    (r".*flameshot screen.*", "Screenshot: full screen"),
    (r"^resize shrink width.*", "Shrink width"),
    (r"^resize grow width.*", "Grow width"),
    (r"^resize shrink height.*", "Shrink height"),
    (r"^resize grow height.*", "Grow height"),
]

KEY_NAMES = {
    "$mod": "Super",
    "Return": "Enter",
    "grave": "`",
    "period": ".",
    "semicolon": ";",
    "space": "Space",
    "Print": "PrtSc",
    "XF86AudioRaiseVolume": "Vol+ key",
    "XF86AudioLowerVolume": "Vol- key",
    "XF86AudioMute": "Mute key",
    "XF86AudioMicMute": "Mic-mute key",
    "XF86MonBrightnessUp": "Bright+ key",
    "XF86MonBrightnessDown": "Bright- key",
}


def pretty_key(key):
    return "+".join(KEY_NAMES.get(part, part) for part in key.split("+"))


def describe_i3(command):
    command = re.sub(r"^exec\s+(--no-startup-id\s+)?", "", command).strip()
    for pattern, label in I3_RULES:
        m = re.match(pattern, command)
        if m:
            return label(m) if callable(label) else label
    return command


def i3_section():
    rows = []
    mode = None
    workspace_seen = set()
    for raw in I3_CONFIG.read_text(encoding="utf-8").splitlines():
        line = raw.strip()
        m = re.match(r'^mode "([^"]+)" \{', line)
        if m:
            mode = m[1]
            continue
        if line == "}":
            mode = None
            continue
        m = re.match(r"^bindsym\s+(\S+)\s+(.*)$", line)
        if not m:
            continue
        key, command = m[1], m[2]
        ws = re.match(r"^(move container to )?workspace number", command)
        if ws:
            kind = "move" if ws[1] else "go"
            if kind in workspace_seen:
                continue
            workspace_seen.add(kind)
            prefix = "Super+Shift" if kind == "move" else "Super"
            label = "Move window to workspace 1–10" if kind == "move" else "Go to workspace 1–10"
            rows.append(("i3", f"{prefix}+1…0", label))
            if kind == "go":
                rows.append(("i3", "Super+<current no.>", "Jump back to previous workspace"))
            continue
        section = "i3 resize" if mode == "resize" else "i3"
        rows.append((section, pretty_key(key), describe_i3(command)))
    return rows


def polybar_section():
    return [
        ("bar", "Click workspace", "Go to that workspace"),
        ("bar", "Click ⏮ ⏯ ⏭", "Previous / play-pause / next track"),
        ("bar", "Click wifi pill", "Wi-Fi menu (switch network, on/off)"),
        ("bar", "Click clock", "Calendar"),
        ("bar", "Scroll volume pill", "Volume up / down (max 150%)"),
        ("bar", "Right-click volume", "Open sound settings (pavucontrol)"),
        ("bar", "Click mic pill", "Mute / unmute microphone"),
        ("bar", "Scroll mic pill", "Mic level up / down"),
    ]


def tmux_section():
    rows = []
    prefix = "C-b"
    text = TMUX_CONFIG.read_text(encoding="utf-8") if TMUX_CONFIG.exists() else ""
    m = re.search(r"^set -g prefix (\S+)", text, re.M)
    if m:
        prefix = m[1]
    custom = {
        "|": "Split pane side by side",
        "-": "Split pane top / bottom",
        "r": "Reload tmux config",
        "m": "Zoom / unzoom pane",
        "h": "Focus pane left",
        "j": "Focus pane down",
        "k": "Focus pane up",
        "l": "Focus pane right",
    }
    seen = set()
    for line in text.splitlines():
        m = re.match(r"^bind(?:-key)?\s+(?:-r\s+)?(?!-T)(\S+)\s+", line.strip())
        if m:
            key = m[1].strip("'\"")
            if key in custom and key not in seen:
                seen.add(key)
                rows.append(("tmux", f"{prefix} {key}", custom[key]))
    rows.append(("tmux", "Ctrl+h/j/k/l", "Move between tmux panes and nvim splits"))
    rows.append(("tmux", "v / y (copy mode)", "Start selection / copy"))
    try:
        out = subprocess.run(["tmux", "list-keys", "-N", "-T", "prefix"], capture_output=True, text=True, timeout=3).stdout
    except (OSError, subprocess.SubprocessError):
        out = ""
    for line in out.splitlines():
        m = re.match(r"^(\S+)\s+(.*)$", line.strip())
        if not m:
            continue
        key = m[1].split(" ")[-1]
        if key in seen:
            continue
        seen.add(key)
        rows.append(("tmux", f"{prefix} {key}", m[2]))
    return rows


def nvim_section():
    CACHE.mkdir(parents=True, exist_ok=True)
    cache = CACHE / "nvim.tsv"
    newest = max((p.stat().st_mtime for p in NVIM_DIR.rglob("*.lua")), default=0)
    if not cache.exists() or cache.stat().st_mtime < newest:
        lua = (
            'local out = {} '
            'local leader = vim.g.mapleader or "\\\\" '
            'for _, mode in ipairs({"n","v","x","i","t"}) do '
            'for _, m in ipairs(vim.api.nvim_get_keymap(mode)) do '
            'if m.desc and m.desc ~= "" then '
            'local lhs = m.lhs:gsub("^" .. vim.pesc(leader), "<leader>") '
            'table.insert(out, mode .. "\\t" .. lhs .. "\\t" .. m.desc) end end end '
            f'local f = io.open("{cache}", "w") f:write(table.concat(out, "\\n")) f:close()'
        )
        try:
            subprocess.run(["nvim", "--headless", "-c", f"lua {lua}", "-c", "qa!"], capture_output=True, timeout=30)
        except (OSError, subprocess.SubprocessError):
            return []
    if not cache.exists():
        return []
    modes = {"n": "", "v": " (visual)", "x": " (visual)", "i": " (insert)", "t": " (terminal)"}
    rows = []
    seen = set()
    for line in cache.read_text(encoding="utf-8").splitlines():
        parts = line.split("\t")
        if len(parts) != 3:
            continue
        mode, lhs, desc = parts
        lhs = lhs.replace("<leader>", "Space ").replace("Space  ", "Space Space").strip()
        if (lhs, desc) in seen:
            continue
        seen.add((lhs, desc))
        rows.append(("nvim", lhs + modes.get(mode, ""), desc))
    return rows


def kitty_section():
    return [
        ("kitty", "Ctrl+Shift+c / v", "Copy / paste"),
        ("kitty", "Ctrl+Shift+= / -", "Bigger / smaller font"),
        ("kitty", "Ctrl+Shift+Backspace", "Reset font size"),
        ("kitty", "Ctrl+Shift+F5", "Reload kitty config"),
        ("kitty", "Ctrl+Shift+Up / Down", "Scroll line by line"),
        ("kitty", "Ctrl+Shift+h", "Open scrollback in a pager"),
    ]


def shell_section():
    return [
        ("shell", "z <name>", "Jump to a folder you've visited (zoxide)"),
        ("shell", "z koulier", "Jump to ~/koulier/new-koulier"),
        ("shell", "z -", "Jump back to the previous folder"),
        ("shell", "zoxide query <name>", "Show where z <name> would go"),
        ("shell", "lazygit", "Git UI in the current repo (? for help)"),
        ("shell", "btop", "System monitor"),
        ("shell", "Alt+b / Alt+f", "Cursor one word back / forward"),
    ]


def tips_section():
    return [
        ("tips", "Restart picom", "pkill -x picom; picom --experimental-backends -b"),
        ("tips", "Blur strength", "~/.config/picom/picom.conf → strength (now 4), then restart picom"),
        ("tips", "Dim unfocused", "~/.config/picom/picom.conf → inactive-dim (now 0.2), then restart picom"),
        ("tips", "Terminal opacity", "~/.config/kitty/kitty.conf → background_opacity, then Ctrl+Shift+F5"),
        ("tips", "Border width", "~/.config/i3/config → border pixel 3, then Super+Shift+r"),
        ("tips", "Wallpaper", "~/.config/i3/config → feh line (rainy-city.jpg)"),
        ("tips", "Cursor size", "~/.Xresources → Xcursor.size, then log out / in"),
        ("tips", "Reload tmux", "tmux source-file ~/.tmux.conf  (or C-a r)"),
        ("tips", "Backups", "~/rice-backup-2026-11-23*"),
    ]


def main():
    rows = i3_section() + polybar_section() + tmux_section() + nvim_section() + kitty_section() + shell_section() + tips_section()
    width = 24
    keys = [r[1] if len(r[1]) <= width else r[1][: width - 1] + "…" for r in rows]
    lines = [f"{r[0]:<10} {k:<{width}}  {r[2]}" for r, k in zip(rows, keys)]
    subprocess.run(
        [
            "rofi", "-dmenu", "-i", "-no-custom",
            "-p", " Keys",
            "-mesg", "Type to filter: i3, bar, tmux, nvim, kitty, shell, tips, or any word",
            "-theme-str", "window {width: 1000px;} listview {lines: 16;}",
        ],
        input="\n".join(lines),
        text=True,
    )


if __name__ == "__main__":
    main()
