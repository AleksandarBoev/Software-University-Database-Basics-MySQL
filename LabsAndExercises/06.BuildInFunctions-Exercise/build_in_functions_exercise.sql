#01. Find Names of All Employees by First Name 
#Setup
USE `soft_uni_database`;

#Judge code
SELECT `first_name`, `last_name` FROM `employees`
WHERE LEFT(`first_name`, 2) = 'Sa'
ORDER BY `employee_id`
LIMIT 1000;

#02. Find Names of All Employees by Last Name 
SELECT `first_name`, `last_name` FROM `employees`
WHERE `last_name` LIKE '%ei%'
ORDER BY `employee_id`
LIMIT 1000;

#03. Find First Names of All Employess 
SELECT `first_name` FROM `employees`
WHERE `department_id` IN (3, 10) AND (EXTRACT(YEAR FROM `hire_date`) BETWEEN 1995 AND 2005)
ORDER BY `employee_id`
LIMIT 1000;

#04. Find All Employees Except Engineers 
SELECT `first_name`, `last_name` FROM `employees`
WHERE `job_title` NOT LIKE '%engineer%'
LIMIT 1000;

#05. Find Towns with Name Length 
SELECT `name` FROM `towns`
WHERE CHAR_LENGTH(`name`) IN (5, 6)
ORDER BY `name` ASC
LIMIT 1000;

#06. Find Towns Starting With 
SELECT `town_id`, `name` FROM `towns`
WHERE LEFT(`name`, 1) IN ('M', 'K', 'B', 'E') #`name` LIKE '[MKBE]%' --> does not work...
ORDER BY `name` ASC
LIMIT 1000;

#07. Find Towns Not Starting With 
SELECT `town_id`, `name` FROM `towns`
WHERE LEFT(`name`, 1) NOT IN ('R', 'B', 'D')
ORDER BY `name` ASC
LIMIT 1000;

#08. Create View Employees Hired After 
CREATE VIEW `v_employees_hired_after_2000` AS
SELECT `first_name`, `last_name` FROM `employees`
WHERE EXTRACT(YEAR FROM `hire_date`) > 2000;

#09. Length of Last Name 
SELECT `first_name`, `last_name` FROM `employees`
WHERE CHAR_LENGTH(`last_name`) = 5
LIMIT 1000;

#10. Countries Holding 'A' 
#LIKE %a%a%a%
#CHAR_LENGTH(REPLACE(`word`, 'a', '')) - CHAR_LENGTH(`word`) >= 3
#LOCATE('a', `word`, LOCATE('a', `word`, LOCATE('a', `word`, 1))) = 1;