#!/bin/bash

# Author: Pedro Augusto
# Date: 2025-02-14
# Description: This script will install basic packages that are commonly used in a Linux environment

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
  curl                         # curl is a command-line tool for transferring data with URLs. It supports various protocols, including HTTP, HTTPS, FTP, and more, making it a versatile utility for downloading files, making API requests, and performing other network-related tasks from the terminal.
  wget                         # wget is a command-line utility for downloading files from the web. It supports HTTP, HTTPS, and FTP protocols, and it can be used to download files recursively, resume interrupted downloads, and perform various other tasks related to downloading content from the internet.
  git                          # Git is a distributed version control system that allows developers to track changes in their code, collaborate with others, and manage different versions of their projects. It provides a powerful and flexible way to handle source code management and is widely used in software development.
  build-essential              # build-essential is a package that includes essential tools for building software on Debian-based systems. It typically includes the GCC compiler, make, and other development tools required for compiling and building software from source.
  nano                         # Nano is a simple and user-friendly text editor for the terminal. It provides basic text editing capabilities and is often used for editing configuration files and writing scripts in a command-line environment.
  unzip                        # Unzip is a utility for extracting compressed ZIP files. It allows users to decompress and access the contents of ZIP archives, making it useful for handling compressed files downloaded from the internet or received via email.
  man-db                       # man-db is a package that provides the man command, which is used to view manual pages for commands and programs in the terminal. It allows users to access documentation and usage information for various commands and utilities.
  gpg                          # GnuPG (GPG) is a tool for secure communication and data encryption. It allows users to encrypt and sign data, verify signatures, and manage cryptographic keys, providing a secure way to protect sensitive information and ensure data integrity.
  apt-transport-https          # apt-transport-https is a package that allows the APT package manager to access repositories over the HTTPS protocol. It is necessary for securely downloading packages from repositories that use HTTPS, ensuring the integrity and confidentiality of the package data during transmission.
  software-properties-common   # software-properties-common is a package that provides tools for managing software repositories and PPAs (Personal Package Archives) on Debian-based systems. It includes the add-apt-repository command, which allows users to easily add and manage third-party repositories for installing software that may not be available in the default repositories.
  whois                        # whois is a command-line utility that allows users to query databases to obtain information about domain names, IP addresses, and other network-related data. It is commonly used for looking up information about website ownership, domain registration details, and network infrastructure.  ca-certificates # CA Certificates is a package that provides a set of trusted Certificate Authority (CA) certificates for verifying the authenticity of SSL/TLS connections.
  ca-certificates              # CA Certificates is a package that provides a set of trusted Certificate Authority (CA) certificates for verifying the authenticity of SSL/TLS connections.
)

# Install basic packages
log "${BLUE}Installing basic packages...${NOFORMAT}"
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
log "${WHITE}Basic packages installation completed.${NOFORMAT}"
