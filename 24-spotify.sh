#!/bin/bash

# Author: Pedro Augusto
# Date: 2025-02-15
# Description: This script will install Spotify music streaming service

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

if [[ "$install_spotify" -eq 1 ]]; then

    if [ ! -f /etc/apt/sources.list.d/spotify.list ]; then
        log "${YELLOW}  Adding Spotify repository... ${NOFORMAT}"
        curl -sS https://download.spotify.com/debian/pubkey_5384CE82BA52C83A.asc | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
        echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
    fi

    log "${BLUE}Installing Spotify music streaming service...${NOFORMAT}"
    if command -v spotify > /dev/null 2>&1; then
        log "${GREEN}  ✅ Spotify music streaming service is already installed. ${NOFORMAT}"
    else
        log "${YELLOW}  ⬇️ Spotify music streaming service is not installed. ${NOFORMAT}"
        log "    Installing Spotify music streaming service..."
        sudo apt install -y spotify-client 2>&1 | tee -a "$LOG_FILE"
        log "${GREEN}  ✅ Spotify music streaming service installation completed. ${NOFORMAT}"
    fi
else
    log "${YELLOW}Skipping Spotify music streaming service installation...${NOFORMAT}"
fi
log "${WHITE}Spotify music streaming service installation completed.${NOFORMAT}"
