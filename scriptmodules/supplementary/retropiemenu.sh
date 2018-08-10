#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
# Menu de retropie usado en MasOS....

rp_module_id="retropiemenu"
rp_module_desc="MasOS configuration menu for EmulationStation"
rp_module_section="core"

function _update_hook_retropiemenu() {
    # to show as installed when upgrading to retropie-setup 4.x
    if ! rp_isInstalled "$md_idx" && [[ -f "$home/.emulationstation/gamelists/retropie/gamelist.xml" ]]; then
        mkdir -p "$md_inst"
        # to stop older scripts removing when launching from retropie menu in ES due to not using exec or exiting after running retropie-setup from this module
        touch "$md_inst/.retropie"
    fi
}

function depends_retropiemenu() {
    getDepends mc
}

function install_bin_retropiemenu() {
    return
}

function configure_retropiemenu()
{
    [[ "$md_mode" == "remove" ]] && return

    local rpdir="$home/RetroPie/retropiemenu"
    mkdir -p "$rpdir"
    cp -Rv "$md_data/icons" "$rpdir/"
    chown -R $user:$user "$rpdir"

    isPlatform "rpi" && rm -f "$rpdir/dispmanx.rp"

    # add the gameslist / icons
    local files=(
        'audiosettings'
        # 'backgroundmusic'
		# 'bezelproject'
		# 'bezels'
		'bluetooth'
        'configedit'
        'esthemes'
        'filemanager'
        'raspiconfig'
        'retroarch'
        'retronetplay'
        'rpsetup'
        'runcommand'
        # 'showip'
        'splashscreen'
		# 'videoloading'
        'wifi'
		# 'masosupdateallsystem'
    )

    local names=(
        'Audio'
		# 'Musica de Fondo'
		# 'Project Bezels'
		# 'Bezels'
        'Bluetooth'
        'Editar Config'
        'ES Themes'
        'File Manager'
        'Raspi-Config'
        'Retroarch'
        'RetroArch Net Play'
        'MasOS Setup'
        'Run Command Configuration'
        # 'Mostrar tu IP'
        'Configurar Splash Screens'
		# 'Videoloadind script'
        'WiFi agregar o editar config'
    )

    local descs=(
        'Configuraciones de audio Elija predeterminado de auto, jack de 3.5 mm o HDMI. Controles del mezclador y aplicar configuraciones predeterminadas.'
        # 'Musica de Fondo en MasOS'
		# 'Project Bezels ,cientos de bezels configurados y instalados con un simple clic.'
		# 'Bezels - Activa o desactiva rapidamente los bezels que tengas activos'
		'Regístrese y conéctese a dispositivos bluetooth. Anule el registro y elimine los dispositivos y visualice los dispositivos registrados y conectados.'
        'Cambie las opciones comunes de RetroArch y edite manualmente las configuraciones de RetroArch, las configuraciones globales y las configuraciones que no son de RetroArch.'
        'Install, uninstall, or update EmulationStation themes. Most themes can be previewed at ..... coming soon!.'
        'Administrador de archivos básico de ASCII para Linux que le permite navegar, copiar, eliminar y mover archivos.'
        'Cambie la contraseña del usuario, las opciones de arranque, la internacionalización, la cámara, agregue su pi a Rastrack, overclock, overscan, división de memoria, SSH y más.'
        'Inicia la GUI de RetroArch para que pueda cambiar las opciones de RetroArch. Nota: Los cambios no se guardarán a menos que haya habilitado la opción "Guardar configuración al salir".'
        'Configure las opciones de RetroArch Netplay, elija host o cliente, puerto, IP de host, marcos de demora y su apodo.'
        'Instale MasOS desde binario o fuente, instale paquetes experimentales, controladores adicionales, edite recursos compartidos de samba, raspador personalizado, así como otras configuraciones relacionadas con MasOS.'
        'Change what appears on the runcommand screen. Enable or disable the menu, enable or disable box art, and change CPU configuration.'
        # 'Muestra su dirección IP actual, así como otra información proporcionada por el comando, "ip addr show."'
        'Habilite o deshabilite la pantalla secundaria en el inicio de MasOS. Elija una pantalla secundaria, descargue nuevas pantallas emergentes y regrese la pantalla secundaria a la predeterminada.'
        # 'Reproducier video mientras carga la rom.'
		'Conéctese o desconecte de una red wifi y configure wifi.'
    )

    setESSystem "RetroPie" "retropie" "$rpdir" ".rp .sh" "sudo $scriptdir/masos_pkgs.sh retropiemenu launch %ROM% </dev/tty >/dev/tty" "" "retropie"

    local file
    local name
    local desc
    local image
    local i
    for i in "${!files[@]}"; do
        case "${files[i]}" in
            audiosettings|raspiconfig|splashscreen)
                ! isPlatform "rpi" && continue
                ;;
            wifi)
                [[ "$__os_id" != "Raspbian" ]] && continue
        esac

        file="${files[i]}"
        name="${names[i]}"
        desc="${descs[i]}"
        image="$home/RetroPie/retropiemenu/icons/${files[i]}.png"

        touch "$rpdir/$file.rp"

        local function
        for function in $(compgen -A function _add_rom_); do
            "$function" "retropie" "RetroPie" "$file.rp" "$name" "$desc" "$image"
        done
    done
}

function remove_retropiemenu() {
    rm -rf "$home/RetroPie/retropiemenu"
    rm -rf "$home/.emulationstation/gamelists/retropie"
    delSystem retropie
}

function launch_retropiemenu() {
    clear
    local command="$1"
    local basename="${command##*/}"
    local no_ext="${basename%.rp}"
    joy2keyStart
    case "$basename" in
        retroarch.rp)
            joy2keyStop
            cp "$configdir/all/retroarch.cfg" "$configdir/all/retroarch.cfg.bak"
            chown $user:$user "$configdir/all/retroarch.cfg.bak"
            su $user -c "\"$emudir/retroarch/bin/retroarch\" --menu --config \"$configdir/all/retroarch.cfg\""
            iniConfig " = " '"' "$configdir/all/retroarch.cfg"
            iniSet "config_save_on_exit" "false"
            ;;
        rpsetup.rp)
            rp_callModule setup gui
            ;;
        raspiconfig.rp)
            raspi-config
            ;;
        filemanager.rp)
            mc
            ;;
        showip.rp)
            local ip="$(ip route get 8.8.8.8 2>/dev/null | awk '{print $NF; exit}')"
            printMsgs "dialog" "Su IP es: $ip\n\nOutput of 'ip addr show':\n\n$(ip addr show)"
            ;;
        *.rp)
            rp_callModule $no_ext depends
            if fnExists gui_$no_ext; then
                rp_callModule $no_ext gui
            else
                rp_callModule $no_ext configure
            fi
            ;;
        *.sh)
            cd "$home/RetroPie/retropiemenu"
            sudo -u "$user" bash "$command"
            ;;
    esac
    joy2keyStop
    clear
}
