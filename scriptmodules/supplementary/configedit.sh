#!/usr/bin/env bash

# This file is part of The RetroPie Project
#
# The RetroPie Project is the legal property of its developers, whose names are
# too numerous to list here. Please refer to the COPYRIGHT.md file distributed with this source.
#
# See the LICENSE.md file at the top-level directory of this distribution and
# at https://raw.githubusercontent.com/RetroPie/RetroPie-Setup/master/LICENSE.md
#

rp_module_id="configedit"
rp_module_desc="Editar configuraciones MasOS / RetroArch"
rp_module_section="config"

function _video_fullscreen_configedit() {
    local mode="$1"
    local value="$2"
    case "$mode" in
        get)
            iniGet "video_fullscreen_x"
            local res_x="$ini_value"

            iniGet "video_fullscreen_y"
            local res_y="$ini_value"

            if [[ -z "$res_x" && -z "$res_y" ]]; then
                echo "unset"
            elif [[ "$res_x" == "0" && "$res_y" == "0" ]]; then
                echo "Resolucion de salida de video"
            else
                echo "${res_x}x${res_y}"
            fi
            ;;
        set)
            local save="$1"
            local res=(
                "320x240"
                "640x480"
                "800x600"
                "960x720"
                "1280x960"
            )
            local i=1
            local item
            local options=(U "unset")
            local default
            for item in "${res[@]}"; do
                [[ "$item" == "$value" ]] && default="$i"
                options+=($i "$item")
                ((i++))
            done
            options+=(
                O "Resolucion de salida de video"
                C "Personalizado"
            )
            [[ "$value" == "Resolucion de salida de video" ]] && default="O"
            [[ "$value" == "unset" ]] && default="U"
            [[ -z "$default" ]] && default="C"
            local cmd=(dialog --default-item "$default" --menu "Elija la resolucion de render de RetroArch" 22 76 16 )
            local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
            [[ -z "$choice" ]] && return
            local res
            if [[ "$choice" == "U" ]]; then
                iniUnset "video_fullscreen_x"
                iniUnset "video_fullscreen_y"
            elif [[ "$choice" == "O" ]]; then
                iniSet "video_fullscreen_x" "0"
                iniSet "video_fullscreen_y" "0"
            else
                if [[ "$choice" == "C" ]]; then
                    cmd=(dialog --backtitle "$__backtitle" --inputbox "Por favor ingresa la resolucion de render como WIDTHxHEIGHT" 10 60)
                    res=$("${cmd[@]}" 2>&1 >/dev/tty)
                    [[ -z "$res" || ! "$res" =~ ^[0-9]+x[0-9]+$ ]] && return
                else
                    res="${res[$choice-1]}"
                fi
                res=(${res/x/ })
                iniSet "video_fullscreen_x" "${res[0]}"
                iniSet "video_fullscreen_y" "${res[1]}"
            fi
            ;;
    esac
}

function _joypad_index_configedit() {
    local mode="$1"
    local value="$2"
    while true; do

        local players=()
        local player
        for player in 1 2 3 4; do
            iniGet "input_player${player}_joypad_index"
            if [[ -n "$ini_value" ]]; then
                players+=("$ini_value")
            else
                players+=("unset")
            fi
        done

        case "$mode" in
            get)
                echo "${players[@]}"
                return
                ;;
            set)
                local dev
                local devs_name=()
                local path
                local paths=()

                # get joystick device paths
                while read -r dev; do
                    if udevadm info --name=$dev | grep -q "ID_INPUT_JOYSTICK=1"; then
                        paths+=("$(udevadm info --name=$dev --query=name)")
                    fi
                done < <(find /dev/input -name "js*")

                if [[ "${#paths[@]}" -gt 0 ]]; then
                    # sort by path
                    IFS=$'\n'
                    while read -r path; do
                        devs_name+=("$(cat /sys/class/$path/device/name)")
                    done < <(sort <<<"${paths[*]}")
                    unset IFS
                fi

                local options=()
                local i
                local value
                local joypad
                for i in 1 2 3 4; do
                    player="${players[$i-1]}"
                    value="$player"
                    joypad="${devs_name[$player]}"
                    [[ -z "$joypad" ]] && joypad="not connected"
                    [[ "$player" != "unset" ]] && value+=" ($joypad)"
                    options+=("$i" "$value")
                done
                local cmd=(dialog --backtitle "$__backtitle" --menu "Elige un jugador para ajustar" 22 76 16)
                local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
                [[ -z "$choice" ]] && return
                player="$choice"
                options=(U Unset)
                local i=0
                for dev in "${devs_name[@]}"; do
                    options+=("$i" "$dev")
                    ((i++))
                done
                local cmd=(dialog --backtitle "$__backtitle" --menu "Elige un Gamepad" 22 76 16)
                local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
                [[ -z "$choice" ]] && continue
                case "$choice" in
                    U)
                        iniUnset "input_player${player}_joypad_index"
                        ;;
                    *)
                        iniSet "input_player${player}_joypad_index" "$choice"
                        ;;
                esac
                ;;
        esac
    done
}

