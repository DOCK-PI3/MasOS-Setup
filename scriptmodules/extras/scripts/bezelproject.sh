#!/bin/bash
rp_module_id="bezelproject"
rp_module_desc="BezelPrject en MasOS"
rp_module_section=""


# Welcome
 dialog --backtitle "The Bezel Project" --title "The Bezel Project - Bezel Pack Utility" \
    --yesno "\nMenu Bezel Project Utility.\n\nEsta utilidad proporcionará una descarga para los paquetes de bezels del sistema Retroarach para ser utilizado en varios sistemas dentro de MasOS.\n\nEstos paquetes de bezels solo funcionaran si las ROM que está utilizando reciben el nombre según NO-intro utilizada por EmuMovies/HyperSpin.\n\nEsta utilidad proporciona una descarga para un paquete de bezels para un sistema e incluye un archivo de bezel PNG para cada ROM de ese sistema. La descarga tambien incluira los archivos de configuracion necesarios necesarios para Retroarch para mostrarlos. El script tambien actualizara los archivos retroarch.cfg necesarios para los emuladores ubicados en el directorio /opt/masos/configs. Estos cambios son necesarios para mostrar los bezels PNG con una opacidad de 1.\n\nPor regla general, se completan los nuevos paquetes de bezels y debera ejecutar el actualizador de scripts para descargar la version mas nueva y ver estos paquetes adicionales.\n\n* * NOTA **\nEl marco del bezel MAME esta incluido para las roms ubicadas en las carpetas arcade /fba/mame-libretro rom.\n\n\n¿Desea continuar?" \
    28 110 2>&1 > /dev/tty \
    || exit


function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MENU PRINCIPAL " \
            --ok-label OK --cancel-label Exit \
            --menu "Elija una opcion" 25 75 20 \
            1 "Descargar pack bezel de sistema (automaticamente habilita los bezels)" \
            2 "Habilitar pack bezel de sistema" \
            3 "Deshabilitar pack bezel de sistema" \
            4 "Informacion:  Retroarch cores setup de bezels por sistema" \
			2>&1 > /dev/tty)

        case "$choice" in
            1) download_bezel  ;;
            2) enable_bezel  ;;
            3) disable_bezel  ;;
            4) retroarch_bezelinfo  ;;
            *)  break ;;
        esac
    done
}

#########################################################
# Functions for download and enable/disable bezel packs #
#########################################################

function install_bezel_pack() {
    local theme="$1"
    local repo="$2"
    if [[ -z "$repo" ]]; then
        repo="default"
    fi
    if [[ -z "$theme" ]]; then
        theme="default"
        repo="default"
    fi
    atheme=`echo ${theme} | sed 's/.*/\L&/'`

    if [[ "${atheme}" == "mame" ]];then
      mv "/opt/masos/configs/all/retroarch/config/disable_FB Alpha" "/opt/masos/configs/all/retroarch/config/FB Alpha" 2> /dev/null
      mv "/opt/masos/configs/all/retroarch/config/disable_MAME 2003" "/opt/masos/configs/all/retroarch/config/MAME 2003" 2> /dev/null
      mv "/opt/masos/configs/all/retroarch/config/disable_MAME 2010" "/opt/masos/configs/all/retroarch/config/MAME 2010" 2> /dev/null
    fi

    git clone "https://github.com/$repo/bezelproject-$theme.git" "/tmp/${theme}"
    cp -r "/tmp/${theme}/retroarch/" /opt/masos/configs/all/
    sudo rm -rf "/tmp/${theme}"

    if [[ "${atheme}" == "mame" ]];then
      show_bezel "arcade"
      show_bezel "fba"
      show_bezel "mame-libretro"
    else
      show_bezel "${atheme}"
    fi
}

function uninstall_bezel_pack() {
    local theme="$1"
    if [[ -d "/opt/masos/configs/all/retroarch/overlay/GameBezels/$theme" ]]; then
        rm -rf "/opt/masos/configs/all/retroarch/overlay/GameBezels/$theme"
    fi
    if [[ "${theme}" == "MAME" ]]; then
      if [[ -d "/opt/masos/configs/all/retroarch/overlay/ArcadeBezels" ]]; then
        rm -rf "/opt/masos/configs/all/retroarch/overlay/ArcadeBezels"
      fi
    fi
}

function download_bezel() {
    local themes=(
        'thebezelproject MAME'
        'thebezelproject Atari5200'
        'thebezelproject Atari7800'
        'thebezelproject GCEVectrex'
        'thebezelproject MasterSystem'
        'thebezelproject MegaDrive'
        'thebezelproject NES'
        'thebezelproject Sega32X'
        'thebezelproject SG-1000'
        'thebezelproject SNES'
        'thebezelproject SuperGrafx'
    )
    while true; do
        local theme
        local installed_bezelpacks=()
        local repo
        local options=()
        local status=()
        local default

        options+=(U "Actualizar el script - el script se cerrara despues de actualizarse")

        local i=1
        for theme in "${themes[@]}"; do
            theme=($theme)
            repo="${theme[0]}"
            theme="${theme[1]}"
            if [[ -d "/opt/masos/configs/all/retroarch/overlay/GameBezels/$theme" ]]; then
                status+=("i")
                options+=("$i" "Actualizar o Desinstalar $theme (instalado)")
                installed_bezelpacks+=("$theme $repo")
            else
                status+=("n")
                options+=("$i" "Instalar $theme (no instalado)")
            fi
            ((i++))
        done
        local cmd=(dialog --default-item "$default" --backtitle "$__backtitle" --menu "The Bezel Project -  Bezel Pack Downloader - Elija una opcion" 22 76 16)
        local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
        default="$choice"
        [[ -z "$choice" ]] && break
        case "$choice" in
            U)  #update install script to get new theme listings
                cd "/home/pi/RetroPie/scripts" 
                mv "bezelproject.sh" "bezelproject.sh.bkp" 
                wget "https://raw.githubusercontent.com/Moriggy/BezelProject/master/bezelproject.sh" 
                chmod 777 "bezelproject.sh" 
                exit
                ;;
            *)  #install or update themes
                theme=(${themes[choice-1]})
                repo="${theme[0]}"
                theme="${theme[1]}"
#                if [[ "${status[choice]}" == "i" ]]; then
                if [[ -d "/opt/masos/configs/all/retroarch/overlay/GameBezels/$theme" ]]; then
                    options=(1 "Actualizar $theme" 2 "Desinstalar $theme")
                    cmd=(dialog --backtitle "$__backtitle" --menu "Elija una opcion de pack de bezel" 12 40 06)
                    local choice=$("${cmd[@]}" "${options[@]}" 2>&1 >/dev/tty)
                    case "$choice" in
                        1)
                            install_bezel_pack "$theme" "$repo"
                            ;;
                        2)
                            uninstall_bezel_pack "$theme"
                            ;;
                    esac
                else
                    install_bezel_pack "$theme" "$repo"
                fi
                ;;
        esac
    done
}


function disable_bezel() {

clear
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MENU PRINCIPAL " \
            --ok-label OK --cancel-label Exit \
            --menu "Que sistema quieres deshabilitar los bezels?" 25 75 20 \
            1 "GCEVectrex" \
            2 "SuperGrafx" \
            3 "Sega32X" \
            4 "SG-1000" \
            5 "Arcade" \
            6 "Final Burn Alpha" \
            7 "MAME Libretro" \
            8 "NES" \
            9 "MasterSystem" \
            10 "Atari 5200" \
            11 "Atari 7800" \
            12 "SNES" \
            13 "MegaDrive" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) hide_bezel vectrex ;;
            2) hide_bezel supergrafx ;;
            3) hide_bezel sega32x ;;
            4) hide_bezel sg-1000 ;;
            5) hide_bezel arcade ;;
            6) hide_bezel fba ;;
            7) hide_bezel mame-libretro ;;
            8) hide_bezel nes ;;
            9) hide_bezel mastersystem ;;
            10) hide_bezel atari5200 ;;
            11) hide_bezel atari7800 ;;
            12) hide_bezel snes ;;
            13) hide_bezel megadrive ;;
            *)  break ;;
        esac
    done

}

function enable_bezel() {
sudo chown -R pi:pi /opt/masos/
clear
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MENU PRINCIPAL " \
            --ok-label OK --cancel-label Exit \
            --menu "Que sistema quieres habilitar los bezels?" 25 75 20 \
            1 "GCEVectrex" \
            2 "SuperGrafx" \
            3 "Sega32X" \
            4 "SG-1000" \
            5 "Arcade" \
            6 "Final Burn Alpha" \
            7 "MAME Libretro" \
            8 "NES" \
            9 "MasterSystem" \
            10 "Atari 5200" \
            11 "Atari 7800" \
            12 "SNES" \
            13 "MegaDrive" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) show_bezel gcevectrex ;;
            2) show_bezel supergrafx ;;
            3) show_bezel sega32x ;;
            4) show_bezel sg-1000 ;;
            5) show_bezel arcade ;;
            6) show_bezel fba ;;
            7) show_bezel mame-libretro ;;
            8) show_bezel nes ;;
            9) show_bezel mastersystem ;;
            10) show_bezel atari5200 ;;
            11) show_bezel atari7800 ;;
            12) show_bezel snes ;;
            13) show_bezel megadrive ;;
            *)  break ;;
        esac
    done

}

