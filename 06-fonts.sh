#!/bin/bash

# Author: Pedro Augusto
# Date: 2025-02-15
# Description: This script will install fonts and related utilities for the system

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

PACKAGES=(
  fonts-noto-cjk
  fonts-noto-color-emoji
  fonts-noto-core
  fonts-noto-mono
  fonts-dejavu-core
  fonts-dejavu-mono
  fonts-liberation
  fonts-liberation-sans-narrow
  fonts-font-awesome
  fonts-droid-fallback
)

# Install fonts and related utilities
log "${BLUE}Installing fonts and related utilities...${NOFORMAT}"
for package in "${PACKAGES[@]}"; do
    # Check if package is already installed
    if dpkg -l | grep -q "$package"; then
        log "${GREEN} ✅ $package is already installed.${NOFORMAT}"
        continue
    fi
    log "${BLUE} ⬇️ Installing $package...${NOFORMAT}"
    sudo apt install -y "$package" 2>&1 | tee -a "$LOG_FILE"
    log "${GREEN}  ✅ $package installation completed. ${NOFORMAT}"
done

# ensure $HOME/.local/share/fonts exists
mkdir -pv "$HOME/.local/share/fonts" 2>&1 | tee -a "$LOG_FILE"
cp -rfv .local/share/fonts $HOME/.local/share 2>&1 | tee -a "$LOG_FILE"
fc-cache -fv 2>&1 | tee -a "$LOG_FILE"

log "${WHITE}Fonts and related utilities installation completed.${NOFORMAT}"
