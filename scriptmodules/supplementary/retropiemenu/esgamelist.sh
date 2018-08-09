#!/bin/bash

IFS=';'

# Welcome
 dialog --backtitle "Emulation Station" --title "Emulation Station Gamelist Utility" \
    --yesno "\nEmulation Station gamelist utility.\n\nThis utility will install premade Emulation Station gamelist.xml files as well as perform a cleanup in the file.\nThese premade files will be located in the roms folder along with the roms themselves.  The cleanup utility will only work on gamelist.xml files located within the roms folder also.\n\nInstall premade gamelist files.\nThe premade gamelist.xml files contain prescraped information for every game for a particular system with multiple entries per game to account for all known rom filename extensions.  These premade gamelist.xml files are setup in such a way to use the No Intro naming convention for roms used by EmuMovies, Hyperspin, and Launchbox.\n\nYou will need to also chose your rom filename extension when installing the premade gamelist.\n\nThey are also setup to use the following folders for game media.\n\nboxart - to store box art PNG files\ncartart - to store cartridge art PNG files\nsnap - to store MP4 game video snaps\nwheel - to store game PNG wheel art\n\nYou will need to copy the game media into those corresponding folders in order to use these premade gamelist.xml files.\n\nCleanup existing gamelist file\nThe cleanup utility will perform an audit on the rom files you have installed versus what is listed in the gamelist.xml file.  It will remove all entries from a gamelist.xml file where there is no matching rom file.  This process will create a curated gamelist.xml file only containg entries for rom files it locates in the particular system rom folder.\n\nFor those systems with large romsets like MAME/FBA, the script will take awhile to run.\n\nYou can monitor it’s progress with this file:  /tmp/remove.txt\n\n---You must restart Emulation Station after making these changes---\n\nWARNING: Always make a backup copy of your gamelist.xml and media files before making changes to your system.\n\n\nDo you want to proceed?" \
    43 130 2>&1 > /dev/tty \
    || exit

function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "What action would you like to perform?" 25 75 20 \
            1 "Install premade gamelist.xml file" \
            2 "Cleanup a gamelist.xml file" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) install  ;;
            2) cleanup  ;;
            *)  break ;;
        esac
    done
}

