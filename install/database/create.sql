-- # mysql -u root -p 
drop database rali_marketing;
create database rali_marketing;
drop user rali;
create user rali;
grant usage on *.* to rali@'%' identified by 'passw0rd';
grant file on *.* to rali@'%' identified by 'passw0rd';
grant all privileges on rali_marketing.* to rali@'%';
grant usage on *.* to rali@'localhost' identified by 'passw0rd';
grant file on *.* to rali@'localhost' identified by 'passw0rd';
grant all privileges on rali_marketing.* to rali@'localhost';
FLUSH PRIVILEGES;

