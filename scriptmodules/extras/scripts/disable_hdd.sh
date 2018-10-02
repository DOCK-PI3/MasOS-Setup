#!/bin/sh
#
# Disabling HDD (USB0)
#

# creates backup config
if [ -f "/opt/masos/configs/all/emulationstation/es_systems.cfg.bk " ];
then
   echo "already backed up"
else
   echo "backing up" 
   cp /opt/masos/configs/all/emulationstation/es_systems.cfg /opt/masos/configs/all/emulationstation/es_systems.cfg.bk 
fi

# disabling HDD
sudo cp /home/pi/MasOS/scripts/es_systems_HDDOFF.cfg /opt/masos/configs/all/emulationstation/es_systems.cfg
echo "es_systems updated, rebooting"
echo
echo "back to factory settings"
echo

# rebooting
sudo reboot