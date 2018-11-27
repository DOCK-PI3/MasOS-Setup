#!/usr/bin/env bash
rp_module_id="masosbezels"
rp_module_desc="Packs bezel MasOS Team"
rp_module_section=""
BACKTITLE="MasOS Team	Descarga de Bezels"

# Welcome
 dialog --backtitle "MasOS Team" --title "Descarcga packs bezels" \
    --yesno "\nDescarga MasOS Retroarch Bezels menú.\n\nEsta utilidad proporcionará una manera rápida de descargar bezels para los emuladores de Retroarch.\n\nPuedes usar esta utilidad para descargar o borrar bezels de forma rápida y sencilla.\n\nPuede elegir 1080p, 720p u otro. Dependiendo de la resolución de su TV / monitor, puede que tenga que probar un par de ellos para obtener el correcto.\n\nSi encuentras que ninguna de estas opciones funcione correctamente, deberás ir a RetroArch (hotkey + x) para configurarlo manualmente.\n\nSÓLO SE PUEDE TENER UN PACK DE BEZELS ACTIVO.\n\n\nQuieres proceder?" \
    30 80 2>&1 > /dev/tty \
    || exit


function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MAIN MENU " \
            --ok-label OK --cancel-label Atras \
            --menu "SÓLO se puede tener 1 pack a la vez. Qué acción te gustaría realizar?" 25 75 20 \
            1 "Pack bezels 1920x1080" \
			2 "Pack bezels 1280x720" \
			3 "Eliminar bezels de los sistemas" \
			2>&1 > /dev/tty)

        case "$choice" in
            1) full_hd  ;;
            2) solo_hd ;;
			3) delete  ;;
			*)  break ;;
        esac
    done
}

function full_hd() {
	scriptdir="$(dirname "$0")"
	scriptdir="$(cd "$scriptdir" && pwd)"
	sudo $scriptdir/full_hd.sh
}

function solo_hd() {
	scriptdir="$(dirname "$0")"
	scriptdir="$(cd "$scriptdir" && pwd)"
	sudo $scriptdir/solo_hd.sh
}

function delete() {
local choice
	bezel_dir="/opt/masos/configs/all/retroarch"
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " Borrar bezels " \
            --ok-label Sí --cancel-label No \
            --menu "Vas a borrar los bezels..." 25 75 20 \
            1 "Estás seguro que quieres continuar?" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) dialog --infobox "...Borrando..." 3 25 ; sleep 2  
				mv $bezel_dir/config/remaps $bezel_dir
				mv $bezel_dir/remaps $bezel_dir/config/ && chmod 755 $bezel_dir/config/remaps
				rm -R $bezel_dir/config/*
				rm -R $bezel_dir/overlay/* 
				break;;
            *)  break ;;
        esac
    done
}

# Main

main_menu