function hide_bezel() {
dialog --infobox "...procesando..." 3 20 ; sleep 2
emulator=$1
file="/opt/masos/configs/${emulator}/retroarch.cfg"

case ${emulator} in
arcade)
  cp /opt/masos/configs/${emulator}/retroarch.cfg /opt/masos/configs/${emulator}/retroarch.cfg.bkp
  cat /opt/masos/configs/${emulator}/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
  cp /tmp/retroarch.cfg /opt/masos/configs/${emulator}/retroarch.cfg
  mv "/opt/masos/configs/all/retroarch/config/FB Alpha" "/opt/masos/configs/all/retroarch/config/disable_FB Alpha"
  mv "/opt/masos/configs/all/retroarch/config/MAME 2003" "/opt/masos/configs/all/retroarch/config/disable_MAME 2003"
  mv "/opt/masos/configs/all/retroarch/config/MAME 2010" "/opt/masos/configs/all/retroarch/config/disable_MAME 2010"
  ;;
fba)
  cp /opt/masos/configs/${emulator}/retroarch.cfg /opt/masos/configs/${emulator}/retroarch.cfg.bkp
  cat /opt/masos/configs/${emulator}/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
  cp /tmp/retroarch.cfg /opt/masos/configs/${emulator}/retroarch.cfg
  mv "/opt/masos/configs/all/retroarch/config/FB Alpha" "/opt/masos/configs/all/retroarch/config/disable_FB Alpha"
  ;;
mame-libretro)
  cp /opt/masos/configs/${emulator}/retroarch.cfg /opt/masos/configs/${emulator}/retroarch.cfg.bkp
  cat /opt/masos/configs/${emulator}/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
  cp /tmp/retroarch.cfg /opt/masos/configs/${emulator}/retroarch.cfg
  mv "/opt/masos/configs/all/retroarch/config/MAME 2003" "/opt/masos/configs/all/retroarch/config/disable_MAME 2003"
  mv "/opt/masos/configs/all/retroarch/config/MAME 2010" "/opt/masos/configs/all/retroarch/config/disable_MAME 2010"
  ;;
*)
  cp /opt/masos/configs/${emulator}/retroarch.cfg /opt/masos/configs/${emulator}/retroarch.cfg.bkp
  cat /opt/masos/configs/${emulator}/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
  cp /tmp/retroarch.cfg /opt/masos/configs/${emulator}/retroarch.cfg
  ;;
esac

}

function show_bezel() {
dialog --infobox "...procesando..." 3 20 ; sleep 2
emulator=$1
file="/opt/masos/configs/${emulator}/retroarch.cfg"

case ${emulator} in
arcade)
  ifexist=`cat /opt/masos/configs/arcade/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/arcade/retroarch.cfg /opt/masos/configs/arcade/retroarch.cfg.bkp
    cat /opt/masos/configs/arcade/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/arcade/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/MAME-Horizontal.cfg"' /opt/masos/configs/arcade/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/arcade/retroarch.cfg
    mv "/opt/masos/configs/all/retroarch/config/disable_FB Alpha" "/opt/masos/configs/all/retroarch/config/FB Alpha"
    mv "/opt/masos/configs/all/retroarch/config/disable_MAME 2003" "/opt/masos/configs/all/retroarch/config/MAME 2003"
    mv "/opt/masos/configs/all/retroarch/config/disable_MAME 2010" "/opt/masos/configs/all/retroarch/config/MAME 2010"
  else
    cp /opt/masos/configs/arcade/retroarch.cfg /opt/masos/configs/arcade/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/MAME-Horizontal.cfg"' /opt/masos/configs/arcade/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/arcade/retroarch.cfg
    mv "/opt/masos/configs/all/retroarch/config/disable_FB Alpha" "/opt/masos/configs/all/retroarch/config/FB Alpha"
    mv "/opt/masos/configs/all/retroarch/config/disable_MAME 2003" "/opt/masos/configs/all/retroarch/config/MAME 2003"
    mv "/opt/masos/configs/all/retroarch/config/disable_MAME 2010" "/opt/masos/configs/all/retroarch/config/MAME 2010"
  fi
  ;;
fba)
  ifexist=`cat /opt/masos/configs/fba/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/fba/retroarch.cfg /opt/masos/configs/fba/retroarch.cfg.bkp
    cat /opt/masos/configs/fba/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/fba/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/MAME-Horizontal.cfg"' /opt/masos/configs/fba/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/fba/retroarch.cfg
    mv "/opt/masos/configs/all/retroarch/config/disable_FB Alpha" "/opt/masos/configs/all/retroarch/config/FB Alpha"
  else
    cp /opt/masos/configs/fba/retroarch.cfg /opt/masos/configs/fba/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/MAME-Horizontal.cfg"' /opt/masos/configs/fba/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/fba/retroarch.cfg
    mv "/opt/masos/configs/all/retroarch/config/disable_FB Alpha" "/opt/masos/configs/all/retroarch/config/FB Alpha"
  fi
  ;;
mame-libretro)
  ifexist=`cat /opt/masos/configs/mame-libretro/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/mame-libretro/retroarch.cfg /opt/masos/configs/mame-libretro/retroarch.cfg.bkp
    cat /opt/masos/configs/mame-libretro/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/mame-libretro/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/MAME-Horizontal.cfg"' /opt/masos/configs/mame-libretro/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/mame-libretro/retroarch.cfg
    mv "/opt/masos/configs/all/retroarch/config/disable_MAME 2003" "/opt/masos/configs/all/retroarch/config/MAME 2003"
    mv "/opt/masos/configs/all/retroarch/config/disable_MAME 2010" "/opt/masos/configs/all/retroarch/config/MAME 2010"
  else
    cp /opt/masos/configs/mame-libretro/retroarch.cfg /opt/masos/configs/mame-libretro/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/MAME-Horizontal.cfg"' /opt/masos/configs/mame-libretro/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/mame-libretro/retroarch.cfg
    mv "/opt/masos/configs/all/retroarch/config/disable_MAME 2003" "/opt/masos/configs/all/retroarch/config/MAME 2003"
    mv "/opt/masos/configs/all/retroarch/config/disable_MAME 2010" "/opt/masos/configs/all/retroarch/config/MAME 2010"
  fi
  ;;
atari2600)
  ifexist=`cat /opt/masos/configs/atari2600/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/atari2600/retroarch.cfg /opt/masos/configs/atari2600/retroarch.cfg.bkp
    cat /opt/masos/configs/atari2600/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/atari2600/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Atari-2600.cfg"' /opt/masos/configs/atari2600/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/atari2600/retroarch.cfg
  else
    cp /opt/masos/configs/atari2600/retroarch.cfg /opt/masos/configs/atari2600/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Atari-2600.cfg"' /opt/masos/configs/atari2600/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/atari2600/retroarch.cfg
  fi
  ;;
atari5200)
  ifexist=`cat /opt/masos/configs/atari5200/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/atari5200/retroarch.cfg /opt/masos/configs/atari5200/retroarch.cfg.bkp
    cat /opt/masos/configs/atari5200/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/atari5200/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Atari-5200.cfg"' /opt/masos/configs/atari5200/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/atari5200/retroarch.cfg
  else
    cp /opt/masos/configs/atari5200/retroarch.cfg /opt/masos/configs/atari5200/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Atari-5200.cfg"' /opt/masos/configs/atari5200/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/atari5200/retroarch.cfg
  fi
  ;;
atari7800)
  ifexist=`cat /opt/masos/configs/atari7800/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/atari7800/retroarch.cfg /opt/masos/configs/atari7800/retroarch.cfg.bkp
    cat /opt/masos/configs/atari7800/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/atari7800/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Atari-7800.cfg"' /opt/masos/configs/atari7800/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/atari7800/retroarch.cfg
  else
    cp /opt/masos/configs/atari7800/retroarch.cfg /opt/masos/configs/atari7800/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Atari-7800.cfg"' /opt/masos/configs/atari7800/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/atari7800/retroarch.cfg
  fi
  ;;
coleco)
  ifexist=`cat /opt/masos/configs/coleco/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/coleco/retroarch.cfg /opt/masos/configs/coleco/retroarch.cfg.bkp
    cat /opt/masos/configs/coleco/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/coleco/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Colecovision.cfg"' /opt/masos/configs/coleco/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/coleco/retroarch.cfg
  else
    cp /opt/masos/configs/coleco/retroarch.cfg /opt/masos/configs/coleco/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Colecovision.cfg"' /opt/masos/configs/coleco/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/coleco/retroarch.cfg
  fi
  ;;
famicom)
  ifexist=`cat /opt/masos/configs/famicom/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/famicom/retroarch.cfg /opt/masos/configs/famicom/retroarch.cfg.bkp
    cat /opt/masos/configs/famicom/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/famicom/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-Famicom.cfg"' /opt/masos/configs/famicom/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/famicom/retroarch.cfg
  else
    cp /opt/masos/configs/famicom/retroarch.cfg /opt/masos/configs/famicom/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-Famicom.cfg"' /opt/masos/configs/famicom/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/famicom/retroarch.cfg
  fi
  ;;
fds)
  ifexist=`cat /opt/masos/configs/fds/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/fds/retroarch.cfg /opt/masos/configs/fds/retroarch.cfg.bkp
    cat /opt/masos/configs/fds/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/fds/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-Famicom-Disk-System.cfg"' /opt/masos/configs/fds/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/fds/retroarch.cfg
  else
    cp /opt/masos/configs/fds/retroarch.cfg /opt/masos/configs/fds/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-Famicom-Disk-System.cfg"' /opt/masos/configs/fds/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/fds/retroarch.cfg
  fi
  ;;
mastersystem)
  ifexist=`cat /opt/masos/configs/mastersystem/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/mastersystem/retroarch.cfg /opt/masos/configs/mastersystem/retroarch.cfg.bkp
    cat /opt/masos/configs/mastersystem/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/mastersystem/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sega-Master-System.cfg"' /opt/masos/configs/mastersystem/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/mastersystem/retroarch.cfg
  else
    cp /opt/masos/configs/mastersystem/retroarch.cfg /opt/masos/configs/mastersystem/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sega-Master-System.cfg"' /opt/masos/configs/mastersystem/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/mastersystem/retroarch.cfg
  fi
  ;;
