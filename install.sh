#!/usr/bin/env bash

# read configuration file
. ./config.conf

set -euo pipefail

current_dir="$PWD"
should_reboot=0

NOFORMAT='\033[0m'
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
WHITE='\033[1;37m'

# Ensure the screenshots directory exists for flameshot
if [ ! -d "$HOME/Pictures/Screenshots" ]; then
  mkdir -p "$HOME/Pictures/Screenshots"
fi

# print configuration summary
echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
echo -e "${CYAN} Configuration Summary: ${NOFORMAT}"
echo -e "${WHITE}  - Install LibreOffice:${YELLOW} ${install_libreoffice} ${NOFORMAT}"
echo -e "${WHITE}  - Install Brave:${YELLOW} ${install_brave} ${NOFORMAT}"
echo -e "${WHITE}  - Install Firefox:${YELLOW} ${install_firefox} ${NOFORMAT}"
echo -e "${WHITE}  - Install MS Edge:${YELLOW} ${install_edge} ${NOFORMAT}"
echo -e "${WHITE}  - Install Intune Portal:${YELLOW} ${install_intune_portal} ${NOFORMAT}"
echo -e "${WHITE}  - Install Cursor:${YELLOW} ${install_cursor} ${NOFORMAT}"
echo -e "${WHITE}  - Install Code:${YELLOW} ${install_code} ${NOFORMAT}"
echo -e "${WHITE}  - Install PowerShell:${YELLOW} ${install_powershell} ${NOFORMAT}"
echo -e "${WHITE}  - Install NodeJS:${YELLOW} ${install_nodejs} ${NOFORMAT}"
echo -e "${WHITE}  - Install Rust:${YELLOW} ${install_rust} ${NOFORMAT}"
echo -e "${WHITE}  - Install QEMU:${YELLOW} ${install_qemu} ${NOFORMAT}"
echo -e "${WHITE}  - Install Spotify:${YELLOW} ${install_spotify} ${NOFORMAT}"
echo -e "${WHITE}  - Install Steam:${YELLOW} ${install_steam} ${NOFORMAT}"
echo -e "${WHITE}  - Install GZDoom:${YELLOW} ${install_gzdoom} ${NOFORMAT}"
echo -e "${WHITE}  - Install VLC:${YELLOW} ${install_vlc} ${NOFORMAT}"
echo -e "${WHITE}  - Install GIMP:${YELLOW} ${install_gimp} ${NOFORMAT}"
echo -e "${WHITE}  - Install FileZilla:${YELLOW} ${install_filezilla} ${NOFORMAT}"
echo -e "${WHITE}  - Install KeePassXC:${YELLOW} ${install_keepassxc} ${NOFORMAT}"
echo -e "${WHITE}  - Install Cubic:${YELLOW} ${install_cubic} ${NOFORMAT}"
echo -e "${WHITE}  - Install Minecraft:${YELLOW} ${install_minecraft} ${NOFORMAT}"
echo -e "${WHITE}  - Install Teams:${YELLOW} ${install_teams} ${NOFORMAT}"
echo -e "${WHITE}  - Install Draw.io:${YELLOW} ${install_drawio} ${NOFORMAT}"
echo -e "${WHITE}  - Theme:${YELLOW} ${theme} ${NOFORMAT}"
echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"

# It seems that these .sources files are generated automatically... let's fix this
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

if [ "$install_cursor" -eq 1 ]; then
  if [ -f /etc/apt/sources.list.d/cursor.sources ]; then
    if [ -f /etc/apt/sources.list.d/cursor.list ]; then
      sudo rm -f /etc/apt/sources.list.d/cursor.list
    fi
  fi
else
  if [ -f /etc/apt/sources.list.d/cursor.sources ]; then
    sudo rm -f /etc/apt/sources.list.d/cursor.sources
  fi
  if [ -f /etc/apt/sources.list.d/cursor.list ]; then
    sudo rm -f /etc/apt/sources.list.d/cursor.list
  fi
fi

# Remove firefox from snap
if  sudo snap list | grep firefox > /dev/null 2>&1; then 
  sudo snap remove --purge firefox
fi
sudo apt remove --purge firefox -y
sudo apt autoremove -y

echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
echo -e "${CYAN} -> Checking repositories ${NOFORMAT}"

if ! grep -q "zhangsongcui3371/fastfetch" /etc/apt/sources.list.d/*.sources; then
  echo -e "${YELLOW}  Adding zhangsongcui3371/fastfetch repository... ${NOFORMAT}"
  sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
fi
if ! grep -q "cubic-wizard/release" /etc/apt/sources.list.d/*.sources; then
  echo -e "${YELLOW}  Adding cubic-wizard/release repository... ${NOFORMAT}"
  sudo add-apt-repository -y ppa:cubic-wizard/release
fi
if ! grep -q "dotnet/backports" /etc/apt/sources.list.d/*.sources; then
  echo -e "${YELLOW}  Adding dotnet/backports repository... ${NOFORMAT}"
  sudo add-apt-repository -y ppa:dotnet/backports
fi
if [ ! -f /etc/apt/sources.list.d/microsoft-ubuntu-noble-prod.list ]; then
  echo -e "${YELLOW}  Adding packages.microsoft.com/ubuntu/24.04/prod noble main repository... ${NOFORMAT}"
  curl https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor > microsoft.gpg
  sudo install -o root -g root -m 644 microsoft.gpg /usr/share/keyrings/
  rm microsoft.gpg
  sudo sh -c 'echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/ubuntu/24.04/prod noble main" > /etc/apt/sources.list.d/microsoft-ubuntu-noble-prod.list'
fi
if [ ! -f /etc/apt/sources.list.d/microsoft-edge.list ]; then
  echo -e "${YELLOW}  Adding packages.microsoft.com/repos/edge stable main repository... ${NOFORMAT}"
  curl -fsSL https://packages.microsoft.com/keys/microsoft.asc | gpg --dearmor | sudo tee /usr/share/keyrings/microsoft-edge.gpg > /dev/null
  echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft-edge.gpg] https://packages.microsoft.com/repos/edge stable main" | sudo tee /etc/apt/sources.list.d/microsoft-edge.list
fi
if [ ! -f /etc/apt/sources.list.d/vscode.sources ]; then
  if [ ! -f /etc/apt/sources.list.d/vscode.list ]; then
    echo -e "${YELLOW}  Adding packages.microsoft.com/repos/code stable main repository... ${NOFORMAT}"
    echo "deb [arch=amd64 signed-by=/usr/share/keyrings/microsoft.gpg] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list
  fi
fi
if [ "$install_cursor" -eq 1 ]; then
  if [ ! -f /etc/apt/sources.list.d/cursor.sources ]; then
    if [ ! -f /etc/apt/sources.list.d/cursor.list ]; then
      echo -e "${YELLOW}  Adding downloads.cursor.com/aptrepo stable main repository... ${NOFORMAT}"
      curl -fsSL https://downloads.cursor.com/keys/anysphere.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/cursor.gpg > /dev/null
      echo "deb [signed-by=/etc/apt/keyrings/cursor.gpg] https://downloads.cursor.com/aptrepo stable main" | sudo tee /etc/apt/sources.list.d/cursor.list
    fi
  fi
fi
if [ ! -f /etc/apt/sources.list.d/spotify.list ]; then
  curl -sS https://download.spotify.com/debian/pubkey_5384CE82BA52C83A.asc | sudo gpg --dearmor --yes -o /etc/apt/trusted.gpg.d/spotify.gpg
  echo "deb https://repository.spotify.com stable non-free" | sudo tee /etc/apt/sources.list.d/spotify.list
fi
if [ ! -f /etc/apt/sources.list.d/teams-for-linux.sources ]; then
  sudo wget -qO /etc/apt/keyrings/teams-for-linux.asc https://repo.teamsforlinux.de/teams-for-linux.asc
  echo "Types: deb
URIs: https://repo.teamsforlinux.de/debian/
Suites: stable
Components: main
Signed-By: /etc/apt/keyrings/teams-for-linux.asc
Architectures: amd64" | sudo tee /etc/apt/sources.list.d/teams-for-linux.sources
fi
if [ ! -f /etc/apt/preferences.d/mozilla-firefox ]; then
  cat <<EOF | sudo tee /etc/apt/preferences.d/mozilla-firefox
Package: *
Pin: release o=Ubuntu*
Pin-Priority: -1

Package: firefox*
Pin: origin packages.mozilla.org
Pin-Priority: 1001
EOF
fi

if [ ! -f /etc/apt/sources.list.d/mozilla.list ]; then
  wget -q https://packages.mozilla.org/apt/repo-signing-key.gpg -O- \
    | sudo tee /etc/apt/keyrings/packages.mozilla.org.asc > /dev/null
  echo "deb [signed-by=/etc/apt/keyrings/packages.mozilla.org.asc] https://packages.mozilla.org/apt mozilla main" \
    | sudo tee -a /etc/apt/sources.list.d/mozilla.list > /dev/null
fi

echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
echo -e "${CYAN} -> Updating the system ${NOFORMAT}"
sudo dpkg --configure -a
sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y

echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
echo -e "${CYAN} -> Checking NVIDIA drivers ${NOFORMAT}"
if command -v nvidia-smi > /dev/null 2>&1; then
    echo -e "${GREEN}  ✅ Driver installed. ${NOFORMAT}"
else
    echo -e "${YELLOW}  ⬇️ Driver is not installed. ${NOFORMAT}"
    echo "    Installing NVIDIA driver..."
    sudo apt update -y
    sudo apt install -y ubuntu-drivers-common
    sudo ubuntu-drivers autoinstall

    should_reboot=1
fi

echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
echo -e "${CYAN} -> Installing basic utilities ${NOFORMAT}"
BASICPACKAGES=(
  curl
  wget
  git
  build-essential
  nano
  unzip
  man-db
  acpi
  lm-sensors
  bc
  gpg
  apt-transport-https
  software-properties-common
  libplist-utils
)

for pkg in "${BASICPACKAGES[@]}"; do
  if dpkg-query -W -f='${Status}' "${pkg}" 2>/dev/null | grep -q "ok installed"; then
    echo -e "${GREEN}  ✅ Package ${pkg} is installed. ${NOFORMAT}"
  else
    echo -e "${YELLOW}  ⬇️ Package ${pkg} is not installed. ${NOFORMAT}"
    echo "    Installing ${pkg}..."
    sudo apt install -y "${pkg}"
  fi
done

echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
echo -e "${CYAN} -> Installing Terminal & Shell goodies ${NOFORMAT}"
TERMPACKAGES=(
  alacritty
  htop
  btop
  ranger
  fastfetch
  bat
  ncal
  fortune-mod
  cowsay
  lolcat
  mpg123
  ffmpeg
  ncdu
  jq
  tldr
  chafa
)

for pkg in "${TERMPACKAGES[@]}"; do
  if dpkg-query -W -f='${Status}' "${pkg}" 2>/dev/null | grep -q "ok installed"; then
    echo -e "${GREEN}  ✅ Package ${pkg} is installed. ${NOFORMAT}"
  else
    echo -e "${YELLOW}  ⬇️ Package ${pkg} is not installed. ${NOFORMAT}"
    echo "    Installing ${pkg}..."
    sudo apt install -y "${pkg}"
  fi
done

if command -v starship >/dev/null 2>&1; then
    echo -e "${GREEN}  ✅ Package starship is installed. ${NOFORMAT}"
else
    echo -e "${YELLOW}  ⬇️ Package starship is not installed. ${NOFORMAT}"
    echo "    Installing starship..."
    curl -sS https://starship.rs/install.sh | sh -s -- -y
fi

echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
echo -e "${CYAN} -> Installing X Windows tools ${NOFORMAT}"
XWINPACKAGES=(
  x11-utils
  feh
  picom
  imagemagick
  xdg-utils
  scrot
  playerctl
  gdm-settings
  ca-certificates
  filezilla
  keepassxc
  cubic
)

for pkg in "${XWINPACKAGES[@]}"; do
  if dpkg-query -W -f='${Status}' "${pkg}" 2>/dev/null | grep -q "ok installed"; then
    echo -e "${GREEN}  ✅ Package ${pkg} is installed. ${NOFORMAT}"
  else
    echo -e "${YELLOW}  ⬇️ Package ${pkg} is not installed. ${NOFORMAT}"
    echo "    Installing ${pkg}..."
    sudo apt install -y "${pkg}"
  fi
done

if [ "$install_spotify" -eq 1 ]; then
  echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
  echo -e "${CYAN} -> Installing Spotify ${NOFORMAT}"
  if command -v spotify >/dev/null 2>&1; then
      echo -e "${GREEN}  ✅ Package spotify is installed. ${NOFORMAT}"
  else
      echo -e "${YELLOW}  ⬇️ Package spotify is not installed. ${NOFORMAT}"
      echo "    Installing spotify..."
      sudo apt install -y spotify-client
  fi
fi

if [ "$install_steam" -eq 1 ]; then
  echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
  echo -e "${CYAN} -> Installing Steam ${NOFORMAT}"
  if command -v steam >/dev/null 2>&1; then
      echo -e "${GREEN}  ✅ Package steam is installed. ${NOFORMAT}"
  else
      echo -e "${YELLOW}  ⬇️ Package steam is not installed. ${NOFORMAT}"
      echo "    Installing steam..."
      sudo dpkg --add-architecture i386
      sudo apt update -y
      sudo apt install -y steam-installer
  fi
fi

if [ "$install_gzdoom" -eq 1 ]; then
  echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
  echo -e "${CYAN} -> Installing GZDoom ${NOFORMAT}"
  if command -v gzdoom >/dev/null 2>&1; then
      echo -e "${GREEN}  ✅ Package gzdoom is installed. ${NOFORMAT}"
  else
      echo -e "${YELLOW}  ⬇️ Package gzdoom is not installed. ${NOFORMAT}"
      echo "    Installing gzdoom..."

      sudo apt install -y gzdoom
  fi
fi

if [ "$install_vlc" -eq 1 ]; then
  echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
  echo -e "${CYAN} -> Installing VLC ${NOFORMAT}"
  if command -v vlc >/dev/null 2>&1; then
      echo -e "${GREEN}  ✅ Package vlc is installed. ${NOFORMAT}"
  else
      echo -e "${YELLOW}  ⬇️ Package vlc is not installed. ${NOFORMAT}"
      echo "    Installing vlc..."
      sudo apt install -y vlc
  fi
fi

if [ "$install_gimp" -eq 1 ]; then
  echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
  echo -e "${CYAN} -> Installing GIMP ${NOFORMAT}"
  if command -v gimp >/dev/null 2>&1; then
      echo -e "${GREEN}  ✅ Package gimp is installed. ${NOFORMAT}"
  else
      echo -e "${YELLOW}  ⬇️ Package gimp is not installed. ${NOFORMAT}"
      echo "    Installing gimp..."
      sudo apt install -y gimp
  fi
fi 

if [ "$install_filezilla" -eq 1 ]; then
  echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
  echo -e "${CYAN} -> Installing FileZilla ${NOFORMAT}"
  if command -v filezilla >/dev/null 2>&1; then
      echo -e "${GREEN}  ✅ Package filezilla is installed. ${NOFORMAT}"
  else
      echo -e "${YELLOW}  ⬇️ Package filezilla is not installed. ${NOFORMAT}"
      echo "    Installing filezilla..."
      sudo apt install -y filezilla
  fi
fi

if [ "$install_keepassxc" -eq 1 ]; then
  echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
  echo -e "${CYAN} -> Installing KeePassXC ${NOFORMAT}"
  if command -v keepassxc >/dev/null 2>&1; then
      echo -e "${GREEN}  ✅ Package keepassxc is installed. ${NOFORMAT}"
  else
      echo -e "${YELLOW}  ⬇️ Package keepassxc is not installed. ${NOFORMAT}"
      echo "    Installing keepassxc..."
      sudo apt install -y keepassxc
  fi
fi

if [ "$install_cubic" -eq 1 ]; then
  echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
  echo -e "${CYAN} -> Installing Cubic ${NOFORMAT}"
  if command -v cubic >/dev/null 2>&1; then
      echo -e "${GREEN}  ✅ Package cubic is installed. ${NOFORMAT}"
  else
      echo -e "${YELLOW}  ⬇️ Package cubic is not installed. ${NOFORMAT}"
      echo "    Installing cubic..."
      sudo apt install -y cubic
  fi
fi

if [ "$install_minecraft" -eq 1 ]; then
  echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
  echo -e "${CYAN} -> Installing Minecraft ${NOFORMAT}"
  if command -v minecraft-launcher >/dev/null 2>&1; then
      echo -e "${GREEN}  ✅ Package minecraft-launcher is installed. ${NOFORMAT}"
  else
      echo -e "${YELLOW}  ⬇️ Package minecraft-launcher is not installed. ${NOFORMAT}"
      echo "    Installing minecraft-launcher..."
      wget https://launcher.mojang.com/download/Minecraft.deb -O /tmp/Minecraft.deb
      sudo apt install -y /tmp/Minecraft.deb
      rm /tmp/Minecraft.deb
  fi
fi

echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
echo -e "${CYAN} -> Installing Fonts ${NOFORMAT}"
FONTSPACKAGES=(
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

for pkg in "${FONTSPACKAGES[@]}"; do
  if dpkg-query -W -f='${Status}' "${pkg}" 2>/dev/null | grep -q "ok installed"; then
    echo -e "${GREEN}  ✅ Package ${pkg} is installed. ${NOFORMAT}"
  else
    echo -e "${YELLOW}  ⬇️ Package ${pkg} is not installed. ${NOFORMAT}"
    echo "    Installing ${pkg}..."
    sudo apt install -y "${pkg}"
  fi
done

echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
echo -e "${CYAN} -> Installing Window Manager ${NOFORMAT}"
WMPACKAGES=(
  i3-wm
  i3blocks
  suckless-tools
  rofi
  xautolock
  brightnessctl
  flameshot
)

for pkg in "${WMPACKAGES[@]}"; do
  if dpkg-query -W -f='${Status}' "${pkg}" 2>/dev/null | grep -q "ok installed"; then
    echo -e "${GREEN}  ✅ Package ${pkg} is installed. ${NOFORMAT}"
  else
    echo -e "${YELLOW}  ⬇️ Package ${pkg} is not installed. ${NOFORMAT}"
    echo "    Installing ${pkg}..."
    sudo apt install -y "${pkg}"
  fi
done

sudo usermod -aG video $USER

echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
echo -e "${CYAN} -> Building i3lock-color (used by betterlockscreen) ${NOFORMAT}"

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
    echo -e "${GREEN}  ✅ Package ${pkg} is installed. ${NOFORMAT}"
  else
    echo -e "${YELLOW}  ⬇️ Package ${pkg} is not installed. ${NOFORMAT}"
    echo "    Installing ${pkg}..."
    sudo apt install -y "${pkg}"
  fi
done

if [ -f "/usr/bin/i3lock" ]; then
    echo -e "${GREEN}  ✅ Package i3lock is installed. ${NOFORMAT}"
else
    echo -e "${YELLOW}  ⬇️ Package i3lock is not installed. ${NOFORMAT}"
    echo "    Installing i3lock..."
    git clone https://github.com/Raymo111/i3lock-color.git
    cd i3lock-color
    ./build.sh
    sudo ./install-i3lock-color.sh
    cd ..
    sudo rm -rf i3lock-color
fi

if command -v betterlockscreen >/dev/null 2>&1; then
    echo -e "${GREEN}  ✅ Package betterlockscreen is installed. ${NOFORMAT}"
else
    echo -e "${YELLOW}  ⬇️ Package betterlockscreen is not installed. ${NOFORMAT}"
    echo "    Installing betterlockscreen..."
    curl -fsSL https://raw.githubusercontent.com/betterlockscreen/betterlockscreen/main/install.sh  | sudo bash -s system
fi

echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
echo -e "${CYAN} -> Installing Utilities ${NOFORMAT}"
UTILSPACKAGES=(
  pulseaudio-utils
  alsa-utils
  thunar
  sysstat
)

for pkg in "${UTILSPACKAGES[@]}"; do
  if dpkg-query -W -f='${Status}' "${pkg}" 2>/dev/null | grep -q "ok installed"; then
    echo -e "${GREEN}  ✅ Package ${pkg} is installed. ${NOFORMAT}"
  else
    echo -e "${YELLOW}  ⬇️ Package ${pkg} is not installed. ${NOFORMAT}"
    echo "    Installing ${pkg}..."
    sudo apt install -y "${pkg}"
  fi
done

if [ "$install_libreoffice" -eq 1 ]; then
  echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
  echo -e "${CYAN} -> Installing Libre Office (Free Office) ${NOFORMAT}"
  OFFICEPACKAGES=(
    libreoffice
  )

  for pkg in "${OFFICEPACKAGES[@]}"; do
    if dpkg-query -W -f='${Status}' "${pkg}" 2>/dev/null | grep -q "ok installed"; then
      echo -e "${GREEN}  ✅ Package ${pkg} is installed. ${NOFORMAT}"
    else
      echo -e "${YELLOW}  ⬇️ Package ${pkg} is not installed. ${NOFORMAT}"
      echo "    Installing ${pkg}..."
      sudo apt install -y "${pkg}"
    fi
  done
fi

if [ "$install_brave" -eq 1 ]; then
  echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
  echo -e "${CYAN} -> Installing Brave ${NOFORMAT}"

  if command -v brave-browser >/dev/null 2>&1; then
      echo -e "${GREEN}  ✅ Package brave is installed. ${NOFORMAT}"
  else
      echo -e "${YELLOW}  ⬇️ Package brave is not installed. ${NOFORMAT}"
      echo "    Installing brave..."
      curl -fsSL https://dl.brave.com/install.sh  | sh -s -- -y
  fi
fi

if [ "$install_firefox" -eq 1 ]; then
  echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
  echo -e "${CYAN} -> Installing Firefox ${NOFORMAT}"

  if command -v firefox >/dev/null 2>&1; then
      echo -e "${GREEN}  ✅ Package firefox is installed. ${NOFORMAT}"
  else
      echo -e "${YELLOW}  ⬇️ Package firefox is not installed. ${NOFORMAT}"
      echo "    Installing firefox..."
      sudo apt install -y firefox
  fi
fi

if [ "$install_edge" -eq 1 ]; then
  echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
  echo -e "${CYAN} -> Installing MS Edge ${NOFORMAT}"
  if command -v microsoft-edge >/dev/null 2>&1; then
      echo -e "${GREEN}  ✅ Package msedge is installed. ${NOFORMAT}"
  else
      echo -e "${YELLOW}  ⬇️ Package msedge is not installed. ${NOFORMAT}"
      echo "    Installing msedge..."
      sudo apt install -y microsoft-edge-stable
  fi

  echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
  echo -e "${CYAN} -> Ensure MS Edge is default browser (needed for intune) ${NOFORMAT}"
  EDGE_DESKTOP="microsoft-edge.desktop"
  xdg-settings set default-web-browser "$EDGE_DESKTOP"
  xdg-mime default "$EDGE_DESKTOP" x-scheme-handler/http
  xdg-mime default "$EDGE_DESKTOP" x-scheme-handler/https
  xdg-mime default "$EDGE_DESKTOP" text/html
fi

if [ "$install_intune_portal" -eq 1 ]; then
  echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
  echo -e "${CYAN} -> Installing Intune Portal ${NOFORMAT}"
  if command -v intune-portal >/dev/null 2>&1; then
      echo -e "${GREEN}  ✅ Package intune-portal is installed. ${NOFORMAT}"
  else
      echo -e "${YELLOW}  ⬇️ Package intune-portal is not installed. ${NOFORMAT}"
      echo "    Installing intune-portal..."
      sudo apt install -y intune-portal
      should_reboot=1
  fi
fi

if [ "$install_dotnet_sdks" -eq 1 ]; then
  echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
  echo -e "${CYAN} -> Installing dotnet sdks ${NOFORMAT}"
  DOTNETPACKAGES=(
    dotnet-sdk-8.0
    dotnet-sdk-9.0
    dotnet-sdk-10.0
  )

  for pkg in "${DOTNETPACKAGES[@]}"; do
    if dpkg-query -W -f='${Status}' "${pkg}" 2>/dev/null | grep -q "ok installed"; then
      echo -e "${GREEN}  ✅ Package ${pkg} is installed. ${NOFORMAT}"
    else
      echo -e "${YELLOW}  ⬇️ Package ${pkg} is not installed. ${NOFORMAT}"
      echo "    Installing ${pkg}..."
      sudo apt install -y "${pkg}"
    fi
  done
fi

if [ "$install_code" -eq 1 ]; then
  echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
  echo -e "${CYAN} -> Installing Visual Studio Code ${NOFORMAT}"
  if command -v code >/dev/null 2>&1; then
      echo -e "${GREEN}  ✅ Package code is installed. ${NOFORMAT}"
  else
      echo -e "${YELLOW}  ⬇️ Package code is not installed. ${NOFORMAT}"
      echo "    Installing code..."
      sudo apt install -y code
  fi

  echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
  echo -e "${CYAN} -> Installing Visual Studio Code Extensions ${NOFORMAT}"
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
      echo -e "${GREEN}  ✅ Extension ${vscext} is installed. ${NOFORMAT}"
    else
      echo -e "${YELLOW}  ⬇️ Extension ${vscext} is not installed. ${NOFORMAT}"
      echo "    Installing ${vscext}..."
      code --install-extension "${vscext}"
    fi
  done
fi

if [ "$install_cursor" -eq 1 ]; then
  echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
  echo -e "${CYAN} -> Installing Cursor ${NOFORMAT}"
  if command -v cursor >/dev/null 2>&1; then
      echo -e "${GREEN}  ✅ Package cursor is installed. ${NOFORMAT}"
  else
      echo -e "${YELLOW}  ⬇️ Package cursor is not installed. ${NOFORMAT}"
      echo "    Installing cursor..."
      sudo apt install -y cursor
  fi
fi

echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
echo -e "${CYAN} -> Copying files ${NOFORMAT}"
cp -f .bashrc ~
cp -rf .local/share/fonts $HOME/.local/share
cp -rf .local/share/backgrounds $HOME/.local/share
cp -rf .local/share/locks $HOME/.local/share
cp -rf .local/share/Nokia $HOME/.local/share
cp -rf .local/share/gdm $HOME/.local/share
fc-cache -f
cp -rf .config $HOME
cp -rf .vscode $HOME
cp -f $HOME/.local/share/locks/${theme}.jpg $HOME/.local/share/locks/current.jpg
cp -f $HOME/.local/share/gdm/${theme}.jpg $HOME/.local/share/gdm/current.jpg
cp -f $HOME/.local/share/backgrounds/${theme}.jpg $HOME/.local/share/backgrounds/current.jpg

if [ "$install_powershell" -eq 1 ]; then
  echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
  echo -e "${CYAN} -> Installing PowerShell ${NOFORMAT}"
  if command -v pwsh >/dev/null 2>&1; then
    echo -e "${GREEN}  ✅ PowerShell is installed. ${NOFORMAT}"
  else
    echo -e "${YELLOW}  ⬇️ PowerShell is not installed. ${NOFORMAT}"
    echo "    Installing PowerShell..."
    sudo apt-get install -y powershell
  fi

  echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
  echo -e "${CYAN} -> Ensure PnP.PowerShell is installed ${NOFORMAT}"
  pwsh -nop -c "if (!(Get-Module -ListAvailable -Name 'PnP.PowerShell')) { Install-Module PnP.PowerShell -Scope CurrentUser -Force }"
  echo -e "${CYAN} -> Ensure Microsoft.Graph.Groups is installed ${NOFORMAT}"
  pwsh -nop -c "if (!(Get-Module -ListAvailable -Name 'Microsoft.Graph.Groups')) { Install-Module Microsoft.Graph.Groups -Scope CurrentUser -Force }"
fi

if [ "$install_nodejs" -eq 1 ]; then
  echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
  echo -e "${CYAN} -> Installing NVM ${NOFORMAT}"
  if [ -d "$HOME/.nvm" ]; then
    echo -e "${GREEN}  ✅ NVM is installed. ${NOFORMAT}"
  else
    echo -e "${YELLOW}  ⬇️ NVM is not installed. ${NOFORMAT}"
    echo "    Installing NVM..."
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
  fi
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"

  echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
  echo -e "${CYAN} -> Installing Node.js LTS ${NOFORMAT}"
  if nvm ls --no-colors | grep -q 'lts'; then
    echo -e "${GREEN}  ✅ Node.js LTS is installed. ${NOFORMAT}"
  else
    echo -e "${YELLOW}  ⬇️ Node.js is not installed. ${NOFORMAT}"
    echo "    Installing Node.js..."
    nvm install --lts
    nvm alias default 'lts/*'
  fi
fi

if [ "$install_rust" -eq 1 ]; then
  echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
  echo -e "${CYAN} -> Installing Rust ${NOFORMAT}"
  if command -v rustc >/dev/null 2>&1; then
    echo -e "${GREEN}  ✅ Rust is installed. ${NOFORMAT}"
  else
    echo -e "${YELLOW}  ⬇️ Rust is not installed. ${NOFORMAT}"
    echo "    Installing Rust..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    source "$HOME/.cargo/env"
  fi
fi

if [ "$install_teams" -eq 1 ]; then
  echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
  echo -e "${CYAN} -> Installing Microsoft Teams ${NOFORMAT}"
  if command -v teams-for-linux >/dev/null 2>&1; then
    echo -e "${GREEN}  ✅ Microsoft Teams is installed. ${NOFORMAT}"
  else
    echo -e "${YELLOW}  ⬇️ Microsoft Teams is not installed. ${NOFORMAT}"
    echo "    Installing Microsoft Teams..."
    sudo apt install -y teams-for-linux
  fi
fi

if [ "$install_drawio" -eq 1 ]; then
  echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
  echo -e "${CYAN} -> Installing draw.io ${NOFORMAT}"
  if command -v drawio >/dev/null 2>&1; then
    echo -e "${GREEN}  ✅ draw.io is installed. ${NOFORMAT}"
  else
    echo -e "${YELLOW}  ⬇️ draw.io is not installed. ${NOFORMAT}"
    echo "    Installing draw.io..."
    wget https://github.com/jgraph/drawio-desktop/releases/download/v29.3.6/drawio-amd64-29.3.6.deb -O /tmp/drawio.deb
    sudo apt install -y /tmp/drawio.deb
    rm /tmp/drawio.deb
  fi
fi

if [ "$install_qemu" -eq 1 ]; then
  echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
  echo -e "${CYAN} -> Installing QEMU ${NOFORMAT}"
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
      echo -e "${GREEN}  ✅ Package ${pkg} is installed. ${NOFORMAT}"
    else
      echo -e "${YELLOW}  ⬇️ Package ${pkg} is not installed. ${NOFORMAT}"
      echo "    Installing ${pkg}..."
      sudo apt install -y "${pkg}"
    fi
  done

  sudo usermod -aG libvirt   $USER
  sudo usermod -aG kvm       $USER
fi

echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
echo -e "${CYAN} -> Configure betterlockscreen ${NOFORMAT}"
if [ -d $HOME/.cache/betterlockscreen/current ]; then
    echo -e "${GREEN}  ✅ betterlockscreen is already configured. ${NOFORMAT}"
else
    betterlockscreen -u $HOME/.local/share/locks/current.jpg
fi

echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
echo -e "${CYAN} -> Setting alacritty as default terminal ${NOFORMAT}"
sudo update-alternatives --set x-terminal-emulator /usr/bin/alacritty

echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
echo -e "${CYAN} -> Setting GDM Wallpaper ${NOFORMAT}"
sudo mkdir -p /usr/share/backgrounds/gdm
sudo cp $HOME/.local/share/gdm/current.jpg /usr/share/backgrounds/gdm/gdm-wallpaper
sudo machinectl shell gdm@ /bin/bash -c "gsettings set com.ubuntu.login-screen background-picture-uri 'file:///usr/share/backgrounds/gdm/gdm-wallpaper'; gsettings set com.ubuntu.login-screen background-size 'cover'"

echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
echo -e "${GREEN} -> DONE! ${NOFORMAT}"

if (( should_reboot == 1 )); then
    echo -e "${RED} >> You should reboot to apply recent changes! ${NOFORMAT}"
fi

source ~/.bashrc
