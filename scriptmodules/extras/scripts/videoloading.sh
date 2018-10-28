#!/usr/bin/env bash
rp_module_id="bashvideoloading"
rp_module_desc="Video mientras carga la rom en MasOS"
rp_module_section=""
infobox="${infobox}_______________________________________________________\n\n"
infobox="${infobox}\n"
infobox="${infobox}MasOS Video Loading Screen Script\n\n"
infobox="${infobox}\n"
infobox="${infobox}Video loading screen se puede activar en MasOS.\n\n"
infobox="${infobox}Esta opción VIENE DESACTIVADA POR DEFECTO.\n\n"
infobox="${infobox}Cuando inicias un juego, se reproduce un video como pantalla de carga del sistema elegido.\n\n"
infobox="${infobox}Al salir del juego, se reproducirá otro video\n"
infobox="${infobox}\n\n"
infobox="${infobox}**Activar**\nCuando ejecuta la opción de activar, se crea la carpeta o la carpeta videoloadingscreens_disable se renombra a videoloadingscreens y se copian los archivos necesarios para que se reproduzcan los videos.\n"
infobox="${infobox}\n"
infobox="${infobox}**Desactivar**\nCuando ejecuta la opción de deshabilitar, la carpeta videoloadingscreens se renombra a videoloadingscreens_disable y renombran a .bkp los archivos de configuración que hacen que se reproduzcan los videos. \n"
infobox="${infobox}\n"

dialog --backtitle "MasOS Video Loading Screen Script" \
--title "MasOS Video Loading Screen Script (by MasOS Team)" \
--msgbox "${infobox}" 35 100



function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "MasOS Video Loading Screen Script" --title " MENÚ PRINCIPAL " \
            --ok-label OK --cancel-label Salir \
            --menu "Que accion te gustaria realizar?" 25 75 20 \
            1 "PI3 Activar videoloadingscreens" \
            2 "PI3 Desactivar videoloadingscreens" \
            3 "PC Activar videoloadingscreens" \
            4 "PC Desactivar videoloadingscreens" \
			5 "PI3 Descargar packs videoloadingscreens" \
			6 "PC Descargar packs videoloadingscreens" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) enable_videoloadingscreens  ;;
            2) disable_videoloadingscreens  ;;
            3) enable_videoloadingscreensPC  ;;
            4) disable_videoloadingscreensPC  ;;
			5) download_video ;;
			6) download_video_pc ;;
            *)  break ;;
        esac
    done
}


function disable_videoloadingscreens() {
	dialog --infobox "...Desactivando..." 3 22 ; sleep 2
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
	fichero="/opt/masos/configs/all/runcommand-onstart.sh.bkp"

	if [[ -d "$disable_dir" ]]; then
		mv /home/pi/MasOS/videoloadingscreens_disable /home/pi/MasOS/videoloadingscreens
	
		if [[ -f "$fichero" ]]; then
			mv /opt/masos/configs/all/runcommand-onstart.sh.bkp /opt/masos/configs/all/runcommand-onstart.sh
			mv /opt/masos/configs/all/runcommand-onend.sh.bkp /opt/masos/configs/all/runcommand-onend.sh
		else
			cp /home/pi/RetroPie/scripts/pi3/runcommand-onstart.sh /opt/masos/configs/all/runcommand-onstart.sh
			cp /home/pi/RetroPie/scripts/pi3/runcommand-onend.sh /opt/masos/configs/all/runcommand-onend.sh
		fi
	else
		mkdir /home/pi/MasOS/videoloadingscreens
		sudo chown -R pi:pi $enable_dir
		cp /home/pi/RetroPie/scripts/pi3/runcommand-onstart.sh /opt/masos/configs/all/runcommand-onstart.sh
		cp /home/pi/RetroPie/scripts/pi3/runcommand-onend.sh /opt/masos/configs/all/runcommand-onend.sh
	fi

}

