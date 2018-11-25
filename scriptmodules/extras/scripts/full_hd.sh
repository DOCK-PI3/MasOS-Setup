#!/usr/bin/env bash
rp_module_id="masosbezels"
rp_module_desc="Packs bezel MasOS Team"
rp_module_section=""
BACKTITLE="MasOS Team	Descarga de Bezels FULL HD (1920x1080)"

# Welcome
 dialog --backtitle "MasOS Team" --title "Descarcga packs bezels" \
    --yesno "\nDescarga Bezels de consolas para tu MasOS.\n\nEsta utilidad proporciona un pack de bezels para los emuladores de Retroarch.\n\nPuedes usar esta utilidad para descargar bezels de forma rápida y sencilla.\n\nTodos los packs son de 1080p (1920x1080).\n\nSi encuentras que ninguna de estas opciones funcione correctamente, por favor notificalo a MasOS Team.\n\nSÓLO SE PUEDE TENER UN PACK DE BEZELS ACTIVO.\n\n\nQuieres continuar?" \
    30 80 2>&1 > /dev/tty \
    || exit


function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MAIN MENU " \
            --ok-label Descargar --cancel-label Atras \
            --menu "Al terminar la descarga, este menú se cerrará. Qué pack te gustaría descargar?" 25 75 20 \
            1 "Pack Batocera (con scanlines)" \
			2 "Pack Moriggy (con scanlines)" \
			3 "Pack Batocera (sin scanlines)" \
            4 "Pack Moriggy (sin scanlines)" \
			2>&1 > /dev/tty)

        case "$choice" in
            1) batocera_scanlines  ;;
            2) moriggy_retro ;;
			3) batocera ;;
			4) moriggy  ;;
			*)  break ;;
        esac
    done
}

function batocera_scanlines() {
	bezel_dir="/opt/masos/configs/all/retroarch"
	mkdir $bezel_dir/tmp
	dir="$bezel_dir/tmp"
	dialog --infobox "...Comenzando la descarga..." 3 35 ; sleep 1
	cd $dir && wget "https://github.com/Moriggy/bezels-Moriggy/archive/master.zip" && unzip $dir/master.zip
	rm $dir/master.zip
	mv $bezel_dir/config/remaps $bezel_dir
	rm -R $bezel_dir/config/*
	rm -R $bezel_dir/overlay/*
	mv $bezel_dir/remaps $bezel_dir/config/ && chmod 755 $bezel_dir/config/remaps
	destinationpath_dir="/opt/masos/configs/all/retroarch"
	cp -R $dir/bezels-Moriggy-master/retroarch/* $destinationpath_dir
	# Cogemos el nombre de usuario para modificar los permisos de las carpetas
	user="$(cat /etc/passwd | grep '1000' | cut -d: -f1)"
	chown -R $user:$user $bezel_dir/config/*
	chown -R $user:$user $bezel_dir/overlay/*
	rm -R $dir
	dialog --infobox "...Descarga completada..." 3 35 ; sleep 2
	exit;
}

function moriggy_retro() {
	bezel_dir="/opt/masos/configs/all/retroarch"
	mkdir $bezel_dir/tmp
	dir="$bezel_dir/tmp"
	dialog --infobox "...Comenzando la descarga..." 3 35 ; sleep 1
	cd $dir && wget "https://github.com/Moriggy/bezels-retro/archive/master.zip" && unzip $dir/master.zip
	rm $dir/master.zip
	mv $bezel_dir/config/remaps $bezel_dir
	rm -R $bezel_dir/config/*
	rm -R $bezel_dir/overlay/*
	mv $bezel_dir/remaps $bezel_dir/config/ && chmod 755 $bezel_dir/config/remaps
	destinationpath_dir="/opt/masos/configs/all/retroarch"
	cp -R $dir/bezels-retro-master/retroarch/* $destinationpath_dir
	# Cogemos el nombre de usuario para modificar los permisos de las carpetas
	user="$(cat /etc/passwd | grep '1000' | cut -d: -f1)"
	chown -R $user:$user $bezel_dir/config/*
	chown -R $user:$user $bezel_dir/overlay/*
	rm -R $dir
	dialog --infobox "...Descarga completada..." 3 35 ; sleep 2
	exit;
}

function batocera() {
	bezel_dir="/opt/masos/configs/all/retroarch"
	mkdir $bezel_dir/tmp
	dir="$bezel_dir/tmp"
	dialog --infobox "...Comenzando la descarga..." 3 35 ; sleep 1
	cd $dir && wget "https://github.com/Moriggy/bezels-batocera/archive/master.zip" && unzip $dir/master.zip
	rm $dir/master.zip
	mv $bezel_dir/config/remaps $bezel_dir
	rm -R $bezel_dir/config/*
	rm -R $bezel_dir/overlay/*
	mv $bezel_dir/remaps $bezel_dir/config/ && chmod 755 $bezel_dir/config/remaps
	destinationpath_dir="/opt/masos/configs/all/retroarch"
	cp -R $dir/bezels-batocera-master/retroarch/* $destinationpath_dir
	# Cogemos el nombre de usuario para modificar los permisos de las carpetas
	user="$(cat /etc/passwd | grep '1000' | cut -d: -f1)"
	chown -R $user:$user $bezel_dir/config/*
	chown -R $user:$user $bezel_dir/overlay/*
	rm -R $dir
	dialog --infobox "...Descarga completada..." 3 35 ; sleep 2
	exit;
}

function moriggy() {
	bezel_dir="/opt/masos/configs/all/retroarch"
	mkdir $bezel_dir/tmp
	dir="$bezel_dir/tmp"
	dialog --infobox "...Comenzando la descarga..." 3 35 ; sleep 1
	cd $dir && wget "https://github.com/Moriggy/bezels-rmaximus/archive/master.zip" && unzip $dir/master.zip
	rm $dir/master.zip
	mv $bezel_dir/config/remaps $bezel_dir
	rm -R $bezel_dir/config/*
	rm -R $bezel_dir/overlay/*
	mv $bezel_dir/remaps $bezel_dir/config/ && chmod 755 $bezel_dir/config/remaps
	destinationpath_dir="/opt/masos/configs/all/retroarch"
	cp -R $dir/bezels-rmaximus-master/retroarch/* $destinationpath_dir
	# Cogemos el nombre de usuario para modificar los permisos de las carpetas
	user="$(cat /etc/passwd | grep '1000' | cut -d: -f1)"
	chown -R $user:$user $bezel_dir/config/*
	chown -R $user:$user $bezel_dir/overlay/*
	rm -R $dir
	dialog --infobox "...Descarga completada..." 3 35 ; sleep 2
	exit;
}

# Main

main_menu

