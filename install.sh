#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "$0")"

PACKAGES=(i3 polybar picom rofi dunst kitty tmux nvim btop cava lazygit gsimplecal starship fastfetch espanso gtk x11 fonts bash bin)

step() { printf '\n\033[1;35m==> %s\033[0m\n' "$*"; }
ver_ge() { [[ "$(printf '%s\n%s\n' "$2" "$1" | sort -V | head -1)" == "$2" ]]; }
apt_install() { sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends "$@"; }
gh_latest() { curl -sSL -o "$tmp/release.json" "https://api.github.com/repos/$1/releases/latest" && sed -n 's/.*"tag_name": *"\([^"]*\)".*/\1/p' "$tmp/release.json" | head -1; }

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT
mkdir -p "$HOME/.local/bin" "$HOME/.local/share/fonts" "$HOME/.local/share/icons" "$HOME/.local/opt" \
    "$HOME/.config/systemd/user" "$HOME/.config/gtk-3.0" "$HOME/.config/gtk-4.0"
export PATH="$HOME/.local/bin:$PATH"

step "apt packages"
sudo apt-get update
apt_install build-essential pkg-config git curl ca-certificates unzip xz-utils fontconfig stow python3 \
    i3 polybar picom rofi dunst tmux feh flameshot copyq xclip xdotool x11-xserver-utils \
    playerctl cava gsimplecal pavucontrol libnotify-bin imagemagick btop xss-lock i3lock \
    network-manager-gnome dex brightnessctl

step "i3 with gaps (4.22+)"
printf '# i3 config file (v4)\ngaps inner 1\n' > "$tmp/gaps-test"
i3_check=$(i3 -C -c "$tmp/gaps-test" 2>&1 || true)
if [[ "$i3_check" == *ERROR* ]]; then
    apt_install meson ninja-build libxcb1-dev libxcb-keysyms1-dev libpango1.0-dev libxcb-util0-dev \
        libxcb-icccm4-dev libyajl-dev libstartup-notification0-dev libxcb-randr0-dev libev-dev \
        libxcb-cursor-dev libxcb-xinerama0-dev libxcb-xkb-dev libxkbcommon-dev libxkbcommon-x11-dev \
        libxcb-xrm-dev libxcb-shape0-dev libpcre2-dev libcairo2-dev
    curl -sSL -o "$tmp/i3.tar.xz" https://i3wm.org/downloads/i3-4.24.tar.xz
    tar -xJf "$tmp/i3.tar.xz" -C "$tmp"
    meson setup "$tmp/i3-4.24/build" "$tmp/i3-4.24" --prefix=/usr/local --buildtype=release >/dev/null
    ninja -C "$tmp/i3-4.24/build" >/dev/null
    sudo ninja -C "$tmp/i3-4.24/build" install >/dev/null
    hash -r
fi

step "kitty 0.30+"
if ! command -v kitty >/dev/null || ! ver_ge "$(kitty --version | grep -oE '[0-9]+\.[0-9]+' | head -1)" 0.30; then
    curl -sSL https://sw.kovidgoyal.net/kitty/installer.sh | sh /dev/stdin launch=n dest="$HOME/.local/opt" >/dev/null
    ln -sfn "$HOME/.local/opt/kitty.app/bin/kitty" "$HOME/.local/bin/kitty"
    ln -sfn "$HOME/.local/opt/kitty.app/bin/kitten" "$HOME/.local/bin/kitten"
fi

step "neovim 0.10+"
if ! command -v nvim >/dev/null || ! ver_ge "$(nvim --version | head -1 | grep -oE '[0-9]+\.[0-9]+' | head -1)" 0.10; then
    curl -sSL -o "$tmp/nvim.tar.gz" https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    rm -rf "$HOME/.local/opt/nvim" && mkdir -p "$HOME/.local/opt/nvim"
    tar -xzf "$tmp/nvim.tar.gz" -C "$HOME/.local/opt/nvim" --strip-components=1
    ln -sfn "$HOME/.local/opt/nvim/bin/nvim" "$HOME/.local/bin/nvim"
fi

step "lazygit"
if ! command -v lazygit >/dev/null; then
    tag=$(gh_latest jesseduffield/lazygit)
    curl -sSL -o "$tmp/lazygit.tar.gz" "https://github.com/jesseduffield/lazygit/releases/download/$tag/lazygit_${tag#v}_Linux_x86_64.tar.gz"
    tar -xzf "$tmp/lazygit.tar.gz" -C "$tmp" lazygit
    install -Dm755 "$tmp/lazygit" "$HOME/.local/bin/lazygit"
