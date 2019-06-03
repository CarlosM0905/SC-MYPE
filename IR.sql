-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema db_contable
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema db_contable
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `db_contable` DEFAULT CHARACTER SET utf8 COLLATE utf8_spanish_ci ;
USE `db_contable` ;

-- -----------------------------------------------------
-- Table `db_contable`.`usuario`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_contable`.`usuario` (
  `usr_id` INT NOT NULL AUTO_INCREMENT,
  `usr_nombre` VARCHAR(45) NOT NULL,
  `usr_contrasena` VARCHAR(45) CHARACTER SET 'utf8' COLLATE 'utf8_spanish_ci' NOT NULL,
  PRIMARY KEY (`usr_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_contable`.`empresa`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_contable`.`empresa` (
  `emp_id` INT NOT NULL AUTO_INCREMENT,
  `emp_razon_social` VARCHAR(60) NOT NULL,
  `emp_ruc` VARCHAR(11) NOT NULL,
  `emp_usuario` INT NOT NULL,
  PRIMARY KEY (`emp_id`),
  INDEX `emp_usuario_idx` (`emp_usuario` ASC) VISIBLE,
  CONSTRAINT `emp_usuario`
    FOREIGN KEY (`emp_usuario`)
    REFERENCES `db_contable`.`usuario` (`usr_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_contable`.`tipo_cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_contable`.`tipo_cliente` (
  `tipo_c_id` INT NOT NULL AUTO_INCREMENT,
  `tipo_c_codigo` VARCHAR(5) NOT NULL,
  `tipo_c_descripcion` VARCHAR(40) NOT NULL,
  PRIMARY KEY (`tipo_c_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_contable`.`tipo_proveedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_contable`.`tipo_proveedor` (
  `tipo_p_id` INT NOT NULL,
  `tipo_p_codigo` VARCHAR(5) NOT NULL,
  `tipo_p_descripcion` VARCHAR(40) NULL,
  PRIMARY KEY (`tipo_p_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_contable`.`cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_contable`.`cliente` (
  `cli_id` INT NOT NULL AUTO_INCREMENT,
  `cli_razon_social` VARCHAR(40) NOT NULL,
  `cli_ruc` VARCHAR(11) NOT NULL,
  `cli_tipo` INT NOT NULL,
  PRIMARY KEY (`cli_id`),
  INDEX `tipo_c_id_idx` (`cli_tipo` ASC) VISIBLE,
  CONSTRAINT `tipo_c_id`
    FOREIGN KEY (`cli_tipo`)
    REFERENCES `db_contable`.`tipo_cliente` (`tipo_c_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_contable`.`proveedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_contable`.`proveedor` (
  `prov_id` INT NOT NULL AUTO_INCREMENT,
  `prov_razon_social` VARCHAR(45) NOT NULL,
  `prov_ruc` VARCHAR(11) NOT NULL,
  `prov_tipo` INT NOT NULL,
  PRIMARY KEY (`prov_id`),
  INDEX `prov_tipo_idx` (`prov_tipo` ASC) VISIBLE,
  CONSTRAINT `prov_tipo`
    FOREIGN KEY (`prov_tipo`)
    REFERENCES `db_contable`.`tipo_proveedor` (`tipo_p_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_contable`.`grupo_cuenta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_contable`.`grupo_cuenta` (
  `gru_id` INT NOT NULL AUTO_INCREMENT,
  `gru_nombre` VARCHAR(45) NOT NULL,
  PRIMARY KEY (`gru_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_contable`.`cuenta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_contable`.`cuenta` (
  `cta_id` INT NOT NULL,
  `cta_codigo` VARCHAR(3) NOT NULL,
  `cta_nombre` VARCHAR(45) NOT NULL,
  `cta_grupo` INT NOT NULL,
  PRIMARY KEY (`cta_id`),
  INDEX `cta_grupo_idx` (`cta_grupo` ASC) VISIBLE,
  CONSTRAINT `cta_grupo`
    FOREIGN KEY (`cta_grupo`)
    REFERENCES `db_contable`.`grupo_cuenta` (`gru_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_contable`.`comprobante`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_contable`.`comprobante` (
  `comp_id` INT NOT NULL AUTO_INCREMENT,
  `comp_fecha` DATE NOT NULL,
  `comp_tipo_moneda` VARCHAR(45) NOT NULL,
  `comp_monto_total` DECIMAL(10,2) NOT NULL,
  PRIMARY KEY (`comp_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_contable`.`registro_ventas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_contable`.`registro_ventas` (
  `reg_v_id` INT NOT NULL,
  `reg_v_periodo` DATE NOT NULL,
  `reg_v_total_igv` DECIMAL(10,2) NOT NULL,
  `reg_v_total_base_imponible` DECIMAL(10,2) NOT NULL,
  `reg_v_importe_total` DECIMAL(10,2) NOT NULL,
  `reg_v_empresa` INT NOT NULL,
  PRIMARY KEY (`reg_v_id`),
  INDEX `reg_c_empresa_idx` (`reg_v_empresa` ASC) VISIBLE,
  CONSTRAINT `reg_c_empresa`
    FOREIGN KEY (`reg_v_empresa`)
    REFERENCES `db_contable`.`empresa` (`emp_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_contable`.`venta`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_contable`.`venta` (
  `vent_id` INT NOT NULL,
  `vent_igv` DECIMAL(10,2) NOT NULL DEFAULT 0.0,
  `vent_importe_total` DECIMAL(10,2) NOT NULL DEFAULT 0.0,
  `vent_cliente` INT NOT NULL,
  `vent_cuenta` INT NOT NULL,
  `vent_comprobante` INT NOT NULL,
  `vent_registro` INT NOT NULL,
  PRIMARY KEY (`vent_id`),
  INDEX `vent_cliente_idx` (`vent_cliente` ASC) VISIBLE,
  INDEX `vent_cuenta_idx` (`vent_cuenta` ASC) VISIBLE,
  INDEX `vent_comprobante_idx` (`vent_comprobante` ASC) VISIBLE,
  INDEX `vent_registro_idx` (`vent_registro` ASC) VISIBLE,
  CONSTRAINT `vent_cliente`
    FOREIGN KEY (`vent_cliente`)
    REFERENCES `db_contable`.`cliente` (`cli_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `vent_cuenta`
    FOREIGN KEY (`vent_cuenta`)
    REFERENCES `db_contable`.`cuenta` (`cta_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `vent_comprobante`
    FOREIGN KEY (`vent_comprobante`)
    REFERENCES `db_contable`.`comprobante` (`comp_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `vent_registro`
    FOREIGN KEY (`vent_registro`)
    REFERENCES `db_contable`.`registro_ventas` (`reg_v_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_contable`.`registro_compras`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_contable`.`registro_compras` (
  `reg_c_id` INT NOT NULL,
  `reg_c_periodo` DATE NOT NULL,
  `reg_c_total_igv` DECIMAL(10,2) NOT NULL,
  `reg_c_total_base_imponible` DECIMAL(10,2) NOT NULL,
  `reg_c_importe_total` DECIMAL(10,2) NOT NULL,
  `reg_c_empresa` INT NOT NULL,
  PRIMARY KEY (`reg_c_id`),
  INDEX `reg_c_empresa_idx` (`reg_c_empresa` ASC) VISIBLE,
  CONSTRAINT `reg_c_empresa0`
    FOREIGN KEY (`reg_c_empresa`)
    REFERENCES `db_contable`.`empresa` (`emp_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `db_contable`.`compra`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `db_contable`.`compra` (
  `cmp_id` INT NOT NULL AUTO_INCREMENT,
  `cmp_igv` DECIMAL(10,2) NOT NULL DEFAULT 0.0,
  `cmp_importe_total` DECIMAL(10,2) NOT NULL,
  `cmp_cuenta` INT NOT NULL,
  `cmp_proveedor` INT NOT NULL,
  `cmp_comprobante` INT NOT NULL,
  `cmp_registro` INT NOT NULL,
  PRIMARY KEY (`cmp_id`),
  INDEX `cmp_cuenta_idx` (`cmp_cuenta` ASC) VISIBLE,
  INDEX `cmp_proveedor_idx` (`cmp_proveedor` ASC) VISIBLE,
  INDEX `cmp_comprobante_idx` (`cmp_comprobante` ASC) VISIBLE,
  INDEX `cmp_registro_idx` (`cmp_registro` ASC) VISIBLE,
  CONSTRAINT `cmp_cuenta`
    FOREIGN KEY (`cmp_cuenta`)
    REFERENCES `db_contable`.`cuenta` (`cta_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `cmp_proveedor`
    FOREIGN KEY (`cmp_proveedor`)
    REFERENCES `db_contable`.`proveedor` (`prov_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `cmp_comprobante`
    FOREIGN KEY (`cmp_comprobante`)
    REFERENCES `db_contable`.`comprobante` (`comp_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `cmp_registro`
    FOREIGN KEY (`cmp_registro`)
    REFERENCES `db_contable`.`registro_compras` (`reg_c_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
