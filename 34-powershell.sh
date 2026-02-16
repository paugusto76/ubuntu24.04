#!/bin/bash

# Author: Pedro Augusto
# Date: 2025-02-15
# Description: This script will install Powershell terminal emulator

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

if [ "$install_powershell" -eq 1 ]; then
    log "${BLUE}Installing Powershell...${NOFORMAT}"

    source /etc/os-release
    wget -q https://packages.microsoft.com/config/ubuntu/$VERSION_ID/packages-microsoft-prod.deb -O /tmp/packages-microsoft-prod.deb
    sudo dpkg -i /tmp/packages-microsoft-prod.deb
    rm /tmp/packages-microsoft-prod.deb
    sudo apt-get update -y 2>&1 | tee -a "$LOG_FILE"

    if command -v pwsh >/dev/null 2>&1; then
        log "${GREEN}  ✅ Powershell is installed. ${NOFORMAT}"
    else
        log "${YELLOW}  ⬇️ Powershell is not installed. ${NOFORMAT}"
        log "    Installing Powershell..."
        sudo apt-get install -y powershell 2>&1 | tee -a "$LOG_FILE"  
        log "${GREEN}  ✅ Powershell installation completed. ${NOFORMAT}"
    fi

    echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
    echo -e "${CYAN} -> Ensure PnP.PowerShell is installed ${NOFORMAT}"
    pwsh -nop -c "if (!(Get-Module -ListAvailable -Name 'PnP.PowerShell')) { Install-Module PnP.PowerShell -Scope CurrentUser -Force }"
    echo -e "${CYAN} -> Ensure Microsoft.Graph.Groups is installed ${NOFORMAT}"
    pwsh -nop -c "if (!(Get-Module -ListAvailable -Name 'Microsoft.Graph.Groups')) { Install-Module Microsoft.Graph.Groups -Scope CurrentUser -Force }"
fi

log "${WHITE}Powershell installation completed.${NOFORMAT}"
