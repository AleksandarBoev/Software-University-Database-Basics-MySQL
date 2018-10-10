#Setup
CREATE DATABASE `minions`;

USE `minions`;

#01. Create Tables 
CREATE TABLE `minions` (
    `id` INT,
    `name` VARCHAR(50),
    `age` INT,
    PRIMARY KEY (`id`)
);

CREATE TABLE `towns` (
    `id` INT,
    `name` VARCHAR(50),
    PRIMARY KEY (`id`)
);

#02. Alter Minions Table 
ALTER TABLE `minions`
ADD COLUMN `town_id` INT;

ALTER TABLE `minions`
ADD CONSTRAINT `fk_minions_towns` FOREIGN KEY(`town_id`) REFERENCES `towns`(`id`);

#03. Insert Records in Both Tables 
INSERT INTO `towns`(`id`, `name`) VALUES
(1, 'Sofia'),
(2, 'Plovdiv'),
(3, 'Varna');

INSERT INTO `minions` (`id`, `name`, `age`, `town_id`) VALUES
(1, 'Kevin', 22, 1),
(2, 'Bob', 15, 3),
(3, 'Steward', NULL, 2);

#04. Truncate Table Minions 
TRUNCATE `minions`;

#05. Drop All Tables 
DROP TABLE `minions`;

DROP TABLE `towns`;

#06. Create Table People 
CREATE TABLE `people` (
    `id` INT UNSIGNED AUTO_INCREMENT,
    `name` VARCHAR(200) NOT NULL,
    `picture` MEDIUMBLOB,
    `height` DOUBLE(3 , 2 ),
    `weight` DOUBLE(5 , 2 ),
    `gender` ENUM('m', 'f') NOT NULL,
    `birthdate` DATE NOT NULL,
    `biography` TEXT,
    PRIMARY KEY (`id`)
);

INSERT INTO `people`(`name`, `gender`, `birthdate`) VALUES
('Aleksandar', 'm', '1995-09-28'),
('Pesho', 'm', '1996-12-30'),
('Gosho', 'm', '2000-01-05'),
('Petya', 'f', '1996-09-08'),
('Ivona', 'f', '1996-09-02');

#07. Create Table Users 
CREATE TABLE `users` (
    `id` BIGINT UNSIGNED AUTO_INCREMENT,
    `username` VARCHAR(30) UNIQUE NOT NULL,
    `password` VARCHAR(26) NOT NULL,
    `profile_picture` BLOB,
    `last_login_time` TIME,
    `is_deleted` BOOL,
    PRIMARY KEY (`id`)
);

INSERT INTO `users`(`username`, `password`, `last_login_time`, `is_deleted`) VALUES 
('The Destroyer', 'Cool', '18:53:02', FALSE),
('The Healer', 'Hot', '18:52:02', 1),
('The Tank', 'Tough', '18:51:01', 1),
('The DPS', 'Bullseye', '18:50:00', 0),
('The Magician', 'Aba kadabra', '18:49:00', 1);

#08. Change Primary Key 
ALTER TABLE `users`
MODIFY COLUMN `id` BIGINT UNSIGNED; #remove auto increment

ALTER TABLE `users`
DROP PRIMARY KEY;

ALTER TABLE `users`
ADD CONSTRAINT `pk_users` PRIMARY KEY(`id`, `username`); #not sure what the constraint does for now

ALTER TABLE `users`
MODIFY COLUMN `id` BIGINT UNSIGNED AUTO_INCREMENT; #return the auto increment

#9. Set Default Value of a Field 
ALTER TABLE `users`
MODIFY COLUMN `last_login_time` TIMESTAMP DEFAULT NOW(); #"NOW()" does not work with datatype "TIME"

#10. Set Unique Field 
ALTER TABLE `users`
MODIFY COLUMN `id` BIGINT UNSIGNED;

ALTER TABLE `users`
DROP PRIMARY KEY;

ALTER TABLE `users`
ADD CONSTRAINT `pk_users` PRIMARY KEY(`id`);

ALTER TABLE `users`
MODIFY COLUMN `id` BIGINT UNSIGNED AUTO_INCREMENT;

ALTER TABLE `users`
MODIFY COLUMN `username` VARCHAR(30) UNIQUE;

SELECT * FROM `users`;

