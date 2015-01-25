SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

ALTER SCHEMA `rali_marketing`  DEFAULT CHARACTER SET utf8  DEFAULT COLLATE utf8_general_ci ;

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



