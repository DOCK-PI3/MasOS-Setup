#!/usr/bin/env bash

# This file is part of The MasOS Project
#
# The MasOS Project es legal, esta contruido bajo raspbian que es de codigo abierto, en este nuevo
# sistema trabajan unos pocos desarroladores independientes de diversas partes del planeta.
#
# MasOS El sistema operativo retro en español con emulationstation ,retroarch y varios scripts independientes mas configuraciones y themes nuevos.!
#fork de retropie

__version="4.1.2"

[[ "$__debug" -eq 1 ]] && set -x

# main masos install location
rootdir="/opt/masos"

# if __user is set, try and install for that user, else use SUDO_USER
if [[ -n "$__user" ]]; then
    user="$__user"
    if ! id -u "$__user" &>/dev/null; then
        echo "User $__user not exist"
        exit 1
    fi
else
    user="$SUDO_USER"
    [[ -z "$user" ]] && user="$(id -un)"
fi

home="$(eval echo ~$user)"
datadir="$home/MasOS"
biosdir="$datadir/BIOS"
romdir="$datadir/roms"
emudir="$rootdir/emulators"
configdir="$rootdir/configs"

scriptdir="$(dirname "$0")"
scriptdir="$(cd "$scriptdir" && pwd)"

__logdir="$scriptdir/logs"
__tmpdir="$scriptdir/tmp"
__builddir="$__tmpdir/build"
__swapdir="$__tmpdir"

# check, if sudo is used
if [[ "$(id -u)" -ne 0 ]]; then
    echo "El script debe ejecutarse con sudo. ej: 'sudo $0'"
    exit 1
fi

__backtitle="http://masos.dx.am/ - MasOS-Setup. Directorio de instalacion: $rootdir para el usuario $user"

source "$scriptdir/scriptmodules/system.sh"
source "$scriptdir/scriptmodules/helpers.sh"
source "$scriptdir/scriptmodules/inifuncs.sh"
source "$scriptdir/scriptmodules/packages.sh"
setup_env

rp_registerAllModules

ensureFBMode 320 240

rp_ret=0
if [[ $# -gt 0 ]]; then
    setupDirectories
    rp_callModule "$@"
    rp_ret=$?
else
    rp_printUsageinfo
fi

printMsgs "console" "${__INFMSGS[@]}"
exit $rp_ret
