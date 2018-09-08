#!/bin/bash
rp_module_id="masosupdateallsystem"
rp_module_desc="Actualizador para el sistema MasOS"
rp_module_section=""
infobox= ""
infobox="${infobox}_______________________________________________________\n\n"
infobox="${infobox}\n"
infobox="${infobox}\nMasOS Herramientas extras para el menu ,actualizador de script base \n\n"
infobox="${infobox}\ny reparador de permisos para la version PC"
infobox="${infobox}\n"
infobox="${infobox}\n"
infobox="${infobox}\n"
infobox="${infobox}Se recomienda instalacion de EXTRAS para el menu solo en raspberry pi....\n"
infobox="${infobox}\n"

dialog --backtitle "MasOS extras y actualizador de script base" \
--title "MasOS EXTRAS ,actualizador de Script y raparador de permisos en PC(by mabedeep)" \
--msgbox "${infobox}" 35 110



function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "Que accion te gustaria realizar?" 25 75 20 \
            1 "Actualizar MasOS-Setup script" \
			2 "MasOS EXTRAS para el menu de emulationstaion" \
            3 "Reparar permisos en MasOS PC" \
			2>&1 > /dev/tty)

        case "$choice" in
            1) masossetup_update  ;;
			2) masosmenu_extras  ;;
            3) permisos_pc  ;;
			*)  break ;;
        esac
    done
}
#########################################################################
# funcion actualizacion para MasOS Setup script  ;-) #
function masossetup_update() {                                          #
dialog --infobox "...Actualizando script MasOS-Setup..." 30 55 ; sleep 3
cd 
	sudo rm -R /home/pi/MasOS-Setup/
		sudo git clone --depth=1 https://github.com/DOCK-PI3/MasOS-Setup.git
	sudo chmod -R +x /home/pi/MasOS-Setup/
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
sudo chmod -R +x /opt
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
sudo chmod -R +x /home/masos/RetroPie/
sudo chmod -R +x /opt/masos/
sudo chown -R masos:masos /home/masos/MasOS/
sudo chown -R root:root /home/masos/RetroPie/
sudo chown -R root:root /opt/masos/supplementary/
sudo chown -R masos:masos /opt/masos/supplementary/retropie-manager/
dialog --infobox " Los permisos fueron reparados ..." 30 55 ; sleep 5
# ---------------------------- #
}
main_menu