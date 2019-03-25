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
BACKTITLE="MasOS Video Loading Screen Script"

dialog --backtitle "MasOS Video Loading Screen Script" \
--title "MasOS Video Loading Screen Script (by MasOS Team)" \
--msgbox "${infobox}" 35 100



function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MENÚ PRINCIPAL " \
            --ok-label OK --cancel-label Salir \
            --menu "Que accion te gustaria realizar?" 25 75 20 \
            1 "Activar videoloadingscreens" \
            2 "Desactivar videoloadingscreens" \
            3 "Descargar packs videoloadingscreens" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) enable_videoloadingscreens  ;;
            2) disable_videoloadingscreens  ;;
            3) download_video ;;
            *)  break ;;
        esac
    done
}

function disable_videoloadingscreens() {
	dialog --infobox "...Desactivando..." 3 22 ; sleep 2
	user="$(cat /etc/passwd | grep '1000' | cut -d: -f1)"
	disable_dir="/home/$user/MasOS/videoloadingscreens_disable"
	enable_dir="/home/$user/MasOS/videoloadingscreens"

	if [[ -d "$enable_dir" ]]; then
		mv $enable_dir $disable_dir
		mv /opt/masos/configs/all/runcommand-onstart.sh /opt/masos/configs/all/runcommand-onstart.sh.bkp
		mv /opt/masos/configs/all/runcommand-onend.sh /opt/masos/configs/all/runcommand-onend.sh.bkp
	fi

}

function enable_videoloadingscreens() {
	user="$(cat /etc/passwd | grep '1000' | cut -d: -f1)"
	disable_dir="/home/$user/MasOS/videoloadingscreens_disable"
	enable_dir="/home/$user/MasOS/videoloadingscreens"
	fichero="/opt/masos/configs/all/runcommand-onstart.sh.bkp"
	
	while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MENÚ PRINCIPAL " \
            --ok-label OK --cancel-label Salir \
            --menu "Elige plataforma para activar videolaunchingscreens" 25 75 20 \
            1 "Raspberry" \
            2 "Pc" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) dialog --infobox "...Activando..." 3 19 ; sleep 2
				if [[ -d "$disable_dir" ]]; then
					mv $disable_dir $enable_dir
					mv /opt/masos/configs/all/runcommand-onstart.sh.bkp /opt/masos/configs/all/runcommand-onstart.sh
					mv /opt/masos/configs/all/runcommand-onend.sh.bkp /opt/masos/configs/all/runcommand-onend.sh
				else
					mkdir $enable_dir
					chown -R $user:$user $enable_dir
					cp /home/$user/RetroPie/scripts/pi3/runcommand-onstart.sh /opt/masos/configs/all/runcommand-onstart.sh
					cp /home/$user/RetroPie/scripts/pi3/runcommand-onend.sh /opt/masos/configs/all/runcommand-onend.sh
					chown -R $user:$user /opt/masos/configs/all/runcommand-onstart.sh
					chown -R $user:$user /opt/masos/configs/all/runcommand-onend.sh
				fi
			break ;;
			
            2) dialog --infobox "...Activando..." 3 19 ; sleep 2
				if [[ -d "$disable_dir" ]]; then
					mv $disable_dir $enable_dir
					mv /opt/masos/configs/all/runcommand-onstart.sh.bkp /opt/masos/configs/all/runcommand-onstart.sh
					mv /opt/masos/configs/all/runcommand-onend.sh.bkp /opt/masos/configs/all/runcommand-onend.sh
				else
					mkdir $enable_dir
					chown -R $user:$user $enable_dir
					# Creacion de los ficheros necesarios para el funcionamiento de los videos
					sudo cat > /opt/masos/configs/all/runcommand-onstart.sh <<_EOF_
[[ -f /home/$user/MasOS/videoloadingscreens/\$1.mp4 ]] && vlc -f --no-video-title-show --play-and-exit --no-qt-name-in-title --qt-minimal-view --no-qt-bgcone "/home/$user/MasOS/videoloadingscreens/\$1.mp4"
_EOF_
					chown -R $user:$user /opt/masos/configs/all/runcommand-onstart.sh
					sudo cat > /opt/masos/configs/all/runcommand-onend.sh <<_EOF_
[[ -f /home/$user/MasOS/videoloadingscreens/salir.mp4 ]] && vlc -f --no-video-title-show --play-and-exit --no-qt-name-in-title --qt-minimal-view --no-qt-bgcone "/home/$user/MasOS/videoloadingscreens/salir.mp4"
_EOF_
					chown -R $user:$user /opt/masos/configs/all/runcommand-onend.sh
				fi
				break ;;
            *)  break ;;
        esac
    done

}

