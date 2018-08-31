#!/bin/bash

IFS=';'

# Welcome
 dialog --backtitle "MasOS" --title "MasOS Media Removal Utility" \
    --yesno "\nMasOS media removal utility.\n\nThis utility will remove extra media files (boxart, cartart, snap, and wheel) for a chosen system where there is not a matching game for it.\n\nIf you keep your media for MAME or Final Burn Alpha in the /roms/arcade folder, there is a special choice just for that.\n\nThis script expects you to be using the following media folders.\n\nboxart\ncartart\nsnap\nwheel\n\nWARNING: Always make a backup copy of your SD card and your roms and media files before making changes to your system.\n\n\nDo you want to proceed?" \
    25 80 2>&1 > /dev/tty \
    || exit


function main_menu() {
    local choice

    while true; do
        choice=$(dialog --backtitle "$BACKTITLE" --title " MAIN MENU " \
            --ok-label OK --cancel-label Exit \
            --menu "Which rom media folders do you wish to clean up?" 25 75 20 \
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
            29 "mame-advmame (media in arcade)" \
            30 "mame-libretro" \
            31 "mame-libretro (media in arcade)" \
            32 "mame-mame4all" \
            33 "mame-mame4all (media in arcade)" \
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
            71 "zxspectrum" \
            999 "Exit script" \
            2>&1 > /dev/tty)

        case "$choice" in
            1) remove_media "amiga" ;;
            2) remove_media "amstradcpc" ;;
            3) remove_media "apple2" ;;
            4) remove_media "arcade" ;;
            5) remove_media "atari2600" ;;
            6) remove_media "atari5200" ;;
            7) remove_media "atari7800" ;;
            8) remove_media "atari800" ;;
            9) remove_media "atarilynx" ;;
            10) remove_media "atarist" ;;
            11) remove_media "c64" ;;
            12) remove_media "coco" ;;
            13) remove_media "coleco" ;;
            14) remove_media "daphne" ;;
            15) remove_media "dragon32" ;;
            16) remove_media "dreamcast" ;;
            17) remove_media "famicom" ;;
            18) remove_media "fba" ;;
            19) remove_media_arcade "fba" ;;
            20) remove_media "fds" ;;
            21) remove_media "gameandwatch" ;;
            22) remove_media "gamegear" ;;
            23) remove_media "gb" ;;
            24) remove_media "gba" ;;
            25) remove_media "gbc" ;;
            26) remove_media "genesis" ;;
            27) remove_media "intellivision" ;;
            28) remove_media "mame-advmame" ;;
            29) remove_media_arcade "mame-advmame" ;;
            30) remove_media "mame-libretro" ;;
            31) remove_media_arcade "mame-libretro" ;;
            32) remove_media "mame-mame4all" ;;
            33) remove_media_arcade "mame-mame4all" ;;
            34) remove_media "mastersystem" ;;
            35) remove_media "megadrive" ;;
            36) remove_media "megadrive-japan" ;;
            37) remove_media "msx" ;;
            38) remove_media "msx2" ;;
            39) remove_media "n64" ;;
            40) remove_media "nds" ;;
            41) remove_media "neogeo" ;;
            42) remove_media "nes" ;;
            43) remove_media "ngp" ;;
            44) remove_media "ngpc" ;;
            45) remove_media "oric" ;;
            46) remove_media "pc" ;;
            47) remove_media "pce-cd" ;;
            48) remove_media "pcengine" ;;
            49) remove_media "psp" ;;
            50) remove_media "pspminis" ;;
            51) remove_media "psx" ;;
            52) remove_media "residualvm" ;;
            53) remove_media "scummvm" ;;
            54) remove_media "sega32x" ;;
            55) remove_media "segacd" ;;
            56) remove_media "sfc" ;;
            57) remove_media "sg-1000" ;;
            58) remove_media "snes" ;;
            59) remove_media "supergrafx" ;;
            60) remove_media "tg16" ;;
            61) remove_media "tg-cd" ;;
            62) remove_media "ti99" ;;
            63) remove_media "trs-80" ;;
            64) remove_media "vectrex" ;;
            65) remove_media "videopac" ;;
            66) remove_media "virtualboy" ;;
            67) remove_media "wonderswan" ;;
            68) remove_media "wonderswancolor" ;;
            69) remove_media "x68000" ;;
            70) remove_media "zmachine" ;;
            71) remove_media "zxspectrum" ;;
            999) exit ;;
            *)  break ;;
        esac
    done
}

