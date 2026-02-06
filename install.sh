#!/usr/bin/env bash


##########################
# TODO:
#       KeePass
#


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


echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
echo -e "${CYAN} -> Updating the system ${NOFORMAT}"
sudo apt update -y
sudo apt upgrade -y
sudo apt autoremove -y


echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
echo -e "${CYAN} -> Checking NVIDIA drivers ${NOFORMAT}"
if command -v nvidia-smi >/dev/null 2>&1; then
    echo -e "${GREEN}  ✅ Driver installed. ${NOFORMAT}"
else
    echo -e "${YELLOW}  ⬇️ Driver is not installed. ${NOFORMAT}"
    echo "    Installing NVIDIA driver..."
    sudo apt update
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
echo -e "${CYAN} -> Checking repositories ${NOFORMAT}"
if ! grep -q "zhangsongcui3371/fastfetch" /etc/apt/sources.list.d/*.sources; then
  echo -e "${YELLOW}  Adding zhangsongcui3371/fastfetch repository... ${NOFORMAT}"
  sudo add-apt-repository -y ppa:zhangsongcui3371/fastfetch
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
else
  sudo rm -f /etc/apt/sources.list.d/vscode.list
fi
if [ ! -f /etc/apt/sources.list.d/vscode.sources ]; then
  if [ ! -f /etc/apt/sources.list.d/cursor.list ]; then
    echo -e "${YELLOW}  Adding downloads.cursor.com/apt stable main repository... ${NOFORMAT}"
    curl -fsSL https://downloads.cursor.com/keys/anysphere.asc | gpg --dearmor | sudo tee /etc/apt/keyrings/cursor.gpg > /dev/null
    echo "deb [signed-by=/etc/apt/keyrings/cursor.gpg] https://downloads.cursor.com/aptrepo stable main" | sudo tee /etc/apt/sources.list.d/cursor.list
  fi
else
  sudo rm -f /etc/apt/sources.list.d/cursor.list
fi
sudo apt update -y


echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
echo -e "${CYAN} -> Installing Terminal & Shell goodies ${NOFORMAT}"
TERMPACKAGES=(
  alacritty
  htop
  fastfetch
  bat
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
  gimp
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

if command -v betterlockscreen >/dev/null 2>&1; then
    echo -e "${GREEN}  ✅ Package betterlockscreen is installed. ${NOFORMAT}"
else
    echo -e "${YELLOW}  ⬇️ Package betterlockscreen is not installed. ${NOFORMAT}"
    echo "    Installing betterlockscreen..."
    curl -fsSL https://raw.githubusercontent.com/betterlockscreen/betterlockscreen/main/install.sh  | sudo bash -s system
fi


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


echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
echo -e "${CYAN} -> Installing Brave ${NOFORMAT}"

if command -v brave-browser >/dev/null 2>&1; then
    echo -e "${GREEN}  ✅ Package brave is installed. ${NOFORMAT}"
else
    echo -e "${YELLOW}  ⬇️ Package brave is not installed. ${NOFORMAT}"
    echo "    Installing brave..."
    curl -fsSL https://dl.brave.com/install.sh  | sh -s -- -y
fi


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
echo -e "${CYAN} -> Installing Intune Portal ${NOFORMAT}"
if command -v intune-portal >/dev/null 2>&1; then
    echo -e "${GREEN}  ✅ Package intune-portal is installed. ${NOFORMAT}"
else
    echo -e "${YELLOW}  ⬇️ Package intune-portal is not installed. ${NOFORMAT}"
    echo "    Installing intune-portal..."
    sudo apt install -y intune-portal
    should_reboot=1
fi


echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
echo -e "${CYAN} -> Installing dotnet sdks ${NOFORMAT}"
OFFICEPACKAGES=(
  dotnet-sdk-8.0
  dotnet-sdk-9.0
  dotnet-sdk-10.0
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
echo -e "${CYAN} -> Installing Cursor ${NOFORMAT}"
if command -v cursor >/dev/null 2>&1; then
    echo -e "${GREEN}  ✅ Package cursor is installed. ${NOFORMAT}"
else
    echo -e "${YELLOW}  ⬇️ Package cursor is not installed. ${NOFORMAT}"
    echo "    Installing cursor..."
    sudo apt install -y cursor
fi


echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
echo -e "${CYAN} -> Ensure MS Edge is default browser (needed for intune) ${NOFORMAT}"
EDGE_DESKTOP="microsoft-edge.desktop"
xdg-settings set default-web-browser "$EDGE_DESKTOP"
xdg-mime default "$EDGE_DESKTOP" x-scheme-handler/http
xdg-mime default "$EDGE_DESKTOP" x-scheme-handler/https
xdg-mime default "$EDGE_DESKTOP" text/html

echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
echo -e "${CYAN} -> Copying files ${NOFORMAT}"
cp -f .bashrc ~
cp -rf .local/share/fonts ~/.local/share
cp -rf .local/share/backgrounds ~/.local/share
cp -rf .local/share/locks ~/.local/share
cp -rf .local/share/Nokia ~/.local/share
fc-cache -f
cp -rf .config ~
cp -rf .vscode ~


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


echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
echo -e "${CYAN} -> Configure betterlockscreen ${NOFORMAT}"
if [ -d ~/.cache/betterlockscreen/current ]; then
    echo -e "${GREEN}  ✅ betterlockscreen is already configured. ${NOFORMAT}"
else
    betterlockscreen -u /home/augusto/.local/share/locks/astronaut.jpg
fi

echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
echo -e "${CYAN} -> Setting alacritty as default terminal ${NOFORMAT}"
sudo update-alternatives --set x-terminal-emulator /usr/bin/alacritty


echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
echo -e "${CYAN} -> Ensure PnP.PowerShell is installed ${NOFORMAT}"
pwsh -nop -c "if (!(Get-Module -ListAvailable -Name 'PnP.PowerShell')) { Install-Module PnP.PowerShell -Scope CurrentUser -Force }"


echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
echo -e "${CYAN} -> Setting GDM Wallpaper ${NOFORMAT}"
sudo mkdir -p /usr/share/backgrounds/gdm
sudo cp .local/share/gdm/astronaut.jpg /usr/share/backgrounds/gdm/gdm-wallpaper
sudo machinectl shell gdm@ /bin/bash -c "gsettings set com.ubuntu.login-screen background-picture-uri 'file:///usr/share/backgrounds/gdm/gdm-wallpaper'; gsettings set com.ubuntu.login-screen background-size 'cover'"


echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
echo -e "${GREEN} -> DONE! ${NOFORMAT}"

if (( should_reboot == 1 )); then
    echo -e "${RED} >> You should reboot to apply recent changes! ${NOFORMAT}"
fi
