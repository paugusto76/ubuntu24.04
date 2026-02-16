#!/bin/bash

# Author: Pedro Augusto
# Date: 2025-02-15
# Description: This script will install Microsoft Teams communication platform

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

if [ "$install_teams" -eq 1 ]; then
    log "${BLUE}Installing Microsoft Teams...${NOFORMAT}"

  if [ ! -f /etc/apt/sources.list.d/teams-for-linux.sources ]; then
    sudo wget -qO /etc/apt/keyrings/teams-for-linux.asc https://repo.teamsforlinux.de/teams-for-linux.asc
    echo "Types: deb
URIs: https://repo.teamsforlinux.de/debian/
Suites: stable
Components: main
Signed-By: /etc/apt/keyrings/teams-for-linux.asc
Architectures: amd64" | sudo tee /etc/apt/sources.list.d/teams-for-linux.sources
  fi

  if command -v teams-for-linux >/dev/null 2>&1; then
    log "${GREEN}  ✅ Microsoft Teams is installed. ${NOFORMAT}"
  else
    log "${YELLOW}  ⬇️ Microsoft Teams is not installed. ${NOFORMAT}"
    log "    Installing Microsoft Teams..."
    sudo apt install -y teams-for-linux 2>&1 | tee -a "$LOG_FILE"
    log "${GREEN}  ✅ Microsoft Teams installation completed. ${NOFORMAT}"
  fi
fi

log "${WHITE}Microsoft Teams installation completed.${NOFORMAT}"
