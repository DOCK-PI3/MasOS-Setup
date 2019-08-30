#!/usr/bin/env bash
# This file is part of The MasOS Project
# Creado por DOCK-PI3 para MasOS
#
# Copy your music MP3 files (either to the SD card or USB memory stick)
# Point fruitbox to your MP3 files (edit skins/WallJuke/fruitbox.cfg (or any other skin you fancy) and change the MusicPath parameter)
# Run fruitbox ( ./fruitbox --cfg skins/WallJuke/fruitbox.cfg)
#
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/DOCK-PI3/MasOS-Setup/master/LICENSE.md
rp_module_id="fruitbox"
rp_module_desc="Fruitbox - Un jukebox MP3 rétro personnalisable. Lea la Ayuda del paquete para más información."
rp_module_help="Solo funciona con el linux Kernel: 4.14.98-v7 o inferior.\n\nCopiar sus ficheros .mp3 en '$romdir/jukebox' a continuación, inicie Fruitbox desde EmulationStation.\n\nPara configurar un gamepad, inicie 'Configuración de Jukebox' en Configuración, luego 'Habilitar configuración de gamepad'.\n\nPara recibir ayuda de MasOS Team busque en youtube o telegran..salu2"
rp_module_section="opt"

function depends_fruitbox() {
    getDepends libsm-dev libxcursor-dev libxi-dev libxinerama-dev libxrandr-dev libxpm-dev libvorbis-dev libtheora-dev
}

function sources_fruitbox() {
    # gitPullOrClone "$md_build/allegro5" "https://github.com/dos1/allegro5.git"
    # gitPullOrClone "$md_build/fruitbox" "https://github.com/DOCK-PI3/rpi-fruitbox.git"
	# git clone --depth=1 https://github.com/DOCK-PI3/rpi-fruitbox.git
    # downloadAndExtract "https://ftp.osuosl.org/pub/blfs/conglomeration/mpg123/mpg123-1.24.0.tar.bz2" "$md_build"
	cd && wget https://github.com/DOCK-PI3/rpi-fruitbox/raw/master/install.sh
}

function build_fruitbox() {
	cd && chmod +x ./install.sh && source ./install.sh
}

