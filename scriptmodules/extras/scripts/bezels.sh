#!/bin/bash
rp_module_id="bezelproject"
rp_module_desc="BezelPrject en MasOS"
rp_module_section=""
IFS=';'

# Welcome
 dialog --backtitle "MasOS Utility" --title "MasOS Retroarch Bezel Utility Menu" \
    --yesno "\nMasOS Retroarch Bezel Utility menu.\n\nEsta utilidad proporcionará una manera rápida de ocultar o mostrar bezels dentro de emuladores Retroarch.\n\nPuedes usar esta utilidad para ocultar o mostrar muchos sistemas al mismo tiempo o individualmente.\n\nPara sistemas de mano, hay tres opciones para bezels. Puede elegir 1080p, 720p u otro. Dependiendo de la resolución de su TV / monitor, puede que tenga que probar un par de ellos para obtener el correcto. \ N \ nSi no encuentra ninguna de estas opciones que funcionen correctamente, deberá ir a RetroArch (select + x) para ajustar manualmente.\n\nHay una opción para instalar bezels conosle. Cuando esté habilitado, mostrará bezels de juegos o géneros para muchos juegos basados ​​en consola. La habilitación de los bezels de la consola también habilitará automáticamente los bezels del sistema para esas consolas.\n\n\nQuieres proceder?" \
    30 110 2>&1 > /dev/tty \
    || exit


function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MAIN MENU " \
            --ok-label OK --cancel-label Atras \
            --menu "Que acción te gustaría realizar?" 25 75 20 \
            1 "Ocultar bezel del sistema" \
            2 "Mostrar bezel del sistema" \
            3 "Habilite el paquete de bezels del sistema n°1 (solo puede tener 1 habilitado a la vez)" \
            4 "Habilite el paquete de bezels del sistema n°2 (solo puede tener 1 habilitado a la vez)" \
            5 "Habilite el paquete de bezels del sistema n°3 (solo puede tener 1 habilitado a la vez)" \
            6 "Opcional: habilitar los marcos del juego de la consola" \
			2>&1 > /dev/tty)

        case "$choice" in
            1) disable_bezel  ;;
            2) enable_bezel  ;;
            3) bezel_pack1  ;;
            4) bezel_pack2  ;;
            5) bezel_pack3  ;;
            6) console_bezels  ;;
			*)  break ;;
        esac
    done
}


