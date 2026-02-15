#!/bin/bash

# Author: Pedro Augusto
# Date: 2025-02-15
# Description: This script will install Windows Manager and related utilities for the system

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
  i3-wm
  i3blocks
  suckless-tools
  rofi
  xautolock
  brightnessctl
  flameshot
  pulseaudio-utils
  alsa-utils
  thunar
  sysstat
)

# Install Windows Manager and related utilities
log "${BLUE}Installing Windows Manager and related utilities...${NOFORMAT}"
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

sudo usermod -aG video $USER

log "${WHITE} --------------------------------------------------- ${NOFORMAT}"
log "${CYAN} -> Building i3lock-color (used by betterlockscreen) ${NOFORMAT}"

I3LOCKCOLORPACKAGES=(
  autoconf
  gcc
  make
  pkg-config
  libpam0g-dev
  libcairo2-dev
  libfontconfig1-dev
  libxcb-composite0-dev
  libev-dev
  libx11-xcb-dev
  libxcb-xkb-dev
  libxcb-xinerama0-dev
  libxcb-randr0-dev
  libxcb-image0-dev
  libxcb-util0-dev
  libxcb-xrm-dev
  libxkbcommon-dev
  libxkbcommon-x11-dev
  libjpeg-dev
  libgif-dev
)

for pkg in "${I3LOCKCOLORPACKAGES[@]}"; do
  if dpkg-query -W -f='${Status}' "${pkg}" 2>/dev/null | grep -q "ok installed"; then
    log "${GREEN}  ✅ Package ${pkg} is installed. ${NOFORMAT}"
  else
    log "${YELLOW}  ⬇️ Package ${pkg} is not installed. ${NOFORMAT}"
    log "    Installing ${pkg}..."
    sudo apt install -y "${pkg}" 2>&1 | tee -a "$LOG_FILE"
    log "${GREEN}  ✅ Package ${pkg} installation completed. ${NOFORMAT}"
  fi
done

if [ -f "/usr/bin/i3lock" ]; then
    log "${GREEN}  ✅ Package i3lock is installed. ${NOFORMAT}"
else
    log "${YELLOW}  ⬇️ Package i3lock is not installed. ${NOFORMAT}"
    log "    Installing i3lock..."
    git clone https://github.com/Raymo111/i3lock-color.git
    cd i3lock-color
    ./build.sh 2>&1 | tee -a "$LOG_FILE"
    sudo ./install-i3lock-color.sh 2>&1 | tee -a "$LOG_FILE"
    cd ..
    sudo rm -rf i3lock-color
fi

if command -v betterlockscreen >/dev/null 2>&1; then
    log "${GREEN}  ✅ Package betterlockscreen is installed. ${NOFORMAT}"
else
    log "${YELLOW}  ⬇️ Package betterlockscreen is not installed. ${NOFORMAT}"
    log "    Installing betterlockscreen..."
    curl -fsSL https://raw.githubusercontent.com/betterlockscreen/betterlockscreen/main/install.sh  | sudo bash -s system
fi

log "${WHITE}Windows Manager and related utilities installation completed.${NOFORMAT}"
