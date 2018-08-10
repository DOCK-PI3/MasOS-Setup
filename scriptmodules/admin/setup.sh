#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="setup"
rp_module_desc="GUI based setup for MasOS"
rp_module_section=""

function rps_logInit() {
    if [[ ! -d "$__logdir" ]]; then
        if mkdir -p "$__logdir"; then
            chown $user:$user "$__logdir"
        else
            fatalError "No se pudo hacer el directorio $__logdir"
        fi
    fi
    local now=$(date +'%Y-%m-%d_%H%M%S')
    logfilename="$__logdir/rps_$now.log.gz"
    touch "$logfilename"
    chown $user:$user "$logfilename"
    time_start=$(date +"%s")
}

function rps_logStart() {
    echo -e "Iniciar sesion el: $(date -d @$time_start)\n"
    echo "MasOS version: $__version ($(git -C "$scriptdir" log -1 --pretty=format:%h))"
    echo "System: $(uname -a)"
}

function rps_logEnd() {
    time_end=$(date +"%s")
    echo
    echo "El registro termino en: $(date -d @$time_end)"
    date_total=$((time_end-time_start))
    local hours=$((date_total / 60 / 60 % 24))
    local mins=$((date_total / 60 % 60))
    local secs=$((date_total % 60))
    echo "Tiempo de ejecucion: $hours horas, $mins minutos, $secs segundos"
}

