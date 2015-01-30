#!/bin/bash
cd database
echo "(Re) Creating the database..."
mysql -uroot       -p'passw0rd' < create.sql

echo "Creating data model..."
mysql -urali -p'passw0rd' < model.sql

cd ../daemons
echo "Installing Daemons..."
rm -f /etc/init/rali_*.conf
cp rali_*.conf /etc/init
rm -f /etc/init.d/rali_calendar
rm -f /etc/init.d/rali_queue
cp rali_calendar /etc/init.d/
cp rali_queue /etc/init.d/
update-rc.d rali_queue defaults
update-rc.d rali_calendar defaults


cd ../logconf
echo "Installing Logrotate config"
rm -f /etc/logrotate.d/rali
cp rali /etc/logrotate.d/.