function install() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "Which rom folder gamelist.xml file do you wish to install?" 25 75 20 \
            1 "amiga" \
            2 "amstradcpc" \
            3 "apple2" \
            4 "arcade" \
            5 "atari2600" \
            6 "atari5200" \
            7 "atari7800" \
            8 "atari800" \
            9 "atarilynx" \
            10 "atarist" \
            11 "c64" \
            12 "coco" \
            13 "coleco" \
            14 "daphne" \
            15 "dragon32" \
            16 "dreamcast" \
            17 "famicom" \
            18 "fba" \
            19 "fba (media in arcade folder)" \
            20 "fds" \
            21 "gameandwatch" \
            22 "gamegear" \
            23 "gb" \
            24 "gba" \
            25 "gbc" \
            26 "genesis" \
            27 "intellivision" \
            28 "mame-advmame" \
            29 "mame-advmame (media in arcade folder)" \
            30 "mame-libretro" \
            31 "mame-libretro (media in arcade folder)" \
            32 "mame-mame4all" \
            33 "mame-mame4all (media in arcade folder)" \
            34 "mastersystem" \
            35 "megadrive" \
            36 "megadrive-japan" \
            37 "msx" \
            38 "msx2" \
            39 "n64" \
            40 "nds" \
            41 "neogeo" \
            42 "nes" \
            43 "ngp" \
            44 "ngpc" \
            45 "oric" \
            46 "pc" \
            47 "pce-cd" \
            48 "pcengine" \
            49 "psp" \
            50 "pspminis" \
            51 "psx" \
            52 "residualvm" \
            53 "scummvm" \
            54 "sega32x" \
            55 "segacd" \
            56 "sfc" \
            57 "sg-1000" \
            58 "snes" \
            59 "supergrafx" \
            60 "tg16" \
            61 "tg-cd" \
            62 "ti99" \
            63 "trs-80" \
            64 "vectrex" \
            65 "videopac" \
            66 "virtualboy" \
            67 "wonderswan" \
            68 "wonderswancolor" \
            69 "x68000" \
            70 "zmachine" \
            72 "zxspectrum" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) install_gamelist "amiga" ;;
            2) install_gamelist "amstradcpc" ;;
            3) install_gamelist "apple2" ;;
            4) install_gamelist "arcade" ;;
            5) install_gamelist "atari2600" ;;
            6) install_gamelist "atari5200" ;;
            7) install_gamelist "atari7800" ;;
            8) install_gamelist "atari800" ;;
            9) install_gamelist "atarilynx" ;;
            10) install_gamelist "atarist" ;;
            11) install_gamelist "c64" ;;
            12) install_gamelist "coco" ;;
            13) install_gamelist "coleco" ;;
            14) install_gamelist "daphne" ;;
            15) install_gamelist "dragon32" ;;
            16) install_gamelist "dreamcast" ;;
            17) install_gamelist "famicom" ;;
            18) install_gamelist "fba" ;;
            19) install_gamelist_arcade "fba" ;;
            20) install_gamelist "fds" ;;
            21) install_gamelist "gameandwatch" ;;
            22) install_gamelist "gamegear" ;;
            23) install_gamelist "gb" ;;
            24) install_gamelist "gba" ;;
            25) install_gamelist "gbc" ;;
            26) install_gamelist "genesis" ;;
            27) install_gamelist "intellivision" ;;
            28) install_gamelist "mame-advmame" ;;
            29) install_gamelist_arcade "mame-advmame" ;;
            30) install_gamelist "mame-libretro" ;;
            31) install_gamelist_arcade "mame-libretro" ;;
            32) install_gamelist "mame-mame4all" ;;
            33) install_gamelist_arcade "mame-mame4all" ;;
            34) install_gamelist "mastersystem" ;;
            35) install_gamelist "megadrive" ;;
            36) install_gamelist "megadrive-japan" ;;
            37) install_gamelist "msx" ;;
            38) install_gamelist "msx2" ;;
            39) install_gamelist "n64" ;;
            40) install_gamelist "nds" ;;
            41) install_gamelist "neogeo" ;;
            42) install_gamelist "nes" ;;
            43) install_gamelist "ngp" ;;
            44) install_gamelist "ngpc" ;;
            45) install_gamelist "oric" ;;
            46) install_gamelist "pc" ;;
            47) install_gamelist "pce-cd" ;;
            48) install_gamelist "pcengine" ;;
            49) install_gamelist "psp" ;;
            50) install_gamelist "pspminis" ;;
            51) install_gamelist "psx" ;;
            52) install_gamelist "residualvm" ;;
            53) install_gamelist "scummvm" ;;
            54) install_gamelist "sega32x" ;;
            55) install_gamelist "segacd" ;;
            56) install_gamelist "sfc" ;;
            57) install_gamelist "sg-1000" ;;
            58) install_gamelist "snes" ;;
            59) install_gamelist "supergrafx" ;;
            60) install_gamelist "tg16" ;;
            61) install_gamelist "tg-cd" ;;
            62) install_gamelist "ti99" ;;
            63) install_gamelist "trs-80" ;;
            64) install_gamelist "vectrex" ;;
            65) install_gamelist "videopac" ;;
            66) install_gamelist "virtualboy" ;;
            67) install_gamelist "wonderswan" ;;
            68) install_gamelist "wonderswancolor" ;;
            69) install_gamelist "x68000" ;;
            70) install_gamelist "zmachine" ;;
            71) install_gamelist "zxspectrum" ;;
            *)  break ;;
        esac
    done
}

