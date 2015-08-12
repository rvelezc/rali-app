SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

ALTER SCHEMA `rali_marketing`  DEFAULT CHARACTER SET utf8  DEFAULT COLLATE utf8_general_ci ;

CREATE TABLE IF NOT EXISTS `rali_marketing`.`users` (
  `uid` int(11) NOT NULL AUTO_INCREMENT,
  `name` varchar(50) NOT NULL,
  `email` varchar(50) NOT NULL,
  `phone` varchar(100) NULL,
  `password` varchar(200) NOT NULL,
  `address` varchar(50) NULL,
  `city` varchar(50) NULL,
  `created` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`uid`)
) 
ENGINE=InnoDB  
DEFAULT CHARSET=utf8;

CREATE TABLE IF NOT EXISTS `rali_marketing`.`calendar` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `users_id` INT(11) NOT NULL,
  `calendar_status_id` INT(11) NOT NULL,
  `payload` TEXT NULL DEFAULT NULL,
  `batch_id` INT(11) NULL DEFAULT 0,
  `date_to_process` DATETIME NULL DEFAULT NULL,
  `date_completed` TIMESTAMP NULL DEFAULT NULL,
  `date_created` TIMESTAMP NULL DEFAULT NULL,
  `date_modified` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_user_calendar` (`users_id` ASC),
  CONSTRAINT `fk_user_calendar`
    FOREIGN KEY (`users_id`)
    REFERENCES `rali_marketing`.`users` (`uid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION
  )
  ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `rali_marketing`.`transaction` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `batch_id` INT(11) NOT NULL,
  `response_code` INT(11) NULL DEFAULT NULL,
  `response` TEXT NULL DEFAULT NULL,
  `date_created` TIMESTAMP NULL DEFAULT NULL,
  `date_modified` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_transaction_batch1_idx` (`batch_id` ASC),
  CONSTRAINT `fk_transaction_batch1`
    FOREIGN KEY (`batch_id`)
    REFERENCES `rali_marketing`.`batch` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `rali_marketing`.`queue` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `batch_id` INT(11) NOT NULL,
  `queue_status_id` INT(11) NOT NULL DEFAULT 1,
  `process_id` DOUBLE NOT NULL DEFAULT 0,
  `payload` TEXT NOT NULL, 
  `date_created` TIMESTAMP NULL DEFAULT NULL,
  `date_modified` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_queue_batch1_idx` (`batch_id` ASC),
  INDEX `fk_queue_job_status1_idx` (`queue_status_id` ASC),
  INDEX `process_id_idx` (`process_id` ASC),
  CONSTRAINT `fk_queue_batch1`
    FOREIGN KEY (`batch_id`)
    REFERENCES `rali_marketing`.`batch` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `rali_marketing`.`batch` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  `record_count` INT(11) NULL DEFAULT NULL,
  `processed` INT(11) NULL DEFAULT 0,
  `date_created` TIMESTAMP NULL DEFAULT NULL,
  `date_modified` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

DROP TABLE IF EXISTS `rali_marketing`.`user_validation` ;
CREATE TABLE IF NOT EXISTS `rali_marketing`.`user_validation` (
  `uniq_hash` TEXT NOT NULL,
  `validation_type` INT(1) NOT NULL,
  `users_id` INT(11) NOT NULL,
  `created_date` TIMESTAMP NULL DEFAULT NULL,
  `modified_date` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_user_validation` (`users_id` ASC),
  CONSTRAINT `fk_user_validation`
    FOREIGN KEY (`users_id`)
    REFERENCES `rali_marketing`.`users` (`uid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

DROP TABLE IF EXISTS `rali_marketing`.`user_accounts` ;
CREATE TABLE IF NOT EXISTS `rali_marketing`.`user_accounts` (
  `users_id` INT(11) NOT NULL,
  `created_date` TIMESTAMP NULL DEFAULT NULL,
  `modified_date` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
  INDEX `idx_user_accounts` (`users_id` ASC),
  CONSTRAINT `fk_user_accounts`
    FOREIGN KEY (`users_id`)
    REFERENCES `rali_marketing`.`users` (`uid`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

use rali_marketing;
SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

-- Create Trigger for Transaction
DROP TRIGGER IF EXISTS tgr_transaction_insert;
CREATE TRIGGER tgr_transaction_insert BEFORE INSERT on `rali_marketing`.`transaction` FOR EACH ROW SET NEW.date_created = NOW();

-- Create Trigger for Queue
DROP TRIGGER IF EXISTS tgr_queue_insert;
CREATE TRIGGER tgr_queue_insert BEFORE INSERT on `rali_marketing`.`queue` FOR EACH ROW SET NEW.date_created = NOW();

-- Create Trigger for Batch
DROP TRIGGER IF EXISTS tgr_batch_insert;
CREATE TRIGGER tgr_batch_insert BEFORE INSERT on `rali_marketing`.`batch` FOR EACH ROW SET NEW.date_created = NOW();

-- Create Trigger for Calendar
DROP TRIGGER IF EXISTS tgr_calendar_insert;
CREATE TRIGGER tgr_calendar_insert BEFORE INSERT on `rali_marketing`.`calendar` FOR EACH ROW SET NEW.date_created = NOW();

--
-- Dumping data for table `customers_auth`
--

INSERT INTO `users` (`name`, `email`, `phone`, `password`, `address`, `city`, `created`) VALUES
('Rafael Velez', 'rafael.velez.c@gmail.com', '5127737469', '$2a$10$d945928b9e9dddba65bebeMR9yBMu2F2Ff0LV19Dke3EI.RpOljci', '401 Buttercup Creek', 'Austin', '2015-02-15 18:21:20');
