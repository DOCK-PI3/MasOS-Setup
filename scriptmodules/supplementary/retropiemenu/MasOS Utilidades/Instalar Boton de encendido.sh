#!/bin/bash

sudo grep powerpi.py /etc/rc.local > /dev/null 2>&1

if [ $? -eq 0 ] ; then
	echo "El botón de encendido ya se ha habilitado. No es necesario ejecutar este script de nuevo!"
	sleep 5
	exit
else
	echo "Se va a habilitar el botón de encendido. Cuando termine el proceso, se reiniciará el sistema."
	sudo sed -i '/fi/a \ sudo python /home/pi/.powerpi.py --silent & \' /etc/rc.local
	cd /home/pi/ && wget https://raw.githubusercontent.com/Shakz76/Eazy-Hax-RetroPie-Toolkit/master/cfg/.powerpi.py
	sudo reboot
fi
