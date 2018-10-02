#!/bin/sh
#
# Enabling HDD (USB0)
#

# creates backup config
if [ -f "/opt/masos/configs/all/emulationstation/es_systems.cfg.bk " ];
then
   echo "already backed up"
else
   echo "backing up" 
   cp /opt/masos/configs/all/emulationstation/es_systems.cfg /opt/masos/configs/all/emulationstation/es_systems.cfg.bk 
fi

# Enabling HDD
sudo cp /home/pi/MasOS/scripts/es_systems_HDDON.cfg /opt/masos/configs/all/emulationstation/es_systems.cfg
echo "es_systems updated, rebooting"
echo
echo "To go back to factory settings, disable HDD"
echo

# rebooting
sudo reboot
