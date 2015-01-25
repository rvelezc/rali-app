SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

ALTER SCHEMA `encontexto`  DEFAULT CHARACTER SET utf8  DEFAULT COLLATE utf8_general_ci ;

CREATE TABLE IF NOT EXISTS `encontexto`.`campaign` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `client_id` INT(11) NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  `active` TINYINT(1) NOT NULL DEFAULT 1,
  `date_created` TIMESTAMP NULL DEFAULT NULL,
  `date_modified` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_campaigns_clients1_idx` (`client_id` ASC),
  CONSTRAINT `fk_campaigns_clients1`
    FOREIGN KEY (`client_id`)
    REFERENCES `encontexto`.`client` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `encontexto`.`client` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `contact_id` INT(11) NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `active` TINYINT(1) NOT NULL DEFAULT 1,
  PRIMARY KEY (`id`),
  INDEX `fk_clients_contacts1_idx` (`contact_id` ASC),
  CONSTRAINT `fk_clients_contacts1`
    FOREIGN KEY (`contact_id`)
    REFERENCES `encontexto`.`contact` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `encontexto`.`content` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `campaign_id` INT(11) NOT NULL,
  `content_type_id` INT(11) NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  `content` TEXT NOT NULL,
  `origin` VARCHAR(45) NOT NULL,
  `active` TINYINT(1) NOT NULL DEFAULT 1,
  `date_created` TIMESTAMP NULL DEFAULT NULL,
  `date_modified` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_email_campaigns1_idx` (`campaign_id` ASC),
  INDEX `fk_content_content_type1_idx` (`content_type_id` ASC),
  CONSTRAINT `fk_email_campaigns1`
    FOREIGN KEY (`campaign_id`)
    REFERENCES `encontexto`.`campaign` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_content_content_type1`
    FOREIGN KEY (`content_type_id`)
    REFERENCES `encontexto`.`content_type` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `encontexto`.`calendar` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `campaign_id` INT(11) NOT NULL,
  `list_id` INT(11) NOT NULL,
  `calendar_status_id` INT(11) NOT NULL,
  `content_id` INT(11) NOT NULL,
  `users_id` INT(11) UNSIGNED NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  `batch_id` INT(11) NULL DEFAULT 0,
  `date_to_process` DATETIME NULL DEFAULT NULL,
  `date_completed` TIMESTAMP NULL DEFAULT NULL,
  `date_created` TIMESTAMP NULL DEFAULT NULL,
  `date_modified` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_jobs_lists1_idx` (`list_id` ASC),
  INDEX `fk_jobs_campaigns1_idx` (`campaign_id` ASC),
  INDEX `fk_jobs_jobs_status1_idx` (`calendar_status_id` ASC),
  INDEX `fk_jobs_content1_idx` (`content_id` ASC),
  INDEX `fk_calendar_users1_idx` (`users_id` ASC),
  CONSTRAINT `fk_jobs_lists1`
    FOREIGN KEY (`list_id`)
    REFERENCES `encontexto`.`list` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_jobs_campaigns1`
    FOREIGN KEY (`campaign_id`)
    REFERENCES `encontexto`.`campaign` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_jobs_jobs_status1`
    FOREIGN KEY (`calendar_status_id`)
    REFERENCES `encontexto`.`job_status` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_jobs_content1`
    FOREIGN KEY (`content_id`)
    REFERENCES `encontexto`.`content` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_calendar_users1`
    FOREIGN KEY (`users_id`)
    REFERENCES `encontexto`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `encontexto`.`job_status` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `status` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `encontexto`.`list` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `client_id` INT(11) NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  `active` TINYINT(1) NOT NULL DEFAULT 1,
  `date_created` TIMESTAMP NULL DEFAULT NULL,
  `date_modified` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_lists_clients1_idx` (`client_id` ASC),
  CONSTRAINT `fk_lists_clients1`
    FOREIGN KEY (`client_id`)
    REFERENCES `encontexto`.`client` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `encontexto`.`contact` (
  `id` INT(11) NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `last` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `company` VARCHAR(255) NOT NULL,
  `telephone` VARCHAR(25) NOT NULL,
  `telephone2` VARCHAR(25) NULL DEFAULT NULL,
  `address` VARCHAR(255) NOT NULL,
  `address2` VARCHAR(255) NULL DEFAULT NULL,
  `city` VARCHAR(255) NOT NULL,
  `state` VARCHAR(255) NOT NULL,
  `country` VARCHAR(255) NOT NULL,
  `zip` VARCHAR(15) NOT NULL,
  `contact_verified` TINYINT(1) NOT NULL DEFAULT 0,
  `contact_activation_key` VARCHAR(10) NULL DEFAULT NULL,
  `date_created` TIMESTAMP NULL DEFAULT NULL,
  `date_modified` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `idx_name` (`name` ASC),
  INDEX `idx_last` (`last` ASC),
  INDEX `idx_email` (`email` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `encontexto`.`list_has_contact` (
  `list_id` INT(11) NOT NULL,
  `contact_id` INT(11) NOT NULL,
  PRIMARY KEY (`list_id`, `contact_id`),
  INDEX `fk_lists_has_contacts_contacts1_idx` (`contact_id` ASC),
  INDEX `fk_lists_has_contacts_lists1_idx` (`list_id` ASC),
  CONSTRAINT `fk_lists_has_contacts_lists1`
    FOREIGN KEY (`list_id`)
    REFERENCES `encontexto`.`list` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_lists_has_contacts_contacts1`
    FOREIGN KEY (`contact_id`)
    REFERENCES `encontexto`.`contact` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `encontexto`.`users` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `ip_address` VARBINARY(16) NOT NULL,
  `username` VARCHAR(100) NOT NULL,
  `password` VARCHAR(80) NOT NULL,
  `salt` VARCHAR(40) NULL DEFAULT NULL,
  `email` VARCHAR(100) NOT NULL,
  `activation_code` VARCHAR(40) NULL DEFAULT NULL,
  `forgotten_password_code` VARCHAR(40) NULL DEFAULT NULL,
  `forgotten_password_time` INT(11) UNSIGNED NULL DEFAULT NULL,
  `remember_code` VARCHAR(40) NULL DEFAULT NULL,
  `created_on` INT(11) UNSIGNED NOT NULL,
  `last_login` INT(11) UNSIGNED NULL DEFAULT NULL,
  `active` TINYINT(3) UNSIGNED NULL DEFAULT NULL,
  `first_name` VARCHAR(50) NULL DEFAULT NULL,
  `last_name` VARCHAR(50) NULL DEFAULT NULL,
  `company` VARCHAR(100) NULL DEFAULT NULL,
  `phone` VARCHAR(20) NULL DEFAULT NULL,
  PRIMARY KEY (`id`),
  INDEX `idx_username` (`ip_address` ASC))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `encontexto`.`contact_meta` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `contact_id` INT(11) NOT NULL,
  `meta_key` VARCHAR(255) NOT NULL,
  `meta_value` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_contacts_meta_contacts1_idx` (`contact_id` ASC),
  CONSTRAINT `fk_contacts_meta_contacts1`
    FOREIGN KEY (`contact_id`)
    REFERENCES `encontexto`.`contact` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `encontexto`.`contact_tags` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `contact_id` INT(11) NOT NULL,
  `tag` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_contacts_tags_contacts1_idx` (`contact_id` ASC),
  INDEX `idx_tags` (`tag` ASC),
  CONSTRAINT `fk_contacts_tags_contacts1`
    FOREIGN KEY (`contact_id`)
    REFERENCES `encontexto`.`contact` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `encontexto`.`content_type` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `type` VARCHAR(45) NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `encontexto`.`users_group` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `user_id` INT(11) UNSIGNED NOT NULL,
  `group_id` MEDIUMINT(8) UNSIGNED NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_users_group_groups1_idx` (`group_id` ASC),
  INDEX `fk_users_group_users1_idx` (`user_id` ASC),
  CONSTRAINT `fk_users_group_groups1`
    FOREIGN KEY (`group_id`)
    REFERENCES `encontexto`.`groups` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_users_group_users1`
    FOREIGN KEY (`user_id`)
    REFERENCES `encontexto`.`users` (`id`)
    ON DELETE CASCADE
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `encontexto`.`transaction` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `client_id` INT(11) NOT NULL,
  `batch_id` INT(11) NOT NULL,
  `client` VARCHAR(255) NOT NULL,
  `content_type` VARCHAR(45) NOT NULL,
  `content` TEXT NOT NULL,
  `campaign` VARCHAR(255) NOT NULL,
  `list` VARCHAR(255) NOT NULL,
  `contact` VARCHAR(255) NOT NULL,
  `error` INT(11) NULL DEFAULT NULL,
  `response` TEXT NULL DEFAULT NULL,
  `date_created` TIMESTAMP NULL DEFAULT NULL,
  `date_modified` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_transactions_clients1_idx` (`client_id` ASC),
  INDEX `idx_client` (`client` ASC),
  INDEX `idx_campaign` (`campaign` ASC),
  INDEX `fk_transaction_batch1_idx` (`batch_id` ASC),
  CONSTRAINT `fk_transactions_clients1`
    FOREIGN KEY (`client_id`)
    REFERENCES `encontexto`.`client` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_transaction_batch1`
    FOREIGN KEY (`batch_id`)
    REFERENCES `encontexto`.`batch` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `encontexto`.`queue` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `client_id` INT(11) NOT NULL,
  `batch_id` INT(11) NOT NULL,
  `queue_status_id` INT(11) NOT NULL DEFAULT 1,
  `process_id` DOUBLE NOT NULL DEFAULT 0,
  `client` VARCHAR(255) NOT NULL,
  `campaign` VARCHAR(255) NOT NULL,
  `list` VARCHAR(255) NOT NULL,
  `contact` VARCHAR(255) NOT NULL,
  `content_type` VARCHAR(45) NOT NULL,
  `content` TEXT NOT NULL,
  `date_created` TIMESTAMP NULL DEFAULT NULL,
  `date_modified` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  INDEX `fk_transactions_clients1_idx` (`client_id` ASC),
  INDEX `fk_queue_batch1_idx` (`batch_id` ASC),
  INDEX `fk_queue_job_status1_idx` (`queue_status_id` ASC),
  INDEX `process_id_idx` (`process_id` ASC),
  CONSTRAINT `fk_transactions_clients10`
    FOREIGN KEY (`client_id`)
    REFERENCES `encontexto`.`client` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_queue_batch1`
    FOREIGN KEY (`batch_id`)
    REFERENCES `encontexto`.`batch` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_queue_job_status1`
    FOREIGN KEY (`queue_status_id`)
    REFERENCES `encontexto`.`job_status` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `encontexto`.`batch` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(255) NOT NULL,
  `description` TEXT NULL DEFAULT NULL,
  `from_calendar` TINYINT(1) NULL DEFAULT NULL,
  `record_count` INT(11) NULL DEFAULT NULL,
  `processed` INT(11) NULL DEFAULT 0,
  `date_created` TIMESTAMP NULL DEFAULT NULL,
  `date_modified` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `encontexto`.`groups` (
  `id` MEDIUMINT(8) UNSIGNED NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(20) NOT NULL,
  `description` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `encontexto`.`login_attempts` (
  `id` INT(11) UNSIGNED NOT NULL AUTO_INCREMENT,
  `ip_address` VARBINARY(16) NOT NULL,
  `login` VARCHAR(100) NOT NULL,
  `time` INT(11) UNSIGNED NULL DEFAULT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `encontexto`.`contact_has_users` (
  `contact_id` INT(11) NOT NULL,
  `users_id` INT(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`contact_id`, `users_id`),
  INDEX `fk_contact_has_users_users1_idx` (`users_id` ASC),
  INDEX `fk_contact_has_users_contact1_idx` (`contact_id` ASC),
  CONSTRAINT `fk_contact_has_users_contact1`
    FOREIGN KEY (`contact_id`)
    REFERENCES `encontexto`.`contact` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_contact_has_users_users1`
    FOREIGN KEY (`users_id`)
    REFERENCES `encontexto`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `encontexto`.`client_has_users` (
  `client_id` INT(11) NOT NULL,
  `users_id` INT(11) UNSIGNED NOT NULL,
  PRIMARY KEY (`client_id`, `users_id`),
  INDEX `fk_client_has_users_users1_idx` (`users_id` ASC),
  INDEX `fk_client_has_users_client1_idx` (`client_id` ASC),
  CONSTRAINT `fk_client_has_users_client1`
    FOREIGN KEY (`client_id`)
    REFERENCES `encontexto`.`client` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_client_has_users_users1`
    FOREIGN KEY (`users_id`)
    REFERENCES `encontexto`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `encontexto`.`client_has_clients` (
  `agency_id` INT(11) NOT NULL,
  `client_id` INT(11) NOT NULL,
  PRIMARY KEY (`agency_id`, `client_id`),
  INDEX `fk_client_has_client_client2_idx` (`client_id` ASC),
  INDEX `fk_client_has_client_client1_idx` (`agency_id` ASC),
  CONSTRAINT `fk_client_has_client_client1`
    FOREIGN KEY (`agency_id`)
    REFERENCES `encontexto`.`client` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_client_has_client_client2`
    FOREIGN KEY (`client_id`)
    REFERENCES `encontexto`.`client` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;

CREATE TABLE IF NOT EXISTS `encontexto`.`client_preferences` (
  `id` INT(11) NOT NULL AUTO_INCREMENT,
  `client_id` INT(11) NOT NULL,
  `key` VARCHAR(255) NOT NULL,
  `value` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`),
  UNIQUE INDEX `id_UNIQUE` (`id` ASC),
  INDEX `fk_client_preferences_client1_idx` (`client_id` ASC),
  CONSTRAINT `fk_client_preferences_client1`
    FOREIGN KEY (`client_id`)
    REFERENCES `encontexto`.`client` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8
COLLATE = utf8_general_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
