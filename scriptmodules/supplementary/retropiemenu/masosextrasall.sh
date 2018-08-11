#!/bin/bash
rp_module_id="masosupdateallsystem"
rp_module_desc="Actualizador para el sistema MasOS"
rp_module_section=""
infobox= ""
infobox="${infobox}_______________________________________________________\n\n"
infobox="${infobox}\n"
infobox="${infobox}\nMasOS Herramientas extras para el menu y actualizador de script base. \n\n"
infobox="${infobox}\n"
infobox="${infobox}\n"
infobox="${infobox}\n"
infobox="${infobox}\n"
infobox="${infobox}Se recomienda su instalacion....\n"
infobox="${infobox}\n"

dialog --backtitle "MasOS Herramientas extras y actualizador de script base" \
--title "MasOS EXTRAS y actualizador de Script (by mabedeep)" \
--msgbox "${infobox}" 35 110



function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "Que accion te gustaria realizar?" 25 75 20 \
            1 "Actualizar MasOS-Setup script" \
			2 "MasOS EXTRAS para el menu de emulationstaion" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) masossetup_update  ;;
			2) masosmenu_extras  ;;
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
		git clone --depth=1 https://github.com/DOCK-PI3/MasOS-Setup.git
	sudo chmod -R +x /home/pi/MasOS-Setup/
dialog --infobox " MasOS-Setup script se actualizo correctamente!...\n\nEn 5seg se reinicia el sistema..espere por favor!" 60 75 ; sleep 5
# sudo shutdown -r now 
}

# function masosystem_upgrade() {                                                                                       
# dialog --infobox "...Despues de actualizar el sistema se reiniciara automaticamente..." 30 75 ; sleep 5                
# #######################################################################################################################
# # Copia de seguridad ficheros de configuracion backup "Importante guardar copia para restaurar despues de actualizar" #
# #######################################################################################################################
# ############################## by mabedeep ############################################################################
# cd
# sudo mkdir /home//home/pi/backup-temp 
# sudo mkdir /home//home/pi/backup-temp/profile
# sudo chown -R /home/pi:/home/pi /home//home/pi/backup-temp/
# # sudo cp -R /opt/masos/configs/all /home//home/pi/backup-temp/all_backup/
# sudo cp -R /home//home/pi/*.* /home//home/pi/backup-temp/profile/
# # funcion para actualizacion del sistema completo MasOS ,tambien se actualiza MasOS-Setup script
	# sudo rm -R MasOS-Setup/
		# git clone --depth=1 https://github.com/DOCK-PI3/MasOS-Setup.git
			# sudo chmod -R +x MasOS-Setup/
			# sudo apt-get update
		# sudo apt-get upgrade -y
	# clear
# # #######################################################################################################################
# # # Restaurando backup con toda la configuracion del usuario despues de actualizar el sistema completo 	              #
# # #######################################################################################################################
# dialog --infobox "Restaurando configuracion de usuario, buscando backup ..." 30 75 ; sleep 3
# sudo cp -R /home//home/pi/backup-temp/all_backup/* /opt/masos/configs/all
# sudo chmod -R +x /opt/masos
# sudo chown -R root:root /opt
# sudo chown -R /home/pi:/home/pi /opt/masos/configs
# # dialog --infobox " La copia de seguridad se restauro correctamente ,reiniciando el sistema en 10s " 30 75 ; sleep 10
# sudo shutdown -r now
# done
# }

#########################################################################
# Funcion EXTRAs Menu ES para MasOS ;-) #
function masosmenu_extras() {                                          #
dialog --infobox " MasOS opciones Extras en rpi para el menu de ES..." 30 55 ; sleep 5
cd
cp /home/pi/MasOS-Setup/scriptmodules/extras/gamelist.xml /opt/masos/configs/all/emulationstation/gamelists/retropie
# sudo rm -R /home//home/pi/MasOS-Setup/scriptmodules/supplementary/retropiemenu/gamelist.xml
sudo cp -R /home/pi/MasOS-Setup/scriptmodules/supplementary/retropiemenu/*.sh /home/pi/RetroPie/retropiemenu
sudo cp -R /home/pi/MasOS-Setup/scriptmodules/supplementary/retropiemenu/icons /home/pi/RetroPie/retropiemenu
sudo cp -R /home/pi/MasOS-Setup/scriptmodules/extras/scripts /home/pi/RetroPie/
cp -R /home/pi/MasOS-Setup/scriptmodules/extras/teamzt /home/pi/MasOS/roms/
# sudo rm -R /home//home/pi/MasOS-Setup/scriptmodules/extras
sudo chmod -R +x /home/pi/RetroPie
sudo chmod -R +x /home/pi/MasOS/roms/teamzt
sudo chmod -R +x /opt/
sudo mkdir /home/pi/MasOS/videoloadingscreens
sudo mkdir /home/pi/MasOS/roms/music
sudo chown -R pi:pi /home/pi/MasOS
dialog --infobox " Las opciones Extras estan instaladas,reiniciando el sistema en 5seg ..." 30 55 ; sleep 5
# reboot
# sudo chown -R /home/pi:/home/pi /opt/masos/configs
# ---------------- FIN DEL CODIGO ------------ #
}
main_menu