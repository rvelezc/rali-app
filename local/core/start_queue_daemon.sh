#!/bin/sh
sleep 35
echo "---------------------------------------------------------------" >> /enco/local/log/enco.log
NOW=$(date +"%m-%d-%Y %H:%M:%S")
echo "${NOW}: Starting daemon check_queue.php" >> /enco/local/log/enco.log
cd /enco/local/core
./enco_queue.php >> /enco/local/log/enco.log 2>&1 &
wait