function basic_configedit() {
    local config="$1"

    local ini_options=(
        'video_smooth true false'
        'aspect_ratio_index _id_ 4:3 16:9 16:10 16:15 1:1 2:1 3:2 3:4 4:1 4:4 5:4 6:5 7:9 8:3 8:7 19:12 19:14 30:17 32:9 config square core custom'
        '_function_ _video_fullscreen_configedit'
        'video_shader_enable true false'
        "video_shader _file_ *.*p $rootdir/emulators/retroarch/shader"
        'input_overlay_enable true false'
        "input_overlay _file_ *.cfg $rootdir/emulators/retroarch/overlays"
        '_function_ _joypad_index_configedit'
        'input_player1_analog_dpad_mode _id_ disabled left-stick right-stick'
        'input_player2_analog_dpad_mode _id_ disabled left-stick right-stick'
        'input_player3_analog_dpad_mode _id_ disabled left-stick right-stick'
        'input_player4_analog_dpad_mode _id_ disabled left-stick right-stick'
    )

    local ini_titles=(
        'Video Smoothing'
        'Aspect Ratio'
        'Render Resolution'
        'Video Shader Enable'
        "Video Shader File"
        'Overlay Enable'
        'Overlay File'
        'Elige el orden de joypad'
        'Player 1 - usa un stick analógico como d-pad'
        'Player 2 - usa un stick analógico como d-pad'
        'Player 3 - usa un stick analógico como d-pad'
        'Player 4 - usa un stick analógico como d-pad'
    )

    local ini_descs=(
        'Suaviza la imagen con filtrado bilineal. Se debe desactivar si se utilizan shaders de píxeles.'
        'Relacion de aspecto a usar (no configurado por defecto: usara el aspecto central si video_aspect_ratio_auto es verdadero)'
        'Configure la resolucion para representar la salida del emulador en - para un mejor rendimiento en pantallas Full HD, elija una resolucion más baja y se ampliara en hardware'
        'Cargar video_shader en el inicio. Otros shaders se pueden cargar mas tarde en tiempo de ejecucion.'
        'Video shader usar (por defecto ninguno)'
        'Cargar overlay de entrada en el inicio. Otros overlays se pueden cargar mas tarde en tiempo de ejecución.'
        'Input overlay para usar (por defecto ninguno)'
        'Seleccion manual del orden del joypad.'
        'Permitir que los sticks analogicos se utilicen como d-pad - 0 = deshabilitado, 1 = stick izquierdo, 2 = stick derecho'
        'Permitir que los sticks analogicos se utilicen como d-pad - 0 = deshabilitado, 1 = stick izquierdo, 2 = stick derecho'
        'Permitir que los sticks analogicos se utilicen como d-pad - 0 = deshabilitado, 1 = stick izquierdo, 2 = stick derecho'
        'Permitir que los sticks analogicos se utilicen como d-pad - 0 = deshabilitado, 1 = stick izquierdo, 2 = stick derecho'
    )

    iniFileEditor " = " '"' "$config"
}

