#!/bin/sh
#
# Enabling Dreamcast date/time Fix
#

# creates backup config
if [ -f "/opt/retropie/emulators/reicast/bin/reicast.bk" ];
then
   echo "already backed up"
else
   echo "backing up" 
   cp /opt/retropie/emulators/reicast/bin/reicast /opt/retropie/emulators/reicast/bin/reicast.bk 
fi

# Enabling Dreamcast date/time Fix
sudo cp /home/pi/RetroPie/scripts/reicast_nodate /opt/retropie/emulators/reicast/bin/reicast
echo "reicast emulator updated, rebooting"
echo
echo "To go back to factory settings, disable reicast no date"
echo

# rebooting
sudo reboot
