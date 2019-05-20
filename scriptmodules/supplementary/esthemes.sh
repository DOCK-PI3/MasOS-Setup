#!/usr/bin/env bash

# This file is part of The MasOS Project
#
# The MasOS Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/DOCK-PI3/MasOS-Setup/master/LICENSE.md
#

rp_module_id="esthemes"
rp_module_desc="Instalar MasOS themes para EmulationStation"
rp_module_section="config"

function depends_esthemes() {
    if isPlatform "x11"; then
        getDepends feh
    else
        getDepends fbi
    fi
}

function install_theme_esthemes() {
    local theme="$1"
    local repo="$2"
    if [[ -z "$repo" ]]; then
        repo="Moriggy"
    fi
    if [[ -z "$theme" ]]; then
        theme="MasOS"
        repo="Moriggy"
    fi
    mkdir -p "/etc/emulationstation/themes"
    gitPullOrClone "/etc/emulationstation/themes/$theme" "https://github.com/$repo/es-theme-$theme.git"
	sudo chown -R pi:pi /etc/emulationstation/themes/*
}

function uninstall_theme_esthemes() {
    local theme="$1"
    if [[ -d "/etc/emulationstation/themes/$theme" ]]; then
        rm -rf "/etc/emulationstation/themes/$theme"
    fi
}

function gui_esthemes() {
    local themes=(
		'DOCK-PI3 BASE-DEV'
		'DOCK-PI3 BIGGRID'
		'DOCK-PI3 bluepixel'
		'DOCK-PI3 paralleluniverse'
		'DOCK-PI3 Perinquen'
		'DOCK-PI3 PlataFina'
		'Moriggy Resident_Evil'
		'Moriggy Blackhole'
		'Moriggy Neon'
		'Moriggy Spacespin'
		'Moriggy es-next-pixel-Legacy'
		'Moriggy es-next-pixel-Wheel'
		'Moriggy hypernostalgic'
        'Moriggy MasOS'
		'Moriggy maximus-v3'
		'Moriggy retro'
		'Moriggy PandoraBoxVerde'
		'lipebello spaceoddity'
		'lipebello strangerstuff'
		'lipebello swineapple'
		'lipebello retrorama'
		'RetroPie carbon'
		'RetroPie carbon-nometa'
		'dmmarti maximuspie'
		'dmmarti kidz'
		'ehettervik workbench'
		'ruckage famicom-mini'
        'ruckage snes-mini'
		'ruckage nes-mini'
        'TMNTturtleguy ComicBook'
        'TMNTturtleguy ComicBook_4-3'
        'TMNTturtleguy ComicBook_SE-Wheelart'
        'TMNTturtleguy ComicBook_4-3_SE-Wheelart'
		'HerbFargus tronkyfran'
		'dmmarti hurstyblue'
	    'garaine marioblue'
        'garaine bigwood'
		'RetroHursty69 neogeo_only'
		'RetroHursty69 graffiti'
		'RetroHursty69 cabsnazzy'
		'RetroHursty69 heychromey'
		'SuperMagicom nostalgic'
		'RetroHursty69 comiccrazy'
	    'RetroHursty69 greenilicious'
		'waweedman pii-wii'
	)
    while true; do
        local theme
        local installed_themes=()
        local repo
        local options=()
        local status=()
        local default

        local gallerydir="/etc/emulationstation/es-theme-gallery"
        if [[ -d "$gallerydir" ]]; then
            status+=("i")
            options+=(G "Ver o actualizar Theme Gallery")
        else
            status+=("n")
            options+=(G "Descargar Theme Gallery")
        fi

        options+=(U "Actualizar todos los themes instalados")

        local i=1
        for theme in "${themes[@]}"; do
            theme=($theme)
            repo="${theme[0]}"
            theme="${theme[1]}"
            if [[ -d "/etc/emulationstation/themes/$theme" ]]; then
                status+=("i")
                options+=("$i" "Actualizar o desinstalar $repo/$theme (instalado)")
                installed_themes+=("$theme $repo")
            else
                status+=("n")
                options+=("$i" "Instalar $repo/$theme (no instalado)")
            fi
            ((i++))
        done
        local cmd=(dialog --default-item "$default" --backtitle "$__backtitle" --menu "Elija una opcion" 22 76 16)
        local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        default="$choice"
        [[ -z "$choice" ]] && break
        case "$choice" in
            G)
                if [[ "${status[0]}" == "i" ]]; then
                    options=(1 "Ver Theme Gallery" 2 "Actualizar Theme Gallery" 3 "Eliminar Theme Gallery")
                    cmd=(dialog --backtitle "$__backtitle" --menu "Choose an option for gallery" 12 40 06)
                    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
                    case "$choice" in
                        1)
                            cd "$gallerydir"
                            if isPlatform "x11"; then
                                feh --info "echo %f" --slideshow-delay 6 --fullscreen --auto-zoom --filelist images.list
                            else
                                fbi --timeout 6 --once --autozoom --list images.list
                            fi
                            ;;
                        2)
                            gitPullOrClone "$gallerydir" "https://github.com/wetriner/es-theme-gallery"
                            ;;
                        3)
                            if [[ -d "$gallerydir" ]]; then
                                rm -rf "$gallerydir"
                            fi
                            ;;
                    esac
                else
                    gitPullOrClone "$gallerydir" "http://github.com/wetriner/es-theme-gallery"
                fi
                ;;
            U)
                for theme in "${installed_themes[@]}"; do
                    theme=($theme)
                    rp_callModule esthemes install_theme "${theme[0]}" "${theme[1]}"
                done
                ;;
            *)
                theme=(${themes[choice-1]})
                repo="${theme[0]}"
                theme="${theme[1]}"
                if [[ "${status[choice]}" == "i" ]]; then
                    options=(1 "Update $repo/$theme" 2 "Uninstall $repo/$theme")
                    cmd=(dialog --backtitle "$__backtitle" --menu "Elija una opcion para el theme" 12 40 06)
                    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
                    case "$choice" in
                        1)
                            rp_callModule esthemes install_theme "$theme" "$repo"
                            ;;
                        2)
                            rp_callModule esthemes uninstall_theme "$theme"
                            ;;
                    esac
                else
                    rp_callModule esthemes install_theme "$theme" "$repo"
                fi
                ;;
        esac
    done
}
