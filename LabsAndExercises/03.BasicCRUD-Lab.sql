#Downloaded database from course recources:
CREATE DATABASE IF NOT EXISTS `hospital`; 
USE `hospital`;

CREATE TABLE departments (
	id INT PRIMARY KEY AUTO_INCREMENT,
	name VARCHAR(50)
);

INSERT INTO departments(name) VALUES('Therapy'), ('Support'), ('Management'), ('Other');

CREATE TABLE employees (
	id INT PRIMARY KEY AUTO_INCREMENT,
	first_name VARCHAR(50) NOT NULL,
	last_name VARCHAR(50) NOT NULL,
	job_title VARCHAR(50) NOT NULL,
	department_id INT NOT NULL,
	salary DOUBLE NOT NULL,
	CONSTRAINT `fk_department_id` FOREIGN KEY (`department_id`) REFERENCES `departments` (`id`)
);

INSERT INTO `employees` (`first_name`,`last_name`, `job_title`,`department_id`,`salary`) VALUES
	('John', 'Smith', 'Therapist',1, 900.00),
	('John', 'Johnson', 'Acupuncturist',1, 880.00),
	('Smith', 'Johnson', 'Technician',2, 1100.00),
	('Peter', 'Petrov', 'Supervisor',3, 1100.00),
	('Peter', 'Ivanov', 'Dentist',4, 1500.23),
	('Ivan' ,'Petrov', 'Therapist',1, 990.00),
	('Jack', 'Jackson', 'Epidemiologist',4, 1800.00),
	('Pedro', 'Petrov', 'Medical Director',3, 2100.00),
	('Nikolay', 'Ivanov', 'Nutrition Technician',4, 1600.00);
	

	
CREATE TABLE rooms (
	id INT PRIMARY KEY AUTO_INCREMENT,
	occupation VARCHAR(30)
);

INSERT INTO rooms(`occupation`) VALUES('free'), ('occupied'),('free'),('free'),('occupied');

CREATE TABLE patients (
	id INT PRIMARY KEY AUTO_INCREMENT,
	first_name VARCHAR(50),
	last_name VARCHAR(50),
	room_id INT NOT NULL
);

INSERT INTO patients(`first_name`,`last_name`,`room_id`) VALUES('Pesho','Petrov',1),('Gosho','Georgiev',3),('Mariya','Marieva', 2), ('Katya','Katerinova', 2), ('Nikolay','Nikolaev',3);

#My code
#01. Select Employee Information 
SELECT `id`, `first_name`, `last_name`, `job_title` FROM `employees` 
ORDER BY `id` ASC;

#02. Select Employees with Filter 
SELECT `id`, concat(`first_name`, ' ', `last_name`) AS 'full_name', `job_title`, `salary` FROM `employees`
WHERE `salary` > 1000.00
ORDER BY `id` ASC;

#03. Update Salary and Select 
UPDATE `employees`
SET `salary` = `salary` * 1.1
WHERE `job_title` = 'Therapist';

SELECT `salary` FROM `employees`
ORDER BY `salary` ASC;

#04. Top Paid Employee 
CREATE VIEW `v_top_paid_employee` AS
SELECT * FROM `employees`
ORDER BY `salary` DESC
LIMIT 1;

SELECT * FROM `v_top_paid_employee`;

#05. Select Employees by Multiple Filters 
CREATE VIEW `v_department4_high_salaries` AS
SELECT * FROM `employees`
WHERE `department_id` = 4 AND `salary` >= 1600
ORDER BY `id` ASC; 

SELECT * FROM `v_department4_high_salaries`;

#06. Delete from Table 
DELETE FROM `employees`
WHERE `department_id` IN (2, 1); #`department_id` = 2 OR `department_id` = 1;

CREATE VIEW `v_better_column_names` AS
SELECT `id`, `first_name` AS 'First_name', `last_name` AS 'Last_Name', 
	`job_title` AS 'Job_Title', `department_id` AS 'Department_id', `salary` FROM `employees`
    ORDER BY `id` ASC;
    
SELECT * FROM `v_better_column_names`;