function cleanup() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "Which rom folder gamelist.xml file do you wish to clean up?" 25 75 20 \
            1 "amiga" \
            2 "amstradcpc" \
            3 "apple2" \
            4 "arcade" \
            5 "atari2600" \
            6 "atari5200" \
            7 "atari7800" \
            8 "atari800" \
            9 "atarilynx" \
            10 "atarist" \
            11 "c64" \
            12 "coco" \
            13 "coleco" \
            14 "daphne" \
            15 "dragon32" \
            16 "dreamcast" \
            17 "famicom" \
            18 "fba" \
            19 "fba (media in arcade)" \
            20 "fds" \
            21 "gameandwatch" \
            22 "gamegear" \
            23 "gb" \
            24 "gba" \
            25 "gbc" \
            26 "genesis" \
            27 "intellivision" \
            28 "mame-advmame" \
            29 "mame-libretro" \
            30 "mame-mame4all" \
            31 "mastersystem" \
            32 "megadrive" \
            33 "megadrive-japan" \
            34 "msx" \
            35 "msx2" \
            36 "n64" \
            37 "nds" \
            38 "neogeo" \
            39 "nes" \
            40 "ngp" \
            41 "ngpc" \
            42 "oric" \
            43 "pc" \
            44 "pce-cd" \
            45 "pcengine" \
            46 "psp" \
            47 "pspminis" \
            48 "psx" \
            49 "residualvm" \
            50 "scummvm" \
            51 "sega32x" \
            52 "segacd" \
            53 "sfc" \
            54 "sg-1000" \
            55 "snes" \
            56 "supergrafx" \
            57 "tg16" \
            58 "tg-cd" \
            59 "ti99" \
            60 "trs-80" \
            61 "vectrex" \
            62 "videopac" \
            63 "virtualboy" \
            64 "wonderswan" \
            65 "wonderswancolor" \
            66 "x68000" \
            67 "zmachine" \
            68 "zxspectrum" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) clean_gamelist "amiga" ;;
            2) clean_gamelist "amstradcpc" ;;
            3) clean_gamelist "apple2" ;;
            4) clean_gamelist "arcade" ;;
            5) clean_gamelist "atari2600" ;;
            6) clean_gamelist "atari5200" ;;
            7) clean_gamelist "atari7800" ;;
            8) clean_gamelist "atari800" ;;
            9) clean_gamelist "atarilynx" ;;
            10) clean_gamelist "atarist" ;;
            11) clean_gamelist "c64" ;;
            12) clean_gamelist "coco" ;;
            13) clean_gamelist "coleco" ;;
            14) clean_gamelist "daphne" ;;
            15) clean_gamelist "dragon32" ;;
            16) clean_gamelist "dreamcast" ;;
            17) clean_gamelist "famicom" ;;
            18) clean_gamelist "fba" ;;
            19) clean_gamelist_arcade "fba" ;;
            20) clean_gamelist "fds" ;;
            21) clean_gamelist "gameandwatch" ;;
            22) clean_gamelist "gamegear" ;;
            23) clean_gamelist "gb" ;;
            24) clean_gamelist "gba" ;;
            25) clean_gamelist "gbc" ;;
            26) clean_gamelist "genesis" ;;
            27) clean_gamelist "intellivision" ;;
            28) clean_gamelist "mame-advmame" ;;
            29) clean_gamelist "mame-libretro" ;;
            30) clean_gamelist "mame-mame4all" ;;
            31) clean_gamelist "mastersystem" ;;
            32) clean_gamelist "megadrive" ;;
            33) clean_gamelist "megadrive-japan" ;;
            34) clean_gamelist "msx" ;;
            35) clean_gamelist "msx2" ;;
            36) clean_gamelist "n64" ;;
            37) clean_gamelist "nds" ;;
            38) clean_gamelist "neogeo" ;;
            39) clean_gamelist "nes" ;;
            40) clean_gamelist "ngp" ;;
            41) clean_gamelist "ngpc" ;;
            42) clean_gamelist "oric" ;;
            43) clean_gamelist "pc" ;;
            44) clean_gamelist "pce-cd" ;;
            45) clean_gamelist "pcengine" ;;
            46) clean_gamelist "psp" ;;
            47) clean_gamelist "pspminis" ;;
            48) clean_gamelist "psx" ;;
            49) clean_gamelist "residualvm" ;;
            50) clean_gamelist "scummvm" ;;
            51) clean_gamelist "sega32x" ;;
            52) clean_gamelist "segacd" ;;
            53) clean_gamelist "sfc" ;;
            54) clean_gamelist "sg-1000" ;;
            55) clean_gamelist "snes" ;;
            56) clean_gamelist "supergrafx" ;;
            57) clean_gamelist "tg16" ;;
            58) clean_gamelist "tg-cd" ;;
            59) clean_gamelist "ti99" ;;
            60) clean_gamelist "trs-80" ;;
            61) clean_gamelist "vectrex" ;;
            62) clean_gamelist "videopac" ;;
            63) clean_gamelist "virtualboy" ;;
            64) clean_gamelist "wonderswan" ;;
            65) clean_gamelist "wonderswancolor" ;;
            66) clean_gamelist "x68000" ;;
            67) clean_gamelist "zmachine" ;;
            68) clean_gamelist "zxspectrum" ;;
            *)  break ;;
        esac
    done
}