megadrive)
  ifexist=`cat /opt/masos/configs/megadrive/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/megadrive/retroarch.cfg /opt/masos/configs/megadrive/retroarch.cfg.bkp
    cat /opt/masos/configs/megadrive/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/megadrive/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sega-Mega-Drive.cfg"' /opt/masos/configs/megadrive/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/megadrive/retroarch.cfg
  else
    cp /opt/masos/configs/megadrive/retroarch.cfg /opt/masos/configs/megadrive/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sega-Mega-Drive.cfg"' /opt/masos/configs/megadrive/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/megadrive/retroarch.cfg
  fi
  ;;
megadrive-japan)
  ifexist=`cat /opt/masos/configs/megadrive-japan/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/megadrive-japan/retroarch.cfg /opt/masos/configs/megadrive-japan/retroarch.cfg.bkp
    cat /opt/masos/configs/megadrive-japan/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/megadrive-japan/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sega-Mega-Drive-Japan.cfg"' /opt/masos/configs/megadrive-japan/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/megadrive-japan/retroarch.cfg
  else
    cp /opt/masos/configs/megadrive-japan/retroarch.cfg /opt/masos/configs/megadrive-japan/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sega-Mega-Drive-Japan.cfg"' /opt/masos/configs/megadrive-japan/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/megadrive-japan/retroarch.cfg
  fi
  ;;
n64)
  ifexist=`cat /opt/masos/configs/n64/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/n6n64/retroarch.cfg /opt/masos/configs/n64/retroarch.cfg.bkp
    cat /opt/masos/configs/n6/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/n64/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-64.cfg"' /opt/masos/configs/n64/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/n64/retroarch.cfg
  else
    cp /opt/masos/configs/n64/retroarch.cfg /opt/masos/configs/n64/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-64.cfg"' /opt/masos/configs/n64/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/n64/retroarch.cfg
  fi
  ;;
neogeo)
  ifexist=`cat /opt/masos/configs/neogeo/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/neogeo/retroarch.cfg /opt/masos/configs/neogeo/retroarch.cfg.bkp
    cat /opt/masos/configs/neogeo/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/neogeo/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/MAME-Horizontal.cfg"' /opt/masos/configs/neogeo/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/neogeo/retroarch.cfg
  else
    cp /opt/masos/configs/neogeo/retroarch.cfg /opt/masos/configs/neogeo/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/MAME-Horizontal.cfg"' /opt/masos/configs/neogeo/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/neogeo/retroarch.cfg
  fi
  ;;
nes)
  ifexist=`cat /opt/masos/configs/nes/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/nes/retroarch.cfg /opt/masos/configs/nes/retroarch.cfg.bkp
    cat /opt/masos/configs/nes/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport |grep -v force_aspect > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/nes/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-Entertainment-System.cfg"' /opt/masos/configs/nes/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/nes/retroarch.cfg
    sed -i '4i aspect_ratio_index = "16"' /opt/masos/configs/nes/retroarch.cfg
    sed -i '5i video_force_aspect = "true"' /opt/masos/configs/nes/retroarch.cfg
    sed -i '6i video_aspect_ratio = "-1.000000"' /opt/masos/configs/nes/retroarch.cfg
  else
    cp /opt/masos/configs/nes/retroarch.cfg /opt/masos/configs/nes/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-Entertainment-System.cfg"' /opt/masos/configs/nes/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/nes/retroarch.cfg
    sed -i '4i aspect_ratio_index = "16"' /opt/masos/configs/nes/retroarch.cfg
    sed -i '5i video_force_aspect = "true"' /opt/masos/configs/nes/retroarch.cfg
    sed -i '6i video_aspect_ratio = "-1.000000"' /opt/masos/configs/nes/retroarch.cfg
  fi
  ;;
pce-cd)
  ifexist=`cat /opt/masos/configs/pce-cd/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/pce-cd/retroarch.cfg /opt/masos/configs/pce-cd/retroarch.cfg.bkp
    cat /opt/masos/configs/pce-cd/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/pce-cd/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/NEC-PC-Engine-CD.cfg"' /opt/masos/configs/pce-cd/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/pce-cd/retroarch.cfg
  else
    cp /opt/masos/configs/pce-cd/retroarch.cfg /opt/masos/configs/pce-cd/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/NEC-PC-Engine-CD.cfg"' /opt/masos/configs/pce-cd/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/pce-cd/retroarch.cfg
  fi
  ;;
pcengine)
  ifexist=`cat /opt/masos/configs/pcengine/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/pcengine/retroarch.cfg /opt/masos/configs/pcengine/retroarch.cfg.bkp
    cat /opt/masos/configs/pcengine/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/pcengine/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/NEC-PC-Engine.cfg"' /opt/masos/configs/pcengine/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/pcengine/retroarch.cfg
  else
    cp /opt/masos/configs/pcengine/retroarch.cfg /opt/masos/configs/pcengine/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/NEC-PC-Engine.cfg"' /opt/masos/configs/pcengine/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/pcengine/retroarch.cfg
  fi
  ;;
psx)
  ifexist=`cat /opt/masos/configs/psx/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/psx/retroarch.cfg /opt/masos/configs/psx/retroarch.cfg.bkp
    cat /opt/masos/configs/psx/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/psx/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sony-PlayStation.cfg"' /opt/masos/configs/psx/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/psx/retroarch.cfg
  else
    cp /opt/masos/configs/psx/retroarch.cfg /opt/masos/configs/psx/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sony-PlayStation.cfg"' /opt/masos/configs/psx/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/psx/retroarch.cfg
  fi
  ;;
sega32x)
  ifexist=`cat /opt/masos/configs/sega32x/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/sega32x/retroarch.cfg /opt/masos/configs/sega32x/retroarch.cfg.bkp
    cat /opt/masos/configs/sega32x/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/sega32x/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sega-32X.cfg"' /opt/masos/configs/sega32x/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/sega32x/retroarch.cfg
  else
    cp /opt/masos/configs/sega32x/retroarch.cfg /opt/masos/configs/sega32x/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sega-32X.cfg"' /opt/masos/configs/sega32x/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/sega32x/retroarch.cfg
  fi
  ;;
segacd)
  ifexist=`cat /opt/masos/configs/segacd/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/segacd/retroarch.cfg /opt/masos/configs/segacd/retroarch.cfg.bkp
    cat /opt/masos/configs/segacd/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/segacd/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sega-CD.cfg"' /opt/masos/configs/segacd/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/segacd/retroarch.cfg
  else
    cp /opt/masos/configs/segacd/retroarch.cfg /opt/masos/configs/segacd/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sega-CD.cfg"' /opt/masos/configs/segacd/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/segacd/retroarch.cfg
  fi
  ;;
sfc)
  ifexist=`cat /opt/masos/configs/sfc/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/sfc/retroarch.cfg /opt/masos/configs/sfc/retroarch.cfg.bkp
    cat /opt/masos/configs/sfc/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/sfc/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-Super-Famicom.cfg"' /opt/masos/configs/sfc/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/sfc/retroarch.cfg
  else
    cp /opt/masos/configs/sfc/retroarch.cfg /opt/masos/configs/sfc/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-Super-Famicom.cfg"' /opt/masos/configs/sfc/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/sfc/retroarch.cfg
  fi
  ;;
sg-1000)
  ifexist=`cat /opt/masos/configs/sg-1000/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/sg-1000/retroarch.cfg /opt/masos/configs/sg-1000/retroarch.cfg.bkp
    cat /opt/masos/configs/sg-1000/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/sg-1000/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sega-SG-1000.cfg"' /opt/masos/configs/sg-1000/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/sg-1000/retroarch.cfg
  else
    cp /opt/masos/configs/sg-1000/retroarch.cfg /opt/masos/configs/sg-1000/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sega-SG-1000.cfg"' /opt/masos/configs/sg-1000/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/sg-1000/retroarch.cfg
  fi
  ;;
snes)
  ifexist=`cat /opt/masos/configs/snes/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/snes/retroarch.cfg /opt/masos/configs/snes/retroarch.cfg.bkp
    cat /opt/masos/configs/snes/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/snes/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Super-Nintendo-Entertainment-System.cfg"' /opt/masos/configs/snes/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/snes/retroarch.cfg
  else
    cp /opt/masos/configs/snes/retroarch.cfg /opt/masos/configs/snes/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Super-Nintendo-Entertainment-System.cfg"' /opt/masos/configs/snes/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/snes/retroarch.cfg
  fi
  ;;
supergrafx)
  ifexist=`cat /opt/masos/configs/supergrafx/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/supergrafx/retroarch.cfg /opt/masos/configs/supergrafx/retroarch.cfg.bkp
    cat /opt/masos/configs/supergrafx/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/supergrafx/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/NEC-SuperGrafx.cfg"' /opt/masos/configs/supergrafx/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/supergrafx/retroarch.cfg
  else
    cp /opt/masos/configs/supergrafx/retroarch.cfg /opt/masos/configs/supergrafx/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/NEC-SuperGrafx.cfg"' /opt/masos/configs/supergrafx/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/supergrafx/retroarch.cfg
  fi
  ;;
