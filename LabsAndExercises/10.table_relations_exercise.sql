#Setup
CREATE DATABASE `table_relations_exercise_database`;
USE `table_relations_exercise_database`;

#01. One-To-One Relationship 
CREATE TABLE `persons` (
    `person_id` INT NOT NULL,
    `first_name` VARCHAR(30) NOT NULL,
    `salary` DECIMAL(9 , 2 ) NOT NULL,
    `passport_id` INT NOT NULL
);

CREATE TABLE `passports` (
    `passport_id` INT NOT NULL,
    `passport_number` VARCHAR(8) NOT NULL
);

ALTER TABLE `passports`
MODIFY COLUMN `passport_number` VARCHAR(8) NOT NULL UNIQUE,
ADD CONSTRAINT `pk_passports` PRIMARY KEY (`passport_id`),
MODIFY COLUMN `passport_id` INT NOT NULL AUTO_INCREMENT;

ALTER TABLE `persons`
ADD CONSTRAINT `pk_persons` PRIMARY KEY (`person_id`),
MODIFY COLUMN `person_id` INT NOT NULL AUTO_INCREMENT,
MODIFY COLUMN `passport_id` INT NOT NULL UNIQUE, #ensures the one to one relationship
ADD CONSTRAINT `fk_persons_passports` FOREIGN KEY (`passport_id`)
	REFERENCES `passports`(`passport_id`);
    
INSERT INTO `passports`(`passport_id`, `passport_number`) VALUES (101, 'N34FG21B');
INSERT INTO `passports`(`passport_number`) VALUES ('K65LO4R7'), ('ZE657QP2');

INSERT INTO `persons`(`first_name`, `salary`, `passport_id`) VALUES
('Roberto', 43300.00, 102),
('Tom', 56100.00, 103),
('Yana', 60200.00, 101);

#02. One-To-Many Relationship 
CREATE TABLE `manufacturers` (
    `manufacturer_id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(30) NOT NULL,
    `established_on` DATE NOT NULL,
    CONSTRAINT `pk_manufacturers` PRIMARY KEY (`manufacturer_id`)
);

CREATE TABLE `models` (
    `model_id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(30),
    `manufacturer_id` INT NOT NULL,
    CONSTRAINT `pk_models` PRIMARY KEY (`model_id`),
    CONSTRAINT `fk_models_manufacturers` FOREIGN KEY (`manufacturer_id`)
        REFERENCES `manufacturers` (`manufacturer_id`)
);

INSERT INTO `manufacturers`(`name`, `established_on`) VALUES
('BMW', '1916-03-01'),
('Tesla', '2003-01-01'),
('Lada', '1966-05-01');

INSERT INTO `models`(`model_id`, `name`, `manufacturer_id`) VALUES (101, 'X1', 1);
INSERT INTO `models`(`name`, `manufacturer_id`) VALUES
('i6', 1),
('Model S', 2),
('Model X', 2), 
('Model 3', 2),
('Nova', 3);

#03. Many-To-Many Relationship 
CREATE TABLE `students` (
	`student_id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    CONSTRAINT `pk_students` PRIMARY KEY (`student_id`)
);

CREATE TABLE `exams` (
    `exam_id` INT AUTO_INCREMENT NOT NULL,
    `name` VARCHAR(30) NOT NULL,
    CONSTRAINT `pk_exams` PRIMARY KEY (`exam_id`)
);

CREATE TABLE `students_exams` (
    `student_id` INT NOT NULL,
    `exam_id` INT NOT NULL,
    CONSTRAINT `pk_students_exams` PRIMARY KEY (`student_id` , `exam_id`),
    CONSTRAINT `fk_students_exams_students` FOREIGN KEY (`student_id`)
        REFERENCES `students` (`student_id`),
    CONSTRAINT `fk_students_exams_exams` FOREIGN KEY (`exam_id`)
        REFERENCES `exams` (`exam_id`)
);

INSERT INTO `students` (`name`) VALUES ('Mila'), ('Toni'), ('Ron');
INSERT INTO `exams` (`exam_id`, `name`) VALUES 
(101, 'Spring MVC'),
(102, 'Neo4j'),
(103, 'Oracle 11g');

INSERT INTO `students_exams` (`student_id`, `exam_id`) VALUES
(1, 101),
(1, 102),
(2, 101),
(3, 103),
(2, 102),
(2, 103);

#Testing
SELECT 
	`s`.`name` AS `Student Name`,
    `e`.`name` AS `Exam Name`
FROM `students_exams` `se`
JOIN `students` `s`
ON `s`.`student_id` = `se`.`student_id`
JOIN `exams` `e`
ON `e`.`exam_id` = `se`.`exam_id`;

# 04. Self-Referencing 
CREATE TABLE `teachers` (
    `teacher_id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(30) NOT NULL,
    `manager_id` INT,
    CONSTRAINT `pk_teachers` PRIMARY KEY (`teacher_id`),
    CONSTRAINT `fk_teachers_teachers` FOREIGN KEY (`manager_id`)
        REFERENCES `teachers` (`teacher_id`)
);

