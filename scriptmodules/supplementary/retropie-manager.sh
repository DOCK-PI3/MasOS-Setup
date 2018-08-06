#!/usr/bin/env bash

# This file is part of The MasOS Project
#
# The MasOS Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://github.com/DOCK-PI3/MasOS-Setup/blob/master/LICENSE.md
# https://github.com/DOCK-PI3/MasOS-Setup/blob/master/COPYRIGHT.md

rp_module_id="retropie-manager"
rp_module_desc="Web Based Manager for MasOS files configs based on the Retropie/Recalbox Manager"
rp_module_help="Open your browser and go to http://your_masos_ip:8000/"
rp_module_licence="MIT https://raw.githubusercontent.com/botolo78/RetroPie-Manager/retropie/ORIGINAL%20LICENCE.txt"
rp_module_section="exp"
rp_module_flags="noinstclean"

function depends_retropie-manager() {
    local depends=(python-dev virtualenv)
    getDepends "${depends[@]}"
}

function sources_retropie-manager() {
    gitPullOrClone "$md_inst" "https://github.com/DOCK-PI3/MasOS-Manager.git"
}

function install_retropie-manager() {
    cd "$md_inst"
    chown -R $user:$user "$md_inst"
    sudo -u $user make install
	sudo chmod -R +x /opt/masos/supplementary/retropie-manager
}

function _is_enabled_retropie-manager() {
    grep -q 'rpmanager\.sh.*--start' /etc/rc.local
    return $?
}

function enable_retropie-manager() {
    local config="\"$md_inst/rpmanager.sh\" --start --user $user 2>\&1 > /dev/shm/rpmanager.log \&"

    if _is_enabled_retropie-manager; then
        dialog \
          --yesno "MasOS-Manager ya está habilitado para MasOS en /etc/rc.local con la siguiente configuración. \n\n $ (grep "rpmanager \ .sh" /etc/rc.local)\n\n¿Deseas actualizarlo?" \
          22 76 2>&1 >/dev/tty || return
    fi

    sed -i "/rpmanager\.sh.*--start/d" /etc/rc.local
    sed -i "s|^exit 0$|${config}\\nexit 0|" /etc/rc.local
    printMsgs "dialog" "MasOS-Manager habilitado en /etc/rc.local\n\nSe iniciará en el próximo inicio."
}

function disable_retropie-manager() {
    if _is_enabled_retropie-manager; then
        dialog \
          --yesno "¿Estás seguro de que deseas inhabilitar MasOS-Manager en el arranque?" \
          22 76 2>&1 >/dev/tty || return

        sed -i "/rpmanager\.sh.*--start/d" /etc/rc.local
        printMsgs "dialog" "La configuración de MasOS-Manager en /etc/rc.local ha sido eliminada."
    else
        printMsgs "dialog" "MasOS-Manager ya estaba desactivado en /etc/rc.local."
    fi
}

function remove_retropie-manager() {
    sed -i "/rpmanager\.sh.*--start/d" /etc/rc.local
}

function gui_retropie-manager() {
    local cmd=()
    local options=(
        1 "Iniciar MasOS-Manager ahora"
        2 "Detener MasOS-Manager ahora"
        3 "Habilitar MasOS-Manager en el arranque"
        4 "Deshabilitar MasOS-Manager en el arranque"
    )
    local choice
    local rpmanager_status
    local error_msg

    while true; do
        if [[ -f "$md_inst/rpmanager.sh" ]]; then
            rpmanager_status="$($md_inst/rpmanager.sh --isrunning)\n\n"
        fi
        if _is_enabled_retropie-manager; then
            rpmanager_status+="MasOS-Manager is currently enabled on boot"
        else
            rpmanager_status+="MasOS-Manager is currently disabled on boot"
        fi
        cmd=(dialog --backtitle "$__backtitle" --menu "$rpmanager_status\n\nChoose an option." 22 86 16)
        choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        if [[ -n "$choice" ]]; then
            case "$choice" in
                1)
                    dialog --infobox "Starting MasOS-Manager" 4 30 2>&1 >/dev/tty
                    error_msg="$("$md_inst/rpmanager.sh" --start 2>&1 >/dev/null)" \
                    || printMsgs "dialog" "$error_msg"
                    ;;

                2)
                    dialog --infobox "Stopping MasOS-Manager" 4 30 2>&1 >/dev/tty
                    error_msg="$("$md_inst/rpmanager.sh" --stop 2>&1 >/dev/null)" \
                    || printMsgs "dialog" "$error_msg"
                    ;;

                3)  enable_retropie-manager
                    ;;

                4)  disable_retropie-manager
                    ;;
            esac
        else
            break
        fi
    done
}
