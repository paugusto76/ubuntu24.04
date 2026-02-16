#!/bin/bash

# Author: Pedro Augusto
# Date: 2025-02-15
# Description: This script will install Node.js

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

if [ "$install_nodejs" -eq 1 ]; then

    log "${BLUE}Installing Node.js...${NOFORMAT}"

    if [ -d "$HOME/.nvm" ]; then
        log "${GREEN}  ✅ NVM is installed. ${NOFORMAT}"
    else
        log "${YELLOW}  ⬇️ NVM is not installed. ${NOFORMAT}"
        log "    Installing NVM..."
        curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
    fi

    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

    if nvm ls --no-colors | grep -q 'lts'; then
        log "${GREEN}  ✅ Node.js LTS is installed. ${NOFORMAT}"
    else
        log "${YELLOW}  ⬇️ Node.js is not installed. ${NOFORMAT}"
        log "    Installing Node.js..."
        nvm install --lts 
        nvm alias default 'lts/*'
    fi

fi

log "${WHITE}Node.js installation completed.${NOFORMAT}"