tg16)
  ifexist=`cat /opt/masos/configs/tg16/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/tg16/retroarch.cfg /opt/masos/configs/tg16/retroarch.cfg.bkp
    cat /opt/masos/configs/tg16/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/tg16/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/NEC-TurboGrafx-16.cfg"' /opt/masos/configs/tg16/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/tg16/retroarch.cfg
  else
    cp /opt/masos/configs/tg16/retroarch.cfg /opt/masos/configs/tg16/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/NEC-TurboGrafx-16.cfg"' /opt/masos/configs/tg16/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/tg16/retroarch.cfg
  fi
  ;;
tg-cd)
  ifexist=`cat /opt/masos/configs/tg-cd/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/tg-cd/retroarch.cfg /opt/masos/configs/tg-cd/retroarch.cfg.bkp
    cat /opt/masos/configs/tg-cd/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/tg-cd/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/NEC-TurboGrafx-CD.cfg"' /opt/masos/configs/tg-cd/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/tg-cd/retroarch.cfg
  else
    cp /opt/masos/configs/tg-cd/retroarch.cfg /opt/masos/configs/tg-cd/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/NEC-TurboGrafx-CD.cfg"' /opt/masos/configs/tg-cd/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/tg-cd/retroarch.cfg
  fi
  ;;
gcevectrex)
  ifexist=`cat /opt/masos/configs/vectrex/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/vectrex/retroarch.cfg /opt/masos/configs/vectrex/retroarch.cfg.bkp
    cat /opt/masos/configs/vectrex/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/vectrex/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/GCE-Vectrex.cfg"' /opt/masos/configs/vectrex/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/vectrex/retroarch.cfg
  else
    cp /opt/masos/configs/vectrex/retroarch.cfg /opt/masos/configs/vectrex/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/GCE-Vectrex.cfg"' /opt/masos/configs/vectrex/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/vectrex/retroarch.cfg
  fi
  ;;
atarilynx_1080)
  ifexist=`cat /opt/masos/configs/atarilynx/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/atarilynx/retroarch.cfg /opt/masos/configs/atarilynx/retroarch.cfg.bkp
    cat /opt/masos/configs/atarilynx/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Atari-Lynx-Horizontal.cfg"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '5i custom_viewport_width = "1010"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '6i custom_viewport_height = "640"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '7i custom_viewport_x = "455"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '8i custom_viewport_y = "225"' /opt/masos/configs/atarilynx/retroarch.cfg
  else
    cp /opt/masos/configs/atarilynx/retroarch.cfg /opt/masos/configs/atarilynx/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Atari-Lynx-Horizontal.cfg"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '5i custom_viewport_width = "1010"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '6i custom_viewport_height = "640"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '7i custom_viewport_x = "455"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '8i custom_viewport_y = "225"' /opt/masos/configs/atarilynx/retroarch.cfg
  fi  
  ;;  
atarilynx_720)
  ifexist=`cat /opt/masos/configs/atarilynx/retroarch.cfg |grep "input_overlay" |wc -l` 
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/atarilynx/retroarch.cfg /opt/masos/configs/atarilynx/retroarch.cfg.bkp
    cat /opt/masos/configs/atarilynx/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Atari-Lynx-Horizontal.cfg"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '5i custom_viewport_width = "670"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '6i custom_viewport_height = "425"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '7i custom_viewport_x = "305"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '8i custom_viewport_y = "150"' /opt/masos/configs/atarilynx/retroarch.cfg
  else
    cp /opt/masos/configs/atarilynx/retroarch.cfg /opt/masos/configs/atarilynx/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Atari-Lynx-Horizontal.cfg"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '5i custom_viewport_width = "670"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '6i custom_viewport_height = "425"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '7i custom_viewport_x = "305"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '8i custom_viewport_y = "150"' /opt/masos/configs/atarilynx/retroarch.cfg
  fi  
  ;;
atarilynx_other)
  ifexist=`cat /opt/masos/configs/atarilynx/retroarch.cfg |grep "input_overlay" |wc -l` 
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/atarilynx/retroarch.cfg /opt/masos/configs/atarilynx/retroarch.cfg.bkp
    cat /opt/masos/configs/atarilynx/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Atari-Lynx-Horizontal.cfg"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '5i custom_viewport_width = "715"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '6i custom_viewport_height = "460"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '7i custom_viewport_x = "325"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '8i custom_viewport_y = "160"' /opt/masos/configs/atarilynx/retroarch.cfg
  else
    cp /opt/masos/configs/atarilynx/retroarch.cfg /opt/masos/configs/atarilynx/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Atari-Lynx-Horizontal.cfg"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '5i custom_viewport_width = "715"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '6i custom_viewport_height = "460"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '7i custom_viewport_x = "325"' /opt/masos/configs/atarilynx/retroarch.cfg
    sed -i '8i custom_viewport_y = "160"' /opt/masos/configs/atarilynx/retroarch.cfg
  fi
  ;;
gamegear_1080)
  ifexist=`cat /opt/masos/configs/gamegear/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/gamegear/retroarch.cfg /opt/masos/configs/gamegear/retroarch.cfg.bkp
    cat /opt/masos/configs/gamegear/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sega-Game-Gear.cfg"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '5i custom_viewport_width = "1160"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '6i custom_viewport_height = "850"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '7i custom_viewport_x = "380"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '8i custom_viewport_y = "120"' /opt/masos/configs/gamegear/retroarch.cfg
  else
    cp /opt/masos/configs/gamegear/retroarch.cfg /opt/masos/configs/gamegear/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sega-Game-Gear.cfg"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '5i custom_viewport_width = "1160"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '6i custom_viewport_height = "850"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '7i custom_viewport_x = "380"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '8i custom_viewport_y = "120"' /opt/masos/configs/gamegear/retroarch.cfg
  fi  
  ;;  
gamegear_720)
  ifexist=`cat /opt/masos/configs/gamegear/retroarch.cfg |grep "input_overlay" |wc -l` 
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/gamegear/retroarch.cfg /opt/masos/configs/gamegear/retroarch.cfg.bkp
    cat /opt/masos/configs/gamegear/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sega-Game-Gear.cfg"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '5i custom_viewport_width = "780"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '6i custom_viewport_height = "580"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '7i custom_viewport_x = "245"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '8i custom_viewport_y = "70"' /opt/masos/configs/gamegear/retroarch.cfg
  else
    cp /opt/masos/configs/gamegear/retroarch.cfg /opt/masos/configs/gamegear/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sega-Game-Gear.cfg"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '5i custom_viewport_width = "780"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '6i custom_viewport_height = "580"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '7i custom_viewport_x = "245"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '8i custom_viewport_y = "70"' /opt/masos/configs/gamegear/retroarch.cfg
  fi  
  ;;
gamegear_other)
  ifexist=`cat /opt/masos/configs/gamegear/retroarch.cfg |grep "input_overlay" |wc -l` 
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/gamegear/retroarch.cfg /opt/masos/configs/gamegear/retroarch.cfg.bkp
    cat /opt/masos/configs/gamegear/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sega-Game-Gear.cfg"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '5i custom_viewport_width = "835"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '6i custom_viewport_height = "625"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '7i custom_viewport_x = "270"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '8i custom_viewport_y = "75"' /opt/masos/configs/gamegear/retroarch.cfg
  else
    cp /opt/masos/configs/gamegear/retroarch.cfg /opt/masos/configs/gamegear/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sega-Game-Gear.cfg"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '5i custom_viewport_width = "835"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '6i custom_viewport_height = "625"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '7i custom_viewport_x = "270"' /opt/masos/configs/gamegear/retroarch.cfg
    sed -i '8i custom_viewport_y = "75"' /opt/masos/configs/gamegear/retroarch.cfg
  fi
  ;;
gb_1080)
  ifexist=`cat /opt/masos/configs/gb/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/gb/retroarch.cfg /opt/masos/configs/gb/retroarch.cfg.bkp
    cat /opt/masos/configs/gb/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/gb/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-Game-Boy.cfg"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '5i custom_viewport_width = "625"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '6i custom_viewport_height = "565"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '7i custom_viewport_x = "645"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '8i custom_viewport_y = "235"' /opt/masos/configs/gb/retroarch.cfg
  else
    cp /opt/masos/configs/gb/retroarch.cfg /opt/masos/configs/gb/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-Game-Boy.cfg"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '5i custom_viewport_width = "625"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '6i custom_viewport_height = "565"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '7i custom_viewport_x = "645"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '8i custom_viewport_y = "235"' /opt/masos/configs/gb/retroarch.cfg
  fi  
  ;;  
gb_720)
  ifexist=`cat /opt/masos/configs/gb/retroarch.cfg |grep "input_overlay" |wc -l` 
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/gb/retroarch.cfg /opt/masos/configs/gb/retroarch.cfg.bkp
    cat /opt/masos/configs/gb/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/gb/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-Game-Boy.cfg"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '5i custom_viewport_width = "429"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '6i custom_viewport_height = "380"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '7i custom_viewport_x = "420"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '8i custom_viewport_y = "155"' /opt/masos/configs/gb/retroarch.cfg
  else
    cp /opt/masos/configs/gb/retroarch.cfg /opt/masos/configs/gb/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-Game-Boy.cfg"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '5i custom_viewport_width = "429"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '6i custom_viewport_height = "380"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '7i custom_viewport_x = "420"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '8i custom_viewport_y = "155"' /opt/masos/configs/gb/retroarch.cfg
  fi  
  ;;
