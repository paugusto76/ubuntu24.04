#!/bin/bash

# Author: Pedro Augusto
# Date: 2025-02-15
# Description: This script will install Rust programming language

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

if [ "$install_rust" -eq 1 ]; then
    log "${BLUE}Installing Rust...${NOFORMAT}"


    if command -v rustc >/dev/null 2>&1; then
        log "${GREEN}  ✅ Rust is installed. ${NOFORMAT}"
    else
        log "${YELLOW}  ⬇️ Rust is not installed. ${NOFORMAT}"
        log "    Installing Rust..."
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        source "$HOME/.cargo/env"
    fi

fi

log "${WHITE}Rust installation completed.${NOFORMAT}"