function rps_printInfo() {
    reset
    if [[ ${#__ERRMSGS[@]} -gt 0 ]]; then
        printMsgs "dialog" "${__ERRMSGS[@]}"
        printMsgs "dialog" "Consulte $1 para obtener más informacion detallada sobre los errores."
    fi
    if [[ ${#__INFMSGS[@]} -gt 0 ]]; then
        printMsgs "dialog" "${__INFMSGS[@]}"
    fi
}

function depends_setup() {
    # check for VERSION file - if it doesn't exist we will run the post_update script as it won't be triggered
    # on first upgrade to 4.x
    if [[ ! -f "$rootdir/VERSION" ]]; then
        joy2keyStop
        exec "$scriptdir/masos_pkgs.sh" setup post_update gui_setup
    fi

    if isPlatform "rpi" && isPlatform "mesa"; then
        printMsgs "dialog" "ERROR: Tiene habilitado el controlador experimental GL de escritorio. Esto NO es compatible con MasOS, y la Emulation Station y los emuladores no se ejecutaran.\n\nDeshabilite el controlador experimental GL de escritorio desde el menu 'Opciones avanzadas' de raspi-config."
        exit 1
    fi

    # make sure user has the correct group permissions
    if ! isPlatform "x11"; then
        local group
        for group in input video; do
            if ! hasFlag "$(groups $user)" "$group"; then
                dialog --yesno "Su usuario '$usuario' no es miembro del grupo de sistemas '$group'. \n\n Es necesario para que MasOS funcione correctamente. ¿Puedo agregar '$usuario' al grupo '$group'?\n\nTendra que reiniciar para que estos cambios surtan efecto." 22 76 2>&1 >/dev/tty && usermod -a -G "$group" "$user"
            fi
        done
    fi

    # remove all but the last 20 logs
    find "$__logdir" -type f | sort | head -n -20 | xargs -d '\n' --no-run-if-empty rm
}

function updatescript_setup()
{
    clear
    chown -R $user:$user "$scriptdir"
    printHeading "Obteniendo la ultima version en la secuencia de comandos de configuracion de MasOS-Setup."
    pushd "$scriptdir" >/dev/null
    if [[ ! -d ".git" ]]; then
        printMsgs "dialog" "No se puede encontrar el directorio '.git'. Por favor, clona el script de configuracion de MasOS a traves de 'git clone https://github.com/DOCK-PI3/MasOS-Setup.git'"
        popd >/dev/null
        return 1
    fi
    local error
    if ! error=$(su $user -c "git pull 2>&1 >/dev/null"); then
        printMsgs "dialog" "Actualización fallida:\n\n$error"
        popd >/dev/null
        return 1
    fi
    popd >/dev/null

    printMsgs "dialog" "Ya tiene la ultima version del script de configuracion de MasOS."
    return 0
}

function post_update_setup() {
    local return_func=("$@")

    joy2keyStart

    echo "$__version" >"$rootdir/VERSION"

    clear
    local logfilename
    __ERRMSGS=()
    __INFMSGS=()
    rps_logInit
    {
        rps_logStart
        # run _update_hook_id functions - eg to fix up modules for retropie-setup 4.x install detection
        printHeading "Ejecucion de ganchos de actualizacion"
        rp_updateHooks
        rps_logEnd
    } &> >(tee >(gzip --stdout >"$logfilename"))
    rps_printInfo "$logfilename"

    printMsgs "dialog" "AVISO: la secuencia de comandos de configuracion de MasOS y las imagenes de la tarjeta SD de MasOS prefabricadas estan disponibles para descargar de forma gratuita desde https://inforetro.wixsite.com/myarcade .\n\nLa imagen de MasOS preconstruida incluye software que tiene licencias no comerciales. No esta permitido vender imagenes de MasOS ni incluir MasOS con su producto comercial. \n\nNo se incluyen juegos con derechos de autor en MacOS.\n\nSi le vendieron este software, puede informarnos al respecto enviando un correo electronico a dock.pi3@gmail.com ."

    # return to set return function
    "${return_func[@]}"
}

function package_setup() {
    local idx="$1"
    local md_id="${__mod_id[$idx]}"

    while true; do
        local options=()

        local install
        local status
        if rp_isInstalled "$idx"; then
            install="Actualizar"
            status="Instalado"
        else
            install="Instalar"
            status="No Instalado"
        fi

        if rp_hasBinary "$idx"; then
            options+=(B "$install de binario")
        fi

        if fnExists "sources_${md_id}"; then
            options+=(S "$install de la fuente")
        fi

        if rp_isInstalled "$idx"; then
            if fnExists "gui_${md_id}"; then
                options+=(C "Configuracion / Opciones")
            fi
            options+=(X "Eliminar")
        fi

        if [[ -d "$__builddir/$md_id" ]]; then
            options+=(Z "Limpiar carpeta de origen")
        fi

        local help="${__mod_desc[$idx]}\n\n${__mod_help[$idx]}"
        if [[ -n "$help" ]]; then
            options+=(H "Paquete de ayuda")
        fi

        cmd=(dialog --backtitle "$__backtitle" --cancel-label "Back" --menu "Escoge una opcion para ${__mod_id[$idx]} ($status)" 22 76 16)
        choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

        local logfilename
        __ERRMSGS=()
        __INFMSGS=()

        case "$choice" in
            B|I)
                clear
                rps_logInit
                {
                    rps_logStart
                    rp_installModule "$idx"
                    rps_logEnd
                } &> >(tee >(gzip --stdout >"$logfilename"))
                rps_printInfo "$logfilename"
                ;;
            S)
                clear
                rps_logInit
                {
                    rps_logStart
                    rp_callModule "$idx" clean
                    rp_callModule "$idx"
                    rps_logEnd
                } &> >(tee >(gzip --stdout >"$logfilename"))
                rps_printInfo "$logfilename"
                ;;
            C)
                rps_logInit
                {
                    rps_logStart
                    rp_callModule "$idx" gui
                    rps_logEnd
                } &> >(tee >(gzip --stdout >"$logfilename"))
                rps_printInfo "$logfilename"
                ;;
            X)
                local text="Estas seguro de que desea eliminar $md_id?"
                [[ "${__mod_section[$idx]}" == "core" ]] && text+="\n\n ADVERTENCIA: ¡se necesitan paquetes del core -nucleo- para que funcione MasOS!"
                dialog --defaultno --yesno "$text" 22 76 2>&1 >/dev/tty || continue
                rps_logInit
                {
                    rps_logStart
                    rp_callModule "$idx" remove
                    rps_logEnd
                } &> >(tee >(gzip --stdout >"$logfilename"))
                rps_printInfo "$logfilename"
                ;;
            H)
                printMsgs "dialog" "$help"
                ;;
            Z)
                rp_callModule "$idx" clean
                printMsgs "dialog" "$__builddir/$md_id ha sido removido."
                ;;
            *)
                break
                ;;
        esac

    done
}