gb_other)
  ifexist=`cat /opt/masos/configs/gb/retroarch.cfg |grep "input_overlay" |wc -l` 
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/gb/retroarch.cfg /opt/masos/configs/gb/retroarch.cfg.bkp
    cat /opt/masos/configs/gb/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/gb/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-Game-Boy.cfg"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '5i custom_viewport_width = "455"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '6i custom_viewport_height = "415"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '7i custom_viewport_x = "455"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '8i custom_viewport_y = "162"' /opt/masos/configs/gb/retroarch.cfg
  else
    cp /opt/masos/configs/gb/retroarch.cfg /opt/masos/configs/gb/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-Game-Boy.cfg"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '5i custom_viewport_width = "455"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '6i custom_viewport_height = "415"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '7i custom_viewport_x = "455"' /opt/masos/configs/gb/retroarch.cfg
    sed -i '8i custom_viewport_y = "162"' /opt/masos/configs/gb/retroarch.cfg
  fi
  ;;
gba_1080)
  ifexist=`cat /opt/masos/configs/gba/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/gba/retroarch.cfg /opt/masos/configs/gba/retroarch.cfg.bkp
    cat /opt/masos/configs/gba/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/gba/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-Game-Boy-Advance.cfg"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '5i custom_viewport_width = "1005"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '6i custom_viewport_height = "645"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '7i custom_viewport_x = "455"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '8i custom_viewport_y = "215"' /opt/masos/configs/gba/retroarch.cfg
  else
    cp /opt/masos/configs/gba/retroarch.cfg /opt/masos/configs/gba/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-Game-Boy-Advance.cfg"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '5i custom_viewport_width = "1005"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '6i custom_viewport_height = "645"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '7i custom_viewport_x = "455"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '8i custom_viewport_y = "215"' /opt/masos/configs/gba/retroarch.cfg
  fi  
  ;;  
gba_720)
  ifexist=`cat /opt/masos/configs/gba/retroarch.cfg |grep "input_overlay" |wc -l` 
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/gba/retroarch.cfg /opt/masos/configs/gba/retroarch.cfg.bkp
    cat /opt/masos/configs/gba/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/gba/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-Game-Boy-Advance.cfg"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '5i custom_viewport_width = "467"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '6i custom_viewport_height = "316"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '7i custom_viewport_x = "405"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '8i custom_viewport_y = "190"' /opt/masos/configs/gba/retroarch.cfg
  else
    cp /opt/masos/configs/gba/retroarch.cfg /opt/masos/configs/gba/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-Game-Boy-Advance.cfg"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '5i custom_viewport_width = "467"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '6i custom_viewport_height = "316"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '7i custom_viewport_x = "405"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '8i custom_viewport_y = "190"' /opt/masos/configs/gba/retroarch.cfg
  fi  
  ;;
gba_other)
  ifexist=`cat /opt/masos/configs/gba/retroarch.cfg |grep "input_overlay" |wc -l` 
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/gba/retroarch.cfg /opt/masos/configs/gba/retroarch.cfg.bkp
    cat /opt/masos/configs/gba/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/gba/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-Game-Boy-Advance.cfg"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '5i custom_viewport_width = "720"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '6i custom_viewport_height = "455"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '7i custom_viewport_x = "320"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '8i custom_viewport_y = "155"' /opt/masos/configs/gba/retroarch.cfg
  else
    cp /opt/masos/configs/gba/retroarch.cfg /opt/masos/configs/gba/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-Game-Boy-Advance.cfg"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '5i custom_viewport_width = "720"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '6i custom_viewport_height = "455"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '7i custom_viewport_x = "320"' /opt/masos/configs/gba/retroarch.cfg
    sed -i '8i custom_viewport_y = "155"' /opt/masos/configs/gba/retroarch.cfg
  fi
  ;;
gbc_1080)
  ifexist=`cat /opt/masos/configs/gbc/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/gbc/retroarch.cfg /opt/masos/configs/gbc/retroarch.cfg.bkp
    cat /opt/masos/configs/gbc/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/gbc/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-Game-Boy-Color.cfg"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '5i custom_viewport_width = "625"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '6i custom_viewport_height = "565"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '7i custom_viewport_x = "645"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '8i custom_viewport_y = "235"' /opt/masos/configs/gbc/retroarch.cfg
  else
    cp /opt/masos/configs/gbc/retroarch.cfg /opt/masos/configs/gbc/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-Game-Boy-Color.cfg"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '5i custom_viewport_width = "625"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '6i custom_viewport_height = "565"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '7i custom_viewport_x = "645"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '8i custom_viewport_y = "235"' /opt/masos/configs/gbc/retroarch.cfg
  fi  
  ;;  
gbc_720)
  ifexist=`cat /opt/masos/configs/gbc/retroarch.cfg |grep "input_overlay" |wc -l` 
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/gbc/retroarch.cfg /opt/masos/configs/gbc/retroarch.cfg.bkp
    cat /opt/masos/configs/gbc/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/gbc/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-Game-Boy-Color.cfg"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '5i custom_viewport_width = "430"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '6i custom_viewport_height = "380"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '7i custom_viewport_x = "425"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '8i custom_viewport_y = "155"' /opt/masos/configs/gbc/retroarch.cfg
  else
    cp /opt/masos/configs/gbc/retroarch.cfg /opt/masos/configs/gbc/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-Game-Boy-Color.cfg"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '5i custom_viewport_width = "430"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '6i custom_viewport_height = "380"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '7i custom_viewport_x = "425"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '8i custom_viewport_y = "155"' /opt/masos/configs/gbc/retroarch.cfg
  fi  
  ;;
gbc_other)
  ifexist=`cat /opt/masos/configs/gbc/retroarch.cfg |grep "input_overlay" |wc -l` 
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/gbc/retroarch.cfg /opt/masos/configs/gbc/retroarch.cfg.bkp
    cat /opt/masos/configs/gbc/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/gbc/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-Game-Boy-Color.cfg"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '5i custom_viewport_width = "455"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '6i custom_viewport_height = "405"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '7i custom_viewport_x = "455"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '8i custom_viewport_y = "165"' /opt/masos/configs/gbc/retroarch.cfg
  else
    cp /opt/masos/configs/gbc/retroarch.cfg /opt/masos/configs/gbc/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-Game-Boy-Color.cfg"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '5i custom_viewport_width = "455"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '6i custom_viewport_height = "405"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '7i custom_viewport_x = "455"' /opt/masos/configs/gbc/retroarch.cfg
    sed -i '8i custom_viewport_y = "165"' /opt/masos/configs/gbc/retroarch.cfg
  fi
  ;;
ngp_1080)
  ifexist=`cat /opt/masos/configs/ngp/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/ngp/retroarch.cfg /opt/masos/configs/ngp/retroarch.cfg.bkp
    cat /opt/masos/configs/ngp/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/ngp/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/SNK-Neo-Geo-Pocket.cfg"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '5i custom_viewport_width = "700"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '6i custom_viewport_height = "635"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '7i custom_viewport_x = "610"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '8i custom_viewport_y = "220"' /opt/masos/configs/ngp/retroarch.cfg
  else
    cp /opt/masos/configs/ngp/retroarch.cfg /opt/masos/configs/ngp/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/SNK-Neo-Geo-Pocket.cfg"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '5i custom_viewport_width = "700"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '6i custom_viewport_height = "635"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '7i custom_viewport_x = "610"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '8i custom_viewport_y = "220"' /opt/masos/configs/ngp/retroarch.cfg
  fi  
  ;;  
ngp_720)
  ifexist=`cat /opt/masos/configs/ngp/retroarch.cfg |grep "input_overlay" |wc -l` 
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/ngp/retroarch.cfg /opt/masos/configs/ngp/retroarch.cfg.bkp
    cat /opt/masos/configs/ngp/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/ngp/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/SNK-Neo-Geo-Pocket.cfg"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '5i custom_viewport_width = "461"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '6i custom_viewport_height = "428"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '7i custom_viewport_x = "407"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '8i custom_viewport_y = "145"' /opt/masos/configs/ngp/retroarch.cfg
  else
    cp /opt/masos/configs/ngp/retroarch.cfg /opt/masos/configs/ngp/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/SNK-Neo-Geo-Pocket.cfg"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '5i custom_viewport_width = "461"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '6i custom_viewport_height = "428"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '7i custom_viewport_x = "407"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '8i custom_viewport_y = "145"' /opt/masos/configs/ngp/retroarch.cfg
  fi  
  ;;
ngp_other)
  ifexist=`cat /opt/masos/configs/ngp/retroarch.cfg |grep "input_overlay" |wc -l` 
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/ngp/retroarch.cfg /opt/masos/configs/ngp/retroarch.cfg.bkp
    cat /opt/masos/configs/ngp/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/ngp/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/SNK-Neo-Geo-Pocket.cfg"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '5i custom_viewport_width = "490"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '6i custom_viewport_height = "455"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '7i custom_viewport_x = "435"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '8i custom_viewport_y = "155"' /opt/masos/configs/ngp/retroarch.cfg
  else
    cp /opt/masos/configs/ngp/retroarch.cfg /opt/masos/configs/ngp/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/SNK-Neo-Geo-Pocket.cfg"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '5i custom_viewport_width = "490"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '6i custom_viewport_height = "455"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '7i custom_viewport_x = "435"' /opt/masos/configs/ngp/retroarch.cfg
    sed -i '8i custom_viewport_y = "155"' /opt/masos/configs/ngp/retroarch.cfg
  fi
  ;;
ngpc_1080)
  ifexist=`cat /opt/masos/configs/ngpc/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/ngpc/retroarch.cfg /opt/masos/configs/ngpc/retroarch.cfg.bkp
    cat /opt/masos/configs/ngpc/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/SNK-Neo-Geo-Pocket-Color.cfg"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '5i custom_viewport_width = "700"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '6i custom_viewport_height = "640"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '7i custom_viewport_x = "610"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '8i custom_viewport_y = "215"' /opt/masos/configs/ngpc/retroarch.cfg
  else
    cp /opt/masos/configs/ngpc/retroarch.cfg /opt/masos/configs/ngpc/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/SNK-Neo-Geo-Pocket-Color.cfg"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '5i custom_viewport_width = "700"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '6i custom_viewport_height = "640"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '7i custom_viewport_x = "610"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '8i custom_viewport_y = "215"' /opt/masos/configs/ngpc/retroarch.cfg
  fi  
  ;;  
