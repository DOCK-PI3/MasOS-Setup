#!/usr/bin/env bash

infobox= ""
infobox="${infobox}___________________________________________________________________________\n\n"
infobox="${infobox}Install Backgroud Music\n\n"
infobox="${infobox}-Editado por mabedeep para MasOS\n"
infobox="${infobox}___________________________________________________________________________\n\n"

dialog --backtitle "MasOS Toolkit" \
--title "Install Backgroud Music" \
--msgbox "${infobox}" 23 80

function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "What action would you like to perform?" 25 75 20 \
            1 "Instalar MasOS Background Music" \
			2 "Configurar Ruta Default para MasOS BGM" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) Instalar_BGMUSICA  ;;
			2) rutadefault_BGM  ;;
            *)  break ;;
        esac
    done
}

function Instalar_BGMUSICA() {                                          #
dialog --infobox "... Nuevo Script instalador musica de fondo para ES bgm..." 30 55 ; sleep 3
sudo killall emulationstation
# sudo killall emulationstation-dev
sudo sh -c 'echo "deb [trusted=yes] https://repo.fury.io/rydra/ /" > /etc/apt/sources.list.d/es-bgm.list'
sudo apt update
sudo apt install -y python-pygame python-es-bgm
echo -e "\n\n\n   Descargando algo de musica para usted.\n\n\n"
sleep 3
sudo mkdir /home/pi/MasOS/roms/music
sudo chown -R pi:pi /home/pi/MasOS/roms/music
cd /home/pi/MasOS/roms/ && wget http://eazyhax.com/downloads/music.zip -O /home/pi/MasOS/roms/music.zip
unzip -o music.zip && rm music.zip
   sudo cat > /etc/bgmconfig.ini <<_EOF_
[default]
startdelay = 0
musicdir = /home/pi/MasOS/roms/music
restart = True
startsong =
_EOF_
echo -e "\n\n\n   El directorio por defecto donde introducir los .mp3 es /home/pi/MasOS/roms/music \n\n\n.Meta sus mp3 y reinicie el sistema.\n\n\nReiniciando en 7s"
sleep 7
sudo chown -R pi:pi /home/pi/MasOS/roms/music
sudo reboot
}

function rutadefault_BGM() {                                          #
dialog --infobox "... Ruta por default musica de fondo para ES bgm ..." 30 55 ; sleep 3
sudo chown -R pi:pi /etc/bgmconfig.ini
   sudo cat > /etc/bgmconfig.ini <<_EOF_
[default]
startdelay = 0
musicdir = /home/pi/MasOS/roms/music
restart = True
startsong =
_EOF_
echo -e "\n\n\n   El directorio por defecto donde introducir los .mp3 es \n/home/pi/MasOS/roms/music \n\n\n.Despues de meter sus mp3 reinicie el sistema. \n\n\n\n\n\nReiniciando en 7s"
sleep 7
sudo reboot
}

main_menu