#!/bin/bash
cd database
echo "(Re) Creating the database..."
mysql -uroot       -p'passw0rd' < create.sql

