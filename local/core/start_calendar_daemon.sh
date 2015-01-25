#!/bin/sh
sleep 30
echo "---------------------------------------------------------------" >> /enco/local/log/enco.log
NOW=$(date +"%m-%d-%Y %H:%M:%S")
echo "${NOW}: Starting daemon enco_calendar.php" >> /enco/local/log/enco.log
cd /enco/local/core
./enco_calendar.php >> /enco/local/log/enco.log 2>&1 &
wait


