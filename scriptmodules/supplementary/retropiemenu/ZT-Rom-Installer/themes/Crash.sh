#!/bin/bash
if [[ $EUID -eq 0 ]]; then
echo "The ZT Installer will not work on this image"
sleep 5
sudo reboot now
exit 0
fi

# New Script for Ubuntu and RetroPie images signed in as a user
cd $HOME/RetroPie/retropiemenu/ZT-Rom-Installer/
clear
wget -c --user-agent="1.16 built on linux-gnueabihf" http://installer2.srve.io/roms/themes/Crash.zip -q --show-progress

unzip -o $HOME/RetroPie/retropiemenu/ZT-Rom-Installer/Crash.zip -d $HOME/.emulationstation/themes
sudo rm -f $HOME/RetroPie/retropiemenu/ZT-Rom-Installer/Crash.zip*