function download_video() {
	local choice
	user="$(cat /etc/passwd | grep '1000' | cut -d: -f1)"
	enable_dir="/home/$user/MasOS/videoloadingscreens"
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " DESCARGA DE PACKS " \
            --ok-label Descargar --cancel-label Atrás \
            --menu "Que pack te gustaría descargar?" 25 75 20 \
            1 "Pack Moriggy MasOS" \
            2 "Pack Supreme" \
			3 "Pack Mabedeep Dock-pi3" \
			4 "Pack Moriggy Bloques 3D" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) clear
				if [[ -d "$enable_dir" ]]; then
					if [ "$(ls $enable_dir)" ] 
						then 
							echo "Borrando el pack de videos anterior"; sleep 2
							rm -R $enable_dir/*
						else
							echo "No hay videos en $enable_dir"; sleep 2
						fi
					echo "Empezando la descarga del pack de videos elegido"
					echo ""; sleep 2
					cd $enable_dir && wget https://github.com/Moriggy/videoloadingscreens-masos/archive/master.zip && unzip master.zip
					rm $enable_dir/master.zip
					clear
					echo "Moviendo videos a la carpeta de destino, un momento por favor..."; sleep 2
					mv $enable_dir/videoloadingscreens-masos-master/*.mp4 $enable_dir
					rm -R $enable_dir/videoloadingscreens-masos-master/
					chown -R $user:$user $enable_dir
					dialog --infobox "Descarga completada!!" 3 25 ; sleep 3
				else
					dialog --infobox "Debe estar activada la opción de videolaunchingscreens!!" 3 80 ; sleep 5
			fi 
			break ;;
			
            2) clear
				if [[ -d "$enable_dir" ]]; then
					if [ "$(ls $enable_dir)" ] 
						then 
							echo "Borrando el pack de videos anterior"; sleep 2
							rm -R $enable_dir/*
						else
							echo "No hay videos en $enable_dir"; sleep 2
						fi
					echo "Empezando la descarga del pack de videos elegido"
					echo ""; sleep 2
					cd $enable_dir && wget https://github.com/Moriggy/videoloadingscreens-Supreme/archive/master.zip && unzip master.zip
					rm $enable_dir/master.zip
					clear
					echo "Moviendo videos a la carpeta de destino, un momento por favor..."
					mv $enable_dir/videoloadingscreens-Supreme-master/*.mp4 $enable_dir
					rm -R $enable_dir/videoloadingscreens-Supreme-master/
					chown -R $user:$user $enable_dir
					dialog --infobox "Descarga completada!!" 3 25 ; sleep 3
				else
					dialog --infobox "Debe estar activada la opción de videolaunchingscreens!!" 3 80 ; sleep 5
			fi 
			break ;;
			
			3) clear
				if [[ -d "$enable_dir" ]]; then
					if [ "$(ls $enable_dir)" ] 
						then 
							echo "Borrando el pack de videos anterior"; sleep 2
							rm -R $enable_dir/*
						else
							echo "No hay videos en $enable_dir"; sleep 2
						fi
					echo "Empezando la descarga del pack de videos elegido"
					echo ""; sleep 2
					cd $enable_dir && wget https://github.com/DOCK-PI3/sistemas_intros_pack1/archive/master.zip && unzip master.zip
					rm $enable_dir/master.zip
					clear
					echo "Moviendo videos a la carpeta de destino, un momento por favor..."
					mv $enable_dir/sistemas_intros_pack1-master/*.mp4 $enable_dir
					rm -R $enable_dir/sistemas_intros_pack1-master/
					chown -R $user:$user $enable_dir
					dialog --infobox "Descarga completada!!" 3 25 ; sleep 3
				else
					dialog --infobox "Debe estar activada la opción de videolaunchingscreens!!" 3 80 ; sleep 5
			fi 
			break ;;
			
			4) clear
				if [[ -d "$enable_dir" ]]; then
					if [ "$(ls $enable_dir)" ] 
						then 
							echo "Borrando el pack de videos anterior"; sleep 2
							rm -R $enable_dir/*
						else
							echo "No hay videos en $enable_dir"; sleep 2
						fi
					echo "Empezando la descarga del pack de videos elegido"
					echo ""; sleep 2
					cd $enable_dir && wget https://github.com/Moriggy/videoloadingscreens-Bloques-3D/archive/master.zip && unzip master.zip
					rm $enable_dir/master.zip
					clear
					echo "Moviendo videos a la carpeta de destino, un momento por favor..."; sleep 2
					mv $enable_dir/videoloadingscreens-Bloques-3D-master/*.mp4 $enable_dir
					rm -R $enable_dir/videoloadingscreens-Bloques-3D-master/
					chown -R $user:$user $enable_dir
					dialog --infobox "Descarga completada!!" 3 25 ; sleep 3
				else
					dialog --infobox "Debe estar activada la opción de videolaunchingscreens!!" 3 80 ; sleep 5
			fi 
			break ;;
            *)  break ;;
        esac
    done

}

main_menu