#!/usr/bin/env bash

# This file is part of The MasOS Project
#
# The MasOS Project 2018 es legal, esta contruido bajo raspbian que es de codigo abierto, en este nuevo
# sistema trabajan unos pocos desarroladores independientes de diversas partes del planeta.
#
# MasOS El sistema operativo exclusivo para la comunidad MyArcadeSpain ... de ahí su nombre.!
#

scriptdir="$(dirname "$0")"
scriptdir="$(cd "$scriptdir" && pwd)"

"$scriptdir/masos_pkgs.sh" setup gui

