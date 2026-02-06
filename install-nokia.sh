#!/usr/bin/env bash

set -euo pipefail

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
echo -e "${CYAN} -> Install NOKIA certificates ${NOFORMAT}"
if [ -f /usr/local/share/ca-certificates/NokiaInternalRootCA.crt ]; then
  echo -e "${GREEN}  ✅ NOKIA Certificates installed. ${NOFORMAT}"
else
  echo -e "${YELLOW}  ⬇️ Certificates are not installed. ${NOFORMAT}"
  echo "    Installing NOKIA Certificates..."
  wget "http://pki.net.nokia.com/PKI/NokiaInternalRootCA.crt"
  wget "http://pki.net.nokia.com/PKI/NokiaInternalSubCA07(2).crt"
  sudo mv *.crt /usr/local/share/ca-certificates
  sudo update-ca-certificates
fi


echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
echo -e "${CYAN} -> Install ZScaler ${NOFORMAT}"
if command -v zscaler-config >/dev/null 2>&1; then
  echo -e "${GREEN}  ✅ ZScaler is installed. ${NOFORMAT}"
else
  echo -e "${YELLOW}  ⬇️ ZScaler is not installed. ${NOFORMAT}"
  echo "    Installing ZScaler..."
  cp ./zscaler/zscaler-client_3.7.2.51-1_amd64.deb /tmp
  sudo apt install -y /tmp/zscaler-client_3.7.2.51-1_amd64.deb
  rm -f /tmp/zscaler-client_3.7.2.51-1_amd64.deb
fi


echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
echo -e "${CYAN} -> Install Microsoft Defender ${NOFORMAT}"
if dpkg-query -W -f='${Status}' "mdatp" 2>/dev/null | grep -q "ok installed"; then
  echo -e "${GREEN}  ✅ Microsoft Defender is installed. ${NOFORMAT}"
  mdatp connectivity test
else
  echo -e "${YELLOW}  ⬇️ Microsoft Defender is not installed. ${NOFORMAT}"
  echo "    Installing Microsoft Defender..."
  sudo apt install -y mdatp
  sudo python3 ./mdatp/MicrosoftDefenderATPOnboardingLinuxServer.py
  sudo mdatp config real-time-protection --value enabled
  sudo mdatp edr tag set --name GROUP --value LINUX_INTUNE
  sudo systemctl daemon-reload
  sudo systemctl restart mdatp
  mdatp definitions update
  mdatp health
fi


echo -e "${WHITE} --------------------------------------------------- ${NOFORMAT}"
echo -e "${GREEN} -> DONE! ${NOFORMAT}"