ngpc_720)
  ifexist=`cat /opt/masos/configs/ngpc/retroarch.cfg |grep "input_overlay" |wc -l` 
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/ngpc/retroarch.cfg /opt/masos/configs/ngpc/retroarch.cfg.bkp
    cat /opt/masos/configs/ngpc/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/SNK-Neo-Geo-Pocket-Color.cfg"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '5i custom_viewport_width = "460"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '6i custom_viewport_height = "428"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '7i custom_viewport_x = "407"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '8i custom_viewport_y = "145"' /opt/masos/configs/ngpc/retroarch.cfg
  else
    cp /opt/masos/configs/ngpc/retroarch.cfg /opt/masos/configs/ngpc/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/SNK-Neo-Geo-Pocket-Color.cfg"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '5i custom_viewport_width = "460"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '6i custom_viewport_height = "428"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '7i custom_viewport_x = "407"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '8i custom_viewport_y = "145"' /opt/masos/configs/ngpc/retroarch.cfg
  fi  
  ;;
ngpc_other)
  ifexist=`cat /opt/masos/configs/ngpc/retroarch.cfg |grep "input_overlay" |wc -l` 
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/ngpc/retroarch.cfg /opt/masos/configs/ngpc/retroarch.cfg.bkp
    cat /opt/masos/configs/ngpc/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/SNK-Neo-Geo-Pocket-Color.cfg"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '5i custom_viewport_width = "490"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '6i custom_viewport_height = "455"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '7i custom_viewport_x = "435"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '8i custom_viewport_y = "155"' /opt/masos/configs/ngpc/retroarch.cfg
  else
    cp /opt/masos/configs/ngpc/retroarch.cfg /opt/masos/configs/ngpc/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/SNK-Neo-Geo-Pocket-Color.cfg"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '5i custom_viewport_width = "490"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '6i custom_viewport_height = "455"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '7i custom_viewport_x = "435"' /opt/masos/configs/ngpc/retroarch.cfg
    sed -i '8i custom_viewport_y = "155"' /opt/masos/configs/ngpc/retroarch.cfg
  fi
  ;;
psp_1080)
  ifexist=`cat /opt/masos/configs/psp/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/psp/retroarch.cfg /opt/masos/configs/psp/retroarch.cfg.bkp
    cat /opt/masos/configs/psp/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/psp/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sony-PSP.cfg"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '5i custom_viewport_width = "1430"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '6i custom_viewport_height = "820"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '7i custom_viewport_x = "250"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '8i custom_viewport_y = "135"' /opt/masos/configs/psp/retroarch.cfg
  else
    cp /opt/masos/configs/psp/retroarch.cfg /opt/masos/configs/psp/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sony-PSP.cfg"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '5i custom_viewport_width = "1430"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '6i custom_viewport_height = "820"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '7i custom_viewport_x = "250"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '8i custom_viewport_y = "135"' /opt/masos/configs/psp/retroarch.cfg
  fi  
  ;;  
psp_720)
  ifexist=`cat /opt/masos/configs/psp/retroarch.cfg |grep "input_overlay" |wc -l` 
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/psp/retroarch.cfg /opt/masos/configs/psp/retroarch.cfg.bkp
    cat /opt/masos/configs/psp/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/psp/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sony-PSP.cfg"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '5i custom_viewport_width = "950"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '6i custom_viewport_height = "540"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '7i custom_viewport_x = "165"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '8i custom_viewport_y = "90"' /opt/masos/configs/psp/retroarch.cfg
  else
    cp /opt/masos/configs/psp/retroarch.cfg /opt/masos/configs/psp/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sony-PSP.cfg"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '5i custom_viewport_width = "950"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '6i custom_viewport_height = "540"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '7i custom_viewport_x = "165"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '8i custom_viewport_y = "90"' /opt/masos/configs/psp/retroarch.cfg
  fi  
  ;;
psp_other)
  ifexist=`cat /opt/masos/configs/psp/retroarch.cfg |grep "input_overlay" |wc -l` 
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/psp/retroarch.cfg /opt/masos/configs/psp/retroarch.cfg.bkp
    cat /opt/masos/configs/psp/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/psp/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sony-PSP.cfg"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '5i custom_viewport_width = "1015"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '6i custom_viewport_height = "575"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '7i custom_viewport_x = "175"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '8i custom_viewport_y = "95"' /opt/masos/configs/psp/retroarch.cfg
  else
    cp /opt/masos/configs/psp/retroarch.cfg /opt/masos/configs/psp/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sony-PSP.cfg"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '5i custom_viewport_width = "1015"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '6i custom_viewport_height = "575"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '7i custom_viewport_x = "175"' /opt/masos/configs/psp/retroarch.cfg
    sed -i '8i custom_viewport_y = "95"' /opt/masos/configs/psp/retroarch.cfg
  fi
  ;;
pspminis_1080)
  ifexist=`cat /opt/masos/configs/pspminis/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/pspminis/retroarch.cfg /opt/masos/configs/pspminis/retroarch.cfg.bkp
    cat /opt/masos/configs/pspminis/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sony-PSP.cfg"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '5i custom_viewport_width = "1430"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '6i custom_viewport_height = "820"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '7i custom_viewport_x = "250"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '8i custom_viewport_y = "135"' /opt/masos/configs/pspminis/retroarch.cfg
  else
    cp /opt/masos/configs/pspminis/retroarch.cfg /opt/masos/configs/pspminis/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sony-PSP.cfg"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '5i custom_viewport_width = "1430"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '6i custom_viewport_height = "820"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '7i custom_viewport_x = "250"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '8i custom_viewport_y = "135"' /opt/masos/configs/pspminis/retroarch.cfg
  fi  
  ;;  
pspminis_720)
  ifexist=`cat /opt/masos/configs/pspminis/retroarch.cfg |grep "input_overlay" |wc -l` 
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/pspminis/retroarch.cfg /opt/masos/configs/pspminis/retroarch.cfg.bkp
    cat /opt/masos/configs/pspminis/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sony-PSP.cfg"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '5i custom_viewport_width = "950"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '6i custom_viewport_height = "540"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '7i custom_viewport_x = "165"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '8i custom_viewport_y = "90"' /opt/masos/configs/pspminis/retroarch.cfg
  else
    cp /opt/masos/configs/pspminis/retroarch.cfg /opt/masos/configs/pspminis/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sony-PSP.cfg"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '5i custom_viewport_width = "950"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '6i custom_viewport_height = "540"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '7i custom_viewport_x = "165"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '8i custom_viewport_y = "90"' /opt/masos/configs/pspminis/retroarch.cfg
  fi  
  ;;
pspminis_other)
  ifexist=`cat /opt/masos/configs/pspminis/retroarch.cfg |grep "input_overlay" |wc -l` 
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/pspminis/retroarch.cfg /opt/masos/configs/pspminis/retroarch.cfg.bkp
    cat /opt/masos/configs/pspminis/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sony-PSP.cfg"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '5i custom_viewport_width = "1015"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '6i custom_viewport_height = "575"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '7i custom_viewport_x = "175"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '8i custom_viewport_y = "95"' /opt/masos/configs/pspminis/retroarch.cfg
  else
    cp /opt/masos/configs/pspminis/retroarch.cfg /opt/masos/configs/pspminis/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sony-PSP.cfg"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '5i custom_viewport_width = "1015"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '6i custom_viewport_height = "575"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '7i custom_viewport_x = "175"' /opt/masos/configs/pspminis/retroarch.cfg
    sed -i '8i custom_viewport_y = "95"' /opt/masos/configs/pspminis/retroarch.cfg
  fi
  ;;
