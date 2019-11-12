#!/usr/bin/env bash

# This file is part of The MasOS Project
# 
# The MasOS Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
# 
# See the LICENSE.md file at the top-level directory of this distribution and 
# at https://raw.githubusercontent.com/EmulOS/EmulOS-Setup/master/LICENSE.md
#

rp_module_id="gamemaker"
rp_module_desc="MalditaCastilla Gamemaker game - Raspberry Pi"
rp_module_section="exp"
rp_module_flags="!mali !x86"

function depends_gamemaker() {
    getDepends libopenal-dev
}

function install_bin_gamemaker() {
    # Install Maldita Castilla Game
    wget -O- -q https://www.yoyogames.com/download/pi/castilla | tar -xvz -C "$md_inst"

    patchVendorGraphics "$md_inst/MalditaCastilla/MalditaCastilla"
}

function configure_gamemaker() {
    mkRomDir "ports"

    addPort "$md_id" "MalditaCastilla" "MalditaCastilla" "$md_inst/MalditaCastilla/MalditaCastilla"
	# sudo rm -R /opt/masos/ports/gamemaker/TheyNeedToBeFed
	# sudo rm /home/pi/MasOS/roms/ports/TheyNeedToBeFed.sh
	# sudo rm -R /opt/masos/ports/gamemaker/SuperCrateBox
	# sudo rm /home/pi/MasOS/roms/ports/SuperCrateBox.sh
}