function remove_media() {
dialog --infobox "...processing..." 3 20 ; sleep 2
choice=$1
directory="/home/pi/MasOS/roms/${choice}"

ls "${directory}/boxart" | sed -e 's/\.jpg$//' | sed -e 's/\.png$//' > /tmp/boxart.txt
ls "${directory}/cartart" | sed -e 's/\.jpg$//' | sed -e 's/\.png$//' > /tmp/cartart.txt
ls "${directory}/snap" | sed -e 's/\.mp4$//' > /tmp/snap.txt
ls "${directory}/wheel" | sed -e 's/\.jpg$//' | sed -e 's/\.png$//' > /tmp/wheel.txt

rm /tmp/remove_media.sh 2> /dev/null

while read bname
do
ifexist=`ls "${directory}" |grep "${bname}"`
if [[ -z $ifexist ]]
then
echo "rm \"${directory}/boxart/${bname}.png\"" >> /tmp/remove_media.sh
echo "rm \"${directory}/boxart/${bname}.jpg\"" >> /tmp/remove_media.sh
fi
done < /tmp/boxart.txt

while read cname
do
ifexist=`ls "${directory}" |grep "${cname}"`
if [[ -z $ifexist ]]
then
echo "rm \"${directory}/cartart/${cname}.png\"" >> /tmp/remove_media.sh
echo "rm \"${directory}/cartart/${cname}.jpg\"" >> /tmp/remove_media.sh
fi
done < /tmp/cartart.txt

while read sname
do
ifexist=`ls "${directory}" |grep "${sname}"`
if [[ -z $ifexist ]]
then
echo "rm \"${directory}/snap/${sname}.mp4\"" >> /tmp/remove_media.sh
fi
done < /tmp/snap.txt

while read wname
do
ifexist=`ls "${directory}" |grep "${wname}"`
if [[ -z $ifexist ]]
then
echo "rm \"${directory}/wheel/${wname}.png\""  >> /tmp/remove_media.sh
echo "rm \"${directory}/wheel/${wname}.jpg\""  >> /tmp/remove_media.sh
fi
done < /tmp/wheel.txt

#execute the removal
chmod 777 /tmp/remove_media.sh
/tmp/remove_media.sh
rm /tmp/remove_media.sh
}

function remove_media_arcade() {
dialog --infobox "...processing..." 3 20 ; sleep 2
choice=$1
arcade="/home/pi/MasOS/roms/arcade"
directory="/home/pi/MasOS/roms/${choice}"

ls "${arcade}/boxart" | sed -e 's/\.jpg$//' | sed -e 's/\.png$//' > /tmp/boxart.txt
ls "${arcade}/cartart" | sed -e 's/\.jpg$//' | sed -e 's/\.png$//' > /tmp/cartart.txt
ls "${arcade}/snap" | sed -e 's/\.mp4$//' > /tmp/snap.txt
ls "${arcade}/wheel" | sed -e 's/\.jpg$//' | sed -e 's/\.png$//' > /tmp/wheel.txt

rm /tmp/remove_media.sh 2> /dev/null

while read bname
do
ifexist=`ls "${directory}" |grep "${bname}"`
if [[ -z $ifexist ]]
then
echo "rm \"${arcade}/boxart/${bname}.png\"" >> /tmp/remove_media.sh
echo "rm \"${arcade}/boxart/${bname}.jpg\"" >> /tmp/remove_media.sh
fi
done < /tmp/boxart.txt

while read cname
do
ifexist=`ls "${directory}" |grep "${cname}"`
if [[ -z $ifexist ]]
then
echo "rm \"${arcade}/cartart/${cname}.png\"" >> /tmp/remove_media.sh
echo "rm \"${arcade}/cartart/${cname}.jpg\"" >> /tmp/remove_media.sh
fi
done < /tmp/cartart.txt

while read sname
do
ifexist=`ls "${directory}" |grep "${sname}"`
if [[ -z $ifexist ]]
then
echo "rm \"${arcade}/snap/${sname}.mp4\"" >> /tmp/remove_media.sh
fi
done < /tmp/snap.txt

while read wname
do
ifexist=`ls "${directory}" |grep "${wname}"`
if [[ -z $ifexist ]]
then
echo "rm \"${arcade}/wheel/${wname}.png\""  >> /tmp/remove_media.sh
echo "rm \"${arcade}/wheel/${wname}.jpg\""  >> /tmp/remove_media.sh
fi
done < /tmp/wheel.txt

#execute the removal
chmod 777 /tmp/remove_media.sh
/tmp/remove_media.sh
rm /tmp/remove_media.sh
}


# Main

main_menu
