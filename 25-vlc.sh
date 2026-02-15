#!/bin/bash

# Author: Pedro Augusto
# Date: 2025-02-15
# Description: This script will install VLC media player

# Parameters
# --log, -l : Log File
# --help, -h : Display this help message

set -euo pipefail

. ./config.conf
. ./00-common.sh

# Parse parameters
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --log|-l)
            LOG_FILE="$2"
            shift 2
            ;;
        --help|-h)
            log "${BLUE}Usage: $0 [options]${NOFORMAT}"
            log "${BLUE}Options:${NOFORMAT}"
            log "  --log, -l : Log File"
            log "  --help, -h : Display this help message"
            exit 0
            ;;
        *)
            log "${RED}Unknown parameter: $1${NOFORMAT}"
            exit 1
            ;;
    esac
done

if [[ "$install_vlc" -eq 1 ]]; then

    log "${BLUE}Installing VLC media player...${NOFORMAT}"
    if command -v vlc > /dev/null 2>&1; then
        log "${GREEN}  ✅ VLC media player is already installed. ${NOFORMAT}"
    else
        log "${YELLOW}  ⬇️ VLC media player is not installed. ${NOFORMAT}"
        log "    Installing VLC media player..."
        sudo apt install -y vlc 2>&1 | tee -a "$LOG_FILE"
        log "${GREEN}  ✅ VLC media player installation completed. ${NOFORMAT}"
    fi
else
    log "${YELLOW}Skipping VLC media player installation...${NOFORMAT}"
fi
log "${WHITE}VLC media player installation completed.${NOFORMAT}"
