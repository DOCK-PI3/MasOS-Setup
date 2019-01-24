#!/usr/bin/env bash
echo "MasOS se reiniciará cuando el cambio se haya realizado!!"
sleep 5
sudo perl -p -i -e 's/#disable_overscan=1/disable_overscan=1/g' /boot/config.txt

sudo reboot
