#!/bin/bash

# Author: Pedro Augusto
# Date: 2025-02-15
# Description: This script will install Cursor IDE

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

if [ "$install_cursor" -eq 1 ]; then
  if [ -f /etc/apt/sources.list.d/cursor.sources ]; then
    if [ -f /etc/apt/sources.list.d/cursor.list ]; then
      sudo rm -f /etc/apt/sources.list.d/cursor.list
    fi
  fi
else
  if [ -f /etc/apt/sources.list.d/cursor.sources ]; then
    sudo rm -f /etc/apt/sources.list.d/cursor.sources
  fi
  if [ -f /etc/apt/sources.list.d/cursor.list ]; then
    sudo rm -f /etc/apt/sources.list.d/cursor.list
  fi
fi

if [ "$install_cursor" -eq 1 ]; then
  if [ ! -f /etc/apt/sources.list.d/cursor.sources ]; then
    if [ ! -f /etc/apt/sources.list.d/cursor.list ]; then
      echo -e "${YELLOW}  Adding downloads.cursor.com/aptrepo stable main repository... ${NOFORMAT}"
      curl -fsSL https://downloads.cursor.com/keys/anysphere.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/cursor.gpg > /dev/null
      echo "deb [signed-by=/etc/apt/keyrings/cursor.gpg] https://downloads.cursor.com/aptrepo stable main" | sudo tee /etc/apt/sources.list.d/cursor.list
    fi
  fi
fi

if [ "$install_cursor" -eq 1 ]; then
    log "${BLUE}Installing Cursor IDE...${NOFORMAT}"


    if command -v cursor >/dev/null 2>&1; then
        log "${GREEN}  ✅ Cursor IDE is installed. ${NOFORMAT}"
    else
        log "${YELLOW}  ⬇️ Cursor IDE is not installed. ${NOFORMAT}"
        log "    Installing Cursor IDE..."
        sudo apt-get update -y 2>&1 | tee -a "$LOG_FILE"
        sudo apt install -y cursor 2>&1 | tee -a "$LOG_FILE"
        log "${GREEN}  ✅ Cursor IDE installation completed. ${NOFORMAT}"
    fi

fi

log "${WHITE}Cursor IDE installation completed.${NOFORMAT}"