INSERT INTO `teachers`(`teacher_id`, `name`, `manager_id`) 
VALUES (101, 'John', NULL);

INSERT INTO `teachers`(`name`) VALUES
('Maya'),
('Silvia'),
('Ted'),
('Mark'),
('Greta');

UPDATE `teachers`
SET `manager_id` = 106
WHERE `name` IN ('Maya', 'Silvia'); 

UPDATE `teachers`
SET `manager_id` = 105
WHERE `name` IN ('Ted');

UPDATE `teachers`
SET `manager_id` = 101
WHERE `name` IN ('Mark', 'Greta');

#05. Online Store Database 
#Setup
CREATE DATABASE `online_store_database`;
USE `online_store_database`;

#Judge code
CREATE TABLE `item_types` (
    `item_type_id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50),
    CONSTRAINT `pk_item_types` PRIMARY KEY (`item_type_id`)
);

CREATE TABLE `items` (
    `item_id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `item_type_id` INT NOT NULL,
    CONSTRAINT `pk_items` PRIMARY KEY (`item_id`),
    CONSTRAINT `fk_items_item_types` FOREIGN KEY (`item_type_id`)
        REFERENCES `item_types` (`item_type_id`)
);

CREATE TABLE `cities` (
    `city_id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    CONSTRAINT `pk_cities` PRIMARY KEY (`city_id`)
);

CREATE TABLE `customers` (
    `customer_id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `birthday` DATE,
    `city_id` INT NOT NULL,
    CONSTRAINT `pk_customers` PRIMARY KEY (`customer_id`),
    CONSTRAINT `fk_customers_cities` FOREIGN KEY (`city_id`)
        REFERENCES `cities` (`city_id`)
);

CREATE TABLE `orders` (
    `order_id` INT NOT NULL AUTO_INCREMENT,
    `customer_id` INT NOT NULL,
    CONSTRAINT `pk_orders` PRIMARY KEY (`order_id`),
    CONSTRAINT `fk_orders_customers` FOREIGN KEY (`customer_id`)
        REFERENCES `customers` (`customer_id`)
);

CREATE TABLE `order_items` (
    `order_id` INT NOT NULL,
    `item_id` INT NOT NULL,
    CONSTRAINT `pk_order_items` PRIMARY KEY (`order_id` , `item_id`),
    CONSTRAINT `fk_order_items_items` FOREIGN KEY (`item_id`)
        REFERENCES `items` (`item_id`),
    CONSTRAINT `fk_orders_items_orders` FOREIGN KEY (`order_id`)
        REFERENCES `orders` (`order_id`)
);

#06. University Database
#Setup
CREATE DATABASE `university_database`;
USE `university_database`;

#Judge code
CREATE TABLE `subjects` (
    `subject_id` INT NOT NULL AUTO_INCREMENT,
    `subject_name` VARCHAR(50) NOT NULL,
    CONSTRAINT `pk_subjects` PRIMARY KEY (`subject_id`)
);

CREATE TABLE `majors` (
    `major_id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    CONSTRAINT `pk_majors` PRIMARY KEY (`major_id`)
);

CREATE TABLE `students` (
    `student_id` INT NOT NULL AUTO_INCREMENT,
    `student_number` VARCHAR(12) NOT NULL,
    `student_name` VARCHAR(50) NOT NULL,
    `major_id` INT NOT NULL,
    CONSTRAINT `pk_students` PRIMARY KEY (`student_id`),
    CONSTRAINT `fk_students_majors` FOREIGN KEY (`major_id`)
        REFERENCES `majors` (`major_id`)
);

CREATE TABLE `payments` (
    `payment_id` INT NOT NULL AUTO_INCREMENT,
    `payment_date` DATE NOT NULL,
    `payment_amount` DECIMAL(8 , 2 ) NOT NULL,
    `student_id` INT NOT NULL,
    CONSTRAINT `pk_payments` PRIMARY KEY (`payment_id`),
    CONSTRAINT `fk_payments_students` FOREIGN KEY (`student_id`)
        REFERENCES `students` (`student_id`)
);

CREATE TABLE `agenda` (
    `student_id` INT NOT NULL,
    `subject_id` INT NOT NULL,
    CONSTRAINT `pk_agenda` PRIMARY KEY (`student_id` , `subject_id`),
    CONSTRAINT `fk_agenda_subjects` FOREIGN KEY (`subject_id`)
        REFERENCES `subjects` (`subject_id`),
    CONSTRAINT `fk_agenda_students` FOREIGN KEY (`student_id`)
        REFERENCES `students` (`student_id`)
);

#Tasks 7 and 8 are for creating E/R (entity (table) relationship) diagrams
#Database --> Reverse Engineer --> next... pick databases... next...

#09. Peaks in Rila
#Setup 
USE `geography`;

#Judge code
SELECT
	`m`.`mountain_range`,
    `p`.`peak_name`,
    `p`.`elevation`
FROM `peaks` `p`
JOIN `mountains` `m`
	ON `p`.`mountain_id` = `m`.`id`
WHERE `m`.`mountain_range` = 'Rila'
ORDER BY `p`.`elevation` DESC
LIMIT 1000;