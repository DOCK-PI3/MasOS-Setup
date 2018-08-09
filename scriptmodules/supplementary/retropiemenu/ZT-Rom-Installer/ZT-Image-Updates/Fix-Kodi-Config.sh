#!/bin/bash
mkdir -p $HOME/BackupKodi
cp /opt/retropie/configs/ports/kodi/emulators.cfg $HOME/BackupKodi/emulators.cfg
cd $HOME/RetroPie/roms/ports
wget http://roms2.teamzt.srve.io/MBromsets/Fix%20Kodi%20Config.sh
sudo chmod 755 "Fix Kodi Config.sh"
echo Restart Emulation Station to see New File in Ports
sleep 5