function section_gui_setup() {
    local section="$1"

    local default=""
    while true; do
        local options=()

        # we don't build binaries for experimental packages
        if rp_hasBinaries && [[ "$section" != "exp" ]]; then
            options+=(B "Instalar / Actualizar todo ${__sections[$section]} paquetes de binario" "Esto instalara todo ${__sections[$section]} paquetes de archivos binarios (si estan disponibles). Si falta un archivo binario, se realizará una instalacion de source.")
        fi

        options+=(
            S "Instalar / Actualizar todo ${__sections[$section]} paquetes desde la fuente -source" "S Esto construira e instalara todos los paquetes de $section desde source.La construccion desde la fuente atraera las ultimas versiones de muchos de los emuladores. El edificio podria fallar o los binarios resultantes podrian no funcionar. Solo elija esta opcion si se siente comodo trabajando con la consola de Linux y depurando cualquier problema."
            X "Eliminar todo ${__sections[$section]} paquetes" "X Esto eliminara todos los paquetes de $section."
        )

        local idx
        for idx in $(rp_getSectionIds $section); do
            if rp_isInstalled "$idx"; then
                installed="(Instalado)"
            else
                installed=""
            fi
            options+=("$idx" "${__mod_id[$idx]} $installed" "$idx ${__mod_desc[$idx]}"$'\n\n'"${__mod_help[$idx]}")
        done

        local cmd=(dialog --backtitle "$__backtitle" --cancel-label "Back" --item-help --help-button --default-item "$default" --menu "Escoge una opcion" 22 76 16)

        local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        [[ -z "$choice" ]] && break
        if [[ "${choice[@]:0:4}" == "HELP" ]]; then
            # remove HELP
            choice="${choice[@]:5}"
            # get id of menu item
            default="${choice/%\ */}"
            # remove id
            choice="${choice#* }"
            printMsgs "dialog" "$choice"
            continue
        fi

        default="$choice"

        local logfilename
        __ERRMSGS=()
        __INFMSGS=()
        case "$choice" in
            B)
                dialog --defaultno --yesno "¿Seguro que quieres instalar / actualizar todos los paquetes de $section desde binario?" 22 76 2>&1 >/dev/tty || continue
                rps_logInit
                {
                    rps_logStart
                    for idx in $(rp_getSectionIds $section); do
                        rp_installModule "$idx"
                    done
                    rps_logEnd
                } &> >(tee >(gzip --stdout >"$logfilename"))
                rps_printInfo "$logfilename"
                ;;
            S)
                dialog --defaultno --yesno "¿Estas seguro de que deseas instalar / actualizar todos los paquetes de $section desde la fuente?" 22 76 2>&1 >/dev/tty || continue
                rps_logInit
                {
                    rps_logStart
                    for idx in $(rp_getSectionIds $section); do
                        rp_callModule "$idx" clean
                        rp_callModule "$idx"
                    done
                    rps_logEnd
                } &> >(tee >(gzip --stdout >"$logfilename"))
                rps_printInfo "$logfilename"
                ;;

            X)
                local text="¿Seguro que quieres eliminar todos los paquetes de $section?"
                [[ "$section" == "core" ]] && text+="\n\nWARNING - core ¡se necesitan estos paquetes para que MasOS funcione!"
                dialog --defaultno --yesno "$text" 22 76 2>&1 >/dev/tty || continue
                rps_logInit
                {
                    rps_logStart
                    for idx in $(rp_getSectionIds $section); do
                        rp_isInstalled "$idx" && rp_callModule "$idx" remove
                    done
                    rps_logEnd
                } &> >(tee >(gzip --stdout >"$logfilename"))
                rps_printInfo "$logfilename"
                ;;
            *)
                package_setup "$choice"
                ;;
        esac

    done
}

function config_gui_setup() {
    local default
    while true; do
        local options=()
        local idx
        for idx in "${__mod_idx[@]}"; do
            # show all configuration modules and any installed packages with a gui function
            if [[ "${__mod_section[idx]}" == "config" ]] || rp_isInstalled "$idx" && fnExists "gui_${__mod_id[idx]}"; then
                options+=("$idx" "${__mod_id[$idx]}  - ${__mod_desc[$idx]}" "$idx ${__mod_desc[$idx]}")
            fi
        done

        local cmd=(dialog --backtitle "$__backtitle" --cancel-label "Back" --item-help --help-button --default-item "$default" --menu "Escoge una opcion" 22 76 16)

        local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        [[ -z "$choice" ]] && break
        if [[ "${choice[@]:0:4}" == "HELP" ]]; then
            choice="${choice[@]:5}"
            default="${choice/%\ */}"
            choice="${choice#* }"
            printMsgs "dialog" "$choice"
            continue
        fi

        [[ -z "$choice" ]] && break

        default="$choice"

        local logfilename
        __ERRMSGS=()
        __INFMSGS=()
        rps_logInit
        {
            rps_logStart
            if fnExists "gui_${__mod_id[choice]}"; then
                rp_callModule "$choice" depends
                rp_callModule "$choice" gui
            else
                rp_callModule "$idx" clean
                rp_callModule "$choice"
            fi
            rps_logEnd
        } &> >(tee >(gzip --stdout >"$logfilename"))
        rps_printInfo "$logfilename"
    done
}

