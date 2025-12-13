#!/bin/bash

# telegram bot paramets
TOKEN='8438174635:AAFzUi6k6VtmJR2XF1kc9i2Q_s5Qha0BJ94'
CHAT_ID='1181758980'

# geting RAM CPU DISK usage
FreeRAM=$(free -mt | grep Total | grep -Po '[0-9]+$')
CPUUsage=$(grep 'cpu ' /proc/stat | awk '{usage=($2+$4)*100/($2+$4+$5)} END {print usage ""}')
DiskUsage=$(df -h | grep /dev/mmcblk0p2 | grep -Po '\d+(?=%)')

# Logs file location
logsFileLocation='/home/admin/logs/telegramAlertSendScript.log'

# Date with correct format
date=$(date +"%d.%m.%Y %R")

#Function to send telegram alert
alertPost () {
        local messageToSend=$1
        curl -s -X POST https://api.telegram.org/bot$TOKEN/sendMessage -d chat_id=$CHAT_ID -d text="${messageToSend}" > /dev/null
}

logs () {
        local problemWith=$1
        local value=$2
        local isThereAProblem=$3
        if (( $isThereAProblem == 1 ));then
                echo "❌ $date : There is a problem with $problemWith -> $value" >> $logsFileLocation
        else
                echo "✅ $date : There is no problem with $problemWith -> $value" >> $logsFileLocation
        fi
}

#Check Free Memary usage
if (( $FreeRAM < 900 ));then
        alertPost 'Ram usage is high do something'
        logs 'RAM' "$FreeRAM mb" '1'
else
        logs 'RAM' "$FreeRAM mb" '0'
fi

#Check Cpu usage
if [ "$(echo "$CPUUsage > 80" | bc -l)" -eq 1 ]; then
        alertPost 'Cpu vori vichakuma kpi tes incha !'
        logs 'CPU' "$CPUUsage%" '1'
else
        logs 'CPU' "$CPUUsage%" '0'
fi

#Disk usage
if [[ $DiskUsage -ge 85 ]]; then
        alertPost 'Disk usage is high do somthing ara !'
        logs 'Disk' "$DiskUsage%" '1'
else
        logs 'Disk' "$DiskUsage%" '0'
fi

echo -e "\n" >> $logsFileLocation
