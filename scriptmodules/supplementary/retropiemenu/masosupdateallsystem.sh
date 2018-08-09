#!/bin/
rp_module_id="masosupdateallsystem"
rp_module_desc="Actualizador para el sistema MasOS"
rp_module_section=""
infobox= ""
infobox="${infobox}_______________________________________________________\n\n"
infobox="${infobox}\n"
infobox="${infobox}MasOS Script para actualizar todos los paquetes del sistema incluido el MasOS-Setup script. \n\n"
infobox="${infobox}\n"
infobox="${infobox}Puede actualizar solo el MasOS-Setup script por separado o en conjunto con el sistema.\n"
infobox="${infobox}\n"

dialog --backtitle "MasOS Script actualizador del sistema" \
--title "MasOS Script actualizador del sistema (by mabedeep)" \
--msgbox "${infobox}" 35 110



function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "Que accion te gustaria realizar?" 25 75 20 \
            1 "Actualizar MasOS-Setup script" \
            2 "Actualizar sistema MasOS completo" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) masossetup_update  ;;
            2) masosystem_upgrade  ;;
            *)  break ;;
        esac
    done
}
#########################################################################
# funcion actualizacion para MasOS Setup script y sistema completo  ;-) #
function masossetup_update() {                                          #
dialog --infobox " Actualizando script MasOS-Setup..." 3 20 ; sleep 2
cd 
	sudo rm -R MasOS-Setup/
		git clone --depth=1 https://github.com/DOCK-PI3/MasOS-Setup.git
	sudo chmod -R +x MasOS-Setup/
dialog --infobox " MasOS-Setup script se actualizo correctamente!..." 3 20 ; sleep 3
clear
}

function masosystem_upgrade() {                                                                                       
dialog --infobox "...Despues de actualizar el sistema se reiniciara automaticamente..." 3 20 ; sleep 5                
#######################################################################################################################
# Copia de seguridad ficheros de configuracion backup "Importante guardar copia para restaurar despues de actualizar" #
#######################################################################################################################
############################## by mabedeep ############################################################################
sudo mkdir /home/$user/backup-temp /home/$user/backup-temp/all_backup
sudo chown -R $user:$user /home/$user/backup-temp
sudo cp -R /opt/masos/configs/all/* /home/$user/backup-temp/all_backup
cd # funcion para actualizacion del sistema completo MasOS ,tambien se actualiza MasOS-Setup script- ;-)
	sudo rm -R MasOS-Setup/
		git clone --depth=1 https://github.com/DOCK-PI3/MasOS-Setup.git
			sudo chmod -R +x MasOS-Setup/
			sudo apt-get update
		sudo apt-get upgrade -y
	clear
#######################################################################################################################
# Restaurando backup con toda la configuracion del usuario despues de actualizar el sistema completo 	              #
#######################################################################################################################
dialog --infobox "Restaurando configuracion de usuario, buscando backup ..." 3 20 ; sleep 3
sudo cp -R /home/$user/backup-temp/all_backup/* /opt/masos/configs/all
sudo chmod -R +x /opt/masos
sudo chown -R root:root /opt
sudo chown -R $user:$user /opt/masos/configs
dialog --infobox " La copia de seguridad se restauro correctamente ,reiniciando el sistema en 10s " 3 20 ; sleep 10
sudo shutdown -r now
}

main_menu