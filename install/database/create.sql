-- # mysql -u root -p 
drop database IF EXISTS rali_marketing;
create database rali_marketing;
-- drop user rali;
-- create user rali;
grant usage on *.* to rali@'%' identified by '';
grant file on *.* to rali@'%' identified by '';
grant all privileges on rali_marketing.* to rali@'%';
grant usage on *.* to rali@'localhost' identified by '';
grant file on *.* to rali@'localhost' identified by '';
grant all privileges on rali_marketing.* to rali@'localhost';
FLUSH PRIVILEGES;