function advanced_configedit() {
    local config="$1"

    local audio_opts="alsa alsathread sdl2"
    if isPlatform "x11"; then
        audio_opts+=" pulse"
    fi

    local ini_options=(
        'video_smooth true false'
        'aspect_ratio_index _id_ 4:3 16:9 16:10 16:15 1:1 2:1 3:2 3:4 4:1 4:4 5:4 6:5 7:9 8:3 8:7 19:12 19:14 30:17 32:9 config square core custom'
        'video_shader_enable true false'
        "video_shader _file_ *.*p $rootdir/emulators/retroarch/shader"
        'input_overlay_enable true false'
        "input_overlay _file_ *.cfg $rootdir/emulators/retroarch/overlays"
        "audio_driver $audio_opts"
        'video_driver gl dispmanx sdl2 vg vulkan'
        'menu_driver rgui xmb'
        'video_fullscreen_x _string_'
        'video_fullscreen_y _string_'
        'video_frame_delay _string_'
        'video_threaded true false'
        'video_force_aspect true false'
        'video_scale_integer true false'
        'video_aspect_ratio_auto true false'
        'video_aspect_ratio _string_'
        'video_allow_rotate true false'
        'video_rotation 0 1 2 3'
        'custom_viewport_width _string_'
        'custom_viewport_height _string_'
        'custom_viewport_x _string_'
        'custom_viewport_y _string_'
        'video_font_size _string_'
        'fps_show true false'
        'input_overlay_opacity _string_'
        'input_overlay_scale _string_'
        'input_joypad_driver udev sdl2 linuxraw'
        'game_specific_options true false'
        'input_player1_joypad_index _string_'
        'input_player2_joypad_index _string_'
        'input_player3_joypad_index _string_'
        'input_player4_joypad_index _string_'
        'input_player5_joypad_index _string_'
        'input_player6_joypad_index _string_'
        'input_player7_joypad_index _string_'
        'input_player8_joypad_index _string_'
        'input_player1_analog_dpad_mode _id_ disabled left-stick right-stick'
        'input_player2_analog_dpad_mode _id_ disabled left-stick right-stick'
        'input_player3_analog_dpad_mode _id_ disabled left-stick right-stick'
        'input_player4_analog_dpad_mode _id_ disabled left-stick right-stick'
        'input_player5_analog_dpad_mode _id_ disabled left-stick right-stick'
        'input_player6_analog_dpad_mode _id_ disabled left-stick right-stick'
        'input_player7_analog_dpad_mode _id_ disabled left-stick right-stick'
        'input_player8_analog_dpad_mode _id_ disabled left-stick right-stick'

    )

    local ini_descs=(
        'Suaviza la imagen con filtrado bilineal. Se debe desactivar si se utilizan shaders de píxeles.'
        'Aspect ratio para usar (por defecto no establecido - usara el core aspect si video_aspect_ratio_auto es verdadero)'
        'Cargar video_shader en el inicio. Otros shaders se pueden cargar mas tarde en tiempo de ejecucion.'
        'Video shader para usar (por defecto ninguno)'
        'Cargar overlay en el inicio. Otros overlays se pueden cargar mas tarde en tiempo de ejecucion.'
        'Input overlay para usar (por defecto ninguno)'
        'Controlador de audio a usar (por defecto es alsathread)'
        'Controlador de video a usar (por defecto es gl)'
        'Menu driver para usar'
        'Fullscreen x resolution. Resolution of 0 uses the resolution of the desktop. (defaults to 0 if unset)'
        'Fullscreen y resolution. Resolution of 0 uses the resolution of the desktop. (defaults to 0 if unset)'
        'Establece cuántos milisegundos se demoran después de VSync antes de ejecutar el core. Puede reducir la latencia al costo de un mayor riesgo de parpadeo. El maximo es 15'
        'Use threaded video driver. Using this might improve performance at possible cost of latency and more video stuttering.'
        'Forces rendering area to stay equal to content aspect ratio or as defined in video_aspect_ratio.'
        'Only scales video in integer steps. The base size depends on system-reported geometry and aspect ratio. If video_force_aspect is not set, X/Y will be integer scaled independently.'
        'If this is true and video_aspect_ratio or video_aspect_ratio_index is not set, aspect ratio is decided by libretro implementation. If this is false, 1:1 PAR will always be assumed if video_aspect_ratio or  video_aspect_ratio_index is not set.'
        'A floating point value for video aspect ratio (width / height). If this is not set, aspect ratio is assumed to be automatic. Behavior then is defined by video_aspect_ratio_auto.'
        'Allows libretro cores to set rotation modes. Setting this to false will honor, but ignore this request. This is useful for vertically oriented content where one manually rotates the monitor. (defaults to true)'
        'Forces a certain rotation of the screen. The rotation is added to rotations which the libretro core sets (see video_allow_rotate). The angle is <value> * 90 degrees counter-clockwise.'
        'Viewport resolution.'
        'Viewport resolution.'
        'Viewport position x.'
        'Viewport position y.'
        'Size of the OSD font.'
        'Show current frames per second.'
        'Opacity of overlay. Float value 1.000000.'
        'Scale of overlay. Float value 1.000000.'
        'Input joypad driver to use (default is udev)'
        'Game specific core options in retroarch-core-options.cfg, rather than for all games via that core.'
        'Seleccion manual del orden del joypad'
        'Seleccion manual del orden del joypad'
        'Seleccion manual del orden del joypad'
        'Seleccion manual del orden del joypad'
        'Seleccion manual del orden del joypad'
        'Seleccion manual del orden del joypad'
        'Seleccion manual del orden del joypad'
        'Seleccion manual del orden del joypad'
        'Permitir que los sticks analogicos se utilicen como d-pad - 0 = deshabilitado, 1 = stick izquierdo, 2 = stick derecho'
        'Permitir que los sticks analogicos se utilicen como d-pad - 0 = deshabilitado, 1 = stick izquierdo, 2 = stick derecho'
        'Permitir que los sticks analogicos se utilicen como d-pad - 0 = deshabilitado, 1 = stick izquierdo, 2 = stick derecho'
        'Permitir que los sticks analogicos se utilicen como d-pad - 0 = deshabilitado, 1 = stick izquierdo, 2 = stick derecho'
        'Permitir que los sticks analogicos se utilicen como d-pad - 0 = deshabilitado, 1 = stick izquierdo, 2 = stick derecho'
        'Permitir que los sticks analogicos se utilicen como d-pad - 0 = deshabilitado, 1 = stick izquierdo, 2 = stick derecho'
        'Permitir que los sticks analogicos se utilicen como d-pad - 0 = deshabilitado, 1 = stick izquierdo, 2 = stick derecho'
        'Permitir que los sticks analogicos se utilicen como d-pad - 0 = deshabilitado, 1 = stick izquierdo, 2 = stick derecho'

    )

    iniFileEditor " = " '"' "$config"
}

