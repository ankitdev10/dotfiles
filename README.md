# dotfiles

i3 rice on Pop!_OS 22.04: Catppuccin Mocha everywhere, Keyitdev-style pill bar, rainy neon city wallpaper.

Managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level folder is a package that mirrors `$HOME`.

`Super` is the Windows key. `Super+F1` opens a searchable cheatsheet with every shortcut below and more. The day-to-day essentials are in [KEYMAPS.md](KEYMAPS.md).

## Contents

- [Packages](#packages)
- [New machine](#new-machine)
- [What install.sh does](#what-installsh-does)
- [Built from source](#built-from-source)
- [How it fits together](#how-it-fits-together)
- [Updating the repo](#updating-the-repo)
- [Maintaining this repo](#maintaining-this-repo)
- [Troubleshooting](#troubleshooting)
- [i3: windows and workspaces](#i3-windows-and-workspaces)
- [Menus and tools](#menus-and-tools)
- [Bar clicks](#bar-clicks)
- [Media and volume](#media-and-volume)
- [Screenshots](#screenshots)
- [tmux](#tmux)
- [Neovim](#neovim)
- [kitty](#kitty)
- [Shell](#shell)
- [Tweaking the look](#tweaking-the-look)

## Packages

| Package | What it holds |
|---|---|
| `i3` | i3 config, wallpapers, scripts (music corner, dropdown terminal, lock screen, volume/mic pop-ups) |
| `polybar` | Pill bar, Catppuccin colors, scripts: music + mic (event-driven), CPU temp, waves visualizer |
| `picom` | picom v12 config: blur (dual_kawase, strength 4), mauve glow on the focused window, dim unfocused, open/close animations, 10px rounded corners |
| `rofi` | Launcher + fullscreen grid themes, menus: power, wifi, emoji, calculator, clipboard, cheatsheet |
| `dunst` | Notifications |
| `kitty` | Terminal + Catppuccin theme |
| `tmux` | Pill status bar, `C-a` prefix, vim-tmux-navigator |
| `nvim` | Neovim config (lazy.nvim, Catppuccin). Start screen shows the fastfetch desk art; Catppuccin pill status line and tabs |
| `btop`, `cava`, `lazygit`, `gsimplecal` | Catppuccin themes for each |
| `starship` | Prompt |
| `fastfetch` | System info with custom desk-setup art (`logo.txt`, `logo-small.txt`) in new terminals, not in tmux splits or the dropdown |
| `gtk` | GTK 3/4 theme, icon and cursor settings |
| `x11` | `.Xresources` (cursor) |
| `fonts` | Feather icon font used by polybar |
| `bin` | `ricecost`: measure the rice's RAM and CPU |
| `bash` | `.bashrc` (starship, zoxide). Private aliases go in `~/.bashrc.local`, which is not tracked |

Downloaded by `install.sh` instead of committed: Catppuccin GTK theme, Catppuccin cursors, Papirus-Dark icons with Catppuccin folders, starship, zoxide, fastfetch, tpm. Built from source into `~/.local`: dunst 1.13.2 and picom 12.5 (see [Built from source](#built-from-source)).

## New machine

```sh
git clone -b setup https://github.com/ankitdev10/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh
```

Then log out and back in to i3. Open tmux and press `C-a I` once to install tmux plugins.

`install.sh` installs everything needed, including FiraCode Nerd Font and an i3 with gaps support.

## What install.sh does

Run once on a fresh Pop!_OS / Ubuntu 22.04+ machine (x86_64). Safe to re-run: every step checks first and skips work that is already done. Each step prints a `==>` header.

1. **apt packages**: build tools, i3, polybar, rofi, tmux, feh, flameshot, copyq, xclip, xdotool, playerctl, cava, gsimplecal, pavucontrol, libnotify-bin, imagemagick, btop, xss-lock, i3lock, nm-applet, dex, brightnessctl, stow (apt's picom and dunst stay as fallbacks).
2. **i3 with gaps**: if the installed i3 rejects `gaps` (apt's 4.20 on 22.04), builds i3 4.24 into `/usr/local`.
3. **kitty 0.30+**: official installer into `~/.local/opt/kitty.app` if apt's is older (22.04 ships 0.21).
4. **neovim 0.10+**: official release into `~/.local/opt/nvim` if missing or older.
5. **lazygit**, **FiraCode Nerd Font**: latest releases if missing.
6. **GTK theme, cursor, icons**: Catppuccin Mocha Mauve GTK, Catppuccin Mocha Dark cursor, Papirus-Dark with Catppuccin folders.
7. **dunst 1.13.2** and **picom 12** (see [Built from source](#built-from-source)).
8. **fastfetch, starship, zoxide, tpm**.
9. **stow**: existing files that would block a link (e.g. Ubuntu's default `~/.bashrc`) are moved to `~/.dotfiles-backup/<timestamp>/` first, then every package is linked.
10. **gsettings**: GTK, icon and cursor theme (skipped quietly outside a desktop session).

Manual afterwards: log out, pick the **i3** session at login, open tmux and press `C-a I` once.

Hardware-specific values are detected at runtime, not hardcoded: wifi interface, battery and AC adapter (`launch_polybar.sh` exports `WLAN`, `BATTERY`, `ADAPTER`), CPU temperature sensor (k10temp, coretemp, zenpower or thermal_zone0). Monitor names in the i3 config (`eDP`, `HDMI-1-0`) are this laptop's; other machines just ignore those xrandr lines.

Assumes PipeWire (Pop!_OS default) for `wpctl`, used by the volume/mic scripts.

## Built from source

Pop!_OS 22.04 ships old versions, so two programs are built into `~/.local` (no system files touched; the apt versions stay as fallbacks).

| Program | Why | Version | Build |
|---|---|---|---|
| dunst | 1.5 in apt has no progress bars or icon themes | 1.13.2 | `make WAYLAND=0 SYSTEMD=0 PREFIX=$HOME/.local install` |
| picom | v9 in apt has no animations | 12.5 | `meson setup build --prefix=$HOME/.local --buildtype=release && ninja -C build install` |

Notes:

- picom 12 needs libconfig ≥ 1.7 (22.04 has 1.5). With `cmake` installed, meson fetches and builds libconfig automatically.
- dunst's D-Bus service is overridden so the new binary is always used: `~/.local/share/dbus-1/services/org.knopwob.dunst.service` (no `SystemdService=` line) and `~/.config/systemd/user/dunst.service` (tracked in the `dunst` package).
- i3 starts `~/.local/bin/picom` and `~/.local/bin/dunst` explicitly.

## How it fits together

Everything starts from `~/.config/i3/config` at login:

| Started by i3 | What |
|---|---|
| `exec_always ~/.local/bin/picom` | Compositor |
| `exec ~/.local/bin/dunst` | Notifications |
| `exec_always ~/.config/polybar/launch_polybar.sh` | One bar per connected monitor (`MONITOR=<name> polybar toph`) |
| `exec feh --bg-fill …/rainy-city.jpg` | Wallpaper |
| `exec kitty --class dropdown --listen-on …` | Dropdown terminal with remote control on a private socket, kept in the scratchpad |
| `exec xss-lock … ~/.config/i3/scripts/lock.sh` | Lock before sleep |
| `exec copyq`, `nm-applet`, `dex --autostart` | Clipboard, network, XDG autostart |

Key scripts:

| Path | Purpose |
|---|---|
| `i3/.config/i3/scripts/osd.sh` | Volume / mic keys with dunst progress-bar pop-ups (max 150%) |
| `i3/.config/i3/scripts/lock.sh` | Blurred screenshot lock screen (plain i3lock) |
| `i3/.config/i3/scripts/dropdown-toggle.sh` | `Super+Shift+Enter`: starts the dropdown if missing; when showing it, `cd`s to the focused terminal's folder (tmux pane aware) via kitty remote control on `$XDG_RUNTIME_DIR/kitty-dropdown`, only if the dropdown sits at an idle prompt |
| `i3/.config/i3/scripts/music-toggle.sh`, `nowplaying.sh` | `Super+m` music corner (cava + now playing) |
| `polybar/.config/polybar/scripts/music.sh` | Music pill, follows playerctl events |
| `polybar/.config/polybar/scripts/mic.sh` | Mic pill, follows `pactl subscribe` events |
| `polybar/.config/polybar/scripts/wave.sh` | Mini visualizer (cava config `cava/.config/cava/polybar`, 15 fps) |
| `rofi/.config/rofi/scripts/*.sh` | Power, wifi, emoji, calculator, clipboard menus |
| `rofi/.config/rofi/scripts/cheatsheet.py` | `Super+F1`, reads i3 / tmux / nvim keymaps live |
| `bin/.local/bin/ricecost` | Measures the rice's RAM (PSS) and CPU |

The terminal greeting is the fastfetch hook at the end of `bash/.bashrc`: full art at 116+ columns, compact art beside the info at 90–115, compact art above the info at 50–89, info only below 50. The nvim start screen (`nvim/.config/nvim/lua/plugins/alpha.lua`) reads the same `logo.txt` / `logo-small.txt`, so editing the art changes both.

## Updating the repo

Edit configs at their usual paths (`nvim ~/.config/picom/picom.conf`). They are symlinks into this repo, so changes show up here automatically.

```sh
cd ~/dotfiles
git status                     # what changed
git diff                       # review it
git add -A
git commit -m "picom: lower blur"
git push
```

| Task | Command |
|---|---|
| Track a new app | `mkdir -p ~/dotfiles/<app>/.config && mv ~/.config/<app> ~/dotfiles/<app>/.config/ && cd ~/dotfiles && stow <app>` |
| Stop managing an app | `cd ~/dotfiles && stow -D <app>` (removes the links) |
| Re-link after a pull | `cd ~/dotfiles && stow -R <app>` |
| Check a file is still linked | `ls -l ~/.config/<app>/<file>` (look for `->`) |

## Maintaining this repo

Guidelines for anyone changing this setup, including AI coding agents.

**Look**

- Palette is Catppuccin Mocha everywhere. Accent is mauve.

  | Name | Hex | Used for |
  |---|---|---|
  | base | `#1e1e2e` | Terminal / window background |
  | mantle | `#181825` | Pills (polybar, tmux, prompt), rofi |
  | crust | `#11111b` | Rofi input bar |
  | surface0 / surface1 | `#313244` / `#45475a` | Selection, borders |
  | overlay0 | `#6c7086` | Unfocused borders, dim text |
  | text | `#cdd6f4` | Text |
  | mauve | `#cba6f7` | Accent, focused border, glow |
  | peach | `#fab387` | Folder / clock icons, warnings |
  | green | `#a6e3a1` | OK states, branch icon |
  | red | `#f38ba8` | Errors, muted |
  | blue / teal / yellow | `#89b4fa` / `#94e2d5` / `#f9e2af` | Secondary icons |

- Font is FiraCode Nerd Font everywhere; polybar icons use the Feather font.
- Shapes: rounded pills (Nerd Font caps U+E0B6 and U+E0B4) on a mantle background, used by polybar, tmux and the starship prompt.
- Prefer lightweight changes. Avoid anything that keeps a process busy in the background; check with `ricecost` before and after.

**Editing**

- Edit through the normal paths (`~/.config/...`); they are symlinks into this repo. New apps get their own package folder and `stow <app>`.
- Nerd Font / Feather icons are Private Use Area characters. Some editors and tools silently strip them. When generating config text, write them as escapes (`\uXXXX` in JSON/TOML/Python, `$'\uXXXX'` in bash) and verify the result.
- Keep secrets out of the repo. Private shell lines go in `~/.bashrc.local` (untracked, sourced by `.bashrc`).
- Neovim is the owner's daily driver: change only what is asked.
- Commits are authored by the repo owner. Don't add AI co-author trailers.

**Validate before reloading**

| Component | Check | Apply |
|---|---|---|
| i3 | `i3 -C -c ~/.config/i3/config` | `Super+Shift+r` or `i3-msg reload` |
| polybar | `MONITOR=eDP polybar --dump=height toph` | `killall polybar; ~/.config/polybar/launch_polybar.sh` |
| picom | `~/.local/bin/picom --diagnostics` | `pkill -x picom; ~/.local/bin/picom -b` |
| rofi | `rofi -dump-theme` | next time a menu opens |
| dunst | start `~/.local/bin/dunst` in a terminal and read warnings | `killall dunst` (restarts on next notification) |
| kitty | `kitty +runpy 'from kitty.config import load_config; load_config("'$HOME'/.config/kitty/kitty.conf")'` | `Ctrl+Shift+F5` |
| tmux | `tmux source-file ~/.tmux.conf` | same |
| bash | `bash -n ~/.bashrc` | new terminal |
| fastfetch | `fastfetch --pipe` | new terminal |
| cost | `ricecost 60` | — |

## Troubleshooting

| Symptom | Fix |
|---|---|
| No blur / glow / animations | `pgrep -a picom` should show `~/.local/bin/picom`. Restart it. If it crashes, temporarily use `/usr/bin/picom` in the i3 config |
| Old-looking notifications, no progress bars | The old dunst started. `killall dunst; ~/.local/bin/dunst &` and check the D-Bus override above |
| Bar missing on a monitor | `xrandr --query`, then rerun `launch_polybar.sh` |
| Wifi or battery pill empty | Check `ls /sys/class/net` and `ls /sys/class/power_supply`; `launch_polybar.sh` picks the first `wl*`, `BAT*` and `AC*`/`ADP*` |
| `$mod+m` / dropdown does nothing | The scripts relaunch missing windows; check `~/.config/i3/scripts/*.sh` run by hand |
| Icons show as boxes | The glyph is missing from FiraCode Nerd Font; pick another codepoint (`fc-list ':charset=<hex>'`) |
| A config edit doesn't show in `git status` | The app replaced the symlink with a file; move it back into the package and `stow -R <app>` |
| fastfetch art missing | Terminal too narrow (`tput cols`); see thresholds above |

## i3: windows and workspaces

| Key | Action |
|---|---|
| `Super+Enter` | Terminal (kitty) |
| `Super+Shift+Enter` | Dropdown terminal (show / hide). Jumps to the folder of the terminal you were in, if the dropdown is idle |
| `Super+q` | Close window |
| `Super+h/j/k/l` or arrows | Focus window left / down / up / right |
| `Super+Shift+h/j/k/l` or arrows | Move window |
| `Super+1…0` | Go to workspace 1–10 |
| `Super+<current workspace no.>` | Jump back to the previous workspace |
| `Super+Shift+1…0` | Move window to workspace 1–10 |
| `Super+Ctrl+h / l` | Focus other monitor |
| `Super+f` | Fullscreen |
| `Super+e` | Side by side ↔ top / bottom |
| `Super+s` | Stacked layout |
| `Super+w` | Tabbed layout |
| `Super+Shift+Space` | Float / tile window |
| `Super+drag` | Move floating window |
| `Super+r` | Resize mode (arrows or `j k l ;`, `Esc` to leave) |
| `Super+a` | Focus parent container |
| `Super+Shift+c` | Reload i3 config |
| `Super+Shift+r` | Restart i3 (keeps windows) |
| `Super+Shift+e` | Log out |

## Menus and tools

| Key | Action |
|---|---|
| `Super+d` | App launcher |
| `Super+Shift+d` | App launcher, fullscreen grid |
| `Super+Space` | Search apps, windows and commands |
| `Super+Tab` | Switch window |
| `Super+x` | Power menu: lock, suspend, log out, reboot, shut down |
| `Super+.` | Emoji picker (copies to clipboard) |
| `Super+c` | Calculator (qalc: `15% of 240`, `3 ft to cm`; result copied) |
| `Super+v` | CopyQ clipboard manager |
| `Super+Shift+v` | Clipboard history in rofi |
| `Super+m` | Music corner: visualizer + now playing |
| `Super+n` | Show last notification |
| `Super+Shift+n` | Dismiss all notifications |
| `Super+F1` | Cheatsheet |

In any rofi menu: type to filter, `Enter` to pick, `Esc` to close.

## Bar clicks

| Where | Action |
|---|---|
| Workspace icon | Go to that workspace |
| Music pill `⏮ ⏯ ⏭` | Previous / play-pause / next (any player: Brave, Spotify, VLC) |
| Wi-Fi pill | Wi-Fi menu: switch network, rescan, turn off |
| Clock | Calendar |
| Volume pill: click / scroll / right-click | Mute / volume ±5% (max 150%) / sound settings |
| Mic pill: click / scroll | Mute / level ±5% (max 100%) |

## Media and volume

| Key | Action |
|---|---|
| Volume up / down keys | ±5% with an on-screen pop-up (max 150%) |
| Mute key | Mute speakers |
| Mic-mute key | Mute microphone |

## Screenshots

| Key | Action |
|---|---|
| `PrtSc` | Select an area (flameshot) |
| `Super+PrtSc` | Full screen, saved and copied |

After selecting with `PrtSc`: `Ctrl+C` copy, `Ctrl+S` / `Enter` save to `~/Pictures/Screenshots`, `Esc` cancel. The toolbar around the selection draws arrows, boxes, text and blur.

## tmux

Prefix is `Ctrl+a` (written `C-a`): press it, release, then the key.

| Key | Action |
|---|---|
| `C-a \|` | Split side by side |
| `C-a -` | Split top / bottom |
| `Ctrl+h/j/k/l` | Move between panes and nvim splits (no prefix) |
| `C-a` + arrow | Move between panes |
| `C-a m` | Zoom / unzoom pane |
| `C-a c` | New window |
| `C-a 0…9` | Go to window |
| `C-a n` / `C-a p` | Next / previous window |
| `C-a ,` | Rename window |
| `C-a x` | Close pane |
| `C-a d` | Detach (session keeps running) |
| `C-a s` | List sessions |
| `C-a [` | Copy mode: `v` select, `y` copy, `q` quit |
| `C-a r` | Reload tmux config |
| `C-a I` | Install tmux plugins |
| `tmux a` | Reattach from the shell |

## Neovim

Leader is `Space`.

| Key | Action |
|---|---|
| `Space Space` | Find files |
| `Space fs` | Search text in project |
| `Space fr` | Recent files |
| `Space fc` | Search word under cursor |
| `Space e` | File explorer |
| `Space gg` | lazygit |
| `Space w` / `Ctrl+s` | Save |
| `Space q` / `Space qa` | Quit / quit all |
| `Space sv` / `Space sh` / `Space sx` | Split vertical / horizontal / close split |
| `[b` / `]b` | Previous / next buffer |
| `Space bd` | Close buffer |
| `gd` / `gR` / `gi` | Definition / references / implementation |
| `K` | Docs for what's under the cursor |
| `Space ca` | Code actions |
| `Space rn` | Rename symbol |
| `Space co` | Organize imports |
| `[d` / `]d` | Previous / next diagnostic |
| `Space d` / `Space xx` | Line diagnostics / all diagnostics |
| `gcc` / `gc` (visual) | Toggle comment |
| `ghp` / `gsh` / `grh` | Git: preview / stage / reset hunk |
| `gbl` | Git blame line |
| `Space j` | Flash jump |
| `Space ss` / `Space sr` | Save / restore session |
| `Space c` | Change colorscheme |
| `Space nh` | Clear search highlight |

## kitty

| Key | Action |
|---|---|
| `Ctrl+Shift+c` / `v` | Copy / paste |
| `Ctrl+Shift+=` / `-` | Bigger / smaller font |
| `Ctrl+Shift+Backspace` | Reset font size |
| `Ctrl+Shift+F5` | Reload kitty config |
| `Ctrl+Shift+h` | Scrollback in a pager |

## Shell

| Command | Action |
|---|---|
| `z <name>` | Jump to a visited folder (`z koulier`, `z i3`, `z polybar`) |
| `z -` | Previous folder |
| `zoxide query <name>` | Show where `z <name>` goes |
| `lazygit` | Git UI (`?` for help) |
| `btop` | System monitor |
| `ricecost [seconds]` | RAM (PSS) and average CPU of the rice, excluding apps |
| `Alt+b` / `Alt+f` | Cursor one word back / forward |
| `Ctrl+r` | Search command history |
| `Ctrl+l` | Clear screen |
| `pc` | Local Postgres (defined in `~/.bashrc.local`, not tracked) |

## Tweaking the look

| Change | Where | Apply with |
|---|---|---|
| Blur strength (now 4) | `~/.config/picom/picom.conf` → `strength` | `pkill -x picom; ~/.local/bin/picom -b` |
| Dim unfocused windows (now 0.2) | `~/.config/picom/picom.conf` → `inactive-dim` | same as above |
| Terminal opacity (now 0.75) | `~/.config/kitty/kitty.conf` → `background_opacity` | `Ctrl+Shift+F5` in kitty |
| Corner rounding (now 10px) | `~/.config/picom/picom.conf` → `corner-radius` | `pkill -x picom; ~/.local/bin/picom -b` |
| Window borders (now off; focus = mauve glow + dimming) | `~/.config/i3/config` → `border pixel` | `Super+Shift+r` |
| Border colors | `~/.config/i3/config` → `client.*` lines | `Super+Shift+r` |
| Gaps (now 10) | `~/.config/i3/config` → `gaps inner / outer` | `Super+Shift+r` |
| Wallpaper | `~/.config/i3/config` → `feh` line | `Super+Shift+r` |
| Bar modules / colors | `~/.config/polybar/config`, `colors.ini` | `Super+Shift+r` |
| Notification style | `~/.config/dunst/dunstrc` | `killall dunst` (restarts on next notification) |
| Rofi look | `~/.config/rofi/keyit.rasi`, `colors.rasi` | next time a menu opens |
| tmux bar | `~/.tmux.conf` | `C-a r` |
| Cursor size | `~/.Xresources` → `Xcursor.size` | log out and back in |
| GTK theme / icons | `~/.config/gtk-3.0/settings.ini`, `gtk-4.0/settings.ini` | reopen apps |
