#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="audiosettings"
rp_module_desc="Configure audio settings"
rp_module_section="config"
rp_module_flags="!x86 !mali"

function depends_audiosettings() {
    if [[ "$md_mode" == "install" ]]; then
        getDepends alsa-utils
    fi
}

function gui_audiosettings() {
    local cmd=(dialog --backtitle "$__backtitle" --menu "Set audio output." 22 86 16)
    local options=(
        1 "Auto"
        2 "Auriculares - 3.5mm jack"
        3 "HDMI"
        4 "Mezclador - ajustar el volumen de salida"
        R "Restablecer a los predeterminados"
    )
    choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    if [[ -n "$choice" ]]; then
        case "$choice" in
            1)
                amixer cset numid=3 0
                alsactl store
                printMsgs "dialog" "Establecer la salida de audio en auto"
                ;;
            2)
                amixer cset numid=3 1
                alsactl store
                printMsgs "dialog" "Establecer la salida de audio en Auriculares / 3.5mm jack"
                ;;
            3)
                amixer cset numid=3 2
                alsactl store
                printMsgs "dialog" "Establecer la salida de audio en HDMI"
                ;;
            4)
                alsamixer >/dev/tty </dev/tty
                alsactl store
                ;;
            R)
                /etc/init.d/alsa-utils reset
                alsactl store
                printMsgs "dialog" "Los ajustes de audio se restablecen a los valores predeterminados"
                ;;
        esac
    fi
}