#11. Movies Database (91/100)
#Setup
CREATE DATABASE `movies`;

USE `movies`;

#Judge code
CREATE TABLE `directors` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `director_name` VARCHAR(70) NOT NULL,
    `notes` TEXT,
    CONSTRAINT `pk_directors` PRIMARY KEY (`id`)
);

INSERT INTO `directors`(`director_name`) VALUES 
('Director2'),
('Director3'),
('Director4'),
('Director5'),
('Director6');

CREATE TABLE `genres` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `genre_name` VARCHAR(30) NOT NULL,
    `notes` TEXT,
    CONSTRAINT `pk_genres` PRIMARY KEY (`id`)
);

INSERT INTO `genres`(`genre_name`) VALUES 
('Genre1'),
('Genre2'),
('Genre3'),
('Genre4'),
('Genre5');

CREATE TABLE `categories` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `category_name` VARCHAR(30) NOT NULL,
    `notes` TEXT,
    CONSTRAINT `pk_categories` PRIMARY KEY (`id`)
);

INSERT INTO `categories`(`category_name`) VALUES
('Category1'),
('Category2'),
('Category3'),
('Category4'),
('Category5');

# movies (id, title, director_id, copyright_year, length, genre_id, category_id, rating, notes)
CREATE TABLE `movies` (
    `id` INT UNSIGNED NOT NULL AUTO_INCREMENT,
    `title` VARCHAR(30) NOT NULL,
    `director_id` INT UNSIGNED NOT NULL,
    `copyright_year` YEAR NOT NULL,
    `length` TIME NOT NULL,
    `genre_id` INT UNSIGNED NOT NULL,
    `category_id` INT UNSIGNED NOT NULL,
    `rating` DOUBLE NOT NULL,
    `notes` TEXT,
    CONSTRAINT `pk_movies` PRIMARY KEY (`id`),
    CONSTRAINT `fk_movies_directors` FOREIGN KEY (`director_id`)
        REFERENCES `directors` (`id`),
    CONSTRAINT `fk_movies_genres` FOREIGN KEY (`genre_id`)
        REFERENCES `genres` (`id`),
    CONSTRAINT `fk_movies_categories` FOREIGN KEY (`category_id`)
        REFERENCES `categories` (`id`)
);

INSERT INTO `movies`(`title`, `director_id`, `copyright_year`, `length`, `genre_id`, `category_id`, `rating`) VALUES
('Title1',  1, '2001', '02:30:40', 1, 1, 5.0),
('Title2',  2, '2002', '02:15:30', 2, 2, 6.0),
('Title3',  3, '2003', '02:00:20', 3, 3, 7.0),
('Title4',  4, '2004', '01:45:10', 4, 4, 8.0),
('Title5',  5, '2005', '01:30:00', 5, 5, 9.0);

#12. Car Rental Database (75/100)
#Setup
CREATE DATABASE `car_rental`;

USE `car_rental`;

#Judge code
CREATE TABLE `categories` (
    `id` INT AUTO_INCREMENT,
    `category` VARCHAR(50) NOT NULL,
    `daily_rate` DOUBLE(7 , 2 ),
    `weekly_rate` DOUBLE(8 , 2 ),
    `monthly_rate` DOUBLE(9 , 2 ),
    `weekend_rate` DOUBLE(8 , 2 ),
    CONSTRAINT `pk_categories` PRIMARY KEY (`id`)
);

INSERT INTO `categories` (`category`) VALUES 
('Category1'), ('Category2'), ('Category3');

CREATE TABLE `cars` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `plate_number` VARCHAR(12) NOT NULL,
    `make` VARCHAR(30) NOT NULL,
    `model` VARCHAR(20) NOT NULL,
    `car_year` YEAR NOT NULL,
    `category_id` INT NOT NULL,
    `doors` INT(2),
    `picture` BLOB,
    `car_condition` VARCHAR(255),
    `avaliable` BOOL NOT NULL,
    CONSTRAINT `pk_cars` PRIMARY KEY (`id`),
    CONSTRAINT `fk_cars_categories` FOREIGN KEY (`category_id`)
        REFERENCES `categories` (`id`)
);

INSERT INTO `cars` (`plate_number`, `category_id`, `make`, `model`, `car_year`, `avaliable`) VALUES 
('A1234SA', 1, 'Make1', 'BMW', '2000', 1),
('B1234SC', 1, 'Make2', 'Mercedes', '2001', 0),
('C3324SB', 1, 'Make3', 'Skoda', '2002', TRUE);