function install_gamelist() {
  dialog --infobox "...processing..." 3 20 ; sleep 2
  system=$1
  gamelist_dir="/home/pi/RetroPie/roms/${system}"
  sourcepath_dir="/home/pi/RetroPie/ESGamelists/${system}"
 
  let i=0 # define counting variable
  W=() # define working array
  while read -r line; do # process file by file
    let i=$i+1
    W+=($i "$line")
  done < <(cat /home/pi/RetroPie/ESGamelists/romextensions.txt)

  CONFDISP=$(dialog --title "Emulation Station Gamelist Utility" --menu "Current available rom filename extensions.  Chose one to use." 24 80 17 "${W[@]}" 3>&2 2>&1 1>&3)

  clear

  if [ -z $CONFDISP ]; then
   return
  else
    romext=`sed -n ${CONFDISP}p /home/pi/RetroPie/ESGamelists/romextensions.txt`
    cp "${sourcepath_dir}/gamelist.xml" "${gamelist_dir}/gamelist.xml"
    sed -i "s/[a-z][a-z][a-z]<\/path>/${romext}<\/path>/g" "${gamelist_dir}/gamelist.xml"
  fi

}

function install_gamelist_arcade() {
  dialog --infobox "...processing..." 3 20 ; sleep 2
  system=$1
  gamelist_dir="/home/pi/RetroPie/roms/${system}"
  sourcepath_dir="/home/pi/RetroPie/ESGamelists/arcade_media"
 
  cp "${sourcepath_dir}/gamelist.xml" "${gamelist_dir}/gamelist.xml"

}

function clean_gamelist() {
  dialog --infobox "...processing..." 3 20 ; sleep 2
  system=$1
  gamelist_dir="/home/pi/RetroPie/roms/${system}"
  original_gamelist="${gamelist_dir}/gamelist.xml"
  clean_gamelist="${gamelist_dir}/gamelist.xml-clean"

  cp "${original_gamelist}" "${original_gamelist}.bkp"
  cat "$original_gamelist" > "$clean_gamelist" 

  while read -r path; do
    full_path="$path"
    [[ "$path" == ./* ]] && full_path="${gamelist_dir}/$path"
    full_path="$(echo "$full_path" | sed 's/&amp;/\&/g')"
    [[ -f "$full_path" ]] && continue

    xmlstarlet ed -L -d "/gameList/game[path=\"$path\"]" "$clean_gamelist"
    echo "The game with <path> = \"$path\" has been removed from xml." >> /tmp/removed.txt
  done < <(xmlstarlet sel -t -v "/gameList/game/path" "$original_gamelist"; echo)

  cp "${clean_gamelist}" "${original_gamelist}"
}



# Main

main_menu
