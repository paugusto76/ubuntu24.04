#!/bin/bash

# Author: Pedro Augusto
# Date: 2025-02-14
# Description: This script will update the apt package list and upgrade any packages that have updates available

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

# Update apt package list
log "${BLUE}Updating apt package list...${NOFORMAT}"
sudo apt update -y 2>&1 | tee -a "$LOG_FILE"
# Upgrade packages
log "${BLUE}Upgrading packages...${NOFORMAT}"
sudo apt upgrade -y 2>&1 | tee -a "$LOG_FILE"
# Autoremove packages
log "${BLUE}Autoremoving packages...${NOFORMAT}"
sudo apt autoremove -y 2>&1 | tee -a "$LOG_FILE"
log "${GREEN}Apt update and upgrade completed.${NOFORMAT}"
