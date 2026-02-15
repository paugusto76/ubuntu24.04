#!/bin/bash

# Author: Pedro Augusto
# Date: 2025-02-15
# Description: This script will install Brave browser

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

if [[ "$install_brave" -eq 1 ]]; then

    log "${BLUE}Installing Brave browser...${NOFORMAT}"
    if command -v brave-browser > /dev/null 2>&1; then
        log "${GREEN}  ✅ Brave browser is already installed. ${NOFORMAT}"
    else
        log "${YELLOW}  ⬇️ Brave browser is not installed. ${NOFORMAT}"
        log "    Installing Brave browser..."
        curl -fsSL https://dl.brave.com/install.sh  | sh -s -- -y 2>&1 | tee -a "$LOG_FILE"
        log "${GREEN}  ✅ Brave browser installation completed. ${NOFORMAT}"
    fi
else
    log "${YELLOW}Skipping Brave browser installation...${NOFORMAT}"
fi
log "${WHITE}Brave browser installation completed.${NOFORMAT}"
