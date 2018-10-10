#01. Records’ Count 
#Setup
USE `gringotts`;

#Judge Code
SELECT COUNT(`id`) FROM `wizzard_deposits`;

#02. Longest Magic Wand 
SELECT MAX(`magic_wand_size`) AS `longest_magic_want` FROM `wizzard_deposits`;

#03. Longest Magic Wand per Deposit Groups 
SELECT `deposit_group`, MAX(`magic_wand_size`) AS `longest_magic_wand` 
FROM `wizzard_deposits`
GROUP BY `deposit_group`
ORDER BY `longest_magic_wand` ASC, `deposit_group` ASC
LIMIT 1000;

#04. Smallest Deposit Group per Magic Wand Size 
SELECT `deposit_group`
FROM `wizzard_deposits`
GROUP BY `deposit_group`
ORDER BY AVG(`magic_wand_size`) ASC
LIMIT 1;

#05. Deposits Sum 
SELECT `deposit_group`, SUM(`deposit_amount`) AS `total_sum`
FROM `wizzard_deposits`
GROUP BY `deposit_group`
ORDER BY `total_sum` ASC
LIMIT 1000;

#06. Deposits Sum for Ollivander Family 
SELECT `deposit_group`, SUM(`deposit_amount`) AS `total_sum`
FROM `wizzard_deposits`
WHERE `magic_wand_creator` = 'Ollivander family'
GROUP BY `deposit_group`
ORDER BY `deposit_group` ASC
LIMIT 1000;

#07. Deposits Filter 
SELECT `deposit_group`, SUM(`deposit_amount`) AS `total_sum`
FROM `wizzard_deposits`
WHERE `magic_wand_creator` = 'Ollivander family'
GROUP BY `deposit_group`
HAVING `total_sum` < 150000
ORDER BY `total_sum` DESC
LIMIT 1000;

#08. Deposit Charge 
SELECT `deposit_group`, `magic_wand_creator`, MIN(`deposit_charge`) AS `min_deposit_charge`
FROM `wizzard_deposits`
GROUP BY `magic_wand_creator` ASC, `deposit_group` ASC
LIMIT 1000;

#09. Age Groups 
SELECT
	(CASE 
		WHEN `age` BETWEEN 0 AND 10 THEN '[0-10]'
        WHEN `age` BETWEEN 11 AND 20 THEN '[11-20]'
        WHEN `age` BETWEEN 21 AND 30 THEN '[21-30]'
        WHEN `age` BETWEEN 31 AND 40 THEN '[31-40]'
        WHEN `age` BETWEEN 41 AND 50 THEN '[41-50]'
        WHEN `age` BETWEEN 51 AND 60 THEN '[51-60]'
        ELSE '[61+]'
	END) AS `age_group`, 
    COUNT(`id`) AS `wizzard_count`
FROM `wizzard_deposits`
GROUP BY `age_group`
ORDER BY `wizzard_count`;

#10. First Letter 
SELECT LEFT(`first_name`, 1) AS `first_letter`
FROM `wizzard_deposits`
WHERE `deposit_group` = 'Troll Chest'
GROUP BY `first_letter`
ORDER BY `first_letter` ASC
LIMIT 1000;

#11. Average Interest
SELECT `deposit_group`, `is_deposit_expired`, AVG(`deposit_interest`) AS `average_interest`
FROM `wizzard_deposits`
WHERE `deposit_start_date` > '1985-01-01'
GROUP BY `deposit_group`, `is_deposit_expired`
ORDER BY `deposit_group` DESC, `is_deposit_expired` ASC #flag is like a boolean
LIMIT 1000;

#12. Rich Wizard, Poor Wizard TODO *
SELECT SUM(
	SELECT 
		AS `difference`
	FROM `wizzard_deposits`
)

SELECT * FROM `wizzard_deposits`;

SELECT 
	`wd1`.`first_name` AS `host_wizard`,
    `wd1`.`deposit_amount` AS `host_wizard_deposit`,
    `inner_query`.`w2_first_name` AS `guest_wizard`,
    `inner_query`.`w2_deposit_amount` AS `guest_wizard_deposit`
FROM 
	`wizzard_deposits` `wd1`, 
    (SELECT 
		`wd2`.`first_name` AS `w2_first_name`,
        `wd2`.`deposit_amount` AS `w2_deposit_amount`
	FROM `wizzard_deposits` `wd2`
    WHERE `wd2`.`id` > 1) AS `inner_query`;
    
SELECT 
	`wd1`.`first_name`,
    `wd1`.`deposit_amount`,
    `wd2`.`first_name`,
    `wd2`.`deposit_amount`
FROM `wizzard_deposits` `wd1`
INNER JOIN `wizzard_deposits` `wd2`
	ON `wd1`.`id` = `wd2`.`id` + 1;

#13. Employees Minimum Salaries 
#Setup
USE `soft_uni`;

#Judge code
SELECT  `department_id`, MIN(`salary`) AS `minimum_salary`
FROM `employees`
WHERE `hire_date` > '2000-01-01'
GROUP BY `department_id`
HAVING `department_id` IN (2, 5, 7)
ORDER BY `department_id` ASC
LIMIT 1000;

#14. Employees Average Salaries 
CREATE TABLE `employees_with_big_salaries` AS SELECT * FROM `employees`
WHERE `salary` > 30000;

DELETE FROM `employees_with_big_salaries`
WHERE `manager_id` = 42;

UPDATE `employees_with_big_salaries`
SET `salary` = `salary` + 5000
WHERE `department_id` = 1;

SELECT `department_id`, AVG(`salary`) AS `avg_salary`
FROM `employees_with_big_salaries`
GROUP BY `department_id`
ORDER BY `department_id` ASC
LIMIT 1000;

#15. Employees Maximum Salaries 
SELECT `department_id`, MAX(`salary`) AS `max_salary` 
FROM `employees`
GROUP BY `department_id`
HAVING `max_salary` NOT BETWEEN 30000 AND 70000
ORDER BY `department_id`
LIMIT 1000;

#16. Employees Count Salaries 
SELECT COUNT(`employee_id`) - COUNT(`manager_id`) AS `Employees without managers` 
FROM `employees`; #COUNT(`manager_id`) ignores NULL values

#17. 3rd Highest Salary TODO *
SELECT *
FROM
	(SELECT
		`department_id`
		`third_highest_salary`
	FROM `employees`
	GROUP BY `department_id`
	ORDER BY `salary` DESC
	LIMIT 3) AS `inner_query`
ORDER BY `third_highest_salary` ASC
LIMIT 1;


#18. Salary Challenge TODO *

#19. Departments Total Salaries TODO 
SELECT `department_id`,  SUM(`salary`) AS `total_slary`
FROM `employees`
GROUP BY `department_id`
ORDER BY `department_id`
LIMIT 1000;