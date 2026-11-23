#!/usr/bin/env bash
list=$(copyq eval -- 'var n=Math.min(size(),100); for (var i=0;i<n;++i) print(i + "  " + str(read(i)).replace(/\s+/g," ").substring(0,120) + "\n")') || exit 1
choice=$(printf '%s' "$list" | rofi -dmenu -i -p $' Clipboard' -theme-str 'window {width: 800px;} listview {lines: 12;}') || exit 0
index=${choice%% *}
[[ "$index" =~ ^[0-9]+$ ]] && copyq select "$index"
