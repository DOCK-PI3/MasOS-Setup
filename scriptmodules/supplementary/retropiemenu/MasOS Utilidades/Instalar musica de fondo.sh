#!/usr/bin/env bash

infobox= ""
infobox="${infobox}___________________________________________________________________________\n\n"
infobox="${infobox}Instalador Herramienta Musica de fondo para ES , BGM MasOS\n\n"
infobox="${infobox}30-03-2019...Version del script: 2.0 FASE RC1 \n\n"
infobox="${infobox}Install BGM MasOS Backgroud Music Tool for emulationstation\n\n"
infobox="${infobox}-Scrip instalador creado por mabedeep para MasOS 4.X.X\n By MasOS Team\n\n"
infobox="${infobox}NOTA: Agregadas las dos ultimas opciones para descargar \npaquete opcional de musica y el paquete por defecto. \n\n\n\n"
infobox="${infobox}Si falla alguna opcion de la 3 a la 5 avisenos por telegram! Salu2\n\n"
infobox="${infobox}___________________________________________________________________________\n\n"

dialog --backtitle "MasOS BGM Toolkit" \
--title "Instalador BGM Musica de fondo para ES" \
--msgbox "${infobox}" 23 80

function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "Que accion le gustaria realizar?" 25 75 20 \
            1 "Instalar BGM MasOS Background Music" \
			2 "Desactivar o Activar BGM MasOS ,solo despues de instalar" \
            3 "Limpiar de .MP3 el directorio music" \
			4 "EXTRA BGM Descargar DOCK-PI3 ARCADE COLLECTIONS" \
			5 "EXTRA BGM Descargar HEAZYHAX Default install" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) Instalar_BGMUSICA  ;;
			2) off_on_bgm  ;;
			3) limpiar_mp3Dir  ;;
            4) dockpi3_bgmPack  ;;
			5) default_bgmPack  ;;
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
sudo chown -R pi:pi /etc/bgmconfig.ini
   sudo cat > /etc/bgmconfig.ini <<_EOF_
[default]
startdelay = 0
musicdir = /home/pi/MasOS/roms/music
restart = True
startsong =
_EOF_
echo -e "\n\n\n   El directorio por defecto donde introducir los .mp3 es /home/pi/MasOS/roms/music \n\n\n.Meta sus mp3 y reinicie el sistema para empezar a escuchar su musica.\n\n\nReiniciando en 7s"
sleep 7
sudo chown -R pi:pi /home/pi/MasOS/roms/music
sudo reboot
}

#########################################################################
# Activar o descativar la musica de fondo ,para es bgm #
function off_on_bgm() {
        if [[ -f /etc/bgmconfig.ini ]]; then
			sudo chown -R pi:pi /etc/bgmconfig.ini
			sudo mv /etc/bgmconfig.ini /etc/bgmconfig_off.ini
			echo -e "\n\n\n   Desactivando la musica de fondo y reiniciando en 3s.\n\n\n"
		sleep 3
		sudo reboot
    else
        if [[ -f /etc/bgmconfig_off.ini ]]; then
			sudo chown -R pi:pi /etc/bgmconfig_off.ini
			sudo mv /etc/bgmconfig_off.ini /etc/bgmconfig.ini
			echo -e "\n\n\n   Activando la musica de fondo y reiniciando en 3s.\n\n\n"
		sleep 3
		sudo reboot
	fi
		fi
# ---------------------------- #
}

#########################################################################
# Limpiar directorio de musica #
function limpiar_mp3Dir() {
			echo -e "\n\n\n   Este script elimina el directorio completo y lo crea nuevo !....\n\n\n"
		sleep 2
			sudo chown -R pi:pi /home/pi/MasOS/roms/music
			sudo rm -R /home/pi/MasOS/roms/music
			sudo mkdir /home/pi/MasOS/roms/music
			sudo chown -R pi:pi /home/pi/MasOS/roms/music
			echo -e "\n\n\n   Se eliminaron todos sus ficheros de /music.....\n\n\n"
		sleep 2
# ---------------------------- #
}

#########################################################################
# Descargar pack dock-pi3 bgm #
function dockpi3_bgmPack() {
			echo -e "\n\n\n   Descargando pack personal dock-pi3.  ,.....Espere!.....\n\n\nTamaño en disco: 141 mb\n\n\nCanciones: 39 ficheros\n\n\nCategoria: ARCADES\n\n\nFormato: .mp3"
			sleep 5
			cd && wget https://download2268.mediafire.com/g2ccxahl5wug/7p78qqlz22kq0qu/BGM_DOCK-PI3_COLLECTIONS.zip -O /home/pi/BGM_DOCK-PI3_COLLECTIONS.zip
			sudo chown -R pi:pi /home/pi/MasOS/roms/music
			unzip -o BGM_DOCK-PI3_COLLECTIONS.zip && cp -R /home/pi/BGM_DOCK-PI3_COLLECTIONS/*.mp3 /home/pi/MasOS/roms/music/
			cd
			rm BGM_DOCK-PI3_COLLECTIONS.zip && rm -R /home/pi/BGM_DOCK-PI3_COLLECTIONS/
			sudo chown -R pi:pi /home/pi/MasOS/roms/music
		  echo -e "\n\n\n   El pack dock-pi3 se descargo correctamente!.....\n\n\nRecuerde reiniciar el sistema para empezar a escuchar la musica.!\n\n\n"
		sleep 3
# ---------------------------- #
}

#########################################################################
# Descargar pack Default bgm #
function default_bgmPack() {
			echo -e "\n\n\n   Descargando el pack que se instala por Defecto.\n\n\nPack creado por EAZYHAX , http://eazyhax.com .....Espere!.....\n\n\n"
			sleep 3
			sudo chown -R pi:pi /home/pi/MasOS/roms/music
				cd /home/pi/MasOS/roms/ && wget http://eazyhax.com/downloads/music.zip -O /home/pi/MasOS/roms/music.zip
					unzip -o music.zip && rm music.zip
				  sudo chown -R pi:pi /home/pi/MasOS/roms/music
				echo -e "\n\n\n   El pack por defecto se descargo correctamente!.....\n\n\nRecuerde reiniciar el sistema para empezar a escuchar la musica.!\n\n\n"
			sleep 3
# ---------------------------- #
}

main_menu