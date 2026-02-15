#!/bin/bash

# Author: Pedro Augusto
# Date: 2025-02-14
# Description: This script will install drivers for the system

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

if [[ "$install_drivers" -eq 1 ]]; then
    log "${BLUE}Installing drivers...${NOFORMAT}"
    if command -v nvidia-smi > /dev/null 2>&1; then
        log "${GREEN}  ✅ Driver installed. ${NOFORMAT}"
    else
        log "${YELLOW}  ⬇️ Driver is not installed. ${NOFORMAT}"
        log "    Installing NVIDIA driver..."
        sudo apt update -y 2>&1 | tee -a "$LOG_FILE"
        sudo apt install -y ubuntu-drivers-common 2>&1 | tee -a "$LOG_FILE"
        sudo ubuntu-drivers autoinstall 2>&1 | tee -a "$LOG_FILE"
        log "${GREEN}  ✅ Driver installation completed. ${NOFORMAT}"
    fi
else
    log "${YELLOW}Skipping drivers installation...${NOFORMAT}"
fi
log "${WHITE}Drivers installation completed.${NOFORMAT}"
