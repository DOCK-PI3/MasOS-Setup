#!/bin/bash

# Este fichero es parte del Proyecto MasOS
#
# The MasOS Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/DOCK-PI3/MasOS-Setup/master/LICENSE.md
#

rp_module_id="Masos Team"
rp_module_desc="Personalizar el sistema MasOS"
rp_module_section=""
infobox="${infobox}___________________________________________________\n\n"
infobox="${infobox}\nHerramienta para personalizar MasOS\n"
infobox="${infobox}\nMasOS Team no se hace responsable de un mal uso de estos scripts\n\n"
infobox="${infobox}\n"

dialog --backtitle "http://web.masos.ga		MasOS Team" \
--title "Personalizacion de MasOS (by Moriggy)" \
--msgbox "${infobox}" 15 55

function main_menu() {

	local choice
    while true; do
        choice=$(dialog --backtitle "MasOS Team		Personalización de MasOS (script hecho por Moriggy)" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "Que acción te gustaría personalizar?" 25 75 20 \
			1 "Instalar Bezels" \
			2 "Vídeos de Carga de Roms" \
			3 "Overclock (SÓLO) Raspberry pi" \
			4 "Arranque silencioso" \
			2>&1 > /dev/tty)

        case "$choice" in
			1) bezels  ;;
			2) launching_videos  ;;
			3) overclock  ;;
			4) silencio  ;;
			*)  break ;;
        esac
    done
}

# Funcion para instalar bezels	#

function bezels() {

	sudo ~/RetroPie/scripts/MainBezels.sh
	
}

# Funcion para videos de carga	#

function launching_videos() {

	sudo ~/RetroPie/scripts/videoloading.sh
	
}

# Funcion para overclock	#

function overclock() {

	sudo ~/RetroPie/scripts/overclock.sh
	
}

# Funcion para arranque silencioso	#

function silencio() {

	sudo ~/RetroPie/scripts/sym.sh
	
}

main_menu