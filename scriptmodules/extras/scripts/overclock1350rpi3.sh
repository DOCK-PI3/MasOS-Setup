#!/bin/sh
#
# Run this script to overclock the Raspberry Pi 
# After applying the settings, it reboots the system.
#
# To return to the normal state, run normal.sh.
#

# creates backup config
if [ -f "./config.txt.bak" ];
then
   echo "already backed up"
else
   echo "backing up" 
   cp /boot/config.txt ./config.txt.bak 
fi

# applies overclocked settings
sudo cp /home/pi/RetroPie/scripts/config_overclock1350rpi3.txt /boot/config.txt
echo "Overclocked settings updated, rebooting"
echo
echo "To go back to factory settings, run no overclock.sh"
echo

# rebooting
sudo reboot