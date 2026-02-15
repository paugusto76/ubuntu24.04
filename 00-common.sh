#!/bin/bash

# Functions
function log {
    echo -e "$1"
    if [[ -n "$LOG_FILE" ]]; then
        # replace any color codes with empty string for logging
        echo -e "$1" | sed 's/\x1b\[[0-9;]*m//g' >> "$LOG_FILE"
    fi
}

NOFORMAT='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'
