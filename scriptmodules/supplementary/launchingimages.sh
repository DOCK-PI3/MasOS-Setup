#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="launchingimages"
rp_module_desc="Genere una imagen para runcommand basadas en themes de EmulationStation."
rp_module_help="Mientras se carga un juego, se muestra una imagen de inicio del comando de ejecución. Con esta herramienta, puede crear automáticamente algunas imágenes geniales basadas en el tema de emulationstation elegido en su sistema."
rp_module_section="exp"
rp_module_flags="noinstclean"

function depends_launchingimages() {
    local depends=(imagemagick librsvg2-bin)
    if isPlatform "x11"; then
        depends+=(feh)
    else
        depends+=(fbi)
    fi
    getDepends "${depends[@]}"
}

function install_bin_launchingimages() {
    gitPullOrClone "$md_inst" "https://github.com/DOCK-PI3/generate-launching-images.git"
}

function _show_images_launchingimages() {
    local image
    local timeout=5
    local is_list=0

    if [[ "$1" = "1" ]]; then
        is_list=1
        shift
    fi

    [[ -f "$1" ]] || return 1
    image="$1"

    if isPlatform "x11"; then
        feh \
            --cycle-once \
            --hide-pointer \
            --fullscreen \
            --auto-zoom \
            --no-menus \
            --slideshow-delay $timeout \
            --quiet \
            $([[ "$is_list" -eq 1 ]] && echo --filelist) \
            "$image"
    else
        fbi \
            --once \
            --timeout "$timeout" \
            --noverbose \
            --autozoom \
            $([[ "$is_list" -eq 1 ]] && echo --list) \
            "$image" </dev/tty &>/dev/null
    fi
}

function _dialog_menu_launchingimages() {
    local text="$1"
    shift
    local options=()
    local choice
    local opt
    local i

    [[ "$#" -eq 0 ]] && return 1

    i=1
    for opt in "$@"; do
        options+=( "$i" "$opt" )
        ((i++))
    done
    choice=$(dialog --backtitle "$__backtitle" --menu "$text" 22 86 16 "${options[@]}" 2>&1 >/dev/tty) || return
    echo "${options[choice*2-1]}"
}

function _set_theme_launchingimages() {
    _dialog_menu_launchingimages "Lista disponible de themes" $("$md_inst/generate-launching-images.sh" --list-themes) \
    || echo "$theme"
}

function _set_system_launchingimages() {
    local options=()
    local choice

    options=( all )
    options+=( $("$md_inst/generate-launching-images.sh" --list-systems) )
    choice=$(
        _dialog_menu_launchingimages \
            "List of available systems.\n\nSelect the system you want to generate a launching image or \"all\" to generate for all systems." \
            "${options[@]}"
    )
    case "$choice" in
        "all")  echo "" ;;
        "")     echo "$system" ;;
        *)      echo "--system $choice" ;;
    esac
}

function _set_extension_launchingimages() {
    _dialog_menu_launchingimages "Elija la extensión de archivo de la imagen de lanzamiento final." png jpg\
    || echo "$extension"
}

function _set_show_timeout_launchingimages() {
    _dialog_menu_launchingimages \
        "Establezca cuánto tiempo se mostrara la imagen antes de preguntar si acepta (en segundos)" \
        1 2 3 4 5 6 7 8 9 10 \
    || echo "$show_timeout"
}

function _set_loading_text_launchingimages() {
    dialog \
        --backtitle "$__backtitle" \
        --inputbox "Ingrese el texto \"CARGANDO\" (o deje en blanco para que no haya texto):" \
        0 70 \
        "CARGANDO..." \
        2>&1 >/dev/tty \
    || echo "$loading_text"
}

function _set_press_button_text_launchingimages() {
    dialog \
        --backtitle "$__backtitle" \
        --inputbox "Ingrese el texto \"PULSA EL BOTON A" (o deje en blanco para no mostrar texto):" \
        0 70 \
        "PULSA EL BOTON A PARA CONFIGURAR LAS OPCIONES DE LANZAMIENTO" \
        2>&1 >/dev/tty \
    || echo "$press_button_text"
}

function _select_color_launchingimages() {
    _dialog_menu_launchingimages \
        "Elige un color para el $1" \
        white black silver gray gray10 gray25 gray50 gray75 gray90 \
        red orange yellow green cyan blue cyan purple pink brown
}

function _set_loading_text_color_launchingimages() {
    _select_color_launchingimages "\"CARGANDO\" text" || echo "$loading_text_color"
}

function _set_press_button_text_color_launchingimages() {
    _select_color_launchingimages "\"PULSA EL BOTON A\" text" || echo "$press_button_text_color"
}

