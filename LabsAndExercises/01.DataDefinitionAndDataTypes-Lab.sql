#Preparation
CREATE DATABASE `gamebar`;

USE `gamebar`;

#01. Create Tables 
CREATE TABLE `employees`(
	`id` INT AUTO_INCREMENT,
    `first_name` VARCHAR(50) NOT NULL,
    `last_name` VARCHAR(50) NOT NULL,
    PRIMARY KEY(`id`)
);

CREATE TABLE `categories`(
	`id` INT AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    PRIMARY KEY(`id`)
);

CREATE TABLE `products`(
	`id` INT AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `category_id` INT NOT NULL,
    PRIMARY KEY(`id`)
);

#02. Insert Data in Tables 
INSERT INTO `employees`(`first_name`, `last_name`) VALUES 
('Aleksandar', 'Boev'), 
('Pesho', 'Peshov'),
('Gosho', 'Goshov');

#03. Alter Table 
ALTER TABLE `employees`
ADD COLUMN `middle_name` VARCHAR(50) NOT NULL DEFAULT 'Middle Name';

#04. Adding Constraints 
ALTER TABLE `products`
ADD CONSTRAINT `fk_products_categories` FOREIGN KEY(`category_id`) REFERENCES `categories`(`id`);

#05. Modifying Columns 
ALTER TABLE `employees`
MODIFY COLUMN `middle_name` VARCHAR(100) NOT NULL DEFAULT 'Middle Name';

#Additional
SELECT * FROM `employees` LIMIT 10;

DROP DATABASE `gamebar`; #dropping a db is almost never a good idea. Records must atleast be archived.


