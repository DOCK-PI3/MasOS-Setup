#!/usr/bin/env bash
# This file is part of The MasOS Project
# Creado por DOCK-PI3 para MasOS
#
# Copy your music MP3 files (either to the SD card or USB memory stick)
# Point fruitbox to your MP3 files (edit skins/WallJuke/fruitbox.cfg (or any other skin you fancy) and change the MusicPath parameter)
# Run fruitbox ( ./fruitbox --cfg skins/WallJuke/fruitbox.cfg)
#
# This file is part of The RetroArena (TheRA)
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/Retro-Arena/RetroArena-Setup/master/LICENSE.md
#
rp_module_id="fruitbox"
rp_module_desc="Fruitbox - A customizable MP3 Retro Jukebox. Read the Package Help for more information."
rp_module_help="Copy your .mp3 files to '$romdir/jukebox' then launch Fruitbox from EmulationStation.\n\nTo configure a gamepad, launch 'Jukebox Config' in Settings, then 'Enable Gamepad Configuration'."
rp_module_section="opt"

function depends_fruitbox() {
    getDepends libsm-dev libxcursor-dev libxi-dev libxinerama-dev libxrandr-dev libxpm-dev libvorbis-dev libtheora-dev
}

function sources_fruitbox() {
    # gitPullOrClone "$md_build/allegro5" "https://github.com/dos1/allegro5.git"
    gitPullOrClone "$md_build/fruitbox" "https://github.com/DOCK-PI3/rpi-fruitbox.git"
    # downloadAndExtract "https://ftp.osuosl.org/pub/blfs/conglomeration/mpg123/mpg123-1.24.0.tar.bz2" "$md_build"
}

function build_fruitbox() {
    # Build mpg123
    # cd "$md_build/mpg123-1.24.0"
    # chmod +x configure
    # ./configure --with-cpu=arm_fpu --disable-shared
    # make -j4 && make install
    # cd ..
    
    # Overwrite build files.
    # cp -vf "$md_data/CMakeLists.txt" "$md_build/allegro5/"
    
    # Build Allegro5
    # cd "$md_build/allegro5"
    # mkdir build && cd build
    # cmake .. -DSHARED=off
    # make -j4 && make install
    # export PKG_CONFIG_PATH=/opt/masos/emulators/fruitbox/build/allegro5/build/lib/pkgconfig
    # ldconfig
    # cd ../..

    # Build fruitbox
    # cd "$md_build/fruitbox/build"
    # make -j4
    # md_ret_require="$md_build/fruitbox/build/fruitbox"
	cd && wget https://github.com/DOCK-PI3/rpi-fruitbox/raw/master/install.sh
	chmod +x ./install.sh && source ./install.sh
	# sudo chown -R pi:pi /opt/masos/
	# cd && cp -R rpi-fruitbox-master/* /opt/masos/emulators/fruitbox
	# sudo rm -R rpi-fruitbox-master/
}

