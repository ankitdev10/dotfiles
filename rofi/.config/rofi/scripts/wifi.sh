#!/usr/bin/env bash
notify() { dunstify -a wifi -h string:x-dunst-stack-tag:wifi "$1" "$2"; }

radio=$(nmcli radio wifi)
if [[ "$radio" != "enabled" ]]; then
    choice=$(printf '%s\n' $'\U000f05a9  Turn Wi-Fi on' | rofi -dmenu -i -p $'\U000f05aa' -theme-str 'listview {lines: 1;}') || exit 0
    nmcli radio wifi on && notify "Wi-Fi" "Turned on"
    exit 0
fi

icon_for() {
    local s=$1
    if (( s >= 80 )); then printf '\U000f0928'
    elif (( s >= 60 )); then printf '\U000f0925'
    elif (( s >= 40 )); then printf '\U000f0922'
    elif (( s >= 20 )); then printf '\U000f091f'
    else printf '\U000f092f'
    fi
}

declare -A seen
entries=()
ssids=()
while IFS=: read -r inuse signal security ssid; do
    [[ -z "$ssid" || -n "${seen[$ssid]}" ]] && continue
    seen[$ssid]=1
    lock=""
    [[ -n "$security" && "$security" != "--" ]] && lock=$' '
    mark=""
    [[ "$inuse" == "*" ]] && mark=$'   connected'
    entries+=("$(icon_for "$signal")  ${ssid}${lock}${mark}")
    ssids+=("$ssid")
done < <(nmcli -t -e no -f IN-USE,SIGNAL,SECURITY,SSID device wifi list --rescan no 2>/dev/null | sort -t: -k2,2nr)

(nmcli device wifi rescan >/dev/null 2>&1 &)

off=$'\U000f05aa  Turn Wi-Fi off'
rescan=$'  Rescan'
idx=$( { printf '%s\n' "${entries[@]}"; printf '%s\n%s\n' "$rescan" "$off"; } \
    | rofi -dmenu -i -format i -p $'\U000f05a9 Wi-Fi' -theme-str 'listview {lines: 10;}') || exit 0

count=${#entries[@]}
if (( idx == count )); then
    nmcli device wifi rescan >/dev/null 2>&1
    sleep 2
    exec "$0"
elif (( idx == count + 1 )); then
    nmcli radio wifi off && notify "Wi-Fi" "Turned off"
    exit 0
fi

ssid=${ssids[$idx]}
if nmcli -t -f NAME connection show | grep -Fxq "$ssid"; then
    notify "Wi-Fi" "Connecting to $ssid…"
    if nmcli connection up id "$ssid" >/dev/null 2>&1; then
        notify "Wi-Fi" "Connected to $ssid"
    else
        notify "Wi-Fi" "Couldn't connect to $ssid"
    fi
    exit 0
fi

pass=""
if [[ "${entries[$idx]}" == *$''* ]]; then
    pass=$(rofi -dmenu -password -p $' Password' -mesg "Network: $ssid" -theme-str 'listview {lines: 0;}') || exit 0
fi
notify "Wi-Fi" "Connecting to $ssid…"
if [[ -n "$pass" ]]; then
    out=$(nmcli device wifi connect "$ssid" password "$pass" 2>&1)
else
    out=$(nmcli device wifi connect "$ssid" 2>&1)
fi
if [[ $? -eq 0 ]]; then
    notify "Wi-Fi" "Connected to $ssid"
else
    notify "Wi-Fi" "Couldn't connect to $ssid: ${out##*Error: }"
fi
