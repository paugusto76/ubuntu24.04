#!/bin/bash

# Author: Pedro Augusto
# Date: 2025-02-15
# Description: This script will install Cubic ISO customization tool

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

if [[ "$install_cubic" -eq 1 ]]; then

    log "${BLUE}Installing Cubic ISO customization tool...${NOFORMAT}"
    if command -v cubic > /dev/null 2>&1; then
        log "${GREEN}  ✅ Cubic ISO customization tool is already installed. ${NOFORMAT}"
    else
        log "${YELLOW}  ⬇️ Cubic ISO customization tool is not installed. ${NOFORMAT}"
        log "    Installing Cubic ISO customization tool..."
        sudo apt install -y cubic 2>&1 | tee -a "$LOG_FILE"
        log "${GREEN}  ✅ Cubic ISO customization tool installation completed. ${NOFORMAT}"
    fi
else
    log "${YELLOW}Skipping Cubic ISO customization tool installation...${NOFORMAT}"
fi
log "${WHITE}Cubic ISO customization tool installation completed.${NOFORMAT}"
