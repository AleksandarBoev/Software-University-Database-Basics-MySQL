#1. Mountains and Peaks 
#Setup
USE `tests`; #doesn't matter which db will be used for this task

#Judge Code
CREATE TABLE `mountains` (
	`id` INT AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    CONSTRAINT `pk_mountains` PRIMARY KEY (`id`)
);

CREATE TABLE `peaks` (
	`id` INT AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `mountain_id` INT NOT NULL,
    CONSTRAINT `pk_peaks` PRIMARY KEY (`id`),
    CONSTRAINT `fk_peaks_mountains` FOREIGN KEY (`mountain_id`) REFERENCES `mountains`(`id`)
);

#2. Trip Organization 
#Setup
USE `camp`;

#Judge code
SELECT
	`v`.`driver_id`, 
    `v`.`vehicle_type`, 
    CONCAT(`c`.`first_name`, ' ', `c`.`last_name`) AS `driver_name`
FROM `vehicles` `v`
JOIN `campers` `c`
ON `v`.`driver_id` = `c`.`id`;

#3. SoftUni Hiking 
SELECT 
	`r`.`starting_point` AS `route_starting_point`,
    `r`.`end_point` AS `route_ending_point`,
    `r`.`leader_id`,
	CONCAT_WS(' ', `c`.`first_name`, `c`.`last_name`) AS `leadder_name`
FROM `routes` `r`
JOIN `campers` `c`
ON `r`.`leader_id` = `c`.`id`;

#4. Delete Mountains 
#Setup
USE `tests`;

#Judge code
DROP TABLE `peaks`;
DROP TABLE `mountains`;

CREATE TABLE `mountains` (
	`id` INT AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    CONSTRAINT `pk_mountains` PRIMARY KEY (`id`)
);

CREATE TABLE `peaks` (
	`id` INT AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `mountain_id` INT NOT NULL,
    CONSTRAINT `pk_peaks` PRIMARY KEY (`id`),
    CONSTRAINT `fk_peaks_mountains` FOREIGN KEY (`mountain_id`) REFERENCES `mountains`(`id`)
		ON DELETE CASCADE
);

#Testing
INSERT INTO `mountains` (`name`) VALUES ('Vitosha'), ('Rila'), ('Stara Planina'), ('Pirin');
INSERT INTO `peaks` (`name`, `mountain_id`) VALUES 
	('Cherni Vruh', 1), 
    ('Musala', 2), 
    ('Botev', 3),
    ('Vihren', 4),
    ('Kupena', 1),
    ('Samara', 1);
    
CREATE VIEW `v_mountains_and_peaks` AS 
SELECT
	`m`.`name` AS `Mountain Name`,
    `p`.`name` AS `Peak Name`
FROM `mountains` `m`
JOIN `peaks` `p`
ON `p`.`mountain_id` = `m`.`id`;

SELECT * FROM `v_mountains_and_peaks`;

TRUNCATE `peaks`;

SELECT * FROM `v_mountains_and_peaks`;

#5. Project Management DB 
#Setup
CREATE DATABASE `project_management`;
USE `project_management`;

#Judge code
CREATE TABLE `employees` (
	`id` INT AUTO_INCREMENT,
    `first_name` VARCHAR(30) NOT NULL,
    `last_name` VARCHAR(30) NOT NULL, 
    `project_id` INT NOT NULL,
    CONSTRAINT `pk_employees` PRIMARY KEY (`id`)
);

CREATE TABLE `projects` (
	`id` INT AUTO_INCREMENT,
    `client_id` INT NOT NULL,
    `project_lead_id` INT NOT NULL,
    CONSTRAINT `pk_projects` PRIMARY KEY (`id`) 
);

CREATE TABLE `clients` (
	`id` INT AUTO_INCREMENT,
    `client_name` VARCHAR(100) NOT NULL,
    `project_id` INT NOT NULL,
    CONSTRAINT `pk_clients` PRIMARY KEY (`id`)
);

ALTER TABLE `employees`
ADD CONSTRAINT `fk_employees_projects` 
	FOREIGN KEY (`project_id`) REFERENCES `projects`(`id`);
    
ALTER TABLE `projects`
ADD CONSTRAINT `fk_projects_employees`
	FOREIGN KEY (`project_lead_id`) REFERENCES `employees`(`id`),
ADD CONSTRAINT `fk_projects_clients`
	FOREIGN KEY (`client_id`) REFERENCES `clients`(`id`);
    
ALTER TABLE `clients`
ADD CONSTRAINT `fk_clients_projects`
	FOREIGN KEY (`project_id`) REFERENCES `projects`(`id`);
