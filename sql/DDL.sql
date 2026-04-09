-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema corrida_db
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema corrida_db
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `corrida_db` DEFAULT CHARACTER SET utf8 ;
USE `corrida_db` ;

-- -----------------------------------------------------
-- Table `corrida_db`.`users`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `corrida_db`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(255) NOT NULL,
  `email` VARCHAR(255) NOT NULL,
  `senha` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `corrida_db`.`corredores`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `corrida_db`.`corredores` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `nome` VARCHAR(255) NOT NULL,
  `turma` VARCHAR(255) NOT NULL,
  PRIMARY KEY (`id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `corrida_db`.`voltas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `corrida_db`.`voltas` (
  `id` INT NOT NULL AUTO_INCREMENT,
  `tempo` DECIMAL(10,2) NULL,
  `data` TIMESTAMP NULL,
  `corredores_id` INT NOT NULL,
  PRIMARY KEY (`id`),
  INDEX `fk_voltas_corredores_idx` (`corredores_id` ASC) VISIBLE,
  CONSTRAINT `fk_voltas_corredores`
    FOREIGN KEY (`corredores_id`)
    REFERENCES `corrida_db`.`corredores` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;

--DML

USE `corrida_db`;

INSERT INTO `corrida_db`.`users` (`nome`, `email`, `senha`) VALUES
('Administrador', 'admin@racecontrol.com', 'admin123'),
('João Silva', 'joao@email.com', 'joao123'),
('Maria Santos', 'maria@email.com', 'maria123'),
('Pedro Oliveira', 'pedro@email.com', 'pedro123'),
('Ana Costa', 'ana@email.com', 'ana123'),
('Carlos Ferreira', 'carlos@email.com', 'carlos123'),
('Juliana Lima', 'juliana@email.com', 'juliana123'),
('Roberto Alves', 'roberto@email.com', 'roberto123');

INSERT INTO `corrida_db`.`corredores` (`nome`, `turma`) VALUES
('Lewis Hamilton', 'Fórmula 1'),
('Max Verstappen', 'Fórmula 1'),
('Charles Leclerc', 'Fórmula 1'),
('Lando Norris', 'Fórmula 1'),
('Carlos Sainz', 'Fórmula 1'),
('Sergio Pérez', 'Fórmula 1'),
('George Russell', 'Fórmula 1'),
('Fernando Alonso', 'Fórmula 1'),
('Valtteri Bottas', 'Fórmula 1'),
('Daniel Ricciardo', 'Fórmula 1'),
('Eliud Kipchoge', 'Maratona'),
('Kenenisa Bekele', 'Maratona'),
('Mo Farah', 'Maratona'),
('Usain Bolt', 'Velocidade'),
('Andre De Grasse', 'Velocidade'),
('Noah Lyles', 'Velocidade'),
('Alison dos Santos', '400m Barreiras'),
('Karsten Warholm', '400m Barreiras'),
('Sydney McLaughlin', '400m Barreiras'),
('Femke Bol', '400m Barreiras');

-- Voltas da Fórmula 1 (tempos em segundos)
INSERT INTO `corrida_db`.`voltas` (`tempo`, `data`, `corredores_id`) VALUES

-- Lewis Hamilton (id 1)
(95.50, '2024-01-15 10:30:00', 1),
(94.20, '2024-01-15 10:32:00', 1),
(93.80, '2024-01-15 10:34:00', 1),
(92.50, '2024-02-10 09:15:00', 1),
(91.80, '2024-02-10 09:17:00', 1),

-- Max Verstappen (id 2)
(94.80, '2024-01-15 10:30:00', 2),
(93.50, '2024-01-15 10:32:00', 2),
(92.10, '2024-01-15 10:34:00', 2),
(91.20, '2024-02-10 09:15:00', 2),
(90.50, '2024-02-10 09:17:00', 2),

-- Charles Leclerc (id 3)
(96.20, '2024-01-15 10:30:00', 3),
(95.10, '2024-01-15 10:32:00', 3),
(94.50, '2024-01-15 10:34:00', 3),
(93.80, '2024-02-10 09:15:00', 3),
(92.90, '2024-02-10 09:17:00', 3),

-- Lando Norris (id 4)
(97.50, '2024-01-15 10:30:00', 4),
(96.30, '2024-01-15 10:32:00', 4),
(95.80, '2024-01-15 10:34:00', 4),
(94.50, '2024-02-10 09:15:00', 4),
(93.70, '2024-02-10 09:17:00', 4),

-- Carlos Sainz (id 5)
(96.80, '2024-01-20 14:00:00', 5),
(95.50, '2024-01-20 14:02:00', 5),
(94.90, '2024-01-20 14:04:00', 5),
(94.10, '2024-02-15 11:00:00', 5),
(93.50, '2024-02-15 11:02:00', 5),

-- Sergio Pérez (id 6)
(95.90, '2024-01-20 14:00:00', 6),
(94.70, '2024-01-20 14:02:00', 6),
(93.80, '2024-01-20 14:04:00', 6),
(92.90, '2024-02-15 11:00:00', 6),
(92.10, '2024-02-15 11:02:00', 6),

-- George Russell (id 7)
(97.20, '2024-01-25 16:30:00', 7),
(96.40, '2024-01-25 16:32:00', 7),
(95.70, '2024-01-25 16:34:00', 7),
(95.00, '2024-02-20 13:15:00', 7),
(94.30, '2024-02-20 13:17:00', 7),

-- Fernando Alonso (id 8)
(96.50, '2024-01-25 16:30:00', 8),
(95.80, '2024-01-25 16:32:00', 8),
(95.10, '2024-01-25 16:34:00', 8),
(94.50, '2024-02-20 13:15:00', 8),
(93.90, '2024-02-20 13:17:00', 8),

-- Voltas de Maratona (tempos em minutos)
-- Eliud Kipchoge (id 11)
(180.50, '2024-03-01 08:00:00', 11),
(179.20, '2024-03-01 08:30:00', 11),
(178.80, '2024-03-01 09:00:00', 11),
(177.50, '2024-03-15 07:45:00', 11),

-- Kenenisa Bekele (id 12)
(182.30, '2024-03-01 08:00:00', 12),
(181.10, '2024-03-01 08:30:00', 12),
(180.50, '2024-03-01 09:00:00', 12),
(179.80, '2024-03-15 07:45:00', 12),

-- Mo Farah (id 13)
(185.40, '2024-03-05 09:15:00', 13),
(184.20, '2024-03-05 09:45:00', 13),
(183.50, '2024-03-05 10:15:00', 13),
(182.90, '2024-03-20 08:30:00', 13),

-- Voltas de Velocidade (tempos em segundos - pista 100m)
-- Usain Bolt (id 14)
(9.85, '2024-04-01 14:00:00', 14),
(9.78, '2024-04-01 14:15:00', 14),
(9.72, '2024-04-01 14:30:00', 14),
(9.69, '2024-04-15 15:00:00', 14),
(9.63, '2024-04-15 15:15:00', 14),

-- Andre De Grasse (id 15)
(10.05, '2024-04-01 14:00:00', 15),
(9.98, '2024-04-01 14:15:00', 15),
(9.95, '2024-04-01 14:30:00', 15),
(9.91, '2024-04-15 15:00:00', 15),
(9.89, '2024-04-15 15:15:00', 15),

-- Noah Lyles (id 16)
(9.95, '2024-04-05 16:00:00', 16),
(9.88, '2024-04-05 16:15:00', 16),
(9.85, '2024-04-05 16:30:00', 16),
(9.82, '2024-04-20 14:30:00', 16),
(9.79, '2024-04-20 14:45:00', 16),

-- Voltas de 400m Barreiras (tempos em segundos)
-- Alison dos Santos (id 17)
(48.50, '2024-05-01 10:00:00', 17),
(47.80, '2024-05-01 10:05:00', 17),
(47.20, '2024-05-01 10:10:00', 17),
(46.90, '2024-05-20 09:30:00', 17),

-- Karsten Warholm (id 18)
(47.90, '2024-05-01 10:00:00', 18),
(47.10, '2024-05-01 10:05:00', 18),
(46.80, '2024-05-01 10:10:00', 18),
(45.94, '2024-05-20 09:30:00', 18),

-- Sydney McLaughlin (id 19)
(52.30, '2024-05-10 11:00:00', 19),
(51.80, '2024-05-10 11:05:00', 19),
(51.20, '2024-05-10 11:10:00', 19),
(50.68, '2024-05-25 10:15:00', 19),

-- Femke Bol (id 20)
(53.10, '2024-05-10 11:00:00', 20),
(52.60, '2024-05-10 11:05:00', 20),
(52.00, '2024-05-10 11:10:00', 20),
(51.45, '2024-05-25 10:15:00', 20);

-- Ver todos os usuários
SELECT * FROM `corrida_db`.`users`;

-- Ver todos os corredores
SELECT * FROM `corrida_db`.`corredores`;

-- Ver todas as voltas com nomes dos corredores
SELECT 
    v.id,
    c.nome AS corredor,
    c.turma,
    v.tempo,
    v.data
FROM `corrida_db`.`voltas` v
INNER JOIN `corrida_db`.`corredores` c ON v.corredores_id = c.id
ORDER BY v.data DESC;


-- Melhor volta de cada corredor
SELECT 
    c.nome,
    c.turma,
    MIN(v.tempo) AS melhor_tempo,
    COUNT(v.id) AS total_voltas
FROM `corrida_db`.`corredores` c
LEFT JOIN `corrida_db`.`voltas` v ON c.id = v.corredores_id
GROUP BY c.id, c.nome, c.turma
ORDER BY melhor_tempo ASC;

-- Ranking geral (melhores tempos)
SELECT 
    c.nome,
    c.turma,
    MIN(v.tempo) AS melhor_volta,
    ROUND(AVG(v.tempo), 2) AS media_tempo,
    COUNT(v.id) AS total_voltas
FROM `corrida_db`.`corredores` c
INNER JOIN `corrida_db`.`voltas` v ON c.id = v.corredores_id
GROUP BY c.id, c.nome, c.turma
ORDER BY melhor_volta ASC
LIMIT 10;

-- Tempo total por corredor
SELECT 
    c.nome,
    c.turma,
    SUM(v.tempo) AS tempo_total,
    COUNT(v.id) AS quantidade_voltas
FROM `corrida_db`.`corredores` c
INNER JOIN `corrida_db`.`voltas` v ON c.id = v.corredores_id
GROUP BY c.id, c.nome, c.turma
ORDER BY tempo_total ASC;

-- Melhor volta geral
SELECT 
    c.nome,
    c.turma,
    v.tempo AS melhor_tempo_geral,
    v.data
FROM `corrida_db`.`voltas` v
INNER JOIN `corrida_db`.`corredores` c ON v.corredores_id = c.id
ORDER BY v.tempo ASC
LIMIT 1;
