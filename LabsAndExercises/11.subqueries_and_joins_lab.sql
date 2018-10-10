#Setup
USE `soft_uni`;

#1. Managers 
SELECT
	`m`.`employee_id` AS `id`,
    CONCAT(`m`.`first_name`, ' ', `m`.`last_name`) AS `full_name`,
    `d`.`department_id`,
    `d`.`name` AS `department_name`
FROM `departments` `d`
INNER JOIN `employees` `m` #m for manager
	ON `d`.`manager_id` = `m`.`employee_id`
ORDER BY `m`.`employee_id`
LIMIT 5;

#2. Towns and Addresses 
SELECT
	`t`.`town_id`,
    `t`.`name` AS `town_name`,
    `a`.`address_text`
FROM `addresses` `a`
INNER JOIN `towns` `t`
	ON `a`.`town_id` = `t`.`town_id`
WHERE `t`.`name` IN ('San Francisco', 'Sofia', 'Carnation')
ORDER BY `t`.`town_id` ASC, `a`.`address_id` ASC
LIMIT 1000;

#3. Employees Without Managers 
SELECT
	`e`.`employee_id`,
    `e`.`first_name`,
    `e`.`last_name`,
    `e`.`department_id`,
    `e`.`salary`
FROM `employees` `e`
LEFT JOIN `employees` `manager`
	ON `e`.`manager_id` = `manager`.`employee_id`
WHERE `manager`.`employee_id` IS NULL # doesn't matter which field is used, all records are null if there is no connection
LIMIT 1000;

/*
How does the query above work: take ALL records from the left table and try connecting them to records from
the right one. If some records from the left field can't be connected to neither of the records from the right one
then still display them, but give the right table records null values.
*/

#4. High Salary 
SELECT 
	COUNT(`employee_id`) AS `count` 
FROM(
	SELECT `employee_id` FROM `employees`
	WHERE `salary` > (SELECT AVG(`salary`) FROM `employees`)
    ) AS `outer_query`;
    
#Best way of trying to understand and build such queries is to start making/reading
#the inner queries first and then the outer ones I think.

    