################################################ Principio del codigo para pc ######################
function disable_videoloadingscreensPC() {
	dialog --infobox "...Desactivando..." 3 22 ; sleep 2
	disable_dir="~/MasOS/videoloadingscreens_disable"
	enable_dir="~/MasOS/videoloadingscreens"
	if [[ -d "$enable_dir" ]]; then
		mv ~/MasOS/videoloadingscreens ~/MasOS/videoloadingscreens_disable
		sudo mv /opt/masos/configs/all/runcommand-onstart.sh /opt/masos/configs/all/runcommand-onstart.sh.bkp
		sudo mv /opt/masos/configs/all/runcommand-onend.sh /opt/masos/configs/all/runcommand-onend.sh.bkp
	fi

}

function enable_videoloadingscreensPC() {
	dialog --infobox "...Activando..." 3 20 ; sleep 2
	disable_dir="~/MasOS/videoloadingscreens_disable"
	enable_dir="~/MasOS/videoloadingscreens"
	fichero="/opt/masos/configs/all/runcommand-onstart.sh.bkp"
	if [[ -d "$disable_dir" ]]; then
		mv ~/MasOS/videoloadingscreens_disable ~/MasOS/videoloadingscreens
		if [[ -f "$fichero" ]]; then
			sudo mv /opt/masos/configs/all/runcommand-onstart.sh.bkp /opt/masos/configs/all/runcommand-onstart.sh
			sudo mv /opt/masos/configs/all/runcommand-onend.sh.bkp /opt/masos/configs/all/runcommand-onend.sh
		else
			sudo cp ~/RetroPie/scripts/pc/runcommand-onstart.sh /opt/masos/configs/all/runcommand-onstart.sh
			sudo cp ~/RetroPie/scripts/pc/runcommand-onend.sh /opt/masos/configs/all/runcommand-onend.sh
		fi
	else
		sudo mkdir ~/MasOS/videoloadingscreens
		sudo chown -R $user:$user $enable_dir
		sudo cp ~/RetroPie/scripts/pc/runcommand-onstart.sh /opt/masos/configs/all/runcommand-onstart.sh
		sudo cp ~/RetroPie/scripts/pc/runcommand-onend.sh /opt/masos/configs/all/runcommand-onend.sh
	fi

}

