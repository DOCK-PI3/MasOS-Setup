#!/bin/bash

# calculate rough CPU and GPU temperatures:
cpuTempC=""
cpuTempF=""
gpuTempC=""
gpuTempF=""
if [[ -f "/sys/class/thermal/thermal_zone0/temp" ]]; then
    cpuTempC=$(($(cat /sys/class/thermal/thermal_zone0/temp)/1000)) && cpuTempF=$((cpuTempC*9/5+32))
fi

if [[ -f "/opt/vc/bin/vcgencmd" ]]; then
    if gpuTempC=$(/opt/vc/bin/vcgencmd measure_temp); then
        gpuTempC=${gpuTempC:5:2}
        gpuTempF=$((gpuTempC*9/5+32))
    else
        gpuTempC=""
    fi
fi


infobox= ""
infobox="${infobox}\nFecha: $(date)\n"
infobox="${infobox}_______________________________________________________\n"
infobox="${infobox}\nVersion del Kernel: $(uname -a)\n"
infobox="${infobox}_______________________________________________________\n\n"
infobox="${infobox}Temperatura:\n\n"
infobox="${infobox}CPU: ${cpuTempC} C/${cpuTempF} F\n"
infobox="${infobox}GPU: ${gpuTempC} C/${gpuTempF} F\n"
infobox="${infobox}\n"
sdcard1=`df -h |head -2 |grep -v G|awk '{print $2, $3, $4}'`
sdcard2=`df -h |head -2 |grep -v Size|awk '{print $2, $3, $4}'`
infobox="${infobox}SD Card Informacion:\n\n"
infobox="${infobox}${sdcard1}\n"
infobox="${infobox}${sdcard2}\n"
infobox="${infobox}\n"
infobox="${infobox}_______________________________________________________\n"
infobox="${infobox}\nUsuario: $(whoami)\n"
infobox="${infobox}\n"
infobox="${infobox}Nombre de host: $(hostname)\n\n"
infobox="${infobox}Su IP actual:\n"
infobox="${infobox}$(ip route get 8.8.8.8 2>/dev/null | awk '{print $NF; exit}')\n"

dialog --backtitle "MasOS Informacion del Sistema" \
--title "MasOS Info del Sistema" \
--msgbox "${infobox}" 35 65
