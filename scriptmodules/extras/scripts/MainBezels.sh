#!/usr/bin/env bash

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
infobox="${infobox}\nHerramienta para descargar bezels\n"
infobox="${infobox}\n-The Project Bezels\n-Retroarch Bezels\n-Pack MasOS Team Bezels\n"
infobox="${infobox}\n"
BACKTITLE="Menu de opciones de Bezels (by Moriggy)"

dialog --backtitle "http://web.masos.ga		MasOS Team" \
--title "Menu de opciones de Bezels (by Moriggy)" \
--msgbox "${infobox}" 15 55

function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MENU BEZELS " \
            --ok-label OK --cancel-label Atras \
            --menu "Elige una opcion (arriba/abajo) y pulsa A para aceptar:" 25 75 20 \
			1 "The Project Bezels" \
			2 "Herramienta Retroarch Bezels" \
			3 "Packs bezels MasOS Team" \
			2>&1 > /dev/tty)

        case "$choice" in
			1) tpb  ;;
			2) retroarch ;;
			3) packs ;;
			*) break ;;
        esac
    done
}

# The Project Bezels #

function tpb() {

	scriptdir="$(dirname "$0")"
	sudo $scriptdir/bezelproject.sh
	
}

# Retroarch bezels	#

function retroarch() {

	scriptdir="$(dirname "$0")"
	sudo $scriptdir/bezels.sh
	
}

# Retroarch bezels	#

function packs() {

	scriptdir="$(dirname "$0")"
	sudo $scriptdir/masosbezels.sh
	
}

main_menu