CREATE TABLE `employees` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `first_name` VARCHAR(30) NOT NULL,
    `last_name` VARCHAR(30) NOT NULL,
    `title` VARCHAR(30) NOT NULL,
    `notes` TEXT,
    CONSTRAINT `pk_employees` PRIMARY KEY (`id`)
);

INSERT INTO `employees` (`first_name`, `last_name`, `title`) VALUES 
('Aleksandar', 'Boev', 'Boss'),
('Pesho', 'Peshov', 'Cashier'),
('Gosho', 'Goshov', 'PC maintenance');

CREATE TABLE `customers` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `driver_licence_number` VARCHAR(20) NOT NULL,
    `full_name` VARCHAR(50) NOT NULL,
    `address` VARCHAR(40) NOT NULL,
    `city` VARCHAR(20) NOT NULL,
    `zip_code` VARCHAR(20) NOT NULL,
    `notes` TEXT,
    CONSTRAINT `pk_customers` PRIMARY KEY (`id`)
);

INSERT INTO `customers` (`driver_licence_number`, `full_name`, `address`, `city`, `zip_code`) VALUES
('12345', 'Names1', 'Address1', 'City1', '1111'),
('123456', 'Names2', 'Address2', 'City2', '2222'),
('1234567', 'Names3', 'Address3', 'City3', '3333');

CREATE TABLE `rental_orders` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `employee_id` INT NOT NULL,
    `customer_id` INT NOT NULL,
    `car_id` INT NOT NULL,
    `car_condition` VARCHAR(255),
    `tank_level` DOUBLE(5 , 2 ),
    `kilometrage_start` INT(7) UNSIGNED,
    `kilometrage_end` INT(7) UNSIGNED,
    `total_kilometrage` INT(7) UNSIGNED,
    `start_date` DATE NOT NULL,
    `end_date` DATE NOT NULL,
    `total_days` INT(5) UNSIGNED,
    `rate_applied` ENUM('daily_rate', 'weekly_rate', 'monthly_rate', 'weekend_rate') NOT NULL,
    `tax_rate` DECIMAL(5 , 2 ) UNSIGNED NOT NULL,
    `order_status` TEXT NOT NULL,
    `notes` TEXT,
    CONSTRAINT `pk_rental_orders` PRIMARY KEY (`id`),
    CONSTRAINT `fk_rental_orders_employees` FOREIGN KEY (`employee_id`)
        REFERENCES `employees` (`id`),
    CONSTRAINT `fk_rental_orders_customers` FOREIGN KEY (`customer_id`)
        REFERENCES `customers` (`id`),
    CONSTRAINT `fk_rental_orders_cars` FOREIGN KEY (`car_id`)
        REFERENCES `cars` (`id`)
);

INSERT INTO `rental_orders` 
(`employee_id`, `customer_id`, `car_id`, `start_date`, `end_date`, `rate_applied`, `tax_rate`, `order_status`) VALUES
(1, 1, 1, '2018-09-20', '2018-09-25', 'daily_rate', 20.0, 'Ongoing'),
(2, 2, 2, '2018-09-21', '2018-09-26', 'monthly_rate', 20.0, 'About to begin'),
(3, 3, 3, '2018-09-22', '2018-09-27', 'weekend_rate', 20.0, 'Finished');

#13. Hotel Database 
#Setup
CREATE DATABASE `hotel`;

USE `hotel`;

#Judge Code
CREATE TABLE `employees` (
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `first_name` VARCHAR(50) NOT NULL,
    `last_name` VARCHAR(50) NOT NULL,
    `title` VARCHAR(50) NOT NULL,
    `notes` TEXT
);

INSERT INTO `employees` (`first_name`, `last_name`, `title`) VALUES
('A', 'B', 'Cashier'),
('C', 'D', 'Accountant'),
('E', 'F', 'Meintenance');

CREATE TABLE `customers` (
    `account_number` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `first_name` VARCHAR(50) NOT NULL,
    `last_name` VARCHAR(50) NOT NULL,
    `phone_number` VARCHAR(50) NOT NULL,
    `emergency_name` VARCHAR(50) NOT NULL,
    `emergency_number` VARCHAR(50) NOT NULL,
    `notes` TEXT
);