function install_fruitbox() {
	# cd && wget https://github.com/DOCK-PI3/rpi-fruitbox/raw/master/install.sh
	# chmod +x ./install.sh && source ./install.sh
	sudo chown -R pi:pi /opt/masos/
	cd && cp -R rpi-fruitbox-master/* /opt/masos/emulators/fruitbox
	sudo rm -R rpi-fruitbox-master/
    # cp "$md_build/fruitbox/build/fruitbox" "$md_inst/"
    # cp "$md_build/fruitbox/skins.txt" "$md_inst/"
    # cp -R "$md_build/fruitbox/skins" "$md_inst/"
    mkRomDir "jukebox"
    cat > "$romdir/jukebox/+Start Fruitbox.sh" << _EOF_
#!/bin/bash
skin=WallJuke
# if [[ -e "$home/.config/fruitbox" ]]; then
# rm -rf "$home/.config/fruitbox"
sudo /opt/masos/emulators/fruitbox/fruitbox --config-buttons
#else
sudo /opt/masos/emulators/fruitbox/fruitbox --cfg /opt/masos/emulators/fruitbox/skins/\$skin/fruitbox.cfg
fi
_EOF_
    cat > "$romdir/jukebox/+Start Fruitbox_solo_teclado.sh" << _EOF_
#!/bin/bash
skin=WallJuke
sudo /opt/masos/emulators/fruitbox/fruitbox --cfg /opt/masos/emulators/fruitbox/skins/\$skin/fruitbox.cfg
_EOF_
    chmod a+x "$romdir/jukebox/+Start Fruitbox.sh"
    chown $user:$user "$romdir/jukebox/+Start Fruitbox.sh"
	chmod a+x "$romdir/jukebox/+Start Fruitbox_solo_teclado.sh"
    chown $user:$user "$romdir/jukebox/+Start Fruitbox_solo_teclado.sh"
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
    # cp "$md_build/fruitbox/build/fruitbox" "$md_inst/"
    # cp "$md_build/fruitbox/skins.txt" "$md_inst/"
    # cp -R "$md_build/fruitbox/skins" "$md_inst/"
    mkRomDir "jukebox"
    cat > "$romdir/jukebox/+Start Fruitbox.sh" << _EOF_
#!/bin/bash
skin=WallJuke
# if [[ -e "$home/.config/fruitbox" ]]; then
# rm -rf "$home/.config/fruitbox"
sudo /opt/masos/emulators/fruitbox/fruitbox --config-buttons
#else
sudo /opt/masos/emulators/fruitbox/fruitbox --cfg /opt/masos/emulators/fruitbox/skins/\$skin/fruitbox.cfg
fi
_EOF_
    cat > "$romdir/jukebox/+Start Fruitbox_solo_teclado.sh" << _EOF_
#!/bin/bash
skin=WallJuke
sudo /opt/masos/emulators/fruitbox/fruitbox --cfg /opt/masos/emulators/fruitbox/skins/\$skin/fruitbox.cfg
_EOF_
    chmod a+x "$romdir/jukebox/+Start Fruitbox.sh"
    chown $user:$user "$romdir/jukebox/+Start Fruitbox.sh"
	chmod a+x "$romdir/jukebox/+Start Fruitbox_solo_teclado.sh"
    chown $user:$user "$romdir/jukebox/+Start Fruitbox_solo_teclado.sh"
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
}
# duplicar comandos sed para +Start Fruitbox_solo_teclado.sh
function skin_fruitbox() {
    while true; do
        local cmd=(dialog --backtitle "$__backtitle" --menu "Choose a Fruitbox skin" 22 76 16)
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
                printMsgs "dialog" "Enabled Modern skin"
                ;;
            2) 
                sed -i "/skin=/d" "$romdir/jukebox/+Start Fruitbox.sh"
                sed -i "2i skin=NumberOne" "$romdir/jukebox/+Start Fruitbox.sh"
                printMsgs "dialog" "Enabled NumberOne skin"
                ;;
            3) 
                sed -i "/skin=/d" "$romdir/jukebox/+Start Fruitbox.sh"
                sed -i "2i skin=WallJuke" "$romdir/jukebox/+Start Fruitbox.sh"
                printMsgs "dialog" "Enabled WallJuke skin"
                ;;
            4) 
                sed -i "/skin=/d" "$romdir/jukebox/+Start Fruitbox.sh"
                sed -i "2i skin=WallSmall" "$romdir/jukebox/+Start Fruitbox.sh"
                printMsgs "dialog" "Enabled WallSmall skin"
                ;;
            5) 
                sed -i "/skin=/d" "$romdir/jukebox/+Start Fruitbox.sh"
                sed -i "2i skin=Wurly" "$romdir/jukebox/+Start Fruitbox.sh"
                printMsgs "dialog" "Enabled Wurly skin"
                ;;
        esac
    done
}

function gamepad_fruitbox() {
    touch "$home/.config/fruitbox"
    printMsgs "dialog" "Enabled Gamepad Configuration\n\nLaunch Fruitbox from EmulationStation to configure your gamepad.\n\nPress OK to Exit."
    exit 0
}

function dbscan_fruitbox() {
    if [[ -e "$home/MasOS/roms/jukebox/fruitbox.db" ]]; then
        rm -rf "$home/MasOS/roms/jukebox/fruitbox.db"
    fi
    printMsgs "dialog" "Enabled Database Scan\n\nCopy your .mp3 files to '$romdir/jukebox' then launch Fruitbox from EmulationStation.\n\nPress OK to Exit."
    exit 0
}

function gui_fruitbox() {  
    while true; do
        local options=(
            1 "Select Fruitbox Skin"
            2 "Enable Gamepad Configuration"
            3 "Enable Database Scan"
        )
        local cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option" 22 76 16)
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
