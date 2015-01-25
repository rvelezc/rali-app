-- # mysql -u root -p 

drop database encontexto;
create database encontexto;
grant usage on *.* to encontexto@'%' identified by 'passw0rd';
grant file on *.* to encontexto@'%' identified by 'passw0rd';
grant all privileges on encontexto.* to encontexto@'%';
grant usage on *.* to encontexto@'localhost' identified by 'passw0rd';
grant file on *.* to encontexto@'localhost' identified by 'passw0rd';
grant all privileges on encontexto.* to encontexto@'localhost';
FLUSH PRIVILEGES;

