#!/bin/bash

mapfile -t monitors < <(xrandr | grep -w connected)
primary=$(printf '%s\n' "${monitors[@]}" | grep 'primary' | cut -d' ' -f1)
second=$(printf '%s\n' "${monitors[@]}" | grep -v 'primary' | head -n1 | cut -d' ' -f1)
if [ -n "$second" ]; then
  xrandr --output "$primary" --auto --primary --output "$second"  --right-of "$primary" --auto
else
  xrandr --output "$primary" --auto --primary
fi
feh --bg-fill $HOME/.local/share/backgrounds/current.jpg
betterlockscreen -u $HOME/.local/share/locks/current.jpg
