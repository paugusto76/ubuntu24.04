#!/bin/bash

# Author: Pedro Augusto
# Date: 2025-02-15
# Description: This script will install Dotnet SDKs

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

PACKAGES=(
    dotnet-sdk-8.0      # Latest LTS
    dotnet-sdk-9.0      # Latest Current
    dotnet-sdk-10.0     # Latest Preview
)

if [ "$install_dotnet_sdks" -eq 1 ]; then
    log "${BLUE}Installing Dotnet SDKs...${NOFORMAT}"

    sudo apt-get update -y 2>&1 | tee -a "$LOG_FILE"

    for package in "${PACKAGES[@]}"; do
        # Check if package is already installed
        if dpkg-query -W -f='${Status}' "${package}" 2>/dev/null | grep -q "ok installed"; then
            log "${GREEN} ✅ $package is already installed.${NOFORMAT}"
            continue
        fi
        log "${BLUE} ⬇️ Installing $package...${NOFORMAT}"
        sudo apt install -y "$package" 2>&1 | tee -a "$LOG_FILE"
        log "${GREEN}  ✅ $package installation completed. ${NOFORMAT}"
    done

fi

log "${WHITE}Dotnet SDKs installation completed.${NOFORMAT}"