function disable_bezel() {

clear
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "Which system would you like to disable bezels for?" 25 75 20 \
            1 "arcade" \
            2 "fba" \
            3 "mame-libretro" \
            4 "atari2600" \
            5 "atari5200" \
            6 "atari7800" \
            7 "coleco" \
            8 "famicom" \
            9 "fds" \
            10 "mastersystem" \
            11 "megadrive" \
            12 "megadrive-japan" \
            13 "n64" \
            14 "neogeo" \
            15 "nes" \
            16 "pce-cd" \
            17 "pcengine" \
            18 "psx" \
            19 "sega32x" \
            20 "segacd" \
            21 "sfc" \
            22 "sg-1000" \
            23 "snes" \
            24 "supergrafx" \
            25 "tg16" \
            26 "tg-cd" \
            27 "vectrex" \
            28 "atarilynx" \
            29 "gamegear" \
            30 "gb" \
            31 "gba" \
            32 "gbc" \
            33 "ngp" \
            34 "ngpc" \
            35 "psp" \
            36 "pspminis" \
            37 "virtualboy" \
            38 "wonderswan" \
            39 "wonderswancolor" \
            40 "amstradcpc" \
            41 "atari800" \
            42 "atarist" \
            43 "c64" \
            44 "msx" \
            45 "msx2" \
            46 "videopac" \
            47 "x68000" \
            48 "zxspectrum" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) hide_bezel arcade ;;
            2) hide_bezel fba ;;
            3) hide_bezel mame-libretro ;;
            4) hide_bezel atari2600 ;;
            5) hide_bezel atari5200 ;;
            6) hide_bezel atari7800 ;;
            7) hide_bezel coleco ;;
            8) hide_bezel famicom ;;
            9) hide_bezel fds ;;
            10) hide_bezel mastersystem ;;
            11) hide_bezel megadrive ;;
            12) hide_bezel megadrive-japan ;;
            13) hide_bezel n64 ;;
            14) hide_bezel neogeo ;;
            15) hide_bezel nes ;;
            16) hide_bezel pce-cd ;;
            17) hide_bezel pcengine ;;
            18) hide_bezel psx ;;
            19) hide_bezel sega32x ;;
            20) hide_bezel segacd ;;
            21) hide_bezel sfc ;;
            22) hide_bezel sg-1000 ;;
            23) hide_bezel snes ;;
            24) hide_bezel supergrafx ;;
            25) hide_bezel tg16 ;;
            26) hide_bezel tg-cd ;;
            27) hide_bezel vectrex ;;
            28) hide_bezel atarilynx ;;
            29) hide_bezel gamegear ;;
            30) hide_bezel gb ;;
            31) hide_bezel gba ;;
            32) hide_bezel gbc ;;
            33) hide_bezel ngp ;;
            34) hide_bezel ngpc ;;
            35) hide_bezel psp ;;
            36) hide_bezel pspminis ;;
            37) hide_bezel virtualboy ;;
            38) hide_bezel wonderswan ;;
            39) hide_bezel wonderswancolor ;;
            40) hide_bezel amstradcpc ;;
            41) hide_bezel atari800 ;;
            42) hide_bezel atarist ;;
            43) hide_bezel c64 ;;
            44) hide_bezel msx ;;
            45) hide_bezel msx2 ;;
            46) hide_bezel videopac ;;
            47) hide_bezel x68000 ;;
            48) hide_bezel zxspectrum ;;
            *)  break ;;
        esac
    done

}

