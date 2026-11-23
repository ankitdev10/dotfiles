#!/usr/bin/env bash
lock=$'  Lock'
suspend=$'  Suspend'
logout=$'  Log out'
reboot=$'  Reboot'
shutdown=$'  Shut down'

confirm() {
    local ans
    ans=$(printf 'No\nYes\n' | rofi -dmenu -i -p "$1?" -theme-str 'window {width: 300px;} listview {lines: 2;}')
    [[ "$ans" == "Yes" ]]
}

choice=$(printf '%s\n' "$lock" "$suspend" "$logout" "$reboot" "$shutdown" \
    | rofi -dmenu -i -p $' Power' -theme ~/.config/rofi/keyit-image.rasi -theme-str 'window {width: 540px;} listview {lines: 5;}')

case "$choice" in
    "$lock") ~/.config/i3/scripts/lock.sh ;;
    "$suspend") systemctl suspend ;;
    "$logout") confirm "Log out" && i3-msg exit ;;
    "$reboot") confirm "Reboot" && systemctl reboot ;;
    "$shutdown") confirm "Shut down" && systemctl poweroff ;;
esac
