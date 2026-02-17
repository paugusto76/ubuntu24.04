#!/bin/bash

# Author: Pedro Augusto
# Date: 2025-02-15
# Description: This script will install Chromium

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

if [[ "$install_chrome" -eq 1 ]]; then

    log "${BLUE}Installing Chromium...${NOFORMAT}"
    if command -v chromium > /dev/null 2>&1; then
        log "${GREEN}  ✅ Chromium is already installed. ${NOFORMAT}"
    else
        log "${YELLOW}  ⬇️ Chromium is not installed. ${NOFORMAT}"
        log "    Installing Chromium..."
        #curl -fsSL https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb -o /tmp/google-chrome.deb 2>&1 | tee -a "$LOG_FILE"
        #sudo dpkg -i /tmp/google-chrome.deb 2>&1 | tee -a "$LOG_FILE"
        #sudo apt-get install -f -y 2>&1 | tee -a "$LOG_FILE"
        #rm /tmp/google-chrome.deb
        sudo snap install chromium 2>&1 | tee -a "$LOG_FILE"
        log "${GREEN}  ✅ Chromium installation completed. ${NOFORMAT}"
    fi
else
    log "${YELLOW}Skipping Chromium installation...${NOFORMAT}"
fi

log "${WHITE}Chromium installation completed.${NOFORMAT}"
