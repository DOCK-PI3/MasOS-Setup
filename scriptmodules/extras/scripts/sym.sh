#!/usr/bin/env bash

rp_module_id="arranquesilencioso"
rp_module_desc="Arranque silencioso y Música de fondo"
rp_module_section=""
infobox="${infobox}_______________________________________________________\n\n"
infobox="${infobox}\n"
infobox="${infobox}Script para arranque silencioso y música de fondo compatible\n\n"
infobox="${infobox}\n"
infobox="${infobox}Este script oculta las líneas de carga en cada inicio de la Raspberry e instala, si quieres, un reproductor de música compatible con esta opción de arranque\n\n"
infobox="${infobox}Ambas opciones VIENEN DESACTIVADAS POR DEFECTO.\n\n"
infobox="${infobox}Cuando arranca el sistema, tan sólo verás la pantalla del arcoiris y el cursor parpadeando.\n\n"
infobox="${infobox}Al arrancar EmulationStation, comienza la música, en el caso de que hayas instalado la opción.\n"
infobox="${infobox}\n\n"
infobox="${infobox}ESTA OPCIÓN DE MÚSICA ES INCOMPATIBLE CON LA QUE ENCONTRARÁS EN MASOS UTILIDADES.\n\n"

BACKTITLE="MasOS Silence's Script"

dialog --backtitle "$BACKTITLE" \
--title "MasOS Silence's Script (by Moriggy)" \
--msgbox "${infobox}" 35 100



function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MENÚ PRINCIPAL " \
            --ok-label OK --cancel-label Salir \
            --menu "Que accion te gustaria realizar?" 25 75 20 \
            1 "Activar Arranque Silencioso" \
            2 "Desactivar Arranque Silencioso" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) silencio  ;;
            2) no_silencio  ;;
            *)  break ;;
        esac
    done
}

function silencio() {
	fichero="/boot/cmdline.txt"
	clear
	cp $fichero $fichero.bkp
	dato="$(cat /boot/cmdline.txt | grep 'PARTUUID' | cut -d  " "  -f4)"
	
	if [[ -f "$fichero" ]]; then
		echo "Activando arranque silencioso."
		echo "Espera un momento..." ; sleep 3
		
		sudo cat > $fichero <<_EOF_
dwc_otg.lpm_enable=0 console=serial0,115200 console=tty3 loglevel=3 $dato rootfstype=ext4 elevator=deadline fsck.repair=yes rootwait plymouth.enable=0 logo.nologo
_EOF_
		sudo chmod -R +x $fichero
		sudo chown -R root:root $fichero
		dialog --infobox "El arranque silencioso se ha activado.\nEl sistema se reiniciará en 5 seg para hacer efectivo el cambio." 5 75 ; sleep 5
		sudo reboot
	else
		dialog --infobox "El fichero ya existe, no se ha podido activar el arranque silencioso." 3 75 ; sleep 5
	fi

}

function no_silencio() {
	fichero="/boot/cmdline.txt.bkp"
	clear
	
	if [[ -f "$fichero" ]]; then
		echo "Desactivando arranque silencioso."
		echo "Espera un momento..." ; sleep 3
		mv $fichero /boot/cmdline.txt
		sudo chmod -R +x /boot/cmdline.txt
		sudo chown -R root:root /boot/cmdline.txt
		dialog --infobox "El arranque silencioso se ha desactivado.\nEl sistema se reiniciará en 5 seg para hacer efectivo el cambio." 5 80 ; sleep 5
		sudo reboot
	else
		dialog --infobox "El fichero necesario no existe, no tienes activo el arranque silencioso." 3 85 ; sleep 5
	fi
	
}


main_menu