SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS `Aha` DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
USE `Aha` ;

-- -----------------------------------------------------
-- Table `Aha`.`images`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `Aha`.`images` (
  `guid` VARCHAR(50) NOT NULL ,
  `device` VARCHAR(50) NOT NULL ,
  `status` TINYINT NULL ,
  `timestamp` TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ,
  PRIMARY KEY (`guid`, `device`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Aha`.`device`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `Aha`.`device` (
  `guid` VARCHAR(50) NOT NULL ,
  `blacklist` TINYINT NULL ,
  `email` VARCHAR(100) NULL ,
  `phone` VARCHAR(20) NULL ,
  PRIMARY KEY (`guid`) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `Aha`.`admin`
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS `Aha`.`admin` (
  `username` VARCHAR(30) NOT NULL ,
  `password` VARCHAR(40) NULL ,
  PRIMARY KEY (`username`) )
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

