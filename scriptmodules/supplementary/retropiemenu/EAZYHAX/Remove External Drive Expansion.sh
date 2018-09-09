#!/bin/bash
if [ ! -d /home/pi/MasOS/localroms ]; then
    echo ""
    echo ""
    echo "I do not detect that this MasOS is expanded. Killing this script."
    echo ""
    echo ""
	sleep 5
else

sudo sed -i '/addon/d' /etc/fstab
sudo cp /home/pi/RetroPie/retropiemenu/EAZYHAX/10-retropie.org /etc/profile.d/10-retropie.sh
sudo sed -i 's@/home/pi/addonusb/piroms/roms@/home/pi/MasOS/roms@g' /etc/samba/smb.conf
runuser -l pi -c 'unlink /home/pi/MasOS/roms; sudo umount /home/pi/addonusb; sudo umount overlay; sudo umount /home/pi/MasOS/roms;rm -r /home/pi/MasOS/roms; mv /home/pi/MasOS/localroms /home/pi/MasOS/roms' > /dev/null 2>&1
sudo reboot
fi