function update_packages_setup() {
    clear
    local idx
    for idx in ${__mod_idx[@]}; do
        if rp_isInstalled "$idx" && [[ -n "${__mod_section[$idx]}" ]]; then
            rp_installModule "$idx"
        fi
    done
}

function update_packages_gui_setup() {
    local update="$1"
    if [[ "$update" != "actualizar" ]]; then
        dialog --defaultno --yesno "¿Seguro que quieres actualizar los paquetes instalados?" 22 76 2>&1 >/dev/tty || return 1
        updatescript_setup
        # restart at post_update and then call "update_packages_gui_setup update" afterwards
        joy2keyStop
        exec "$scriptdir/masos_pkgs.sh" setup post_update update_packages_gui_setup update
    fi

    local update_os=0
    dialog --yesno "¿Desea actualizar los paquetes subyacentes del sistema operativo? (eg kernel etc) ?" 22 76 2>&1 >/dev/tty && update_os=1
	
    clear

    local logfilename
    __ERRMSGS=()
    __INFMSGS=()
    rps_logInit
    {
        rps_logStart
        [[ "$update_os" -eq 1 ]] && apt_upgrade_raspbiantools
        update_packages_setup
        rps_logEnd
    } &> >(tee >(gzip --stdout >"$logfilename"))

    rps_printInfo "$logfilename"
    printMsgs "dialog" "Los paquetes instalados se han actualizado."
    gui_setup
}

function basic_install_setup() {
    local idx
    for idx in $(rp_getSectionIds core) $(rp_getSectionIds main); do     
		rp_installModule "$idx"
    done
}

function packages_gui_setup() {
    local section
    local default
    local options=()

    for section in core main opt driver exp; do
        options+=($section "Administrar ${__sections[$section]} paquetes" "$section Elija la parte superior instalar / actualizar / configurar paquetes de la ${__sections[$section]}")
    done

    local cmd
    while true; do
        cmd=(dialog --backtitle "$__backtitle" --cancel-label "Back" --item-help --help-button --default-item "$default" --menu "Escoge una opcion" 22 76 16)

        local choice
        choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        [[ -z "$choice" ]] && break
        if [[ "${choice[@]:0:4}" == "HELP" ]]; then
            choice="${choice[@]:5}"
            default="${choice/%\ */}"
            choice="${choice#* }"
            printMsgs "dialog" "$choice"
            continue
        fi
        section_gui_setup "$choice"
        default="$choice"
    done
}

function uninstall_setup()
{
    dialog --defaultno --yesno "¿Seguro que quieres desinstalar MasOS?" 22 76 2>&1 >/dev/tty || return 0
    dialog --defaultno --yesno "¿Estas REALMENTE seguro de que deseas desinstalar MasOS?\n\n$rootdir se eliminara, esto incluye archivos de configuracion para todos componentes." 22 76 2>&1 >/dev/tty || return 0
    clear
    printHeading "Desinstalando MasOS"
    for idx in "${__mod_idx[@]}"; do
        rp_isInstalled "$idx" && rp_callModule $idx remove
    done
    rm -rfv "$rootdir"
    dialog --defaultno --yesno "¿Desea eliminar todos los archivos de $datadir ? Esto incluye todas las ROM instaladas, los archivos de la BIOS y las pantallas personalizadas. " 22 76 2>&1 >/dev/tty && rm -rfv "$datadir"
    if dialog --defaultno --yesno "¿Desea eliminar todos los paquetes de sistema de los que depende MasOS?\n\nADVERTENCIA: esto eliminara paquetes como SDL incluso si se instalaron antes de instalar MasOS - tambien eliminara cualquier configuracion de paquete - como los de /etc/ samba para Samba. \n\ nSi no esta seguro, elija No (seleccionado por defecto)." 22 76 2>&1 >/dev/tty; then
        clear
        # remove all dependencies
        for idx in "${__mod_idx[@]}"; do
            rp_isInstalled "$idx" && rp_callModule "$idx" depends remove
        done
    fi
    printMsgs "dialog" "MasOS fue desistalado."
}

