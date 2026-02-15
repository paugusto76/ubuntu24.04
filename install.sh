#!/bin/bash

set -euo pipefail

LOG_FILE="install.log"
# create log file if it doesn't exist
if [[ ! -f "$LOG_FILE" ]]; then
    touch "$LOG_FILE"
else # clear log file
    > "$LOG_FILE"
fi

# log start of installation
echo "Installation started at $(date)" | tee -a "$LOG_FILE"
echo "----------------------------------------" | tee -a "$LOG_FILE"

# Run scripts
./01-aptupdate.sh --log "$LOG_FILE"
./02-basicpackages.sh --log "$LOG_FILE"
./03-drivers.sh --log "$LOG_FILE"
./04-terminalutils.sh --log "$LOG_FILE"
./05-xwindows.sh --log "$LOG_FILE"
./06-fonts.sh --log "$LOG_FILE"
./07-wm.sh --log "$LOG_FILE"

./11-brave.sh --log "$LOG_FILE"
./12-chrome.sh --log "$LOG_FILE"
./13-msedge.sh --log "$LOG_FILE"

./21-gimp.sh --log "$LOG_FILE"
./22-filezilla.sh --log "$LOG_FILE"
./23-keepassxc.sh --log "$LOG_FILE"
./24-spotify.sh --log "$LOG_FILE"
./25-vlc.sh --log "$LOG_FILE"
./26-cubic.sh --log "$LOG_FILE"
./27-qemu.sh --log "$LOG_FILE"

# log end of installation
echo "----------------------------------------" | tee -a "$LOG_FILE"
echo "Installation completed at $(date)" | tee -a "$LOG_FILE"