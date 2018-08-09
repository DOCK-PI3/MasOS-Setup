#!/bin/bash
if [[ $EUID -eq 0 ]]; then
sudo rm -r /home/pi/RetroPie/retropiemenu/ZT-Rom-Installer
echo "The ZT Installer will not work on this image"
echo "Removing the ZT Installer"
sleep 5
sudo reboot now
exit 0
fi

# New Script for Ubuntu and RetroPie images signed in as a user
mkdir -p $HOME/.emulationstation/themes
cd $HOME/.emulationstation/themes
git clone --depth=1 https://github.com/dmmarti/es-theme-maximuspie.git maximuspie
