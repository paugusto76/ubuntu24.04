#!/bin/bash

# Author: Pedro Augusto
# Date: 2025-02-16
# Description: This script will finalize the installation process by performing some cleanup tasks and displaying a completion message

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

log "${BLUE}Finalizing installation...${NOFORMAT}"
# Perform any cleanup tasks here if necessary

log "${BLUE} -> Copying files ${NOFORMAT}"
cp -f .bashrc ~
cp -rf .local/share/backgrounds $HOME/.local/share
cp -rf .local/share/locks $HOME/.local/share
cp -rf .local/share/Nokia $HOME/.local/share
cp -rf .local/share/gdm $HOME/.local/share
fc-cache -f
cp -rf .config $HOME
cp -f $HOME/.local/share/locks/${theme}.jpg $HOME/.local/share/locks/current.jpg
cp -f $HOME/.local/share/gdm/${theme}.jpg $HOME/.local/share/gdm/current.jpg
cp -f $HOME/.local/share/backgrounds/${theme}.jpg $HOME/.local/share/backgrounds/current.jpg


log "${WHITE} --------------------------------------------------- ${NOFORMAT}"
log "${CYAN} -> Configure betterlockscreen ${NOFORMAT}"
if [ -d $HOME/.cache/betterlockscreen/current ]; then
    log "${GREEN}  ✅ betterlockscreen is already configured. ${NOFORMAT}"
else
    betterlockscreen -u $HOME/.local/share/locks/current.jpg
fi

log "${WHITE} --------------------------------------------------- ${NOFORMAT}"
log "${CYAN} -> Setting alacritty as default terminal ${NOFORMAT}"
sudo update-alternatives --set x-terminal-emulator /usr/bin/alacritty

log "${WHITE} --------------------------------------------------- ${NOFORMAT}"
log "${CYAN} -> Setting GDM Wallpaper ${NOFORMAT}"
sudo mkdir -p /usr/share/backgrounds/gdm
sudo cp $HOME/.local/share/gdm/current.jpg /usr/share/backgrounds/gdm/gdm-wallpaper
sudo machinectl shell gdm@ /bin/bash -c "gsettings set com.ubuntu.login-screen background-picture-uri 'file:///usr/share/backgrounds/gdm/gdm-wallpaper'; gsettings set com.ubuntu.login-screen background-size 'cover'"
