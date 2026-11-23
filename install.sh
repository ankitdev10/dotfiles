#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

PACKAGES=(i3 polybar picom rofi dunst kitty tmux nvim btop cava lazygit gsimplecal starship fastfetch gtk x11 fonts bash)

sudo apt install -y \
    i3 polybar picom rofi dunst kitty tmux feh flameshot copyq xclip xdotool \
    playerctl cava gsimplecal pavucontrol libnotify-bin imagemagick btop stow \
    xss-lock i3lock network-manager unzip curl git

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

theme=catppuccin-mocha-mauve-standard+default
if [[ ! -d "$HOME/.themes/$theme" ]]; then
    curl -sSL -o "$tmp/gtk.zip" "https://github.com/catppuccin/gtk/releases/download/v1.0.3/$theme.zip"
    mkdir -p "$HOME/.themes" && unzip -oq "$tmp/gtk.zip" -d "$HOME/.themes"
fi
mkdir -p "$HOME/.config/gtk-4.0"
for f in assets gtk.css gtk-dark.css; do
    ln -sfn "$HOME/.themes/$theme/gtk-4.0/$f" "$HOME/.config/gtk-4.0/$f"
done

cursor=catppuccin-mocha-dark-cursors
if [[ ! -d "$HOME/.icons/$cursor" ]]; then
    curl -sSL -o "$tmp/cursor.zip" "https://github.com/catppuccin/cursors/releases/latest/download/$cursor.zip"
    mkdir -p "$HOME/.icons/default" && unzip -oq "$tmp/cursor.zip" -d "$HOME/.icons"
    printf '[Icon Theme]\nInherits=%s\n' "$cursor" > "$HOME/.icons/default/index.theme"
fi

if [[ ! -d "$HOME/.local/share/icons/Papirus-Dark" ]]; then
    tag=$(curl -sSL https://api.github.com/repos/PapirusDevelopmentTeam/papirus-icon-theme/releases/latest | grep -m1 '"tag_name"' | cut -d'"' -f4)
    curl -sSL -o "$tmp/papirus.tar.gz" "https://github.com/PapirusDevelopmentTeam/papirus-icon-theme/archive/refs/tags/$tag.tar.gz"
    curl -sSL -o "$tmp/folders.tar.gz" https://github.com/catppuccin/papirus-folders/archive/refs/heads/main.tar.gz
    tar -xzf "$tmp/papirus.tar.gz" -C "$tmp" && tar -xzf "$tmp/folders.tar.gz" -C "$tmp"
    src=$(ls -d "$tmp"/papirus-icon-theme-*) && folders=$(ls -d "$tmp"/papirus-folders-*)
    for size in "$folders"/src/*; do cp -a "$size"/. "$src/Papirus/$(basename "$size")/"; done
    find "$src/Papirus" -type l -name '*.svg' | while read -r link; do
        target=$(readlink "$link")
        if [[ "$target" =~ ^(folder|user)-blue(-.+)?\.svg$ ]]; then
            new="${BASH_REMATCH[1]}-cat-mocha-mauve${BASH_REMATCH[2]}.svg"
            [[ -e "$(dirname "$link")/$new" ]] && ln -sfn "$new" "$link"
        fi
    done
    mkdir -p "$HOME/.local/share/icons" && cp -a "$src/Papirus" "$src/Papirus-Dark" "$HOME/.local/share/icons/"
fi

if ! "$HOME/.local/bin/dunst" --version 2>/dev/null | grep -q v1.13; then
    sudo apt install -y libdbus-1-dev libx11-dev libxinerama-dev libxrandr-dev libxss-dev \
        libglib2.0-dev libpango1.0-dev libgdk-pixbuf-2.0-dev libnotify-dev libcairo2-dev
    git clone -q --depth 1 -b v1.13.2 https://github.com/dunst-project/dunst.git "$tmp/dunst"
    make -C "$tmp/dunst" WAYLAND=0 SYSTEMD=0 PREFIX="$HOME/.local" install >/dev/null
    sed -i '/^SystemdService=/d' "$HOME/.local/share/dbus-1/services/org.knopwob.dunst.service"
fi

if ! command -v fastfetch >/dev/null; then
    curl -sSL -o "$tmp/fastfetch.tar.gz" https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-amd64.tar.gz
    tar -xzf "$tmp/fastfetch.tar.gz" -C "$tmp"
    install -Dm755 "$tmp/fastfetch-linux-amd64/usr/bin/fastfetch" "$HOME/.local/bin/fastfetch"
fi

command -v starship >/dev/null || curl -sS https://starship.rs/install.sh | sh -s -- -y -b "$HOME/.local/bin"
command -v zoxide >/dev/null || curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    git clone -q https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

fc-list | grep -qi "FiraCode Nerd Font" || echo "Install FiraCode Nerd Font: https://www.nerdfonts.com/font-downloads"

stow -v -t "$HOME" "${PACKAGES[@]}"
fc-cache -f >/dev/null
gsettings set org.gnome.desktop.interface gtk-theme "$theme"
gsettings set org.gnome.desktop.interface icon-theme Papirus-Dark
gsettings set org.gnome.desktop.interface cursor-theme "$cursor"

echo "Done. Log out and back in to i3."