INSERT INTO `customers` (`first_name`, `last_name`, `phone_number`, `emergency_name`, `emergency_number`) VALUES
('1', '1', '1', '1', '1'),
('2', '2', '2', '2', '2'),
('3', '3', '3', '3', '3');


CREATE TABLE `room_status` (
    `room_status` VARCHAR(50) NOT NULL PRIMARY KEY,
    `notes` TEXT NOT NULL
);

INSERT INTO `room_status`(`room_status`, `notes`) VALUES 
('Reserved', 'Can not be reserved.'),
('Taken', 'There is a customer there already.'),
('Not taken', 'Can be reserved and taken.');

CREATE TABLE `room_types` (
    `room_type` VARCHAR(50) NOT NULL PRIMARY KEY,
    `notes` TEXT NOT NULL
);

INSERT INTO `room_types`(`room_type`, `notes`) VALUES
('Big', 'Between 41 and 50 square meters inclusive'),
('Medium', 'Between 31 and 40 square meters inclusive'),
('Small', 'Between 21 and 30 square meters inclusive');

CREATE TABLE `bed_types` (
    `bed_type` VARCHAR(50) NOT NULL PRIMARY KEY,
    `notes` TEXT NOT NULL
);

INSERT INTO `bed_types`(`bed_type`, `notes`) VALUES
('Big', 'King size'),
('Medium', '1.80 by 1.00 meters'),
('Small', 'Kid size');

CREATE TABLE `rooms` (
    `room_number` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `room_type` VARCHAR(50) NOT NULL,
    `bed_type` VARCHAR(50) NOT NULL,
    `rate` DOUBLE(6 , 2 ) UNSIGNED NOT NULL,
    `room_status` VARCHAR(50) NOT NULL,
    `notes` TEXT,
    FOREIGN KEY (`room_type`)
        REFERENCES `room_types` (`room_type`),
    FOREIGN KEY (`bed_type`)
        REFERENCES `bed_types` (`bed_type`),
    FOREIGN KEY (`room_status`)
        REFERENCES `room_status` (`room_status`)
);

INSERT INTO `rooms`(`room_type`, `bed_type`, `rate`, `room_status`) VALUES
('Big', 'Big', 3.5, 'Reserved'), 
('Medium', 'Medium', 3.0, 'Taken'), 
('Small', 'Small', 3.0, 'Not taken');

CREATE TABLE `payments` (
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `employee_id` INT NOT NULL,
    `payment_date` DATE NOT NULL,
    `account_number` INT NOT NULL,
    `first_date_occupied` DATE,
    `last_date_occpuied` DATE,
    `total_days` INT,
    `amount_charged` DECIMAL(8 , 2 ) DEFAULT 0.00,
    `tax_rate` DOUBLE(5 , 2 ) NOT NULL,
    `tax_amount` DOUBLE(5 , 2 ) NOT NULL,
    `payment_total` DECIMAL(8 , 2 ) NOT NULL,
    `notes` TEXT,
    FOREIGN KEY (`employee_id`)
        REFERENCES `employees` (`id`),
    FOREIGN KEY (`account_number`)
        REFERENCES `customers` (`account_number`)
);

INSERT INTO `payments`(`employee_id`, `payment_date`, `account_number`, `tax_rate`, `tax_amount`, `payment_total`) VALUES
(1, '2018-09-25', 1, 10.0, 23.49, 234.87),
(2, '2017-09-25', 2, 10.0, 33.39, 333.87),
(3, '2016-09-25', 3, 10.0, 44.44, 444.87);

CREATE TABLE `occupancies` (
    `id` INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    `employee_id` INT NOT NULL,
    `date_occupied` DATE NOT NULL,
    `account_number` INT NOT NULL,
    `room_number` INT NOT NULL,
    `rate_applied` DOUBLE(6 , 2 ),
    `phone_charge` INT(3),
    `notes` TEXT,
    FOREIGN KEY (`employee_id`)
        REFERENCES `employees` (`id`),
    FOREIGN KEY (`account_number`)
        REFERENCES `customers` (`account_number`),
    FOREIGN KEY (`room_number`)
        REFERENCES `rooms` (`room_number`)
);

