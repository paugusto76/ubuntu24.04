#!/bin/bash

# Author: Pedro Augusto
# Date: 2025-02-15
# Description: This script will install Gimp image editor

# Parameters
# --log, -l : Log File
# --help, -h : Display this help message

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

if [[ "$install_gimp" -eq 1 ]]; then

    log "${BLUE}Installing Gimp image editor...${NOFORMAT}"
    if command -v gimp > /dev/null 2>&1; then
        log "${GREEN}  ✅ Gimp image editor is already installed. ${NOFORMAT}"
    else
        log "${YELLOW}  ⬇️ Gimp image editor is not installed. ${NOFORMAT}"
        log "    Installing Gimp image editor..."
        sudo apt install -y gimp 2>&1 | tee -a "$LOG_FILE"
        log "${GREEN}  ✅ Gimp image editor installation completed. ${NOFORMAT}"
    fi
else
    log "${YELLOW}Skipping Gimp image editor installation...${NOFORMAT}"
fi
log "${WHITE}Gimp image editor installation completed.${NOFORMAT}"
