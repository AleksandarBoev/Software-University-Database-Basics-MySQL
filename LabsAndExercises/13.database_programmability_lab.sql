USE `soft_uni`;
#Note: Do NOT include delimiter queries, the new delimiter after the "END", the CALL procedure or SELECT function queries
#1. Count Employees by Town 
DELIMITER $$
#Judge code start
CREATE FUNCTION `ufn_count_employees_by_town`(`town_name` VARCHAR(50))
RETURNS INT(7)
BEGIN
	DECLARE `result` INT(7);
    SET `result` := 
		(
        SELECT
			COUNT(`e`.`employee_id`)
		FROM `employees` `e`
        INNER JOIN `addresses` `a`
			ON `a`.`address_id` = `e`.`address_id`
		INNER JOIN `towns` `t` 
			ON `t`.`town_id` = `a`.`town_id`
		WHERE `t`.`name` = `town_name`
		);
	
    RETURN `result`;
END #Judge code end
$$

SELECT `ufn_count_employees_by_town`('Sofia') AS `count`;

#2. Employees Promotion 
#Duplicating table and changing values in it so that the original one is not affected.
CREATE TABLE `employees_2` AS SELECT * FROM `employees`;

DELIMITER $$

CREATE PROCEDURE `usp_raise_salaries`(`department_name` VARCHAR(50)) 
BEGIN
	UPDATE `employees_2` `e` #change `employees_2` to `employees`
    INNER JOIN `departments` `d`
		ON `e`.`department_id` = `d`.`department_id`
	SET `e`.`salary` = `e`.`salary` * 1.05
    WHERE `d`.`name` = `department_name`;
END$$

CALL `usp_raise_salaries`('Finance');

SELECT 
	`first_name`,
    `salary`
FROM `employees_2` `e`
INNER JOIN `departments` `d`
	ON `e`.`department_id` = `d`.`department_id`
WHERE `d`.`name` = 'Finance'
ORDER BY `first_name`, `salary`;

#3.	Employees Promotion By ID 
DROP TABLE `employees_2`;
CREATE TABLE `employees_2` AS SELECT * FROM `employees`;

DELIMITER $$

CREATE PROCEDURE `usp_raise_salary_by_id`(`id` INT)
BEGIN
	UPDATE `employees_2`
    SET `salary` = `salary` * 1.05
    WHERE `employee_id` = `id`;
END$$

CALL `usp_raise_salary_by_id` (178);
SELECT `salary` FROM `employees_2` WHERE `employee_id` = 178;

#4. Triggered
#Submit the create table query + trigger creation query without the delimiter parts
# and change the `employee_2` table to `employee`
CREATE TABLE `deleted_employees`(
	`employee_id` INT NOT NULL AUTO_INCREMENT,#would be better if it was NOT AUTO_INCREMENT, but judge wants it this way
    `first_name` VARCHAR(30) NOT NULL,
    `last_name` VARCHAR(30) NOT NULL,
    `middle_name` VARCHAR(30) NOT NULL,
    `job_title` VARCHAR(30) NOT NULL,
    `department_id` INT NOT NULL,
    `salary` DOUBLE NOT NULL,
    CONSTRAINT `pk_deleted_employees` PRIMARY KEY (`employee_id`),
    CONSTRAINT `fk_deleted_employees` FOREIGN KEY (`department_id`) #is it a good idea to put constraints in a 
		REFERENCES `departments`(`department_id`)                  #temporary table?
);

DELIMITER $$

CREATE TRIGGER `tr_deleted_employees`
AFTER DELETE
ON `employees_2`
FOR EACH ROW
BEGIN
	INSERT INTO `deleted_employees`
		(`first_name`, `last_name`, `middle_name`, `job_title`, `department_id`, `salary`)
	VALUES
		(OLD.`first_name`, OLD.`last_name`, IF(OLD.`middle_name` IS NULL, 'NULL', OLD.`middle_name`), 
        OLD.`job_title`, OLD.`department_id`, OLD.`salary`);
END$$

SELECT COUNT(*) FROM `employees_2`;
SELECT * FROM `deleted_employees`;

DELETE FROM `employees_2`
WHERE `employee_id` IN (216);

SELECT COUNT(*) FROM `employees_2`;
SELECT * FROM `deleted_employees`;