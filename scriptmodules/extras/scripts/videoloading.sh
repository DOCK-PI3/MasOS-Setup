#!/bin/bash
rp_module_id="bashvideoloading"
rp_module_desc="Video mientras carga la rom en MasOS"
rp_module_section=""
infobox= ""
infobox="${infobox}_______________________________________________________\n\n"
infobox="${infobox}\n"
infobox="${infobox}MasOS Video Loading Screen Script\n\n"
infobox="${infobox}\n"
infobox="${infobox}Video loading screen se va a activar en MasOS.\n"
infobox="${infobox}\n"
infobox="${infobox}Cuando inicias un juego, se reproduce un video como pantalla de carga.\n"
infobox="${infobox}\n"
infobox="${infobox}\n\n"
infobox="${infobox}**Deshabilitar**\ncuando ejecuta la opción de deshabilitar, la carpeta videoloadingscreens se renombra a videoloadingscreens_disable\n"
infobox="${infobox}\n"
infobox="${infobox}**Habilitar**\ncuando ejecuta la opción de habilitar, la carpeta videoloadingscreens_disable se renombra a videoloadingscreens\n"
infobox="${infobox}\n"

dialog --backtitle "MasOS Video Loading Screen Script" \
--title "MasOS Video Loading Screen Script (by MasOS Team)" \
--msgbox "${infobox}" 35 110



function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MAIN MENU " \
            --ok-label OK --cancel-label Atras \
            --menu "Que accion te gustaria realizar?" 25 75 20 \
            1 "Activar videoloadingscreens" \
            2 "Desactivar videoloadingscreens" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) enable_videoloadingscreens  ;;
            2) disable_videoloadingscreens  ;;
            *)  break ;;
        esac
    done
}


function disable_videoloadingscreens() {
	dialog --infobox "...Desactivando..." 3 20 ; sleep 2
	disable_dir="/home/pi/MasOS/videoloadingscreens_disable"
	enable_dir="/home/pi/MasOS/videoloadingscreens"

	if [[ -d "$enable_dir" ]]; then
	 mv /home/pi/MasOS/videoloadingscreens /home/pi/MasOS/videoloadingscreens_disable
	 mv /opt/masos/configs/all/runcommand-onstart.sh /opt/masos/configs/all/runcommand-onstart.sh.bkp
	 mv /opt/masos/configs/all/runcommand-onend.sh /opt/masos/configs/all/runcommand-onend.sh.bkp
	fi

}

function enable_videoloadingscreens() {
	dialog --infobox "...Activando..." 3 20 ; sleep 2
	disable_dir="/home/pi/MasOS/videoloadingscreens_disable"
	enable_dir="/home/pi/MasOS/videoloadingscreens"

	if [[ -d "$disable_dir" ]]; then
	 mv /home/pi/MasOS/videoloadingscreens_disable /home/pi/MasOS/videoloadingscreens
	
		if [[ ! "$fichero" ]]; then
			mv /opt/masos/configs/all/runcommand-onstart.sh.bkp /opt/masos/configs/all/runcommand-onstart.sh
			mv /opt/masos/configs/all/runcommand-onend.sh.bkp /opt/masos/configs/all/runcommand-onsend.sh
		else
			cp /home/pi/RetroPie/scripts/pi3/runcommand-onstart.sh /opt/masos/configs/all/runcommand-onstart.sh
			cp /home/pi/RetroPie/scripts/pi3/runcommand-onend.sh /opt/masos/configs/all/runcommand-onend.sh
		fi
	fi

}

main_menu