virtualboy_1080)
  ifexist=`cat /opt/masos/configs/virtualboy/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/virtualboy/retroarch.cfg /opt/masos/configs/virtualboy/retroarch.cfg.bkp
    cat /opt/masos/configs/virtualboy/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-Virtual-Boy.cfg"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '5i custom_viewport_width = "1115"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '6i custom_viewport_height = "695"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '7i custom_viewport_x = "405"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '8i custom_viewport_y = "215"' /opt/masos/configs/virtualboy/retroarch.cfg
  else
    cp /opt/masos/configs/virtualboy/retroarch.cfg /opt/masos/configs/virtualboy/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-Virtual-Boy.cfg"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '5i custom_viewport_width = "1115"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '6i custom_viewport_height = "695"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '7i custom_viewport_x = "405"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '8i custom_viewport_y = "215"' /opt/masos/configs/virtualboy/retroarch.cfg
  fi  
  ;;  
virtualboy_720)
  ifexist=`cat /opt/masos/configs/virtualboy/retroarch.cfg |grep "input_overlay" |wc -l` 
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/virtualboy/retroarch.cfg /opt/masos/configs/virtualboy/retroarch.cfg.bkp
    cat /opt/masos/configs/virtualboy/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-Virtual-Boy.cfg"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '5i custom_viewport_width = "740"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '6i custom_viewport_height = "470"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '7i custom_viewport_x = "270"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '8i custom_viewport_y = "140"' /opt/masos/configs/virtualboy/retroarch.cfg
  else
    cp /opt/masos/configs/virtualboy/retroarch.cfg /opt/masos/configs/virtualboy/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-Virtual-Boy.cfg"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '5i custom_viewport_width = "740"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '6i custom_viewport_height = "470"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '7i custom_viewport_x = "270"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '8i custom_viewport_y = "140"' /opt/masos/configs/virtualboy/retroarch.cfg
  fi  
  ;;
virtualboy_other)
  ifexist=`cat /opt/masos/configs/virtualboy/retroarch.cfg |grep "input_overlay" |wc -l` 
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/virtualboy/retroarch.cfg /opt/masos/configs/virtualboy/retroarch.cfg.bkp
    cat /opt/masos/configs/virtualboy/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-Virtual-Boy.cfg"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '5i custom_viewport_width = "787"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '6i custom_viewport_height = "494"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '7i custom_viewport_x = "290"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '8i custom_viewport_y = "153"' /opt/masos/configs/virtualboy/retroarch.cfg
  else
    cp /opt/masos/configs/virtualboy/retroarch.cfg /opt/masos/configs/virtualboy/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-Virtual-Boy.cfg"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '5i custom_viewport_width = "787"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '6i custom_viewport_height = "494"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '7i custom_viewport_x = "290"' /opt/masos/configs/virtualboy/retroarch.cfg
    sed -i '8i custom_viewport_y = "153"' /opt/masos/configs/virtualboy/retroarch.cfg
  fi
  ;;
wonderswan_1080)
  ifexist=`cat /opt/masos/configs/wonderswan/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/wonderswan/retroarch.cfg /opt/masos/configs/wonderswan/retroarch.cfg.bkp
    cat /opt/masos/configs/wonderswan/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Bandai-WonderSwan-Horizontal.cfg"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '5i custom_viewport_width = "950"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '6i custom_viewport_height = "605"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '7i custom_viewport_x = "495"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '8i custom_viewport_y = "225"' /opt/masos/configs/wonderswan/retroarch.cfg
  else
    cp /opt/masos/configs/wonderswan/retroarch.cfg /opt/masos/configs/wonderswan/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Bandai-WonderSwan-Horizontal.cfg"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '5i custom_viewport_width = "950"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '6i custom_viewport_height = "605"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '7i custom_viewport_x = "495"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '8i custom_viewport_y = "225"' /opt/masos/configs/wonderswan/retroarch.cfg
  fi  
  ;;  
wonderswan_720)
  ifexist=`cat /opt/masos/configs/wonderswan/retroarch.cfg |grep "input_overlay" |wc -l` 
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/wonderswan/retroarch.cfg /opt/masos/configs/wonderswan/retroarch.cfg.bkp
    cat /opt/masos/configs/wonderswan/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Bandai-WonderSwan-Horizontal.cfg"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '5i custom_viewport_width = "645"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '6i custom_viewport_height = "407"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '7i custom_viewport_x = "325"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '8i custom_viewport_y = "148"' /opt/masos/configs/wonderswan/retroarch.cfg
  else
    cp /opt/masos/configs/wonderswan/retroarch.cfg /opt/masos/configs/wonderswan/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Bandai-WonderSwan-Horizontal.cfg"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '5i custom_viewport_width = "645"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '6i custom_viewport_height = "407"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '7i custom_viewport_x = "325"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '8i custom_viewport_y = "148"' /opt/masos/configs/wonderswan/retroarch.cfg
  fi  
  ;;
wonderswan_other)
  ifexist=`cat /opt/masos/configs/wonderswan/retroarch.cfg |grep "input_overlay" |wc -l` 
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/wonderswan/retroarch.cfg /opt/masos/configs/wonderswan/retroarch.cfg.bkp
    cat /opt/masos/configs/wonderswan/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Bandai-WonderSwan-Horizontal.cfg"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '5i custom_viewport_width = "690"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '6i custom_viewport_height = "435"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '7i custom_viewport_x = "345"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '8i custom_viewport_y = "155"' /opt/masos/configs/wonderswan/retroarch.cfg
  else
    cp /opt/masos/configs/wonderswan/retroarch.cfg /opt/masos/configs/wonderswan/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Bandai-WonderSwan-Horizontal.cfg"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '5i custom_viewport_width = "690"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '6i custom_viewport_height = "435"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '7i custom_viewport_x = "345"' /opt/masos/configs/wonderswan/retroarch.cfg
    sed -i '8i custom_viewport_y = "155"' /opt/masos/configs/wonderswan/retroarch.cfg
  fi
  ;;
wonderswancolor_1080)
  ifexist=`cat /opt/masos/configs/wonderswancolor/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/wonderswancolor/retroarch.cfg /opt/masos/configs/wonderswancolor/retroarch.cfg.bkp
    cat /opt/masos/configs/wonderswancolor/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Bandai-WonderSwan-Color-Horizontal.cfg"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '5i custom_viewport_width = "950"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '6i custom_viewport_height = "605"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '7i custom_viewport_x = "490"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '8i custom_viewport_y = "225"' /opt/masos/configs/wonderswancolor/retroarch.cfg
  else
    cp /opt/masos/configs/wonderswancolor/retroarch.cfg /opt/masos/configs/wonderswancolor/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Bandai-WonderSwan-Color-Horizontal.cfg"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '5i custom_viewport_width = "950"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '6i custom_viewport_height = "605"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '7i custom_viewport_x = "490"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '8i custom_viewport_y = "225"' /opt/masos/configs/wonderswancolor/retroarch.cfg
  fi  
  ;;  
wonderswancolor_720)
  ifexist=`cat /opt/masos/configs/wonderswancolor/retroarch.cfg |grep "input_overlay" |wc -l` 
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/wonderswancolor/retroarch.cfg /opt/masos/configs/wonderswancolor/retroarch.cfg.bkp
    cat /opt/masos/configs/wonderswancolor/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Bandai-WonderSwan-Color-Horizontal.cfg"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '5i custom_viewport_width = "643"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '6i custom_viewport_height = "405"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '7i custom_viewport_x = "325"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '8i custom_viewport_y = "150"' /opt/masos/configs/wonderswancolor/retroarch.cfg
  else
    cp /opt/masos/configs/wonderswancolor/retroarch.cfg /opt/masos/configs/wonderswancolor/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Bandai-WonderSwan-Color-Horizontal.cfg"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '5i custom_viewport_width = "643"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '6i custom_viewport_height = "405"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '7i custom_viewport_x = "325"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '8i custom_viewport_y = "150"' /opt/masos/configs/wonderswancolor/retroarch.cfg
  fi  
  ;;
wonderswancolor_other)
  ifexist=`cat /opt/masos/configs/wonderswancolor/retroarch.cfg |grep "input_overlay" |wc -l` 
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/wonderswancolor/retroarch.cfg /opt/masos/configs/wonderswancolor/retroarch.cfg.bkp
    cat /opt/masos/configs/wonderswancolor/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Bandai-WonderSwan-Color-Horizontal.cfg"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '5i custom_viewport_width = "690"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '6i custom_viewport_height = "435"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '7i custom_viewport_x = "345"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '8i custom_viewport_y = "155"' /opt/masos/configs/wonderswancolor/retroarch.cfg
  else
    cp /opt/masos/configs/wonderswancolor/retroarch.cfg /opt/masos/configs/wonderswancolor/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Bandai-WonderSwan-Color-Horizontal.cfg"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '4i aspect_ratio_index = "22"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '5i custom_viewport_width = "690"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '6i custom_viewport_height = "435"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '7i custom_viewport_x = "345"' /opt/masos/configs/wonderswancolor/retroarch.cfg
    sed -i '8i custom_viewport_y = "155"' /opt/masos/configs/wonderswancolor/retroarch.cfg
  fi
  ;;
amstradcpc)
  ifexist=`cat /opt/masos/configs/amstradcpc/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/amstradcpc/retroarch.cfg /opt/masos/configs/amstradcpc/retroarch.cfg.bkp
    cat /opt/masos/configs/amstradcpc/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/amstradcpc/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Amstrad-CPC.cfg"' /opt/masos/configs/amstradcpc/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/amstradcpc/retroarch.cfg
  else
    cp /opt/masos/configs/amstradcpc/retroarch.cfg /opt/masos/configs/amstradcpc/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Amstrad-CPC.cfg"' /opt/masos/configs/amstradcpc/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/amstradcpc/retroarch.cfg
  fi
  ;;
atari800)
  ifexist=`cat /opt/masos/configs/atari800/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/atari800/retroarch.cfg /opt/masos/configs/atari800/retroarch.cfg.bkp
    cat /opt/masos/configs/atari800/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/atari800/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Atari-800.cfg"' /opt/masos/configs/atari800/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/atari800/retroarch.cfg
  else
    cp /opt/masos/configs/atari800/retroarch.cfg /opt/masos/configs/atari800/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Atari-800.cfg"' /opt/masos/configs/atari800/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/atari800/retroarch.cfg
  fi
  ;;
atarist)
  ifexist=`cat /opt/masos/configs/atarist/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/atarist/retroarch.cfg /opt/masos/configs/atarist/retroarch.cfg.bkp
    cat /opt/masos/configs/atarist/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/atarist/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Atari-ST.cfg"' /opt/masos/configs/atarist/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/atarist/retroarch.cfg
  else
    cp /opt/masos/configs/atarist/retroarch.cfg /opt/masos/configs/atarist/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Atari-ST.cfg"' /opt/masos/configs/atarist/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/atarist/retroarch.cfg
  fi
  ;;