function enable_bezel() {

clear
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "Which system would you like to enable bezels for?" 25 75 20 \
            1 "arcade" \
            2 "fba" \
            3 "mame-libretro" \
            4 "atari2600" \
            5 "atari5200" \
            6 "atari7800" \
            7 "coleco" \
            8 "famicom" \
            9 "fds" \
            10 "mastersystem" \
            11 "megadrive" \
            12 "megadrive-japan" \
            13 "n64" \
            14 "neogeo" \
            15 "nes" \
            16 "pce-cd" \
            17 "pcengine" \
            18 "psx" \
            19 "sega32x" \
            20 "segacd" \
            21 "sfc" \
            22 "sg-1000" \
            23 "snes" \
            24 "supergrafx" \
            25 "tg16" \
            26 "tg-cd" \
            27 "vectrex" \
            28 "atarilynx_1080" \
            29 "atarilynx_720" \
            30 "atarilynx_other" \
            31 "gamegear_1080" \
            32 "gamegear_720" \
            33 "gamegear_other" \
            34 "gb_1080" \
            35 "gb_720" \
            36 "gb_other" \
            37 "gba_1080" \
            38 "gba_720" \
            39 "gba_other" \
            40 "gbc_1080" \
            41 "gbc_720" \
            42 "gbc_other" \
            43 "ngp_1080" \
            44 "ngp_720" \
            45 "ngp_other" \
            46 "ngpc_1080" \
            47 "ngpc_720" \
            48 "ngpc_other" \
            49 "psp_1080" \
            50 "psp_720" \
            51 "psp_other" \
            52 "pspminis_1080" \
            53 "pspminis_720" \
            54 "pspminis_other" \
            55 "virtualboy_1080" \
            56 "virtualboy_720" \
            57 "virtualboy_other" \
            58 "wonderswan_1080" \
            59 "wonderswan_720" \
            60 "wonderswan_other" \
            61 "wonderswancolor_1080" \
            62 "wonderswancolor_720" \
            63 "wonderswancolor_other" \
            64 "amstradcpc" \
            65 "atari800" \
            66 "atarist" \
            67 "c64" \
            68 "msx" \
            69 "msx2" \
            70 "videopac" \
            71 "x68000" \
            72 "zxspectrum" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) show_bezel arcade ;;
            2) show_bezel fba ;;
            3) show_bezel mame-libretro ;;
            4) show_bezel atari2600 ;;
            5) show_bezel atari5200 ;;
            6) show_bezel atari7800 ;;
            7) show_bezel coleco ;;
            8) show_bezel famicom ;;
            9) show_bezel fds ;;
            10) show_bezel mastersystem ;;
            11) show_bezel megadrive ;;
            12) show_bezel megadrive-japan ;;
            13) show_bezel n64 ;;
            14) show_bezel neogeo ;;
            15) show_bezel nes ;;
            16) show_bezel pce-cd ;;
            17) show_bezel pcengine ;;
            18) show_bezel psx ;;
            19) show_bezel sega32x ;;
            20) show_bezel segacd ;;
            21) show_bezel sfc ;;
            22) show_bezel sg-1000 ;;
            23) show_bezel snes ;;
            24) show_bezel supergrafx ;;
            25) show_bezel tg16 ;;
            26) show_bezel tg-cd ;;
            27) show_bezel vectrex ;;
            28) show_bezel atarilynx_1080 ;;
            29) show_bezel atarilynx_720 ;;
            30) show_bezel atarilynx_other ;;
            31) show_bezel gamegear_1080 ;;
            32) show_bezel gamegear_720 ;;
            33) show_bezel gamegear_other ;;
            34) show_bezel gb_1080 ;;
            35) show_bezel gb_720 ;;
            36) show_bezel gb_other ;;
            37) show_bezel gba_1080 ;;
            38) show_bezel gba_720 ;;
            39) show_bezel gba_other ;;
            40) show_bezel gbc_1080 ;;
            41) show_bezel gbc_720 ;;
            42) show_bezel gbc_other ;;
            43) show_bezel ngp_1080 ;;
            44) show_bezel ngp_720 ;;
            45) show_bezel ngp_other ;;
            46) show_bezel ngpc_1080 ;;
            47) show_bezel ngpc_720 ;;
            48) show_bezel ngpc_other ;;
            49) show_bezel psp_1080 ;;
            50) show_bezel psp_720 ;;
            51) show_bezel psp_other ;;
            52) show_bezel pspminis_1080 ;;
            53) show_bezel pspminis_720 ;;
            54) show_bezel pspminis_other ;;
            55) show_bezel virtualboy_1080 ;;
            56) show_bezel virtualboy_720 ;;
            57) show_bezel virtualboy_other ;;
            58) show_bezel wonderswan_1080 ;;
            59) show_bezel wonderswan_720 ;;
            60) show_bezel wonderswan_other ;;
            61) show_bezel wonderswancolor_1080 ;;
            62) show_bezel wonderswancolor_720 ;;
            63) show_bezel wonderswancolor_other ;;
            64) show_bezel amstradcpc ;;
            65) show_bezel atari800 ;;
            66) show_bezel atarist ;;
            67) show_bezel c64 ;;
            68) show_bezel msx ;;
            69) show_bezel msx2 ;;
            70) show_bezel videopac ;;
            71) show_bezel x68000 ;;
            72) show_bezel zxspectrum ;;
            *)  break ;;
        esac
    done

}