function _set_solid_bg_color_launchingimages() {
    local choice
    local cmd=(dialog --backtitle "$__backtitle" --menu "Color a utilizar como fondo" 22 86 16)
    local options=(
          0 "Desactivar \"Color de fondo sólido\""
          1 "Usa el color del sistema definido por el theme"
          2 "Selecciona un color"
    )
    choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

    case "$choice" in
        0)  echo
            ;;
        1)  echo "--solid-bg-color"
            ;;
        2)  echo "--solid-bg-color $(_select_color_launchingimages background)"
            ;;
        *)  echo "$solid_bg_color"
            ;;
    esac
}

function _dialog_yesno_launchingimages() {
    dialog --backtitle "$__backtitle" --yesno "$@" 20 60 2>&1 >/dev/tty
}

function _set_no_ask_launchingimages() {
    _dialog_yesno_launchingimages "Si habilita \"no_ask"\, todas las imágenes generadas seran aceptadas automaticamente.\n\n¿Desea habilitarlo?" \
    && echo "--no-ask"
}

function _set_no_logo_launchingimages() {
    _dialog_yesno_launchingimages "Si activa \"no_logo"\, las imagenes no tendran el logotipo del sistema.\n\n¿Desea habilitarlo?" \
    && echo "--no-logo"
}

function _set_logo_belt_launchingimages() {
    _dialog_yesno_launchingimages "Si habilitas \"logo_belt"\ la imagen tendra un cinturon blanco semitransparente detras del logo.\n\n¿Deseas habilitarlo?" \
    && echo "--logo-belt"
}

function _get_all_launchingimages() {
    find "$configdir" -type f -regex ".*launching\.\(png\|jpg\)" | sort
}

function _is_theme_chosen_launchingimages() {
    if [[ -z "$1" ]]; then
        printMsgs "dialog" "No elegiste un theme!\n\nVe a \"Configuraciones de generacion de imágenes\" y elije uno."
        return 1
    fi
}

function _get_config_file_launchingimages() {
    local file_list=$(find "$md_inst" -type f -name '*.cfg' ! -name '.current.cfg' | sort | xargs)
    if [[ -z "$file_list" ]]; then
        printMsgs "dialog" "There's no config file saved."
        return 1
    fi
    _dialog_menu_launchingimages "Elige el archivo" $file_list # XXX: no hay citas alrededor de $file_list es obligatorio!
    return $?
}

function _load_config_launchingimages() {
    echo "$(loadModuleConfig \
        'theme=' \
        'extension=png' \
        'show_timeout=5' \
        'loading_text=CARGANDO' \
        'press_button_text=PULSA EL BOTON A PARA CONFIGURAR LAS OPCIONES DE LANZAMIENTO' \
        'loading_text_color=white' \
        'press_button_text_color=gray50' \
        'no_ask=' \
        'no_logo=' \
        'solid_bg_color=' \
        'system=' \
        'logo_belt=' \
    )"
}

function _settings_launchingimages() {
    local cmd=(dialog --backtitle "$__backtitle" --title " SETTINGS " --cancel-label "Back" --menu "runcommand launching images generation settings." 22 86 16)
    local options
    local choice
    local config_file

    iniConfig ' = ' '"' "$current_cfg"

    while true; do
        eval $(_load_config_launchingimages)

        options=( 
            config_file "$(
               [[ "$config_file" == *"$theme.cfg" ]] && echo "$(basename "$config_file")"
            )"
            theme "$theme"
            system "$(
                if [[ -z "$system" ]]; then
                    echo "all systems in es_systems.cfg"
                else
                    echo "$system" | cut -d' ' -f2
                fi
            )"
            extension ".$extension"
            loading_text "\"$loading_text\""
            press_button_text "\"$press_button_text\""
            loading_text_color "$loading_text_color"
            press_button_text_color "$press_button_text_color"
            show_timeout "$( [[ -n "$no_ask" ]] && echo "don't show (see no_ask)" || echo "$show_timeout seconds")"
            no_ask "$( [[ -n "$no_ask" ]] && echo true || echo false)"
            no_logo "$( [[ -n "$no_logo" ]] && echo true || echo false)"
            logo_belt "$( [[ -n "$logo_belt" ]] && echo true || echo false)"
            solid_bg_color "$(
                if [[ -z "$solid_bg_color" ]]; then
                    echo false
                elif [[ -z "$(echo "$solid_bg_color" | cut -s -d' ' -f2)" ]]; then
                    echo "get from the theme"
                else
                    echo "$solid_bg_color" | cut -s -d' ' -f2
                fi
            )"
        )
        choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)

        [[ -z "$choice" ]] && break

        if [[ "$choice" = "config_file" ]]; then
            config_file=$(_manage_config_file_launchingimages)
            continue
        fi

        iniSet "$choice" "$(_set_${choice}_launchingimages)"
    done
}

