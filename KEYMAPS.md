# Keymaps

The day-to-day keys and commands for this setup. `$mod` is the Super (Windows) key. Everything here is also searchable live with `$mod+F1`.

## i3: windows and workspaces

| Keys | What it does |
|---|---|
| `$mod+Enter` | New terminal (kitty) |
| `$mod+q` | Close the window |
| `$mod+1…0` | Go to workspace 1–10 |
| `$mod+<current number>` | Jump back to the previous workspace |
| `$mod+Shift+1…0` | Send the focused window to another workspace |
| `$mod+h/j/k/l` or arrows | Focus left / down / up / right |
| `$mod+Shift+h/j/k/l` or arrows | Move the window |
| `$mod+Ctrl+h` / `l` | Focus the other monitor |
| `$mod+f` | Fullscreen; again to restore |
| `$mod+Shift+Space` | Float / tile the window; drag floating windows with `$mod` + mouse |
| `$mod+e` | Side by side ↔ top / bottom |
| `$mod+w` / `$mod+s` | Tabbed / stacked layout (`$mod+e` brings back side by side) |
| `$mod+r`, then arrows | Resize mode; `Esc` to leave |
| `$mod+a` | Focus the parent container |
| `$mod+Shift+c` | Reload the i3 config |
| `$mod+Shift+r` | Restart i3 (windows stay) |
| `$mod+Shift+e` | Log out |

## Menus (rofi)

| Keys | What it does |
|---|---|
| `$mod+d` | App launcher |
| `$mod+Shift+d` | Fullscreen app grid |
| `$mod+Tab` | Switch to any open window by name |
| `$mod+Space` | Search apps, windows and commands together |
| `$mod+Shift+v` | Clipboard history |
| `$mod+v` | CopyQ clipboard manager |
| `$mod+c` | Calculator (`15% of 2400`, `5 km to miles`, `0x1f to dec`); result is copied |
| `$mod+.` | Emoji picker (copied) |
| `$mod+x` | Power menu: lock, suspend, log out, reboot, shut down |
| `$mod+F1` | Searchable cheatsheet of every key in i3, tmux, nvim, kitty |

In any menu: type to filter, `Enter` to pick, `Esc` to close.

## Floating helpers

| Keys | What it does |
|---|---|
| `$mod+Shift+Enter` | Dropdown terminal; jumps to the folder of the terminal you were in |
| `$mod+m` | Music corner: visualizer + now playing |
| `$mod+n` / `$mod+Shift+n` | Bring back the last notification / dismiss all |
| `PrtSc` | Screenshot an area (flameshot): `Ctrl+C` copy, `Ctrl+S` save, `Esc` cancel |
| `$mod+PrtSc` | Screenshot the full screen (saved to `~/Pictures/Screenshots` and copied) |

## Media keys

| Keys | What it does |
|---|---|
| Volume up / down | ±5% with a pop-up (max 150%) |
| Mute | Mute speakers |
| Mic mute | Mute the microphone |

## Bar clicks

| Where | What it does |
|---|---|
| Workspace icon | Go to that workspace |
| Music pill `⏮ ⏯ ⏭` | Previous / play-pause / next for whatever is playing |
| Wi-Fi pill | Wi-Fi menu: switch network, rescan, turn off |
| Clock | Calendar |
| Volume pill: click / scroll / right-click | Mute / ±5% / sound settings (output device, per-app volume) |
| Mic pill: click / scroll | Mute / level ±5% |

## tmux

Prefix is `Ctrl+a` (`C-a`): press it, release, then the key.

| Keys | What it does |
|---|---|
| `C-a \|` / `C-a -` | Split side by side / top-bottom (same folder) |
| `Ctrl+h/j/k/l` | Move between panes and nvim splits (no prefix) |
| `C-a` + arrow | Move between panes |
| `C-a m` | Zoom a pane to full size and back |
| `C-a c` | New window |
| `C-a 0…9` | Go to window |
| `C-a n` / `C-a p` | Next / previous window |
| `C-a ,` | Rename the window |
| `C-a x` | Close the pane |
| `C-a s` | List sessions and switch |
| `C-a d` | Detach (keeps running); `tmux a` to come back |
| `C-a [` | Scroll / copy mode: `v` select, `y` copy, `q` quit |
| `C-a r` | Reload the tmux config |
| `C-a I` | Install tmux plugins |

## Neovim

Leader is `Space`.

| Keys | What it does |
|---|---|
| `Space Space` | Find files |
| `Space fs` | Search text in the project |
| `Space fr` | Recent files |
| `Space fc` | Search the word under the cursor |
| `Space e` | File explorer (neo-tree) |
| `Space gg` | lazygit |
| `Space w` / `Ctrl+s` | Save |
| `Space q` / `Space qa` | Quit / quit all |
| `Shift+h` / `Shift+l` | Previous / next buffer tab |
| `Space bd` | Close the buffer |
| `Space sv` / `Space sh` / `Space sx` | Split vertical / horizontal / close split |
| `gd` / `gR` / `gi` | Definition / references / implementation |
| `K` | Docs for what's under the cursor |
| `Space ca` | Code actions |
| `Space rn` | Rename symbol |
| `Space co` | Organize imports |
| `[d` / `]d` | Previous / next diagnostic |
| `Space d` / `Space xx` | Line diagnostics / all diagnostics |
| `gcc` / `gc` (visual) | Toggle comment |
| `ghp` / `gsh` / `grh` | Git: preview / stage / reset hunk |
| `gbl` | Git blame the line |
| `Space j` | Flash jump |
| `Space ss` / `Space sr` | Save / restore session |
| `Space nh` | Clear search highlight |

## kitty

| Keys | What it does |
|---|---|
| `Ctrl+Shift+c` / `v` | Copy / paste |
| `Ctrl+Shift+=` / `-` | Bigger / smaller font |
| `Ctrl+Shift+Backspace` | Reset font size |
| `Ctrl+Shift+F5` | Reload the kitty config |
| `Ctrl+Shift+h` | Scrollback in a pager |

## Shell

| Command | What it does |
|---|---|
| `z <name>` | Jump to a visited folder (`z koulier`, `z i3`, `z polybar`) |
| `z -` / `cd -` | Back to the previous folder |
| `Ctrl+r` | Search command history |
| `Alt+b` / `Alt+f` | Cursor one word back / forward |
| `Ctrl+a` / `Ctrl+e` | Start / end of the line (outside tmux, where `Ctrl+a` is the prefix) |
| `Ctrl+u` / `Ctrl+w` | Delete the whole line / the previous word |
| `!!` | Repeat the last command (`sudo !!`) |
| `lazygit` | Git UI: stage, commit, push, branches |
| `btop` | What is using CPU / RAM |
| `cava` | Audio visualizer (run outside tmux) |
| `ricecost [seconds]` | RAM and CPU cost of the rice |

## Keeping the setup healthy

| Command | When |
|---|---|
| `cd ~/dotfiles && git status` | See what changed |
| `git add -A && git commit -m "…" && git push` | Save the setup to GitHub |
| `i3 -C -c ~/.config/i3/config` | Check the i3 config before reloading (no output means fine) |
| `pkill -x picom; ~/.local/bin/picom -b` | Restart picom after changing blur, glow, animations |
| `killall polybar; ~/.config/polybar/launch_polybar.sh` | Restart the bar |
| `tmux source-file ~/.tmux.conf` | Reload tmux (or `C-a r`) |

## Most underused

`$mod+Tab` (switch window by name), `$mod+Shift+v` (clipboard history), `C-a m` (zoom pane), `z <name>` (jump to folders), and `$mod+F1` whenever you forget something.