function hide_bezel() {
dialog --infobox "...processing..." 3 20 ; sleep 2
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
dialog --infobox "...processing..." 3 20 ; sleep 2
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
    cat /opt/masos/configs/nes/retroarch.cfg |grep -v input_overlay |grep -v aspect_ratio |grep -v custom_viewport > /tmp/retroarch.cfg
    cp /tmp/retroarch.cfg /opt/masos/configs/nes/retroarch.cfg
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-Entertainment-System.cfg"' /opt/masos/configs/nes/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/nes/retroarch.cfg
  else
    cp /opt/masos/configs/nes/retroarch.cfg /opt/masos/configs/nes/retroarch.cfg.bkp
    sed -i '2i input_overlay = "/opt/masos/configs/all/retroarch/overlay/Nintendo-Entertainment-System.cfg"' /opt/masos/configs/nes/retroarch.cfg
    sed -i '3i input_overlay_opacity = "1.000000"' /opt/masos/configs/nes/retroarch.cfg
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
vectrex)
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
esac
}

function bezel_pack1() {
  dialog --infobox "...processing..." 3 20 ; sleep 2
  sourcepath_dir="/home/pi/MasOS/RetroarchBezels/bezelpack1"
  destinationpath_dir="/opt/masos/configs/all/retroarch/overlay"
  cp ${sourcepath_dir}/* ${destinationpath_dir}
}

function bezel_pack2() {
  dialog --infobox "...processing..." 3 20 ; sleep 2
  sourcepath_dir="/home/pi/MasOS/RetroarchBezels/bezelpack2"
  destinationpath_dir="/opt/masos/configs/all/retroarch/overlay"
  cp ${sourcepath_dir}/* ${destinationpath_dir}
}

function bezel_pack3() {
  dialog --infobox "...processing..." 3 20 ; sleep 2
  sourcepath_dir="/home/pi/MasOS/RetroarchBezels/bezelpack3"
  destinationpath_dir="/opt/masos/configs/all/retroarch/overlay"
  cp ${sourcepath_dir}/* ${destinationpath_dir}
}

function console_bezels() {
local choice
    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "What action would you like to perform?" 25 75 20 \
            1 "Hide console game bezels" \
            2 "Show console game bezels" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) hide_console_bezels  ;;
            2) show_console_bezels  ;;
            *)  break ;;
        esac
    done
}

function hide_console_bezels() {
dialog --infobox "...processing..." 3 20 ; sleep 2
hide_bezel atari2600
hide_bezel atari5200
hide_bezel atari7800
hide_bezel coleco
hide_bezel famicom
hide_bezel fds
hide_bezel mastersystem
hide_bezel megadrive
hide_bezel megadrive-japan
hide_bezel n64
hide_bezel nes
hide_bezel pce-cd
hide_bezel pcengine
hide_bezel psx
hide_bezel sega32x
hide_bezel segacd
hide_bezel sfc
hide_bezel sg-1000
hide_bezel snes
hide_bezel supergrafx
hide_bezel tg16
hide_bezel tg-cd
  mv "/opt/masos/configs/all/retroarch/config/Atari800" "/opt/masos/configs/all/retroarch/config/disable_Atari800"
  mv "/opt/masos/configs/all/retroarch/config/BlueMSX" "/opt/masos/configs/all/retroarch/config/disable_BlueMSX"
  mv "/opt/masos/configs/all/retroarch/config/FCEUmm" "/opt/masos/configs/all/retroarch/config/disable_FCEUmm"
  mv "/opt/masos/configs/all/retroarch/config/Genesis Plus GX" "/opt/masos/configs/all/retroarch/config/disable_Genesis Plus GX"
  mv "/opt/masos/configs/all/retroarch/config/Mednafen PCE Fast" "/opt/masos/configs/all/retroarch/config/disable_Mednafen PCE Fast"
  mv "/opt/masos/configs/all/retroarch/config/Mednafen SuperGrafx" "/opt/masos/configs/all/retroarch/config/disable_Mednafen SuperGrafx"
  mv "/opt/masos/configs/all/retroarch/config/Mupen64Plus GLES2" "/opt/masos/configs/all/retroarch/config/disable_Mupen64Plus GLES2"
  mv "/opt/masos/configs/all/retroarch/config/Nestopia" "/opt/masos/configs/all/retroarch/config/disable_Nestopia"
  mv "/opt/masos/configs/all/retroarch/config/PCSX-ReARMed" "/opt/masos/configs/all/retroarch/config/disable_PCSX-ReARMed"
  mv "/opt/masos/configs/all/retroarch/config/PicoDrive" "/opt/masos/configs/all/retroarch/config/disable_PicoDrive"
  mv "/opt/masos/configs/all/retroarch/config/ProSystem" "/opt/masos/configs/all/retroarch/config/disable_ProSystem"
  mv "/opt/masos/configs/all/retroarch/config/Snes9x" "/opt/masos/configs/all/retroarch/config/disable_Snes9x"
  mv "/opt/masos/configs/all/retroarch/config/Snes9x 2010" "/opt/masos/configs/all/retroarch/config/disable_Snes9x 2010"
  mv "/opt/masos/configs/all/retroarch/config/Stella" "/opt/masos/configs/all/retroarch/config/disable_Stella"
}

function show_console_bezels() {
dialog --infobox "...processing..." 3 20 ; sleep 2
show_bezel atari2600
show_bezel atari5200
show_bezel atari7800
show_bezel coleco
show_bezel famicom
show_bezel fds
show_bezel mastersystem
show_bezel megadrive
show_bezel megadrive-japan
show_bezel n64
show_bezel nes
show_bezel pce-cd
show_bezel pcengine
show_bezel psx
show_bezel sega32x
show_bezel segacd
show_bezel sfc
show_bezel sg-1000
show_bezel snes
show_bezel supergrafx
show_bezel tg16
show_bezel tg-cd
  mv "/opt/masos/configs/all/retroarch/config/disable_Atari800" "/opt/masos/configs/all/retroarch/config/Atari800"
  mv "/opt/masos/configs/all/retroarch/config/disable_BlueMSX" "/opt/masos/configs/all/retroarch/config/BlueMSX"
  mv "/opt/masos/configs/all/retroarch/config/disable_FCEUmm" "/opt/masos/configs/all/retroarch/config/FCEUmm"
  mv "/opt/masos/configs/all/retroarch/config/disable_Genesis Plus GX" "/opt/masos/configs/all/retroarch/config/Genesis Plus GX"
  mv "/opt/masos/configs/all/retroarch/config/disable_Mednafen PCE Fast" "/opt/masos/configs/all/retroarch/config/Mednafen PCE Fast"
  mv "/opt/masos/configs/all/retroarch/config/disable_Mednafen SuperGrafx" "/opt/masos/configs/all/retroarch/config/Mednafen SuperGrafx"
  mv "/opt/masos/configs/all/retroarch/config/disable_Mupen64Plus GLES2" "/opt/masos/configs/all/retroarch/config/Mupen64Plus GLES2"
  mv "/opt/masos/configs/all/retroarch/config/disable_Nestopia" "/opt/masos/configs/all/retroarch/config/Nestopia"
  mv "/opt/masos/configs/all/retroarch/config/disable_PCSX-ReARMed" "/opt/masos/configs/all/retroarch/config/PCSX-ReARMed"
  mv "/opt/masos/configs/all/retroarch/config/disable_PicoDrive" "/opt/masos/configs/all/retroarch/config/PicoDrive"
  mv "/opt/masos/configs/all/retroarch/config/disable_ProSystem" "/opt/masos/configs/all/retroarch/config/ProSystem"
  mv "/opt/masos/configs/all/retroarch/config/disable_Snes9x" "/opt/masos/configs/all/retroarch/config/Snes9x"
  mv "/opt/masos/configs/all/retroarch/config/disable_Snes9x 2010" "/opt/masos/configs/all/retroarch/config/Snes9x 2010"
  mv "/opt/masos/configs/all/retroarch/config/disable_Stella" "/opt/masos/configs/all/retroarch/config/Stella"
}

# Main

main_menu

