#!/bin/bash

echo "Debes estar conectado a internet para que esto funcione."
sleep 2
runuser -l pi -c 'cd /home/pi/MasOS/roms/ports; wget http://eazyhax.com/downloads/cavestoryen.zip; unzip cavestoryen.zip; rm cavestoryen.zip'
if [ -d "/home/pi/MasOS/roms/ports/CaveStory" ]; then
echo "Parece que está instalado y listo. Que te diviertas!"
else
echo "Parece que algo salió mal. No veo que CaveStory esté instalado."
fi
sleep 5
exit

