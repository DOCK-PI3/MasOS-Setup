#!/bin/sh
#
# Disabling HDD (USB0)
#

# creates backup config
if [ -f "/opt/retropie/configs/all/emulationstation/es_systems.cfg.bk " ];
then
   echo "already backed up"
else
   echo "backing up" 
   cp /opt/retropie/configs/all/emulationstation/es_systems.cfg /opt/retropie/configs/all/emulationstation/es_systems.cfg.bk 
fi

# disabling HDD
sudo cp /home/pi/RetroPie/scripts/es_systems_HDDOFF.cfg /opt/retropie/configs/all/emulationstation/es_systems.cfg
echo "es_systems updated, rebooting"
echo
echo "back to factory settings"
echo

# rebooting
sudo reboot