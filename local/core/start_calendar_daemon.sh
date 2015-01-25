#!/bin/sh
sleep 30
echo "---------------------------------------------------------------" >> /rali/rali-app/local/log/enco.log
NOW=$(date +"%m-%d-%Y %H:%M:%S")
echo "${NOW}: Starting daemon enco_calendar.php" >> /rali/rali-app/local/log/rali.log
cd /rali/rali-app/local/core
./rali_calendar.php >> /rali/rali-app/local/log/rali.log 2>&1 &
wait


