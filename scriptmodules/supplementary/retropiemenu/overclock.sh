#!/bin/bash
# This script change CPU and GPU settings

infobox=""
infobox="${infobox}______________________________________________________________________________________\n\n"
infobox="${infobox}\n"
infobox="${infobox}Overclock RPI 3/3B+ on/off\n\n"
infobox="${infobox}\n"
infobox="${infobox}Warning this script will change the CPU and GPU settings. Used at your own risk.\n"
infobox="${infobox}\n"
infobox="${infobox}You must have heatsinks or fan or your RPI before running this script.\n"
infobox="${infobox}\n"
infobox="${infobox}Your system will reboot after running this script.\n"
infobox="${infobox}\n\n"
infobox="${infobox}**Enable RPI3**\n"
infobox="${infobox}Overclock 1300 RPI3\n"
infobox="${infobox}Overclock 1350 RPI3\n"
infobox="${infobox}Overclock 1400 RPI3\n"
infobox="${infobox}\n"
infobox="${infobox}**Enable RPI3B+**\n"
infobox="${infobox}Overclock 1475 RPI3B+\n"
infobox="${infobox}Overclock 1500 RPI3B+\n"
infobox="${infobox}Overclock 1550 RPI3B+\n"
infobox="${infobox}Overclock 1575 RPI3B+\n"
infobox="${infobox}\n"
infobox="${infobox}\n\n"
infobox="${infobox}**Disable**\nNo overclock, all overclock settings are removed"
infobox="${infobox}\n"
infobox="${infobox}\n"
infobox="${infobox}Warning !!! 1550 and 1575 overclock not work on all pi3b+.\n"
infobox="${infobox}Sometimes this hight settings need 2 or 3 boot to work.\n"
infobox="${infobox}"

dialog --backtitle "RetroPie Overclock RPI 3/3b+ on/off" \
--title "RetroPie Overclock By WDG & REGALAD" \
--msgbox "${infobox}" 35 110

function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "What action would you like to perform?" 25 75 20 \
            1 "Overclock 1300 rpi3" \
            2 "Overclock 1350 rpi3" \
			3 "Overclock 1400 rpi3" \
			4 "Overclock 1475 rpi3B+" \
			5 "Overclock 1500 rpi3B+" \
			6 "Overclock 1550 rpi3B+" \
			7 "Overclock 1575 rpi3B+" \
			8 "No overclock" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) overclock1300  ;;
            2) overclock1350  ;;
            3) overclock1400  ;;
            4) overclock1475  ;;
            5) overclock1500  ;;
			6) overclock1550  ;;
			7) overclock1575  ;;
            8) nooverclock  ;;
            *)  break ;;
        esac
    done
}


function overclock1300() {
	dialog --infobox "...Applying..." 3 20 ; sleep 2
	sudo /home/pi/RetroPie/scripts/overclock1300rpi3.sh
}

function overclock1350() {
	dialog --infobox "...Applying..." 3 20 ; sleep 2
	sudo /home/pi/RetroPie/scripts/overclock1350rpi3.sh
}

function overclock1400() {
	dialog --infobox "...Applying..." 3 20 ; sleep 2
	sudo /home/pi/RetroPie/scripts/overclock1400rpi3.sh
}

function overclock1475() {
	dialog --infobox "...Applying..." 3 20 ; sleep 2
	sudo /home/pi/RetroPie/scripts/overclock1475rpi3plus.sh
}

function overclock1500() {
	dialog --infobox "...Applying..." 3 20 ; sleep 2
	sudo /home/pi/RetroPie/scripts/overclock1500rpi3plus.sh
}

function overclock1550() {
	dialog --infobox "...Applying..." 3 20 ; sleep 2
	sudo /home/pi/RetroPie/scripts/overclock1550rpi3plus.sh
}

function overclock1575() {
	dialog --infobox "...Applying..." 3 20 ; sleep 2
	sudo /home/pi/RetroPie/scripts/overclock1575rpi3plus.sh
}

function nooverclock() {
	dialog --infobox "...Applying..." 3 20 ; sleep 2
	sudo /home/pi/RetroPie/scripts/nooverclock.sh
}

main_menu
