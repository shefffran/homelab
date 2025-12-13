#!/bin/bash

fileLocation='/home/admin/logs/telegramAlertSendScript.log'
getFileSize=$(du -bs $fileLocation| cut -f1)
createTempFile='/home/admin/logs/telegramAlertSendScript.tmp'

# if file > 100MB
if (( getFileSize > 1000000 )); then

    # count lines in the file
    total=$(wc -l < "$fileLocation")
    half=$(( total / 2 ))

    # keep last half of the lines
    tail -n "$half" "$fileLocation" > "$createTempFile"

    # replace original file
    mv "$createTempFile" "$fileLocation"
fi
