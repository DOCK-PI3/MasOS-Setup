#!/usr/bin/env bash
rp_module_id="masosupdateallsystem"
rp_module_desc="Actualizador para el sistema MasOS"
rp_module_section=""
infobox= "${infobox}\n"
infobox="${infobox}_______________________________________________________\n\n"
infobox="${infobox}\n"
infobox="${infobox}\nMasOS Herramientas extras para el menu ,actualizador de script base \n\n"
infobox="${infobox}\ny reparador de permisos para la version PC,IDIOMAS y mucho mas.."
infobox="${infobox}\n"
infobox="${infobox}\n"
infobox="${infobox}\n"
infobox="${infobox}Se recomienda instalacion de EXTRAS para el menu solo en raspberry pi....\n"
infobox="${infobox}\n"

dialog --backtitle "MasOS extras y actualizador de script base" \
--title "MasOS EXTRAS ,actualizador de Script y raparador de permisos en PC(by MasOS TEAM)" \
--msgbox "${infobox}" 35 110



function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "Que accion te gustaria realizar?" 25 75 20 \
            1 "Actualizar MasOS-Setup script" \
			2 "MasOS EXTRAS para el menu de emulationstation" \
            3 "Reparar permisos en MasOS PC" \
            4 "Rasbperry pi ES instalar idioma español" \
            5 "PC ES instalar idioma español" \
		    6 "BETA Instalar MalditaCastilla en Raspberry pi" \
			2>&1 > /dev/tty)

        case "$choice" in
            1) masossetup_update  ;;
			2) masosmenu_extras  ;;
            3) permisos_pc  ;;
			4) pi_spanish  ;;
			5) pc_spanish  ;;
			6) inst_malditac  ;;
			*)  break ;;
        esac
    done
}
#########################################################################
# funcion actualizacion para MasOS Setup script  ;-) #
function masossetup_update() {                                          #
dialog --infobox "...Actualizando script MasOS-Setup..." 30 55 ; sleep 3
cd 
	sudo rm -R ~/MasOS-Setup/
		sudo git clone --depth=1 https://github.com/DOCK-PI3/MasOS-Setup.git
	sudo chmod -R +x ~/MasOS-Setup/
dialog --infobox " MasOS-Setup script se actualizo correctamente!...\n\nEn 5seg se reinicia el sistema..espere por favor!" 60 75 ; sleep 5
sudo reboot 
}

#########################################################################
# Funcion EXTRAs Menu ES para MasOS ;-) #
function masosmenu_extras() {                                          #
dialog --infobox " MasOS opciones Extras en rpi para el menu de ES..." 30 55 ; sleep 5
cd
sudo cp /home/pi/MasOS-Setup/scriptmodules/extras/gamelist.xml /opt/masos/configs/all/emulationstation/gamelists/retropie/
sudo cp /home/pi/MasOS-Setup/scriptmodules/extras/.livewire.py /home/pi/
sudo cp -R /home/pi/MasOS-Setup/scriptmodules/supplementary/retropiemenu/* /home/pi/RetroPie/retropiemenu/
# sudo cp -R /home/pi/MasOS-Setup/scriptmodules/supplementary/retropiemenu/icons /home/pi/RetroPie/retropiemenu
sudo cp -R /home/pi/MasOS-Setup/scriptmodules/extras/scripts /home/pi/RetroPie/
sudo chmod -R +x /home/pi/RetroPie
sudo chmod -R +x /opt/
sudo mkdir /home/pi/MasOS/videoloadingscreens
sudo mkdir /home/pi/MasOS/roms/music
sudo chown -R pi:pi /home/pi/MasOS
dialog --infobox " Las opciones Extras estan instaladas,reiniciando el sistema en 5seg ..." 30 55 ; sleep 5
sudo reboot
# ---------------------------- #
}

#########################################################################
# Funcion Reparar permisos en MasOS PC ;-) #
function permisos_pc() {                                          #
dialog --infobox " Repara los permisos en la version PC para que todo funcione correctamente...\n\nRecuerda tu nombre de usuario tiene que ser masos" 30 55 ; sleep 5
cd
sudo chmod -R +x ~/RetroPie/
sudo chmod -R +x /opt/masos/
sudo chown -R $user:$user ~/MasOS/
# sudo chown -R root:root ~/RetroPie/
sudo chown -R $user:$user /opt/masos/
sudo chown -R $user:$user /etc/emulationstation/themes/
dialog --infobox " Los permisos fueron reparados ..." 30 55 ; sleep 5
# ---------------------------- #
}

#########################################################################
# Raspberry pi instalar idioma español en ES #
function pi_spanish() {                                          #
dialog --infobox " Raspberry pi - instalar idioma español en ES..." 30 55 ; sleep 5
cd
sudo killall emulationstation
sudo cp -R /home/pi/MasOS-Setup/scriptmodules/extras/es_idioma/locale/ /opt/masos/supplementary/emulationstation/
sudo cp -R /home/pi/MasOS-Setup/scriptmodules/extras/es_idioma/resources/ /opt/masos/supplementary/emulationstation/
sudo cp -R /home/pi/MasOS-Setup/scriptmodules/extras/es_idioma/* /opt/masos/supplementary/emulationstation/
dialog --infobox " El idioma se instalo correctamente ,reiniciando el sistema en 5seg ..." 30 55 ; sleep 5
sudo reboot
# ---------------------------- #
}

#########################################################################
# PC instalar idioma español en ES #
function pc_spanish() {                                          #
dialog --infobox " PC Ubuntu 16.04.5 - instalar idioma español en ES..." 30 55 ; sleep 5
cd
sudo killall emulationstation
sudo cp -R ~/MasOS-Setup/scriptmodules/extras/es_idiomaPC/locale/ /opt/masos/supplementary/emulationstation/
sudo cp -R ~/MasOS-Setup/scriptmodules/extras/es_idiomaPC/resources/ /opt/masos/supplementary/emulationstation/
sudo cp ~/MasOS-Setup/scriptmodules/extras/es_idiomaPC/* /opt/masos/supplementary/emulationstation/
dialog --infobox " El idioma se instalo correctamente ,reiniciando el sistema en 5seg ..." 30 55 ; sleep 5
sudo reboot
# ---------------------------- #
}

#########################################################################
# funcion Instalador de MalditaCastilla en MasOS  ;-) #
function inst_malditac() {
rp_module_id="gamemaker"
rp_module_desc="MalditaCastilla Gamemaker game for Raspberry Pi"
rp_module_section="exp"
rp_module_flags="!mali !x86"                                          #
dialog --infobox "...Instalando MalditaCastilla en MasOS..." 30 55 ; sleep 3 
  sudo apt-get install -y libopenal-dev
  sudo mkdir /opt/masos/ports
    sudo mkdir /opt/masos/ports/gamemaker
	sudo chown -R pi:pi /opt/masos/ports/
	wget -O- -q https://www.yoyogames.com/download/pi/castilla | tar -xvz -C /opt/masos/ports/gamemaker/
patchVendorGraphics "/opt/masos/ports/gamemaker/MalditaCastilla/MalditaCastilla"
mkdir /home/pi/MasOS/roms/ports
addPort "/home/pi/MasOS/roms/ports" "MalditaCastilla" "MalditaCastilla" "/opt/masos/ports/gamemaker/MalditaCastilla/MalditaCastilla"
dialog --infobox " MalditaCastilla se instalo correctamente en tu raspberry pi!...\n\nReinicia ES o tu sistema si no lo ves en la seccion PORTS!" 60 75 ; sleep 5
}
main_menu