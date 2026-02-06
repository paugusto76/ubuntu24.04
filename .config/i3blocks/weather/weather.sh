#!/usr/bin/env bash

output=$(curl -s --connect-timeout 5 --max-time 10 'wttr.in/Lisbon?format=3' 2>/dev/null)

if [[ "$output" =~ ^Lisbon:.*[+-][0-9]+°C$ ]] || [[ "$output" =~ ^Lisbon:.*[⛅☀️🌧️].*[+-][0-9]+°C$ ]]; then
    echo "$output"
    echo "$output" > ~/.cache/weather-fallback
else
    cat ~/.cache/weather-fallback 2>/dev/null || echo "Lisbon: ?°C"
fi
