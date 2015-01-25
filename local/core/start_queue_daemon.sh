#!/bin/sh
sleep 35
echo "---------------------------------------------------------------" >> /rali/rali-app/local/log/rali.log
NOW=$(date +"%m-%d-%Y %H:%M:%S")
echo "${NOW}: Starting daemon check_queue.php" >> /rali/rali-app/local/log/rali.log
cd /rali/rali-app/local/core
./rali_queue.php >> /rali/rali-app/local/log/rali.log 2>&1 &
wait


