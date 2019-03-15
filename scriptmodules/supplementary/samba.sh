#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="samba"
rp_module_desc="Configura Samba ROM Shares"
rp_module_section="config"

function depends_samba() {
    getDepends samba
}

function remove_share_samba() {
    local name="$1"
    [[ -z "$name" || ! -f /etc/samba/smb.conf ]] && return
    sed -i "/^\[$name\]/,/^force user/d" /etc/samba/smb.conf
}

function add_share_samba() {
    local name="$1"
    local path="$2"
    [[ -z "name" || -z "$path" ]] && return
    remove_share_samba "$name"
    cat >>/etc/samba/smb.conf <<_EOF_
[$1]
comment = $name
path = "$path"
writeable = yes
guest ok = yes
create mask = 0644
directory mask = 0755
force user = $user
_EOF_
}

function restart_samba() {
    service samba restart
}

# new samba shares by mabedeep: agregando rutas directas de ES y ovelays
masosemulationstation="/etc/emulationstation"
retroarch="/opt/masos/configs/all/retroarch"
#fin -----------------------------------------------------------

function install_shares_samba() {
    cp /etc/samba/smb.conf /etc/samba/smb.conf.bak
    add_share_samba "roms" "$romdir"
    add_share_samba "bios" "$home/MasOS/BIOS"
    add_share_samba "configs" "$configdir"
    add_share_samba "splashscreens" "$datadir/splashscreens"
	add_share_samba "emulationstation" "$masosemulationstation"
	add_share_samba "retroarch" "$retroarch" 
# Agregar permisos para usuario pi en directorios nuevos
	sudo chown -R $user:$user /etc/emulationstation
	sudo chown -R $user:$user /opt/masos/configs/all/retroarch
    restart_samba
}


function remove_shares_samba() {
    local name
    for name in roms bios configs splashscreens emulationstation retroarch; do
        remove_share_samba "$name"
    done
}

function gui_samba() {
    while true; do
        local cmd=(dialog --backtitle "$__backtitle" --menu "Elija una opcion" 22 76 16)
        local options=(
            1 "Instalar MasOS Samba shares"
            2 "Eliminar MasOS Samba shares"
            3 "Edicion manual /etc/samba/smb.conf"
            4 "Reiniciar Samba service"
            5 "Eliminar Samba + configuration"
        )
        local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        if [[ -n "$choice" ]]; then
            case "$choice" in
                1)
                    rp_callModule "$md_id" depends
                    rp_callModule "$md_id" install_shares
                    printMsgs "dialog" "Instala y activa samba shares"
                    ;;
                2)
                    rp_callModule "$md_id" remove_shares
                    printMsgs "dialog" "Eliminar samba shares"
                    ;;
                3)
                    editFile /etc/samba/smb.conf
                    ;;
                4)
                    rp_callModule "$md_id" restart
                    ;;
                5)
                    rp_callModule "$md_id" depends remove
                    printMsgs "dialog" "Eliminar Samba service"
                    ;;
            esac
        else
            break
        fi
    done
}
