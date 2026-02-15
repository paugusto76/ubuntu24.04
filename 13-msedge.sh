#!/bin/bash

# Author: Pedro Augusto
# Date: 2025-02-15
# Description: This script will install Microsoft Edge

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

if [[ "$install_edge" -eq 1 ]]; then

    if [ ! -f /etc/apt/sources.list.d/microsoft-edge.list ]; then
        log "${YELLOW}  ⬇️ Microsoft Edge repository is not added. ${NOFORMAT}"
        log "${YELLOW}  Adding packages.microsoft.com/repos/edge stable main repository... ${NOFORMAT}"
        curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/microsoft-edge.gpg > /dev/null
        echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-edge.gpg] https://packages.microsoft.com/repos/edge stable main" | sudo tee /etc/apt/sources.list.d/microsoft-edge.list
        sudo apt update -y 2>&1 | tee -a "$LOG_FILE"
    fi

    log "${BLUE}Installing Microsoft Edge...${NOFORMAT}"
    if command -v microsoft-edge > /dev/null 2>&1; then
        log "${GREEN}  ✅ Microsoft Edge is already installed. ${NOFORMAT}"
    else
        log "${YELLOW}  ⬇️ Microsoft Edge is not installed. ${NOFORMAT}"
        log "    Installing Microsoft Edge..."
        sudo apt install microsoft-edge-stable -y 2>&1 | tee -a "$LOG_FILE"
        log "${GREEN}  ✅ Microsoft Edge installation completed. ${NOFORMAT}"
    fi
else
    log "${YELLOW}Skipping Microsoft Edge installation...${NOFORMAT}"
fi
log "${WHITE}Microsoft Edge installation completed.${NOFORMAT}"
