#!/usr/bin/env bash

# This file is part of The MasOS Project fork de retropie
#
# The MasOS Project 2018 es legal, esta contruido bajo raspbian que es de codigo abierto, en este nuevo
# sistema trabajan unos pocos desarroladores independientes de diversas partes del planeta.
#
# MasOS sistema operativo fork de RetroPie ,proyecto iniciado a mediados del año 2018 por MasOS Team ( Noromu ,Manu ,Moriggy & Mabedeep "DOCK-PI3" ) ...
#

scriptdir="$(dirname "$0")"
scriptdir="$(cd "$scriptdir" && pwd)"

"$scriptdir/masos_pkgs.sh" setup gui

