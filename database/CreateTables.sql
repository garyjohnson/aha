SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `aha` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
USE `aha` ;

-- -----------------------------------------------------
-- Table `aha`.`images`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `aha`.`images` (
  `guid` VARCHAR(50) NOT NULL ,
  `device` VARCHAR(50) NOT NULL ,
  `status` TINYINT NULL ,
  `timestamp` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY (`guid`, `device`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `aha`.`device`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `aha`.`device` (
  `guid` VARCHAR(50) NOT NULL ,
  `blacklist` TINYINT NULL ,
  `email` VARCHAR(100) NULL ,
  `phone` VARCHAR(20) NULL ,
  PRIMARY KEY (`guid`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `aha`.`admin`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `aha`.`admin` (
  `username` VARCHAR(30) NOT NULL ,
  `password` VARCHAR(40) NULL ,
  PRIMARY KEY (`username`) )
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

