#!/bin/bash
cd database
echo "(Re) Creating the database..."
mysql -uroot       -p'passw0rd' < create.sql
echo "Creating data model..."
mysql -uencontexto -p'passw0rd' < model.sql
echo "Loading data..."
mysql -uencontexto -p'passw0rd' --local-infile encontexto < load.sql

cd ../daemons
echo "Installing Daemons..."
rm -f /etc/init/enco_*.conf
cp enco_*.conf /etc/init

cd ../logconf
echo "Installing Logrotate config"
rm -f /etc/logrotate.d/enco
cp enco /etc/logrotate.d/.