fi

step "FiraCode Nerd Font"
fonts_installed=$(fc-list : family)
if [[ "$fonts_installed" != *"FiraCode Nerd Font"* ]]; then
    curl -sSL -o "$tmp/firacode.zip" https://github.com/ryanoasis/nerd-fonts/releases/latest/download/FiraCode.zip
    mkdir -p "$HOME/.local/share/fonts/FiraCode" && unzip -oq "$tmp/firacode.zip" -d "$HOME/.local/share/fonts/FiraCode"
fi

step "GTK theme"
theme=catppuccin-mocha-mauve-standard+default
if [[ ! -d "$HOME/.themes/$theme" ]]; then
    curl -sSL -o "$tmp/gtk.zip" "https://github.com/catppuccin/gtk/releases/download/v1.0.3/$theme.zip"
    mkdir -p "$HOME/.themes" && unzip -oq "$tmp/gtk.zip" -d "$HOME/.themes"
fi
for f in assets gtk.css gtk-dark.css; do
    ln -sfn "$HOME/.themes/$theme/gtk-4.0/$f" "$HOME/.config/gtk-4.0/$f"
done

step "cursor theme"
cursor=catppuccin-mocha-dark-cursors
if [[ ! -d "$HOME/.icons/$cursor" ]]; then
    curl -sSL -o "$tmp/cursor.zip" "https://github.com/catppuccin/cursors/releases/latest/download/$cursor.zip"
    mkdir -p "$HOME/.icons/default" && unzip -oq "$tmp/cursor.zip" -d "$HOME/.icons"
    printf '[Icon Theme]\nInherits=%s\n' "$cursor" > "$HOME/.icons/default/index.theme"
fi