function reboot_setup()
{
    clear
    reboot
}

# retropie-setup main menu
function gui_setup() {
    depends_setup
    joy2keyStart
    local default
    while true; do
        local commit=$(git -C "$scriptdir" log -1 --pretty=format:"%cr (%h)")

        cmd=(dialog --backtitle "$__backtitle" --title "MasOS-Setup Script" --cancel-label "Exit" --item-help --help-button --default-item "$default" --menu "Version: $__version\nLast Commit: $commit" 22 76 16)
        options=(
            I "MasOS Instalacion basica" "Esto instalara todos los paquetes de Core y Main, lo que da una instalacion basica de MasOS.\nPosteriormente, se pueden instalar mas paquetes desde las secciones Opcional y Experimental. Si hay binarios disponibles, se usaran, o los paquetes se construiran desde la fuente, lo que llevara mas tiempo."

			# U "Update" "U Actualiza MasOS-Setup y todos los paquetes instalados actualmente. También permitira actualizar paquetes de sistema operativo. Si hay binarios disponibles, se usaran; de lo contrario, los paquetes se compilaran a partir de la fuente."
			
            P "Administrar paquetes"
            "P Instalar / Quitar y configurar los diversos componentes de MasOS, incluidos emuladores, ports y controladores."

            C "Configuracion / herramientas"
            "C Configuracion y herramientas. Configure samba y cualquier paquete que haya instalado que tenga opciones de configuracion adicionales tambien aparecera aqui."

            X "Desinstalar MasOS"
            "X Desinstalar completamente MasOS."

            R "Realice un reinicio"
            "R Reinicia tu máquina, reinicie su maquina para que las medificaciones tengan efecto."
        )

        choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        [[ -z "$choice" ]] && break

        if [[ "${choice[@]:0:4}" == "HELP" ]]; then
            choice="${choice[@]:5}"
            default="${choice/%\ */}"
            choice="${choice#* }"
            printMsgs "dialog" "$choice"
            continue
        fi
        default="$choice"

        case "$choice" in
            I)
                dialog --defaultno --yesno "¿Estás seguro de que quieres hacer una instalación básica?\n\nEsto instalará todos los paquetes del 'Core' y 'Main'." 22 76 2>&1 >/dev/tty || continue
                clear
                local logfilename
                __ERRMSGS=()
                __INFMSGS=()
                rps_logInit
                {
                    rps_logStart
                    basic_install_setup
					sudo cp -R /home/$user/MasOS-Setup/scriptmodules/supplementary/retropiemenu/masosextrasall.sh /home/$user/RetroPie/retropiemenu/
                    sudo chmod +x /home/$user/RetroPie/retropiemenu/masosextrasall.sh
					rps_logEnd
                } &> >(tee >(gzip --stdout >"$logfilename"))
                rps_printInfo "$logfilename"
                ;;
			# U)
                # update_packages_gui_setup
                # ;;
            P)
                packages_gui_setup
                ;;
            C)
                config_gui_setup
                ;;
            X)
                local logfilename
                __ERRMSGS=()
                __INFMSGS=()
                rps_logInit
                {
                    uninstall_setup
                } &> >(tee >(gzip --stdout >"$logfilename"))
                rps_printInfo "$logfilename"
                ;;
            R)
                dialog --defaultno --yesno "¿Estás seguro de que quieres reiniciar?\n\nTen en cuenta que si reinicias cuando se está ejecutando Emulation Station, perderás los cambios en los metadatos." 22 76 2>&1 >/dev/tty || continue
                sudo cp -R /home/$user/MasOS-Setup/scriptmodules/supplementary/retropiemenu/masosextrasall.sh /home/$user/RetroPie/retropiemenu/
                sudo chmod +x /home/$user/RetroPie/retropiemenu/masosextrasall.sh
				reboot_setup
                ;;
        esac
    done
    joy2keyStop
    clear
}