INSERT INTO `occupancies`(`employee_id`, `date_occupied`, `account_number`, `room_number`) VALUES
(1, '2018-09-25', 1, 1),
(2, '2018-09-26', 2, 2),
(3, '2018-09-27', 3, 3);

#14. Create SoftUni Database 
#Setup
CREATE DATABASE `soft_uni`;

USE `soft_uni`;

#Judge code
CREATE TABLE `towns` (
    `id` INT AUTO_INCREMENT NOT NULL,
    `name` VARCHAR(50) NOT NULL,
    CONSTRAINT `pk_towns` PRIMARY KEY (`id`)
);

CREATE TABLE `addresses` (
    `id` INT AUTO_INCREMENT NOT NULL,
    `address_text` VARCHAR(50) NOT NULL,
    `town_id` INT NOT NULL,
    CONSTRAINT `pk_addresses` PRIMARY KEY (`id`),
    CONSTRAINT `fk_addresses_towns` FOREIGN KEY (`town_id`)
        REFERENCES `towns` (`id`)
);

CREATE TABLE `departments` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50),
    CONSTRAINT `pk_departments` PRIMARY KEY (`id`)
);

CREATE TABLE `employees` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `first_name` VARCHAR(30) NOT NULL,
    `middle_name` VARCHAR(30) NOT NULL,
    `last_name` VARCHAR(30) NOT NULL,
    `job_title` VARCHAR(50) NOT NULL,
    `department_id` INT NOT NULL,
    `hire_date` DATE,
    `salary` DECIMAL(7 , 2 ) NOT NULL,
    `address_id` INT,
    CONSTRAINT `pk_employees` PRIMARY KEY (`id`),
    CONSTRAINT `fk_employees_departments` FOREIGN KEY (`department_id`)
        REFERENCES `departments` (`id`),
    CONSTRAINT `fk_employees_addresses` FOREIGN KEY (`address_id`)
        REFERENCES `addresses` (`id`)
);

#16. Basic Insert 
INSERT INTO `towns` (`name`) VALUES ('Sofia'), ('Plovdiv'), ('Varna'), ('Burgas');
INSERT INTO `departments` (`name`) 
	VALUES ('Engineering'), ('Sales'), ('Marketing'), ('Software Development'), ('Quality Assurance');
INSERT INTO `employees` (`first_name`, `middle_name`, `last_name`, `job_title`, `department_id`, `hire_date`, `salary`) VALUES
('Ivan', 'Ivanov', 'Ivanov', '.NET Developer', 4, '2013-02-01', 3500.00),
('Petar', 'Petrov', 'Petrov', 'Senior Engineer', 1,  '2004-03-02',	4000.00),
('Maria', 'Petrova', 'Ivanova', 'Intern', 5, '2016-08-28',	525.25),
('Georgi', 'Terziev', 'Ivanov', 'CEO',  2,	'2007-12-09', 3000.00),
('Peter', 'Pan', 'Pan', 'Intern', 3, '2016-08-28',	599.88);

#17. Basic Select All Fields 
SELECT * FROM `towns`;
SELECT * FROM `departments`;
SELECT * FROM `employees`;

#18. Basic Select All Fields and Order Them 
SELECT * FROM `towns`
ORDER BY `name` ASC;
    
SELECT * FROM `departments`
ORDER BY `name` ASC;

SELECT * FROM `employees`
ORDER BY `salary` DESC;

#19. Basic Select Some Fields 
SELECT `name` FROM `towns`
ORDER BY `name` ASC;

SELECT `name` FROM `departments`
ORDER BY `name` ASC;

SELECT `first_name`, `last_name`, `job_title`, `salary` FROM `employees`
ORDER BY `salary` DESC;

#20. Increase Employees Salary 
UPDATE `employees`
SET `salary` = `salary` + (`salary` * 0.1)
#WHERE `salary` IS NOT NULL; #does not work for some reason, but seems like the best choice
WHERE `id` > 0;

SELECT `salary` FROM employees;

#21. Decrease Tax Rate 
#Setup
USE `hotel`;

#Judge code
UPDATE `payments` 
SET `tax_rate` = `tax_rate` - (`tax_rate` * 0.03)
WHERE `id` > 0;

SELECT `tax_rate` FROM `payments`;

#22. Delete All Records 
TRUNCATE `occupancies`;
