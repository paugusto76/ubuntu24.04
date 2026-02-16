#!/bin/bash

# Author: Pedro Augusto
# Date: 2025-02-15
# Description: This script will install Powershell terminal emulator

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

if [ "$install_code" -eq 1 ]; then
  if [ -f /etc/apt/sources.list.d/vscode.sources ]; then
    if [ -f /etc/apt/sources.list.d/vscode.list ]; then
      sudo rm -f /etc/apt/sources.list.d/vscode.list
    fi
  fi
else
  if [ -f /etc/apt/sources.list.d/vscode.sources ]; then
    sudo rm -f /etc/apt/sources.list.d/vscode.sources
  fi
  if [ -f /etc/apt/sources.list.d/vscode.list ]; then
    sudo rm -f /etc/apt/sources.list.d/vscode.list
  fi
fi

if [ ! -f /etc/apt/sources.list.d/vscode.sources ]; then
  if [ ! -f /etc/apt/sources.list.d/vscode.list ]; then
    echo -e "${YELLOW}  Adding packages.microsoft.com/repos/code stable main repository... ${NOFORMAT}"
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
  fi
fi



if [ "$install_code" -eq 1 ]; then
    log "${BLUE}Installing Visual Studio Code...${NOFORMAT}"


    if command -v code >/dev/null 2>&1; then
        log "${GREEN}  ✅ Visual Studio Code is installed. ${NOFORMAT}"
    else
        log "${YELLOW}  ⬇️ Visual Studio Code is not installed. ${NOFORMAT}"
        log "    Installing Visual Studio Code..."
        sudo apt-get update -y 2>&1 | tee -a "$LOG_FILE"
        sudo apt install -y code 2>&1 | tee -a "$LOG_FILE"
        log "${GREEN}  ✅ Visual Studio Code installation completed. ${NOFORMAT}"
    fi


    log "${CYAN} -> Installing Visual Studio Code Extensions ${NOFORMAT}"
    VSCODEEXTENSIONS=(
        ms-mssql.mssql
        ms-mssql.sql-database-projects-vscode
        ms-mssql.sql-bindings-vscode
        ms-mssql.data-workspace-vscode
        ms-dotnettools.vscode-dotnet-runtime
        ms-dotnettools.csharp
        ms-vscode.cpptools
        ms-dotnettools.csdevkit
        rokoroku.vscode-theme-darcula
        vscode-icons-team.vscode-icons
        ms-vscode.vscode-node-azure-pack
        github.copilot-chat
        ms-vscode.powershell
        ms-azuretools.vscode-azure-github-copilot
        teamsdevapp.vscode-ai-foundry
        mechatroner.rainbow-csv
        rust-lang.rust-analyzer
    )

    for vscext in "${VSCODEEXTENSIONS[@]}"; do
        if code --list-extensions | grep -q "^${vscext}$"; then
        log "${GREEN}  ✅ Extension ${vscext} is installed. ${NOFORMAT}"
        else
        log "${YELLOW}  ⬇️ Extension ${vscext} is not installed. ${NOFORMAT}"
        log "    Installing ${vscext}..."
        code --install-extension "${vscext}"
        fi
    done

fi

log "${WHITE}Visual Studio Code installation completed.${NOFORMAT}"
