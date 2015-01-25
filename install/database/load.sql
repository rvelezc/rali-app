-- LOAD DATA LOCAL from csv files
SET SQL_SAFE_UPDATES=0;
use encontexto;
-- Delete and LOAD DATA LOCAL from Contact Table
DELETE FROM `encontexto`.`contact`;
DROP TRIGGER IF EXISTS contact_insert;
CREATE TRIGGER contact_insert BEFORE INSERT on `encontexto`.`contact` FOR EACH ROW SET NEW.date_created = NOW();
LOAD DATA LOCAL INFILE '/enco/install/database/csv/contact.csv'          INTO TABLE `encontexto`.`contact`           FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' (id, name, last, email, company, telephone, telephone2, address, address2, city, state, country, zip, contact_verified, contact_activation_key);

-- Delete and LOAD DATA LOCAL from Contact-Meta
DELETE FROM `encontexto`.`contact_meta`;
LOAD DATA LOCAL INFILE '/enco/install/database/csv/contact_meta.csv'     INTO TABLE `encontexto`.`contact_meta`     FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

-- Delete and LOAD DATA LOCAL from Contact-tags
DELETE FROM `encontexto`.`contact_tags`;
LOAD DATA LOCAL INFILE '/enco/install/database/csv/contact_tags.csv'    INTO TABLE `encontexto`.`contact_tags`    FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

-- Delete and LOAD DATA LOCAL from Client
DELETE FROM `encontexto`.`client`;
LOAD DATA LOCAL INFILE '/enco/install/database/csv/client.csv'           INTO TABLE `encontexto`.`client`           FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

-- Delete and LOAD DATA LOCAL from User_group
DELETE FROM `encontexto`.`groups`;
LOAD DATA LOCAL INFILE '/enco/install/database/csv/groups.csv'       INTO TABLE `encontexto`.`groups`       FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

-- Delete and LOAD DATA LOCAL from User
DELETE FROM `encontexto`.`users`;
LOAD DATA LOCAL INFILE '/enco/install/database/csv/users.csv'             INTO TABLE `encontexto`.`users`             FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' (`id`, `ip_address`, `username`, `password`, `salt`, `email`, `activation_code`, `forgotten_password_code`, `created_on`, `last_login`, `active`, `first_name`, `last_name`, `company`, `phone`); 

-- Delete and LOAD DATA LOCAL from User_group
DELETE FROM `encontexto`.`users_group`;
LOAD DATA LOCAL INFILE '/enco/install/database/csv/users_group.csv'       INTO TABLE `encontexto`.`users_group`       FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

-- Delete and LOAD DATA LOCAL from Client_has_contacts
DELETE FROM `encontexto`.`client_has_users`;
LOAD DATA LOCAL INFILE '/enco/install/database/csv/client_has_users.csv'  INTO TABLE `encontexto`.`client_has_users`  FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

-- Delete and LOAD DATA LOCAL from List
DROP TRIGGER IF EXISTS tgr_list_insert;
CREATE TRIGGER tgr_list_insert BEFORE INSERT on `encontexto`.`list` FOR EACH ROW SET NEW.date_created = NOW();
DELETE FROM `encontexto`.`list`;
LOAD DATA LOCAL INFILE '/enco/install/database/csv/list.csv'             INTO TABLE `encontexto`.`list`             FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' (id, client_id, name, description, active);

-- Delete and LOAD DATA LOCAL from List_has_contacts
DELETE FROM `encontexto`.`list_has_contact`;
LOAD DATA LOCAL INFILE '/enco/install/database/csv/list_has_contact.csv' INTO TABLE `encontexto`.`list_has_contact` FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

-- Delete and LOAD DATA LOCAL from Campaign
DELETE FROM `encontexto`.`campaign`;
DROP TRIGGER IF EXISTS tgr_campaign_insert;
CREATE TRIGGER tgr_campaign_insert BEFORE INSERT on `encontexto`.`campaign` FOR EACH ROW SET NEW.date_created = NOW();
LOAD DATA LOCAL INFILE '/enco/install/database/csv/campaign.csv'         INTO TABLE `encontexto`.`campaign`         FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' (id, client_id, name, description, active);

-- Delete and LOAD DATA LOCAL from Content_type
DELETE FROM `encontexto`.`content_type`;
LOAD DATA LOCAL INFILE '/enco/install/database/csv/content_type.csv'     INTO TABLE `encontexto`.`content_type`     FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

-- Delete and LOAD DATA LOCAL from Content
DELETE FROM `encontexto`.`content`;
DROP TRIGGER IF EXISTS tgr_content_insert;
CREATE TRIGGER tgr_content_insert BEFORE INSERT on `encontexto`.`content` FOR EACH ROW SET NEW.date_created = NOW();
LOAD DATA LOCAL INFILE '/enco/install/database/csv/content.csv'          INTO TABLE `encontexto`.`content`          FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n' (id, campaign_id, content_type_id, name, description, content, origin, active);

-- Delete and LOAD DATA LOCAL from Job_status
DELETE FROM `encontexto`.`job_status`;
LOAD DATA LOCAL INFILE '/enco/install/database/csv/job_status.csv'           INTO TABLE `encontexto`.`job_status`           FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';

-- Create Trigger for Job
DROP TRIGGER IF EXISTS tgr_calendar_insert;
CREATE TRIGGER tgr_calendar_insert BEFORE INSERT on `encontexto`.`calendar` FOR EACH ROW SET NEW.date_created = NOW();

-- Create Trigger for Transaction
DROP TRIGGER IF EXISTS tgr_transaction_insert;
CREATE TRIGGER tgr_transaction_insert BEFORE INSERT on `encontexto`.`transaction` FOR EACH ROW SET NEW.date_created = NOW();

-- Create Trigger for Queue
DROP TRIGGER IF EXISTS tgr_queue_insert;
CREATE TRIGGER tgr_queue_insert BEFORE INSERT on `encontexto`.`queue` FOR EACH ROW SET NEW.date_created = NOW();

-- Create Trigger for Batch
DROP TRIGGER IF EXISTS tgr_batch_insert;
CREATE TRIGGER tgr_batch_insert BEFORE INSERT on `encontexto`.`batch` FOR EACH ROW SET NEW.date_created = NOW();



SET SQL_SAFE_UPDATES=1;
