#!/bin/bash
if [ ! -d $HOME/addonusb ]; then
    echo ""
    echo ""
    echo "I do not detect that this MasOS is expanded. Killing this script."
    echo ""
    echo ""
    sleep 5
else

sudo sed -i '/addon/d' /etc/fstab
sudo unlink /etc/profile.d/10-retropie.sh
sudo cp /etc/profile.d/10-retropie.sh.org /etc/profile.d/10-retropie.sh
sudo unlink /etc/samba/smb.conf
sudo cp /etc/samba/smb.conf.bkup /etc/samba/smb.conf
sudo /usr/sbin/service smbd stop
unlink $HOME/MasOS/roms; sudo umount $HOME/addonusb; sudo umount overlay
while [ `df |grep overlay |awk '{print $1 }'|wc -l` -eq 1 ]; do
            echo -e "\n\nOverlay Mount is still present. Waiting a few seconds and will try to dismout the drive again.\n\n"
            sleep 10
            sudo umount overlay
done
echo -e "\n\nCombined drives have been unmounted. Moving on with cleaning up directories and restoring your retro rig.\n\n"
sleep 10

rm -r $HOME/MasOS/combined_drives; rm -r $HOME/addonusb;  mv $HOME/MasOS/localroms $HOME/MasOS/roms  > /dev/null 2>&1
sudo reboot
fi
