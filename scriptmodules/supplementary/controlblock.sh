#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="controlblock"
rp_module_desc="Controlador ControlBlock"
rp_module_section="driver"
rp_module_flags="noinstclean"
rp_module_help="Tenga en cuenta que necesita habilitar o deshabilitar manualmente el Servicio ControlBlock en la seccion Configuracion. IMPORTANTE: si el servicio esta habilitado y la funcion del interruptor de encendido esta habilitada (que es la configuracion predeterminada) en el archivo de configuracion, debe tener un interruptor conectado al ControlBlock."

function depends_controlblock() {
    local depends=(cmake doxygen)
    isPlatform "rpi" && depends+=(libraspberrypi-dev)

    getDepends "${depends[@]}"
}

function sources_controlblock() {
    gitPullOrClone "$md_inst" https://github.com/petrockblog/ControlBlockService2.git
}

function build_controlblock() {
    cd "$md_inst"
    rm -rf "build"
    mkdir build
    cd build
    cmake ..
    make
    md_ret_require="$md_inst/build/controlblock"
}

function install_controlblock() {
    # install from there to system folders
    cd "$md_inst/build"
    make install
}

function gui_controlblock() {
    local cmd=(dialog --backtitle "$__backtitle" --menu "Elija una opcion." 22 86 16)
    local options=(
        1 "Habilitar el controlador ControlBlock"
        2 "Deshabilitar el controlador ControlBlock"

    )
    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    if [[ -n "$choice" ]]; then
        case "$choice" in
            1)
                make -C "$md_inst/build" installservice
                printMsgs "dialog" "Enabled ControlBlock driver."
                ;;
            2)
                make -C "$md_inst/build" uninstallservice
                printMsgs "dialog" "Disabled ControlBlock driver."
                ;;
        esac
    fi
}

function remove_controlblock() {
    make -C "$md_inst/build" uninstallservice
    make -C "$md_inst/build" uninstall
}
