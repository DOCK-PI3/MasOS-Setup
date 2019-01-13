#!/usr/bin/env bash

# ESTE FICHERO FORMA PARTE DEL PROYECTO MASOS CREADO POR MasOS TEAM 2018/2019. 
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/DOCK-PI3/MasOS-Setup/master/LICENSE.md
#

rp_module_id="attractmode"
rp_module_desc="Attract Mode emulator frontend para raspberry pi 3b y b+ con compilacion de mmal incluida"
rp_module_licence="GPL3 https://raw.githubusercontent.com/mickelson/attract/master/License.txt"
rp_module_section="exp"

function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "Quieres instalar Attract? ...dale" 25 75 20 \
            1 "Instalar/Actualizar Attract Mode con mmal" \
			2 "Eliminar Attract Mode en MasOS" \
			3 "Configurar Attract Mode en MasOS" \
			2>&1 > /dev/tty)

        case "$choice" in
            1) masos_attractinstall  ;;
			2) eliminar_attract  ;;
			3) config_attract  ;;
			*)  break ;;
        esac
    done
}


#########################################################################
# Funcion Reparar permisos en MasOS PC ;-) #
function masos_attractinstall() {                                          

# Cierra ES para una mejor y mas rapida compilacion de attract y ffmpeg......
# sudo killall emulationstation

# ACTUALIZAR LISTA DE PAQUETES Y PAQUETES DEL SISTEMA
sudo apt-get update; sudo apt-get upgrade -y

# Crear entorno para compilar
cd /home/pi && mkdir develop

# Instalar las dependencias para "sfml-pi" y Attract-Mode
sudo apt-get install -y cmake libflac-dev libogg-dev libvorbis-dev libopenal-dev libfreetype6-dev libudev-dev libjpeg-dev libudev-dev libfontconfig1-dev

# Descargar y compilar sfml-pi
cd /home/pi/develop
git clone --depth 1 https://github.com/mickelson/sfml-pi sfml-pi
mkdir sfml-pi/build; cd sfml-pi/build
cmake .. -DSFML_RPI=1 -DEGL_INCLUDE_DIR=/opt/vc/include -DEGL_LIBRARY=/opt/vc/lib/libbrcmEGL.so -DGLES_INCLUDE_DIR=/opt/vc/include -DGLES_LIBRARY=/opt/vc/lib/libbrcmGLESv2.so
sudo make -j4 install
sudo ldconfig

# Compilar FFmpeg con soporte mmal (decodificación de video acelerada por hardware)
cd /home/pi/develop
git clone --depth 1 git://source.ffmpeg.org/ffmpeg.git
cd ffmpeg
./configure --enable-mmal --disable-debug --enable-shared
make -j4
sudo make -j4 install
sudo ldconfig

# Descargar y compilar Attract-Mode
cd /home/pi/develop
git clone --depth 1 https://github.com/mickelson/attract attract
cd attract
make -j4 USE_GLES=1
sudo make -j4 install USE_GLES=1
sudo rm -r -f /home/pi/develop
# CONFIG INI PARA Attract-Mode
cd && wget https://github.com/DOCK-PI3/attract-config-rpi/blob/master/RetroPie/retropiemenu/Switch%20To%20Attract%20Mode.sh
sudo cp -R Switch\ To\ Attract\ Mode.sh /home/pi/RetroPie/retropiemenu/
cd && sudo rm -R Switch\ To\ Attract\ Mode.sh
sudo chmod -R +x /home/pi/RetroPie/retropiemenu/
cd && wget https://github.com/DOCK-PI3/attract-config-rpi/blob/master/opt/masos/configs/all/AM-Start.sh
sudo cp -R AM-Start.sh /opt/masos/configs/all/
cd && sudo rm -R AM-Start.sh
sudo chmod -R +x /opt/masos/configs/all/AM-Start.sh
cd && mkdir .attract
dialog --infobox " Antes de instalar la configuracion de attract, \n entre con pi-masos y active el autostart para ES" 30 55 ; sleep 5
dialog --infobox " Luego cambia a AM,una vez que inicie seleccione el idioma ESPAÑOL \n ,ya puede instalar la configuracion ,reiniciando en 10s" 30 55 ; sleep 5
dialog --infobox " Attract se instalo de forma correcta y con mmal ,reiniciando en 5s" 30 55 ; sleep 5
sudo shutdown -r now
# ---------------------------- #
}


#########################################################################
# Funcion eliminar attract en MasOS ;-) #
function eliminar_attract() {
dialog --infobox " ... Eliminando Attract mode de su rpi .......\n\n" 30 55 ; sleep 5
sudo rm -R /home/pi/MasOS/roms/setup
# sudo rm -R /usr/local/share/attract && sudo rm -R /etc/samba/smb.conf
# sudo systemctl restart smbd.service
sudo rm -R /usr/local/bin/attract
sudo cp /opt/masos/configs/all/ES-Start.sh /opt/masos/configs/all/autostart.sh
sudo rm -R /opt/masos/configs/all/AM-Start.sh && sudo rm -R /opt/masos/configs/all/ES-Start.sh
sudo rm -R /home/pi/RetroPie/retropiemenu/Switch\ To\ Attract\ Mode.sh
dialog --infobox " Attract mode se elimino de su sistema" 30 55 ; sleep 5
sudo shutdown -r now
# ---------------------------- #
}


#########################################################################
# Funcion configurar attract en MasOS ;-) #
function config_attract() {
# Configurar Attract-Mode swichs ,menus ,emulators....
dialog --infobox "... Descargando ,descomprimiendo y copiando ficheros de configuracion para Attract y MasOS..." 370 370 ; sleep 2
cd /home/pi/ && wget https://github.com/DOCK-PI3/attract-config-rpi/archive/master.zip && unzip -o master.zip
 sudo rm /home/pi/master.zip
    sudo cp -R /home/pi/attract-config-rpi-master/MasOS/roms/setup /home/pi/MasOS/roms/
	 sudo chmod -R +x /home/pi/MasOS/roms/setup/
	 sudo chown -R pi:pi /home/pi/MasOS/roms/setup/
    sudo cp -R /home/pi/attract-config-rpi-master/RetroPie/retropiemenu/* /home/pi/RetroPie/retropiemenu/
  sudo chmod -R +x /home/pi/RetroPie/retropiemenu/
 sudo cp -R /home/pi/attract-config-rpi-master/opt/masos/configs/all/* /opt/masos/configs/all/
  sudo chmod -R +x /opt/masos/configs/all/AM-Start.sh && sudo chmod -R +x /opt/masos/configs/all/ES-Start.sh
 sudo cp -R /home/pi/attract-config-rpi-master/etc/samba/smb.conf /etc/samba/
 # sudo systemctl restart smbd.service
  sudo cp -R /home/pi/attract-config-rpi-master/attract/* /home/pi/.attract/
  sudo chown -R pi:pi /home/pi/.attract/
  sudo chown -R pi:pi /opt/masos/configs/all/
dialog --infobox " Attract Mode se configuro correctamente!...\n\n Recuerde generar las listas de roms desde attract cuando meta juegos \n\n y para el menu setup si no le aparece!" 370 370 ; sleep 5
# Borrar directorios de compilacion y de configuracion.....
sudo rm -r -f /home/pi/attract-config-rpi-master
# ---------------------------- #
}
main_menu