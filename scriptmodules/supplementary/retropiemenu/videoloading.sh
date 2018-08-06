#!/bin/bash

infobox= ""
infobox="${infobox}_______________________________________________________\n\n"
infobox="${infobox}\n"
infobox="${infobox}MasOS Video Loading Screen Script\n\n"
infobox="${infobox}\n"
infobox="${infobox}Video loading screen ya se ha instalado en esta imagen base.\n"
infobox="${infobox}\n"
infobox="${infobox}Cuando inicias un juego, se reproduce un video como pantalla de carga.\n"
infobox="${infobox}\n"
infobox="${infobox}\n\n"
infobox="${infobox}**Deshabilitar**\ncuando ejecuta la opción de deshabilitar, la carpeta videoloadingscreens se renombra a videoloadingscreens_disable\n"
infobox="${infobox}\n"
infobox="${infobox}**Habilitar**\ncuando ejecuta la opción de habilitar, la carpeta videoloadingscreens_disable se renombra a videoloadingscreens\n"
infobox="${infobox}\n"

dialog --backtitle "MasOS Video Loading Screen Script" \
--title "MasOS Video Loading Screen Script (by Régalad & WDG)" \
--msgbox "${infobox}" 35 110



function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "What action would you like to perform?" 25 75 20 \
            1 "Disable videoloadingscreens" \
            2 "Enable videoloadingscreens" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) disable_videoloadingscreens  ;;
            2) enable_videoloadingscreens  ;;
            *)  break ;;
        esac
    done
}


function disable_videoloadingscreens() {
dialog --infobox "...processing..." 3 20 ; sleep 2
disable_dir="/home/pi/MasOS/videoloadingscreens_disable"
enable_dir="/home/pi/MasOS/videoloadingscreens"

if [[ -d "$enable_dir" ]]; then
 mv /home/pi/MasOS/videoloadingscreens /home/pi/MasOS/videoloadingscreens_disable
fi

}

function enable_videoloadingscreens() {
dialog --infobox "...processing..." 3 20 ; sleep 2
disable_dir="/home/pi/MasOS/videoloadingscreens_disable"
enable_dir="/home/pi/MasOS/videoloadingscreens"

if [[ -d "$disable_dir" ]]; then
 mv /home/pi/MasOS/videoloadingscreens_disable /home/pi/MasOS/videoloadingscreens
fi

}

main_menu

