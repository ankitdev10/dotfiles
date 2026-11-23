# dotfiles

i3 rice on Pop!_OS 22.04: Catppuccin Mocha everywhere, Keyitdev-style pill bar, rainy neon city wallpaper.

Managed with [GNU Stow](https://www.gnu.org/software/stow/). Each top-level folder is a package that mirrors `$HOME`.

`Super` is the Windows key. `Super+F1` opens a searchable cheatsheet with every shortcut below and more.

## Contents

- [Packages](#packages)
- [New machine](#new-machine)
- [Updating the repo](#updating-the-repo)
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
| `polybar` | Pill bar, Catppuccin colors, scripts (music, mic, CPU temp, notifications) |
| `picom` | Blur (dual_kawase, strength 4), shadows, fading, dim unfocused windows |
| `rofi` | Launcher + fullscreen grid themes, menus: power, wifi, emoji, calculator, clipboard, cheatsheet |
| `dunst` | Notifications |
| `kitty` | Terminal + Catppuccin theme |
| `tmux` | Pill status bar, `C-a` prefix, vim-tmux-navigator |
| `nvim` | Neovim config (lazy.nvim, Catppuccin) |
| `btop`, `cava`, `lazygit`, `gsimplecal` | Catppuccin themes for each |
| `starship` | Prompt |
| `fastfetch` | System info with the Pop!_OS logo in new terminals (not in tmux splits or the dropdown) |
| `gtk` | GTK 3/4 theme, icon and cursor settings |
| `x11` | `.Xresources` (cursor) |
| `fonts` | Feather icon font used by polybar |
| `bash` | `.bashrc` (starship, zoxide). Private aliases go in `~/.bashrc.local`, which is not tracked |

Downloaded by `install.sh` instead of committed: Catppuccin GTK theme, Catppuccin cursors, Papirus-Dark icons with Catppuccin folders, starship, zoxide, fastfetch, tpm. dunst 1.13 is built from source.

## New machine

```sh
git clone -b setup https://github.com/ankitdev10/dotfiles ~/dotfiles
cd ~/dotfiles
./install.sh
```

Then log out and back in to i3. Open tmux and press `C-a I` once to install tmux plugins.

Requires FiraCode Nerd Font, and an i3 build with gaps (i3 4.22+ or a newer build).

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

## i3: windows and workspaces

| Key | Action |
|---|---|
| `Super+Enter` | Terminal (kitty) |
| `Super+Shift+Enter` | Dropdown terminal (show / hide) |
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
| `Alt+b` / `Alt+f` | Cursor one word back / forward |
| `Ctrl+r` | Search command history |
| `Ctrl+l` | Clear screen |
| `pc` | Local Postgres (defined in `~/.bashrc.local`, not tracked) |

## Tweaking the look

| Change | Where | Apply with |
|---|---|---|
| Blur strength (now 4) | `~/.config/picom/picom.conf` → `strength` | `pkill -x picom; picom --experimental-backends -b` |
| Dim unfocused windows (now 0.2) | `~/.config/picom/picom.conf` → `inactive-dim` | same as above |
| Terminal opacity (now 0.75) | `~/.config/kitty/kitty.conf` → `background_opacity` | `Ctrl+Shift+F5` in kitty |
| Border width (now 3px) | `~/.config/i3/config` → `border pixel` | `Super+Shift+r` |
| Border colors | `~/.config/i3/config` → `client.*` lines | `Super+Shift+r` |
| Gaps (now 10) | `~/.config/i3/config` → `gaps inner / outer` | `Super+Shift+r` |
| Wallpaper | `~/.config/i3/config` → `feh` line | `Super+Shift+r` |
| Bar modules / colors | `~/.config/polybar/config`, `colors.ini` | `Super+Shift+r` |
| Notification style | `~/.config/dunst/dunstrc` | `killall dunst` (restarts on next notification) |
| Rofi look | `~/.config/rofi/keyit.rasi`, `colors.rasi` | next time a menu opens |
| tmux bar | `~/.tmux.conf` | `C-a r` |
| Cursor size | `~/.Xresources` → `Xcursor.size` | log out and back in |
| GTK theme / icons | `~/.config/gtk-3.0/settings.ini`, `gtk-4.0/settings.ini` | reopen apps |