function download_video_pc() {
	local choice
	enable_dir="~/MasOS/videoloadingscreens"
    while true; do
        choice=$(dialog --backtitle "MasOS Video Loading Screen Script" --title " DESCARGA DE PACKS " \
            --ok-label OK --cancel-label Atrás \
            --menu "Que pack te gustaría descargar?" 25 75 20 \
            1 "Pack Moriggy MasOS" \
            2 "Pack Supreme" \
			3 "Pack Dock-pi3" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) clear
				if [[ -d "$enable_dir" ]]; then
					sudo rm -R $enable_dir/*
					echo "Empezando la descarga del pack de videos elegido"; sleep 2
					cd $enable_dir && wget https://github.com/Moriggy/videoloadingscreens-masos/archive/master.zip && unzip master.zip
					sudo rm $enable_dir/master.zip
					clear
					echo "Moviendo videos a la carpeta de destino, un momento por favor..."
					sudo mv $enable_dir/videoloadingscreens-masos-master/*.mp4 $enable_dir
					sudo rm -R $enable_dir/videoloadingscreens-masos-master/
					sudo chown -R $user:$user $enable_dir
					dialog --infobox "Descarga completada!!" 3 25 ; sleep 3
				else
					dialog --infobox "Debe estar activada la opción de videolaunchingscreens!!" 3 80 ; sleep 5
			fi ;;
			
            2) clear
				if [[ -d "$enable_dir" ]]; then
					sudo rm -R $enable_dir/*
					echo "Empezando la descarga del pack de videos elegido"; sleep 2
					cd $enable_dir && wget https://github.com/Moriggy/videoloadingscreens-Supreme/archive/master.zip && unzip master.zip
					sudo rm $enable_dir/master.zip
					clear
					echo "Moviendo videos a la carpeta de destino, un momento por favor..."
					sudo mv $enable_dir/videoloadingscreens-Supreme-master/*.mp4 $enable_dir
					sudo rm -R $enable_dir/videoloadingscreens-Supreme-master/
					sudo chown -R $user:$user $enable_dir
					dialog --infobox "Descarga completada!!" 3 25 ; sleep 3
				else
					dialog --infobox "Debe estar activada la opción de videolaunchingscreens!!" 3 80 ; sleep 5
			fi ;;
			
			3) clear
				if [[ -d "$enable_dir" ]]; then
					sudo rm -R $enable_dir/*
					echo "Empezando la descarga del pack de videos elegido"; sleep 2
					cd $enable_dir && wget https://github.com/DOCK-PI3/sistemas_intros_pack1/archive/master.zip && unzip master.zip
					sudo rm $enable_dir/master.zip
					clear
					echo "Moviendo videos a la carpeta de destino, un momento por favor..."
					sudo mv $enable_dir/sistemas_intros_pack1-master/*.mp4 $enable_dir
					sudo rm -R $enable_dir/sistemas_intros_pack1-master/
					sudo chown -R $user:$user $enable_dir
					dialog --infobox "Descarga completada!!" 3 25 ; sleep 3
				else
					dialog --infobox "Debe estar activada la opción de videolaunchingscreens!!" 3 80 ; sleep 5
			fi ;;
			
            *)  break ;;
        esac
    done

}

################################################ fin del codigo para pc ######################

function download_video() {
	local choice
	enable_dir="/home/pi/MasOS/videoloadingscreens"
    while true; do
        choice=$(dialog --backtitle "MasOS Video Loading Screen Script" --title " DESCARGA DE PACKS " \
            --ok-label OK --cancel-label Atrás \
            --menu "Que pack te gustaría descargar?" 25 75 20 \
            1 "Pack Moriggy MasOS" \
            2 "Pack Supreme" \
			3 "Pack Dock-pi3" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) clear
				if [[ -d "$enable_dir" ]]; then
					sudo rm -R $enable_dir/*
					echo "Empezando la descarga del pack de videos elegido"; sleep 2
					cd $enable_dir && wget https://github.com/Moriggy/videoloadingscreens-masos/archive/master.zip && unzip master.zip
					sudo rm $enable_dir/master.zip
					clear
					echo "Moviendo videos a la carpeta de destino, un momento por favor..."
					sudo mv $enable_dir/videoloadingscreens-masos-master/*.mp4 $enable_dir
					sudo rm -R $enable_dir/videoloadingscreens-masos-master/
					# sudo chown -R pi:pi $enable_dir
					dialog --infobox "Descarga completada!!" 3 25 ; sleep 3
				else
					dialog --infobox "Debe estar activada la opción de videolaunchingscreens!!" 3 80 ; sleep 5
			fi ;;
			
            2) clear
				if [[ -d "$enable_dir" ]]; then
					sudo rm -R $enable_dir/*
					echo "Empezando la descarga del pack de videos elegido"; sleep 2
					cd $enable_dir && wget https://github.com/Moriggy/videoloadingscreens-Supreme/archive/master.zip && unzip master.zip
					sudo rm $enable_dir/master.zip
					clear
					echo "Moviendo videos a la carpeta de destino, un momento por favor..."
					sudo mv $enable_dir/videoloadingscreens-Supreme-master/*.mp4 $enable_dir
					sudo rm -R $enable_dir/videoloadingscreens-Supreme-master/
					sudo chown -R pi:pi $enable_dir
					dialog --infobox "Descarga completada!!" 3 25 ; sleep 3
				else
					dialog --infobox "Debe estar activada la opción de videolaunchingscreens!!" 3 80 ; sleep 5
			fi ;;
			
			3) clear
				if [[ -d "$enable_dir" ]]; then
					sudo rm -R $enable_dir/*
					echo "Empezando la descarga del pack de videos elegido"; sleep 2
					cd $enable_dir && wget https://github.com/DOCK-PI3/sistemas_intros_pack1/archive/master.zip && unzip master.zip
					sudo rm $enable_dir/master.zip
					clear
					echo "Moviendo videos a la carpeta de destino, un momento por favor..."
					sudo mv $enable_dir/sistemas_intros_pack1-master/*.mp4 $enable_dir
					sudo rm -R $enable_dir/sistemas_intros_pack1-master/
					sudo chown -R pi:pi $enable_dir
					dialog --infobox "Descarga completada!!" 3 25 ; sleep 3
				else
					dialog --infobox "Debe estar activada la opción de videolaunchingscreens!!" 3 80 ; sleep 5
			fi ;;
			
            *)  break ;;
        esac
    done

}

main_menu
