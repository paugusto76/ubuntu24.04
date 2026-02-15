#!/bin/bash

# Author: Pedro Augusto
# Date: 2025-02-14
# Description: This script will install terminal utilities that are commonly used in a Linux environment

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
  alacritty       # Alacritty is a modern terminal emulator that uses GPU acceleration for rendering, making it fast and efficient.
  htop            # htop is an interactive process viewer for Unix systems. It provides a real-time, color-coded display of system processes, resource usage, and performance metrics.
  btop            # btop is a terminal-based resource monitor that provides a visually appealing and interactive interface for monitoring system performance, including CPU, memory, disk, and network usage.
  ranger          # Ranger is a terminal-based file manager that provides a simple and efficient way to navigate and manage files and directories using a text-based interface.
  fastfetch       # Fastfetch is a fast and customizable system information tool that displays various details about the system, such as hardware, software, and performance metrics, in a visually appealing format.
  bat             # Bat is a cat clone with syntax highlighting and Git integration. It provides a more visually appealing way to view file contents in the terminal, with features like line numbers, syntax highlighting for various programming languages, and integration with Git to show changes in files.
  ncal            # ncal is a calendar utility that displays a calendar in the terminal. It can show the current month, a specific month, or an entire year, and it supports various formatting options for displaying the calendar.
  fortune-mod     # fortune-mod is a command-line utility that displays random quotes, jokes, or other messages from a collection of text files. It can be used to add some fun and variety to the terminal experience by displaying a different message each time it is run.
  cowsay          # cowsay is a command-line utility that generates ASCII art of a cow (or other characters) saying a message. It can be used to add some humor and personality to the terminal by displaying messages in a fun and creative way.
  lolcat          # lolcat is a command-line utility that adds rainbow colors to text output in the terminal. It can be used to make terminal output more visually appealing and colorful, adding a fun and vibrant touch to the terminal experience.
  mpg123          # mpg123 is a command-line audio player that supports various audio formats, including MP3. It provides a simple and efficient way to play audio files directly from the terminal, making it a popular choice for users who prefer a command-line interface for their audio playback needs.
  ffmpeg          # FFmpeg is a powerful command-line tool for processing and manipulating multimedia files, including audio and video. It can be used for tasks such as converting between different formats, extracting audio from video files, resizing videos, and much more, making it an essential utility for multimedia processing in the terminal.
  ncdu            # ncdu (NCurses Disk Usage) is a command-line utility that provides a visual representation of disk usage in the terminal. It allows users to navigate through directories and see the size of files and directories, making it easier to identify large files and manage disk space effectively.
  jq              # jq is a command-line JSON processor that allows users to parse, filter, and manipulate JSON data in the terminal. It provides a powerful and flexible way to work with JSON data, making it easier to extract specific information, transform data, and perform various operations on JSON files directly from the command line.
  chafa           # chafa is a command-line utility that converts images into ANSI/Unicode art for display in the terminal. It supports various image formats and provides options for customizing the output, allowing users to create visually appealing representations of images directly in the terminal.
)

if ! grep -q "zhangsongcui3371/fastfetch" /etc/apt/sources.list.d/*.sources; then
  echo -e "${YELLOW}  Adding zhangsongcui3371/fastfetch repository... ${NOFORMAT}"
  sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
fi

# Install terminal utilities
log "${BLUE}Installing terminal utilities...${NOFORMAT}"
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
log "${WHITE}Terminal utilities installation completed.${NOFORMAT}"
