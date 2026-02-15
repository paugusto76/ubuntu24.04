#!/bin/bash

# Author: Pedro Augusto
# Date: 2025-02-15
# Description: This script will install X Window System and related utilities

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
  xorg               # X.Org is the public, open-source implementation of the X Window System. It provides the basic framework for a GUI environment on Unix-like operating systems.
  xserver-xorg       # X server for the X Window System. It handles the display, keyboard, and mouse input for the graphical environment.
  x11-utils          # A collection of utilities for the X Window System, including tools for managing displays, testing X server functionality, and performing various tasks related to the graphical environment.
  feh                # feh is a lightweight and versatile image viewer for the X Window System. It supports various image formats and provides features such as thumbnail generation, slideshow mode, and customizable keybindings, making it a popular choice for users who want a simple and efficient way to view images in a graphical environment.
  picom              # Picom is a compositor for the X Window System that provides features such as transparency, shadows, and animations. It is often used to enhance the visual appearance of the desktop environment by adding effects and improving the overall aesthetics of the graphical interface.
  imagemagick        # ImageMagick is a powerful command-line tool for manipulating and converting images. It supports a wide range of image formats and provides various features for editing, resizing, and transforming images, making it a versatile utility for working with graphics in the X Window System.
  xdg-utils          # XDG Utils is a set of utilities for managing desktop environments, including opening URLs, handling MIME types, and managing desktop entries.
  scrot              # Scrot is a command-line utility for taking screenshots in the X Window System. It supports various options for capturing the entire screen, specific windows, or selected regions, making it a flexible tool for screenshot management.
  playerctl          # Playerctl is a command-line utility for controlling media players that implement the MPRIS D-Bus Interface. It allows users to control playback, retrieve metadata, and manage playlists from the terminal.
  gdm-settings       # GDM Settings is a utility for configuring the GNOME Display Manager (GDM), which is responsible for managing graphical login sessions.
)

# Install X Window System and related utilities
log "${BLUE}Installing X Window System and related utilities...${NOFORMAT}"
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
log "${WHITE}X Window System and related utilities installation completed.${NOFORMAT}"
