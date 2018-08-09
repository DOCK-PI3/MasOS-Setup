#!/bin/sh
#
# disabling Dreamcast date/time Fix
#

# creates backup config
if [ -f "/opt/retropie/emulators/reicast/bin/reicast.bk" ];
then
   echo "already backed up"
else
   echo "backing up" 
   cp /opt/retropie/emulators/reicast/bin/reicast /opt/retropie/emulators/reicast/bin/reicast.bk 
fi

# disabling Dreamcast date/time fix 
sudo cp /home/pi/RetroPie/scripts/reicast_default /opt/retropie/emulators/reicast/bin/reicast
echo "reicast emulator updated, rebooting"
echo
echo "To go back to factory settings"
echo

# rebooting
sudo reboot