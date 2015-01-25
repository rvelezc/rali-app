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

exit 0;

cd ../logconf
echo "Installing Logrotate config"
rm -f /etc/logrotate.d/rali
cp rali /etc/logrotate.d/.