function _manage_config_file_launchingimages() {
    local choice
    local config_file

    eval $(_load_config_launchingimages)

    while true; do
        choice=$(
            dialog --backtitle "$__backtitle" --title " CONFIG FILE " --menu "Elija una opcion" 22 86 16 \
                1 "Cargar archivo" \
                2 "Guardar configuracion actual para \"$theme\"" \
                3 "Eliminar un archivo de configuracion" \
                2>&1 >/dev/tty
        )

        case "$choice" in
            1)  # load config
                config_file=$(_get_config_file_launchingimages) || continue
                cat "$config_file" > "$current_cfg"
                echo "$config_file"
                break
                ;;

            2)  # save config
                _is_theme_chosen_launchingimages "$theme" || break
                config_file="$md_inst/$theme.cfg"
                if [[ -f "$config_file" ]]; then
                    _dialog_yesno_launchingimages "\"$(basename "$config_file")\" ya existe.\n¿Quieres sobreescribirlo?" \
                    || continue
                fi
                cat "$current_cfg" > "$config_file"
                printMsgs "dialog" "\"$(basename "$config_file")\" guardado!"
                echo "$config_file"
                break
                ;;

            3)  # delete config
                config_file=$(_get_config_file_launchingimages) || continue

                _dialog_yesno_launchingimages "¿Estas seguro que quieres borrarlo \"$config_file\"?" \
                || continue

                local err_msg=$(rm -v "$config_file")
                printMsgs "dialog" "$err_msg"
                ;;

            *)
                break
                ;;
        esac
    done
}

function _generate_launchingimages() {
    eval $(_load_config_launchingimages)

    _is_theme_chosen_launchingimages "$theme" || return
    "$md_inst/generate-launching-images.sh" \
        --theme "$theme" \
        --extension "$extension" \
        --show-timeout "$show_timeout" \
        --loading-text "$loading_text" \
        --press-button-text "$press_button_text" \
        --loading-text-color "$loading_text_color" \
        --press-button-text-color "$press_button_text_color" \
        $system \
        $solid_bg_color \
        $no_ask \
        $no_logo \
        $logo_belt \
        2>&1 >/dev/tty

    if [[ "$?" -ne 0 ]]; then
        printMsgs "dialog" "No se pueden generar imagenes de lanzamiento. Por favor, revisa el \"Configuraciones de generacion de imagenes\"."
        return
    fi

    for file in $(_get_all_launchingimages); do
        chown $user:$user "$file"
    done
}

function gui_launchingimages() {
    local cmd=()
    local options=()
    local choice
    local current_cfg="$md_inst/.current.cfg"

    rm -f "$current_cfg"
    while true; do
        cmd=(dialog --backtitle "$__backtitle" --title " runcommand launching images generation " --menu "Elija una opcion." 22 86 16)
        options=( 
            1 "Configuraciones de generacion de imagenes"
            2 "Generar imagenes de lanzamiento."
            3 "Ver la presentacion de diapositivas de todas las imagenes de lanzamiento actuales"
            4 "Ver la imagen de lanzamiento de un sistema especifico"
        )
        choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        if [[ -n "$choice" ]]; then
            case "$choice" in
                1) # Image generation settings
                    _settings_launchingimages
                    ;;

                2) # Generate launching images
                    _generate_launchingimages
                    ;;

                3) # View slideshow of all current launching images
                    local file=$(mktemp)
                    _get_all_launchingimages > "$file"
                    if [[ -s "$file" ]]; then
                        _show_images_launchingimages 1 "$file"
                    else
                        printMsgs "dialog" "No se ha encontrado ninguna imagen de lanzamiento."
                    fi
                    rm -f "$file"
                    ;;

                4) # View the launching image of a specific system
                    while true; do
                        local img_list=( $(_get_all_launchingimages) )
                        if [[ "${#img_list[@]}" -eq 0 ]]; then
                            printMsgs "dialog" "No se ha encontrado ninguna imagen de lanzamiento."
                            break
                        fi
                        choice=$(_dialog_menu_launchingimages "Elige el sistema" "${img_list[@]}")
                        [[ -z "$choice" ]] && break
                        _show_images_launchingimages "$choice"
                    done
                    ;;

            esac
        else
            break
        fi
    done
    rm -f "$current_cfg"
}