c64)
  ifexist=`cat /opt/masos/configs/c64/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/c64/retroarch.cfg /opt/masos/configs/c64/retroarch.cfg.bkp
    cat /opt/masos/configs/c64/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/c64/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Commodore-64.cfg"' /opt/masos/configs/c64/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/c64/retroarch.cfg
  else
    cp /opt/masos/configs/c64/retroarch.cfg /opt/masos/configs/c64/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Commodore-64.cfg"' /opt/masos/configs/c64/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/c64/retroarch.cfg
  fi
  ;;
msx)
  ifexist=`cat /opt/masos/configs/msx/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/msx/retroarch.cfg /opt/masos/configs/msx/retroarch.cfg.bkp
    cat /opt/masos/configs/msx/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/msx/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Microsoft-MSX.cfg"' /opt/masos/configs/msx/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/msx/retroarch.cfg
  else
    cp /opt/masos/configs/msx/retroarch.cfg /opt/masos/configs/msx/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Microsoft-MSX.cfg"' /opt/masos/configs/msx/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/msx/retroarch.cfg
  fi
  ;;
msx2)
  ifexist=`cat /opt/masos/configs/msx2/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/msx2/retroarch.cfg /opt/masos/configs/msx2/retroarch.cfg.bkp
    cat /opt/masos/configs/msx2/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/msx2/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Microsoft-MSX2.cfg"' /opt/masos/configs/msx2/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/msx2/retroarch.cfg
  else
    cp /opt/masos/configs/msx2/retroarch.cfg /opt/masos/configs/msx2/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Microsoft-MSX2.cfg"' /opt/masos/configs/msx2/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/msx2/retroarch.cfg
  fi
  ;;
videopac)
  ifexist=`cat /opt/masos/configs/videopac/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/videopac/retroarch.cfg /opt/masos/configs/videopac/retroarch.cfg.bkp
    cat /opt/masos/configs/videopac/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/videopac/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Magnavox-Odyssey-2.cfg"' /opt/masos/configs/videopac/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/videopac/retroarch.cfg
  else
    cp /opt/masos/configs/videopac/retroarch.cfg /opt/masos/configs/videopac/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Magnavox-Odyssey-2.cfg"' /opt/masos/configs/videopac/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/videopac/retroarch.cfg
  fi
  ;;
x68000)
  ifexist=`cat /opt/masos/configs/x68000/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/x68000/retroarch.cfg /opt/masos/configs/x68000/retroarch.cfg.bkp
    cat /opt/masos/configs/x68000/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/x68000/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sharp-X68000.cfg"' /opt/masos/configs/x68000/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/x68000/retroarch.cfg
  else
    cp /opt/masos/configs/x68000/retroarch.cfg /opt/masos/configs/x68000/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sharp-X68000.cfg"' /opt/masos/configs/x68000/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/x68000/retroarch.cfg
  fi
  ;;
zxspectrum)
  ifexist=`cat /opt/masos/configs/zxspectrum/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/zxspectrum/retroarch.cfg /opt/masos/configs/zxspectrum/retroarch.cfg.bkp
    cat /opt/masos/configs/zxspectrum/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/zxspectrum/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sinclair-ZX-Spectrum.cfg"' /opt/masos/configs/zxspectrum/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/zxspectrum/retroarch.cfg
  else
    cp /opt/masos/configs/zxspectrum/retroarch.cfg /opt/masos/configs/zxspectrum/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Sinclair-ZX-Spectrum.cfg"' /opt/masos/configs/zxspectrum/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/zxspectrum/retroarch.cfg
  fi
  ;;
supergamemachine)
  ifexist=`cat /opt/masos/configs/supergamemachine/retroarch.cfg |grep "input_overlay" |wc -l`
  if [[ ${ifexist} > 0 ]]
  then
    cp /opt/masos/configs/supergamemachine/retroarch.cfg /opt/masos/configs/supergamemachine/retroarch.cfg.bkp
    cat /opt/masos/configs/supergamemachine/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/supergamemachine/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Atari-2600.cfg"' /opt/masos/configs/supergamemachine/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/supergamemachine/retroarch.cfg
  else
    cp /opt/masos/configs/supergamemachine/retroarch.cfg /opt/masos/configs/supergamemachine/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/SuperGameMachine.cfg"' /opt/masos/configs/supergamemachine/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/supergamemachine/retroarch.cfg
  fi
  ;;
esac
}

function retroarch_bezelinfo() {

echo "The Bezel Project is setup with the following sytem-to-core mapping." > /tmp/bezelprojectinfo.txt
echo "" >> /tmp/bezelprojectinfo.txt

echo "To show a specific game bezel, Retroarch must have an override config file for each game.  These " >> /tmp/bezelprojectinfo.txt
echo "configuration files are saved in special directories that are named according to the Retroarch " >> /tmp/bezelprojectinfo.txt
echo "emulator core that system uses." >> /tmp/bezelprojectinfo.txt
echo "" >> /tmp/bezelprojectinfo.txt

echo "The supplied Retroarch configuration files for the bezel utility are setup to use certain " >> /tmp/bezelprojectinfo.txt
echo "emulators for certain systems." >> /tmp/bezelprojectinfo.txt
echo "" >> /tmp/bezelprojectinfo.txt

echo "In order for the supplied bezels to be shown, you must be using the proper Retroarch emulator " >> /tmp/bezelprojectinfo.txt
echo "for a system listed in the table below." >> /tmp/bezelprojectinfo.txt
echo "" >> /tmp/bezelprojectinfo.txt

echo "This table lists all of the systems that have the abilty to show bezels that The Bezel Project " >> /tmp/bezelprojectinfo.txt
echo "hopes to make bezels for." >> /tmp/bezelprojectinfo.txt
echo "" >> /tmp/bezelprojectinfo.txt
echo "" >> /tmp/bezelprojectinfo.txt

echo "System                                          Retroarch Emulator" >> /tmp/bezelprojectinfo.txt
echo "Atari 2600                                      lr-stella" >> /tmp/bezelprojectinfo.txt
echo "Atari 5200                                      lr-atari800" >> /tmp/bezelprojectinfo.txt
echo "Atari 7800                                      lr-prosystem" >> /tmp/bezelprojectinfo.txt
echo "ColecoVision                                    lr-bluemsx" >> /tmp/bezelprojectinfo.txt
echo "GCE Vectrex                                     lr-vecx" >> /tmp/bezelprojectinfo.txt
echo "NEC PC Engine CD                                lr-beetle-pce-fast" >> /tmp/bezelprojectinfo.txt
echo "NEC PC Engine                                   lr-beetle-pce-fast" >> /tmp/bezelprojectinfo.txt
echo "NEC SuperGrafx                                  lr-beetle-supergrafx" >> /tmp/bezelprojectinfo.txt
echo "NEC TurboGrafx-CD                               lr-beetle-pce-fast" >> /tmp/bezelprojectinfo.txt
echo "NEC TurboGrafx-16                               lr-beetle-pce-fast" >> /tmp/bezelprojectinfo.txt
echo "Nintendo 64                                     lr-Mupen64plus" >> /tmp/bezelprojectinfo.txt
echo "Nintendo Entertainment System                   lr-fceumm, lr-nestopia" >> /tmp/bezelprojectinfo.txt
echo "Nintendo Famicom Disk System                    lr-fceumm, lr-nestopia" >> /tmp/bezelprojectinfo.txt
echo "Nintendo Famicom                                lr-fceumm, lr-nestopia" >> /tmp/bezelprojectinfo.txt
echo "Nintendo Super Famicom                          lr-snes9x, lr-snes9x2010" >> /tmp/bezelprojectinfo.txt
echo "Sega 32X                                        lr-picodrive, lr-genesis-plus-gx" >> /tmp/bezelprojectinfo.txt
echo "Sega CD                                         lr-picodrive, lr-genesis-plus-gx" >> /tmp/bezelprojectinfo.txt
echo "Sega Genesis                                    lr-picodrive, lr-genesis-plus-gx" >> /tmp/bezelprojectinfo.txt
echo "Sega Master System                              lr-picodrive, lr-genesis-plus-gx" >> /tmp/bezelprojectinfo.txt
echo "Sega Mega Drive                                 lr-picodrive, lr-genesis-plus-gx" >> /tmp/bezelprojectinfo.txt
echo "Sega Mega Drive Japan                           lr-picodrive, lr-genesis-plus-gx" >> /tmp/bezelprojectinfo.txt
echo "Sega SG-1000                                    lr-genesis-plus-gx" >> /tmp/bezelprojectinfo.txt
echo "Sony PlayStation                                lr-pcsx-rearmed" >> /tmp/bezelprojectinfo.txt
echo "Super Nintendo Entertainment System             lr-snes9x, lr-snes9x2010" >> /tmp/bezelprojectinfo.txt
echo "" >> /tmp/bezelprojectinfo.txt

dialog --backtitle "The Bezel Project" \
--title "The Bezel Project - Bezel Pack Utility" \
--textbox /tmp/bezelprojectinfo.txt 30 110
}

# Main

main_menu

