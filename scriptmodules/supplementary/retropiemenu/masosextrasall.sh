#!/bin/bash
rp_module_id="masosupdateallsystem"
rp_module_desc="Actualizador para el sistema MasOS"
rp_module_section=""
infobox= ""
infobox="${infobox}_______________________________________________________\n\n"
infobox="${infobox}\n"
infobox="${infobox}MasOS Script para actualizar todos los paquetes del sistema incluido el MasOS-Setup script. \n\n"
infobox="${infobox}\n"
infobox="${infobox}\n"
infobox="${infobox}\n"
infobox="${infobox}\n"
infobox="${infobox}Herramienta para reparar iconos en emulationstation del menu y nombres de la lista.\n"
infobox="${infobox}\n"

dialog --backtitle "MasOS Herramienta, mas actualizador del setup" \
--title "MasOS actualizador de Script (by mabedeep)" \
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
	sudo rm -R MasOS-Setup/
		git clone --depth=1 https://github.com/DOCK-PI3/MasOS-Setup.git
	sudo chmod -R +x MasOS-Setup/
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
# sudo mkdir /home/$user/backup-temp 
# sudo mkdir /home/$user/backup-temp/profile
# sudo chown -R $user:$user /home/$user/backup-temp/
# # sudo cp -R /opt/masos/configs/all /home/$user/backup-temp/all_backup/
# sudo cp -R /home/$user/*.* /home/$user/backup-temp/profile/
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
# sudo cp -R /home/$user/backup-temp/all_backup/* /opt/masos/configs/all
# sudo chmod -R +x /opt/masos
# sudo chown -R root:root /opt
# sudo chown -R $user:$user /opt/masos/configs
# # dialog --infobox " La copia de seguridad se restauro correctamente ,reiniciando el sistema en 10s " 30 75 ; sleep 10
# sudo shutdown -r now
# done
# }

#########################################################################
# Funcion EXTRAs Menu ES para MasOS ;-) #
function masosmenu_extras() {                                          #
dialog --infobox " MasOS opciones Extras para el menu de ES..." 30 55 ; sleep 5
cd
sudo cp $user/MasOS-Setup/scriptmodules/extras/gamelist.xml /opt/masos/configs/all/emulationstation/gamelists/retropie
# sudo rm -R /home/$user/MasOS-Setup/scriptmodules/supplementary/retropiemenu/gamelist.xml
sudo cp -R $user/MasOS-Setup/scriptmodules/supplementary/retropiemenu/*.sh $user/RetroPie/retropiemenu
sudo cp -R $user/MasOS-Setup/scriptmodules/supplementary/retropiemenu/icons $user/RetroPie/retropiemenu
sudo cp -R $user/MasOS-Setup/scriptmodules/extras/scripts $user/RetroPie/
sudo cp -R $user/MasOS-Setup/scriptmodules/extras/teamzt $user/MasOS/roms/
# sudo rm -R /home/$user/MasOS-Setup/scriptmodules/extras
sudo chmod -R +x $user/RetroPie
sudo chmod -R +x $user/MasOS/roms/teamzt
sudo chmod -R +x /opt/
sudo mkdir $user/MasOS/videoloadingscreens
sudo mkdir $user/MasOS/roms/music
sudo chown -R $user:$user /home/$user/MasOS
dialog --infobox " Las opciones Extras estan instaladas,reiniciando el sistema en 5seg ..." 30 55 ; sleep 5
# reboot
# sudo chown -R $user:$user /opt/masos/configs
# ---------------- FIN DEL CODIGO ------------ #
}
main_menu