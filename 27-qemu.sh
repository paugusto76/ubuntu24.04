#!/bin/bash

# Author: Pedro Augusto
# Date: 2025-02-15
# Description: This script will install QEMU virtual machine emulator

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

if [ "$install_qemu" -eq 1 ]; then
    log "${BLUE}Installing QEMU virtual machine emulator...${NOFORMAT}"
  QEMUPACKAGES=(
    qemu-system-x86
    libvirt-daemon-system
    libvirt-clients
    virtinst
    bridge-utils
    virt-manager
  )

  for pkg in "${QEMUPACKAGES[@]}"; do
    if dpkg-query -W -f='${Status}' "${pkg}" 2>/dev/null | grep -q "ok installed"; then
      log "${GREEN}  ✅ Package ${pkg} is installed. ${NOFORMAT}"
    else
      log "${YELLOW}  ⬇️ Package ${pkg} is not installed. ${NOFORMAT}"
      log "    Installing ${pkg}..."
      sudo apt install -y "${pkg}" 2>&1 | tee -a "$LOG_FILE"
      log "${GREEN}  ✅ Package ${pkg} installation completed. ${NOFORMAT}"
    fi
  done

  sudo usermod -aG libvirt   $USER
  sudo usermod -aG kvm       $USER
fi

log "${WHITE}QEMU virtual machine emulator installation completed.${NOFORMAT}"