step "Papirus icons with Catppuccin folders"
if [[ ! -d "$HOME/.local/share/icons/Papirus-Dark" ]]; then
    tag=$(gh_latest PapirusDevelopmentTeam/papirus-icon-theme)
    curl -sSL -o "$tmp/papirus.tar.gz" "https://github.com/PapirusDevelopmentTeam/papirus-icon-theme/archive/refs/tags/$tag.tar.gz"
    curl -sSL -o "$tmp/folders.tar.gz" https://github.com/catppuccin/papirus-folders/archive/refs/heads/main.tar.gz
    tar -xzf "$tmp/papirus.tar.gz" -C "$tmp" && tar -xzf "$tmp/folders.tar.gz" -C "$tmp"
    src=$(ls -d "$tmp"/papirus-icon-theme-*) && folders=$(ls -d "$tmp"/papirus-folders-*)
    for size in "$folders"/src/*; do cp -a "$size"/. "$src/Papirus/$(basename "$size")/"; done
    find "$src/Papirus" -type l -name '*.svg' | while read -r link; do
        target=$(readlink "$link")
        if [[ "$target" =~ ^(folder|user)-blue(-.+)?\.svg$ ]]; then
            new="${BASH_REMATCH[1]}-cat-mocha-mauve${BASH_REMATCH[2]}.svg"
            if [[ -e "$(dirname "$link")/$new" ]]; then ln -sfn "$new" "$link"; fi
        fi
    done
    cp -a "$src/Papirus" "$src/Papirus-Dark" "$HOME/.local/share/icons/"
fi

step "dunst 1.13.2"
if ! "$HOME/.local/bin/dunst" --version 2>/dev/null | grep -q v1.13; then
    apt_install libdbus-1-dev libx11-dev libxinerama-dev libxrandr-dev libxss-dev \
        libglib2.0-dev libpango1.0-dev libgdk-pixbuf-2.0-dev libnotify-dev libcairo2-dev
    git clone -q --depth 1 -b v1.13.2 https://github.com/dunst-project/dunst.git "$tmp/dunst"
    make -C "$tmp/dunst" WAYLAND=0 SYSTEMD=0 PREFIX="$HOME/.local" install >/dev/null
    sed -i '/^SystemdService=/d' "$HOME/.local/share/dbus-1/services/org.knopwob.dunst.service"
fi

step "picom 12+"
if ! "$HOME/.local/bin/picom" --version 2>/dev/null | grep -q '^v1[2-9]'; then
    apt_picom=$(apt-cache policy picom | awk '/Candidate:/ {print $2}' | sed 's/^[0-9]*://' | cut -d. -f1)
    if [[ "$apt_picom" =~ ^[0-9]+$ ]] && (( apt_picom >= 12 )); then
        apt_install picom
        ln -sfn "$(command -v picom)" "$HOME/.local/bin/picom"
    else
        apt_install meson ninja-build cmake libconfig-dev libdbus-1-dev libegl-dev libev-dev \
            libgl-dev libepoxy-dev libpcre2-dev libpixman-1-dev libx11-xcb-dev libxcb1-dev libxcb-composite0-dev \
            libxcb-damage0-dev libxcb-glx0-dev libxcb-image0-dev libxcb-present-dev libxcb-randr0-dev \
            libxcb-render0-dev libxcb-render-util0-dev libxcb-shape0-dev libxcb-util-dev libxcb-xfixes0-dev uthash-dev
        git clone -q --depth 1 -b v12.5 https://github.com/yshui/picom.git "$tmp/picom"
        meson setup "$tmp/picom/build" "$tmp/picom" --prefix="$HOME/.local" --buildtype=release >/dev/null
        ninja -C "$tmp/picom/build" install >/dev/null
    fi
fi

step "espanso (text expander)"
if ! command -v espanso >/dev/null; then
    mkdir -p "$HOME/.local/opt/espanso"
    curl -sSL --http1.1 --retry 5 -o "$HOME/.local/opt/espanso/Espanso.AppImage" \
        https://github.com/espanso/espanso/releases/latest/download/Espanso-X11.AppImage
    chmod +x "$HOME/.local/opt/espanso/Espanso.AppImage"
    ln -sfn "$HOME/.local/opt/espanso/Espanso.AppImage" "$HOME/.local/bin/espanso"
fi

step "fastfetch, starship, zoxide, tpm"
if ! command -v fastfetch >/dev/null; then
    curl -sSL -o "$tmp/fastfetch.tar.gz" https://github.com/fastfetch-cli/fastfetch/releases/latest/download/fastfetch-linux-amd64.tar.gz
    tar -xzf "$tmp/fastfetch.tar.gz" -C "$tmp"
    install -Dm755 "$tmp/fastfetch-linux-amd64/usr/bin/fastfetch" "$HOME/.local/bin/fastfetch"
fi
command -v starship >/dev/null || curl -sS https://starship.rs/install.sh | sh -s -- -y -b "$HOME/.local/bin" >/dev/null
command -v zoxide >/dev/null || curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh >/dev/null
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
    git clone -q https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

step "link configs with stow"
backup="$HOME/.dotfiles-backup/$(date +%Y%m%d-%H%M%S)"
move_aside() {
    local target="$HOME/$1"
    if [[ -e "$target" && ! -L "$target" ]]; then
        mkdir -p "$backup/$(dirname "$1")"
        mv "$target" "$backup/$1"
        echo "  moved existing ~/$1 to $backup/"
    fi
}
for pkg in "${PACKAGES[@]}"; do
    while IFS= read -r rel; do
        move_aside "${rel#./}"
    done < <(cd "$pkg" && {
        find . -mindepth 2 -maxdepth 2 -path './.config/*' \
            ! -path './.config/gtk-3.0' ! -path './.config/gtk-4.0' ! -path './.config/systemd'
        find ./.config/gtk-3.0 ./.config/gtk-4.0 ./.config/systemd -type f 2>/dev/null || true
        find . \( -type f -o -type l \) ! -path './.config/*'
    })
done
stow -R -t "$HOME" "${PACKAGES[@]}"

step "finishing"
fc-cache -f >/dev/null
if [[ ! -f "$HOME/.config/espanso/match/private.yml" ]]; then
    printf 'matches:\n  - trigger: ";email"\n    replace: "you@example.com"\n' > "$HOME/.config/espanso/match/private.yml"
fi
espanso service register >/dev/null 2>&1 || true
gsettings set org.gnome.desktop.interface gtk-theme "$theme" 2>/dev/null || true
gsettings set org.gnome.desktop.interface icon-theme Papirus-Dark 2>/dev/null || true
gsettings set org.gnome.desktop.interface cursor-theme "$cursor" 2>/dev/null || true

echo
echo "Done. Log out and back in, choose the i3 session, then press C-a I once inside tmux."