function install_fruitbox() {
md_id="/opt/masos/emulators/fruitbox"
	sudo chown -R pi:pi /opt/masos/
	cd && cp -R rpi-fruitbox-master/* /opt/masos/emulators/fruitbox
	sudo rm -R rpi-fruitbox-master/
    mkRomDir "jukebox"
    cat > "$romdir/jukebox/+Start Fruitbox.sh" << _EOF_
#!/bin/bash
skin=WallJuke
# if [[ -f /home/pi/fruitbox.btn ]]; then
sudo /opt/masos/emulators/fruitbox/fruitbox --cfg /opt/masos/emulators/fruitbox/skins/\$skin/fruitbox.cfg --button-map /home/pi/fruitbox.btn
# else
# sudo /opt/masos/emulators/fruitbox/fruitbox --config-buttons
#fi
_EOF_
    cat > "$romdir/jukebox/+Start Fruitbox_mapear_gamepad.sh" << _EOF_
#!/bin/bash
skin=WallJuke
sudo /opt/masos/emulators/fruitbox/fruitbox --config-buttons
_EOF_
    cat > "$romdir/jukebox/+Start Fruitbox_solo_teclado.sh" << _EOF_
#!/bin/bash
skin=WallJuke
sudo /opt/masos/emulators/fruitbox/fruitbox --cfg /opt/masos/emulators/fruitbox/skins/\$skin/fruitbox.cfg
_EOF_
    chmod a+x "$romdir/jukebox/+Start Fruitbox.sh"
    chown pi:pi "$romdir/jukebox/+Start Fruitbox.sh"
    chmod a+x "$romdir/jukebox/+Start Fruitbox_mapear_gamepad.sh"
    chown pi:pi "$romdir/jukebox/+Start Fruitbox_mapear_gamepad.sh"
	chmod a+x "$romdir/jukebox/+Start Fruitbox_solo_teclado.sh"
    chown pi:pi "$romdir/jukebox/+Start Fruitbox_solo_teclado.sh"
    addEmulator 1 "$md_id" "jukebox" "fruitbox %ROM%"
    addSystem "jukebox"
    touch "$home/.config/fruitbox"
}

function install_bin_fruitbox() {
md_id="/opt/masos/emulators/fruitbox"
	cd && wget https://github.com/DOCK-PI3/rpi-fruitbox/raw/master/install.sh
	chmod +x ./install.sh && source ./install.sh
	sudo chown -R pi:pi /opt/masos/
	cd && cp -R rpi-fruitbox-master/* /opt/masos/emulators/fruitbox
	sudo rm -R rpi-fruitbox-master/
    mkRomDir "jukebox"
    cat > "$romdir/jukebox/+Start Fruitbox.sh" << _EOF_
#!/bin/bash
skin=WallJuke
# if [[ -f /home/pi/fruitbox.btn ]]; then
sudo /opt/masos/emulators/fruitbox/fruitbox --cfg /opt/masos/emulators/fruitbox/skins/\$skin/fruitbox.cfg --button-map /home/pi/fruitbox.btn
# else
# fi
_EOF_
    cat > "$romdir/jukebox/+Start Fruitbox_mapear_gamepad.sh" << _EOF_
#!/bin/bash
skin=WallJuke
sudo /opt/masos/emulators/fruitbox/fruitbox --config-buttons
_EOF_
    cat > "$romdir/jukebox/+Start Fruitbox_solo_teclado.sh" << _EOF_
#!/bin/bash
skin=WallJuke
sudo /opt/masos/emulators/fruitbox/fruitbox --cfg /opt/masos/emulators/fruitbox/skins/\$skin/fruitbox.cfg
_EOF_
    chmod a+x "$romdir/jukebox/+Start Fruitbox.sh"
    chown pi:pi "$romdir/jukebox/+Start Fruitbox.sh"
    chmod a+x "$romdir/jukebox/+Start Fruitbox_mapear_gamepad.sh"
    chown pi:pi "$romdir/jukebox/+Start Fruitbox_mapear_gamepad.sh"
	chmod a+x "$romdir/jukebox/+Start Fruitbox_solo_teclado.sh"
    chown pi:pi "$romdir/jukebox/+Start Fruitbox_solo_teclado.sh"
    addEmulator 1 "$md_id" "jukebox" "fruitbox %ROM%"
    addSystem "jukebox"
    touch "$home/.config/fruitbox"
	sudo chown -R pi:pi /opt/masos/emulators/fruitbox
}

function remove_fruitbox() {
    delSystem jukebox
    rm -rf "$home/.config/fruitbox"
    rm -rf "$romdir/jukebox"
	sudo rm -rf "/opt/masos/emulators/fruitbox"
	sudo rm -rf "$home/fruitbox.btn"
}
# duplicar comandos sed para +Start Fruitbox_solo_teclado.sh
function skin_fruitbox() {
    while true; do
        local cmd=(dialog --backtitle "$__backtitle" --menu "Fruitbox seleccion de skin" 22 76 16)
        local options=(
            1 "Modern"
            2 "NumberOne"
            3 "WallJuke (default)"
            4 "WallSmall"
            5 "Wurly"
        )
        local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        [[ -z "$choice" ]] && break
        case "$choice" in
            1) 
                sed -i "/skin=/d" "$romdir/jukebox/+Start Fruitbox.sh"
                sed -i "2i skin=Modern" "$romdir/jukebox/+Start Fruitbox.sh"
                sed -i "/skin=/d" "$romdir/jukebox/+Start Fruitbox_solo_teclado.sh"
                sed -i "2i skin=Modern" "$romdir/jukebox/+Start Fruitbox_solo_teclado.sh"
                printMsgs "dialog" "Modern skin Habilitado"
                ;;
            2) 
                sed -i "/skin=/d" "$romdir/jukebox/+Start Fruitbox.sh"
                sed -i "2i skin=NumberOne" "$romdir/jukebox/+Start Fruitbox.sh"
                sed -i "/skin=/d" "$romdir/jukebox/+Start Fruitbox_solo_teclado.sh"
                sed -i "2i skin=NumberOne" "$romdir/jukebox/+Start Fruitbox_solo_teclado.sh"
                printMsgs "dialog" "NumberOne skin Habilitado"
                ;;
            3) 
                sed -i "/skin=/d" "$romdir/jukebox/+Start Fruitbox.sh"
                sed -i "2i skin=WallJuke" "$romdir/jukebox/+Start Fruitbox.sh"
                sed -i "/skin=/d" "$romdir/jukebox/+Start Fruitbox_solo_teclado.sh"
                sed -i "2i skin=WallJuke" "$romdir/jukebox/+Start Fruitbox_solo_teclado.sh"
                printMsgs "dialog" "WallJuke skin Habilitado"
                ;;
            4) 
                sed -i "/skin=/d" "$romdir/jukebox/+Start Fruitbox.sh"
                sed -i "2i skin=WallSmall" "$romdir/jukebox/+Start Fruitbox.sh"
                sed -i "/skin=/d" "$romdir/jukebox/+Start Fruitbox_solo_teclado.sh"
                sed -i "2i skin=WallSmall" "$romdir/jukebox/+Start Fruitbox_solo_teclado.sh"
                printMsgs "dialog" "WallSmall skin Habilitado"
                ;;
            5) 
                sed -i "/skin=/d" "$romdir/jukebox/+Start Fruitbox.sh"
                sed -i "2i skin=Wurly" "$romdir/jukebox/+Start Fruitbox.sh"
                sed -i "/skin=/d" "$romdir/jukebox/+Start Fruitbox_solo_teclado.sh"
                sed -i "2i skin=Wurly" "$romdir/jukebox/+Start Fruitbox_solo_teclado.sh"
                printMsgs "dialog" "Wurly skin Habilitado"
                ;;
        esac
    done
}

function gamepad_fruitbox() {
    touch "$home/.config/fruitbox"
    printMsgs "dialog" "Gamepad Configuración Habilitada\n\nInicia Fruitbox desde EmulationStation +Start Fruitbox_mapear_gamepad para configurar tu gamepad.\n\nLuego puedes iniciar desde +Start Fruitbox para usar tu gamepad configurado\n\nPresione OK para Salir."
    exit 0
}

function dbscan_fruitbox() {
    if [[ -e "$home/MasOS/roms/jukebox/fruitbox.db" ]]; then
        rm -rf "$home/MasOS/roms/jukebox/fruitbox.db"
    fi
    printMsgs "dialog" "Exploración de base de datos habilitada\n\nCopia tus ficheros .mp3 a '$romdir/jukebox' a continuación, inicie Fruitbox desde EmulationStation.\n\nPresione OK para Salir."
    exit 0
}

function gui_fruitbox() {  
    while true; do
        local options=(
            1 "Seleccione Skin para Fruitbox"
            2 "Habilitar configuración del gamepad"
            3 "Habilitar exploración de la base de datos"
        )
        local cmd=(dialog --backtitle "$__backtitle" --menu "Elija una opción" 22 76 16)
        local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        [[ -z "$choice" ]] && break
        case "$choice" in
            1)
                skin_fruitbox
                ;;
            2)
                gamepad_fruitbox
                ;;
            3)
                dbscan_fruitbox
                ;;
        esac
    done
}