function choose_config_configedit() {
    local path="$1"
    local include="$2"
    local exclude="$3"
    local cmd=(dialog --backtitle "$__backtitle" --menu "¿Que configuracion te gustaria editar?" 22 76 16)
    local configs=()
    local options=()
    local config
    local i=0
    while read config; do
        config=${config//$path\//}
        configs+=("$config")
        options+=("$i" "$config")
        ((i++))
    done < <(find "$path" -type f -regex "$include" ! -regex "$exclude" ! -regex ".*/downloaded_images/.*" | sort)
    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
    if [[ -n "$choice" ]]; then
        echo "${configs[choice]}"
    fi
}

function basic_menu_configedit() {
    while true; do
        local cmd=(dialog --backtitle "$__backtitle" --menu "¿Qué plataforma quieres ajustar?" 22 76 16)
        local configs=()
        local options=()
        local config
        local dir
        local desc
        local i=0
        while read config; do
            configs+=("$config")
            dir=${config%/*}
            dir=${dir//$configdir\//}
            if [[ "$dir" == "all" ]]; then
                desc="Configurar las opciones por defecto para todos los emuladores libretro."
            else
                desc="Configurar opciones adicionales para $dir"
            fi
            options+=("$i" "$desc")
            ((i++))
        done < <(find "$configdir" -type f -regex ".*/retroarch.cfg" | sort)
        local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        if [[ -n "$choice" ]]; then
            basic_configedit "${configs[choice]}"
        else
            break
        fi
    done
}

function advanced_menu_configedit() {
    while true; do
        local cmd=(dialog --backtitle "$__backtitle" --menu "Elija una opcion" 22 76 16)
        local options=(
            1 "Configurar opciones de Libretro"
            2 "Editar manualmente las configuraciones de RetroArch."
            3 "Editar manualmente configuraciones globales"
            4 "Editar manualmente configuraciones no RetroArch"
            5 "Editar manualmente todas las configuraciones"
        )
        local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        local file="-"
        if [[ -n "$choice" ]]; then
            while [[ -n "$file" ]]; do
                case "$choice" in
                    1)
                        file=$(choose_config_configedit "$configdir" ".*/retroarch.cfg")
                        advanced_configedit "$configdir/$file" 2
                        ;;
                    2)
                        file=$(choose_config_configedit "$configdir" ".*/retroarch.*")
                        editFile "$configdir/$file"
                        ;;
                    3)
                        file=$(choose_config_configedit "$configdir" ".*/all/.*")
                        editFile "$configdir/$file"
                        ;;
                    4)
                        file=$(choose_config_configedit "$configdir" ".*" ".*retroarch.*")
                        editFile "$configdir/$file"
                        ;;
                    5)
                        file=$(choose_config_configedit "$configdir" ".*")
                        editFile "$configdir/$file"
                        ;;
                esac
            done
        else
            break
        fi
    done
}

function gui_configedit() {
    while true; do
        local cmd=(dialog --backtitle "$__backtitle" --menu "Elija una opcion" 22 76 16)
        local options=(
            1 "Configurar las opciones basicas del emulador libretro"
            2 "Configuracion Avanzada"
        )
        local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        local file="-"
        if [[ -n "$choice" ]]; then
            case $choice in
                1)
                    basic_menu_configedit
                    ;;
                2)
                    advanced_menu_configedit
                    ;;
            esac
        else
            break
        fi
    done
}
