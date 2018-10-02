#!/bin/sh
#
# disabling Dreamcast date/time Fix
#

# creates backup config
if [ -f "/opt/masos/emulators/reicast/bin/reicast.bk" ];
then
   echo "already backed up"
else
   echo "backing up" 
   cp /opt/masos/emulators/reicast/bin/reicast /opt/masos/emulators/reicast/bin/reicast.bk 
fi

# disabling Dreamcast date/time fix 
sudo cp /home/pi/MasOS/scripts/reicast_default /opt/masos/emulators/reicast/bin/reicast
echo "reicast emulator updated, rebooting"
echo
echo "To go back to factory settings"
echo

# rebooting
sudo reboot