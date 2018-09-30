#Setup
USE `soft_uni`;

#01. Find All Information About Departments 
SELECT * FROM `departments`
ORDER BY `department_id` ASC;

#02. Find all Department Names 
SELECT `name` FROM `departments`
ORDER BY `department_id` ASC;

#03. Find Salary of Each Employee 
CREATE VIEW `v_names_salary_ordered_by_id_asc` AS #there has to be a better way of naming this
SELECT `first_name`, `last_name`, `salary` FROM `employees`
ORDER BY `employee_id` ASC;

SELECT * FROM `v_names_salary_ordered_by_id_asc`;

#04. Find Full Name of Each Employee 
CREATE VIEW `v_employee_names_sorted_by_id` AS
SELECT `first_name`, `middle_name`, `last_name` FROM `employees`
ORDER BY `employee_id` ASC;

SELECT * FROM `v_employee_names_sorted_by_id` LIMIT 1000;

#05. Find Email Address of Each Employee 
SELECT CONCAT(`first_name`, '.', `last_name`, '@softuni.bg') AS 'full_email_address' FROM `employees`
LIMIT 1000;

#06. Find All Different Employee’s Salaries 
SELECT DISTINCT(`salary`) FROM `employees`
ORDER BY `employee_id` ASC 
LIMIT 1000;

#07. Find all Information About Employees 
SELECT 
    `employee_id` AS 'id',
    `first_name` AS 'First Name',
    `last_name` AS 'Last Name',
    `middle_name` AS 'Middle Name',
    `job_title` AS 'Job Title',
    `department_id` AS 'Dept ID',
    `manager_id` AS 'Mngr ID',
    `hire_date` AS 'Hire Date',
    `salary`,
    `address_id`
FROM `employees`
WHERE `job_title` = 'Sales Representative'
ORDER BY `employee_id` ASC
LIMIT 1000;

 #08. Find Names of All Employees by Salary in Range 
 SELECT `first_name`, `last_name`, `job_title` AS 'JobTitle' FROM `employees`
 WHERE `salary` BETWEEN 20000 AND 30000
 ORDER BY `employee_id` ASC;

#9. Find Names of All Employees 
SELECT concat_ws(' ', `first_name`, `middle_name`, `last_name`) AS 'Full Name' FROM `employees`
WHERE `salary` IN (25000, 14000, 12500, 23600)
LIMIT 1000;

#10. Find All Employees Without Manager 
SELECT `first_name`, `last_name` FROM `employees`
WHERE `manager_id` IS NULL
LIMIT 1000;

#11. Find All Employees with Salary More Than 
SELECT `first_name`, `last_name`, `salary` FROM `employees`
WHERE `salary` > 50000
ORDER BY `salary` DESC
LIMIT 1000;

#12. Find 5 Best Paid Employees 
SELECT `first_name`, `last_name` FROM `employees`
ORDER BY `salary` DESC
LIMIT 5;

#13. Find All Employees Except Marketing 
SELECT `first_name`, `last_name` FROM `employees` 
WHERE `department_id` <> 4
LIMIT 1000;

#14. Sort Employees Table 
CREATE VIEW `v_employees_multiple_sortings` AS
SELECT 
	`employee_id` AS 'id',
    `first_name` AS 'First Name',
    `last_name` AS 'Last Name',
    `middle_name` AS 'Middle Name',
    `job_title`,
    `department_id` AS 'Dept ID',
    `manager_id` AS 'Mngr ID',
    `hire_date` AS 'Hire Date',
    `salary`,
    `address_id`
FROM `employees`
ORDER BY `salary` DESC, `first_name` ASC, `last_name` DESC, `middle_name` ASC, `id` ASC
LIMIT 1000;

SELECT * FROM `v_employees_multiple_sortings`;

#15. Create View Employees with Salaries 
CREATE VIEW `v_employees_salaries` AS 
SELECT `e`.`first_name`, `e`.`last_name`, `e`.`salary` FROM `employees` `e` #practicisng using aliases
LIMIT 1000;

SELECT * FROM `v_employees_salaries`;

#16. Create View Employees with Job Titles 
UPDATE `employees`
SET `middle_name` = ''
WHERE `middle_name` IS NULL;

CREATE VIEW `v_employees_job_titles` AS
SELECT concat_ws(' ', `first_name`, `middle_name`, `last_name`) AS 'full_name', `job_title` FROM `employees`; #IFNULL(middle_name, '')

#17. Distinct Job Titles 
SELECT DISTINCT(`job_title`) AS 'Job_title' FROM `employees`
ORDER BY `job_title` ASC;

#18. Find First 10 Started Projects	
SELECT * FROM `projects`
ORDER BY `start_date` ASC, `name` ASC, `project_id` ASC 
LIMIT 10;

#19. Last 7 Hired Employees	
SELECT `first_name`, `last_name`, `hire_date` FROM `employees`
ORDER BY `hire_date` DESC
LIMIT 7;

#20. Increase Salaries 
UPDATE `employees`
SET `salary` = `salary` * 1.12
WHERE `department_id` IN (1, 2, 4, 11); #can be done with join

SELECT `salary` FROM `employees`
LIMIT 1000;

#21. All Mountain Peaks 
#Setup
USE `geography`;

#Judge code
SELECT `peak_name` FROM `peaks` 
ORDER BY `peak_name` ASC
LIMIT 1000;

#22. Biggest Countries by Population 
SELECT `country_name`, `population` FROM `countries`
WHERE `continent_code` = 'EU'
ORDER BY `population` DESC, `country_name` ASC
LIMIT 30;

#23. Countries and Currency (Euro / Not Euro)
#Look for possible solution in lection 'Build in functions'

#24. All Diablo Characters 
#Setup
USE `diablo`;

#Judge code
SELECT `name` FROM `characters`
ORDER BY `name` ASC
LIMIT 1000;