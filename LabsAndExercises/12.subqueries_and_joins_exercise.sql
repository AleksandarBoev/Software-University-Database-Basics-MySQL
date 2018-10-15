#01. Employee Address 
#Setup
USE `soft_uni`;

#Judge code
SELECT 
	`e`.`employee_id`,
    `e`.`job_title`,
    `e`.`address_id`,
    `a`.`address_text`
FROM `employees` `e`
JOIN `addresses` `a`
ON `e`.`address_id` = `a`.`address_id`
ORDER BY `e`.`address_id` ASC
LIMIT 5;

#02. Addresses with Towns 
SELECT
	`e`.`first_name`,
    `e`.`last_name`,
    `t`.`name` AS `town`,
    `a`.`address_text` AS `address_text`
FROM `employees` `e`
JOIN `addresses` `a`
ON `e`.`address_id` = `a`.`address_id`
JOIN `towns` `t`
ON `a`.`town_id` = `t`.`town_id`
ORDER BY `e`.`first_name` ASC, `e`.`last_name` ASC
LIMIT 5;

#03. Sales Employee 
SELECT
	`e`.`employee_id`,
    `e`.`first_name`,
    `e`.`last_name`,
    `d`.`name` AS `department_name`
FROM `employees` `e`
JOIN `departments` `d`
	ON `e`.`department_id` = `d`.`department_id`
WHERE `d`.`name` = 'Sales'
ORDER BY `e`.`employee_id` DESC;

#04. Employee Departments 
SELECT
	`e`.`employee_id`,
    `e`.`first_name`,
    `e`.`salary`,
    `d`.`name` AS `department_name`
FROM `employees` `e`
JOIN `departments` `d`
	ON `e`.`department_id` = `d`.`department_id`
WHERE `e`.`salary` > 15000
ORDER BY `e`.`department_id` DESC
LIMIT 5;

#05. Employees Without Project 
#To visualise the task better:
/*
SELECT 
	`e`.`employee_id`,
    `e`.`first_name`,
    `ep`.`project_id`
FROM `employees` `e`
LEFT JOIN `employees_projects` `ep` #left join takes EVERYTHING from `employees` table
	ON `e`.`employee_id` = `ep`.`employee_id`
ORDER BY `e`.`employee_id` DESC
LIMIT 1000;
*/

SELECT 
	`e`.`employee_id`,
    `e`.`first_name`
FROM `employees` `e`
LEFT JOIN `employees_projects` `ep`
	ON `e`.`employee_id` = `ep`.`employee_id`
WHERE `ep`.`project_id` IS NULL
ORDER BY `e`.`employee_id` DESC
LIMIT 3;

#06. Employees Hired After 
SELECT 
	`e`.`first_name`,
    `e`.`last_name`,
    `e`.`hire_date`,
    `d`.`name` AS `dept_name`
FROM `employees` `e`
JOIN `departments` `d`
	ON `d`.`department_id` = `e`.`department_id`
WHERE `e`.`hire_date` >= '1999-01-02' AND `d`.`name` IN ('Sales', 'Finance')
ORDER BY `e`.`hire_date` ASC
LIMIT 1000;
# WHERE `e`.`hire_date` > '1999-01-01' does not work, because 01-01-1999 00:00:01 is bigger than 01-01-1999 00:00:00

#07. Employees with Project 
SELECT 
	`ep`.`employee_id`,
    `e`.`first_name`,
    `p`.`name` AS `project_name`
FROM `employees` `e`
INNER JOIN `employees_projects` `ep`
	ON `e`.`employee_id` = `ep`.`employee_id`
#After this join the resulting table is one which has all of the columns of both the tables. 
#This big unified table now can now connect with the other one.
INNER JOIN `projects` `p`
	ON `p`.`project_id` = `ep`.`project_id`
WHERE `p`.`start_date` >= '2002-08-14' AND `p`.`end_date` IS NULL
ORDER BY `e`.`first_name` ASC, `p`.`name` ASC
LIMIT 5;

#08. Employee 24 
SELECT
	`e`.`employee_id`,
    `e`.`first_name`,
    IF(EXTRACT(YEAR FROM `p`.`start_date`) >= 2005, NULL, `p`.`name`) AS `project_name`
FROM `employees` `e`
INNER JOIN `employees_projects` `ep`
	ON `ep`.`employee_id` = `e`.`employee_id`
INNER JOIN `projects` `p`
	ON `p`.`project_id` = `ep`.`project_id`
WHERE `e`.`employee_id` = 24
ORDER BY `project_name` ASC;

#09. Employee Manager 
SELECT
	`e1`.`employee_id`,
    `e1`.`first_name`,
    `e1`.`manager_id`,
    `e2`.`first_name` AS `manager_name`
FROM `employees` `e1`
JOIN `employees` `e2`
	ON `e1`.`manager_id` = `e2`.`employee_id`
WHERE `e1`.`manager_id` IN (3, 7)
ORDER BY `e1`.`first_name` ASC
LIMIT 1000;

SELECT * FROM `employees`;

#10. Employee Summary 
SELECT 
	`e1`.`employee_id`,
    CONCAT(`e1`.`first_name`, ' ', `e1`.`last_name`) AS `employee_name`,
    CONCAT(`e2`.`first_name`, ' ', `e2`.`last_name`) AS `manager_name`,
    `d`.`name` AS `department_name`
FROM `employees` `e1`
INNER JOIN `employees` `e2` # inner join --> employees without managers are left out
	ON `e1`.`manager_id` = `e2`.`employee_id`
INNER JOIN `departments` `d`
	ON `e1`.`department_id` = `d`.`department_id`
ORDER BY `e1`.`employee_id`
LIMIT 5;

#11. Min Average Salary 
SELECT 
	MIN(`average_salary`) AS `min_average_salary` 
FROM (
	SELECT AVG(`salary`) AS `average_salary`
	FROM `employees`
	GROUP BY `department_id`
) AS `outer_query`;

#result of inner query --> a table with one column, named "average_salary", which contains doubles, which are
#averages of the salaries of the departments. The outer query finds the minimal "average_salary" of the inner query.

#12. Highest Peaks in Bulgaria 
#Setup
USE `geography`;

#Judge code
SELECT
	`mc`.`country_code`,
    `m`.`mountain_range`,
    `p`.`peak_name`,
    `p`.`elevation`
FROM `mountains_countries` `mc`
INNER JOIN `mountains` `m`
	ON `mc`.`mountain_id` = `m`.`id`
INNER JOIN `peaks` `p`
	ON `m`.`id` = `p`.`mountain_id`
WHERE `p`.`elevation` > 2835 AND `mc`.`country_code` = 'BG'
ORDER BY `p`.`elevation` DESC
LIMIT 1000;

#13. Count Mountain Ranges 
SELECT
	`mc`.`country_code`,
    COUNT(`mc`.`mountain_id`) AS `mountains_count`
FROM `mountains_countries` `mc`
INNER JOIN `countries` `c`
	ON `c`.`country_code` = `mc`.`country_code`
WHERE `c`.`country_name` IN ('United States', 'Russia', 'Bulgaria')
GROUP BY `mc`.`country_code`
ORDER BY `mountains_count` DESC;

#14. Countries with Rivers 
SELECT
	`countr`.`country_name`,
    `r`.`river_name`
FROM `countries` `countr` 
LEFT JOIN `countries_rivers` `cr`
	ON `countr`.`country_code` = `cr`.`country_code`
LEFT JOIN `rivers` `r`
	ON `r`.`id` = `cr`.`river_id`
INNER JOIN `continents` `cont`
	ON `cont`.`continent_code` = `countr`.`continent_code`
WHERE `cont`.`continent_name` = 'Africa'
ORDER BY `countr`.`country_name` ASC
LIMIT 5;

/*
	How the code works: LEFT JOIN table 'countries' with table `countries_rivers`. That means all records
from 'countries' must be in the resulting table at least once, even if their id's are not in the 'countries_rivers'
table. Resulting table is one with all countries, some of which don't have rivers and so they have NULL for river_id.
	This resulting table is LEFT JOINED with 'rivers' table. That means all the records from the previous resulting
table MUST be in the next resulting table at least once. 
	After that a normal inner join and so on...
*/

#15. *Continents and Currencies - does not give 100/100
SELECT * FROM (
	SELECT 
		`continent_code`,
		`currency_code`,
		COUNT(`currency_code`) AS `currency_code_usage`
	FROM `countries`
	GROUP BY `continent_code`, `currency_code`
	ORDER BY `currency_code_usage` DESC
) AS `outer_query`
WHERE `currency_code_usage` > 1
GROUP BY `continent_code`
ORDER BY `continent_code` ASC, `currency_code` ASC;

#16. Countries without any Mountains 
SELECT COUNT(`country_code`) 
FROM (
	SELECT
		`c`.`country_code`,
        `mc`.`mountain_id`
	FROM `countries` `c`
    LEFT JOIN `mountains_countries` `mc`
		ON `mc`.`country_code` = `c`.`country_code`
    WHERE `mountain_id` IS NULL)
 AS `outer_query`;
 
 #17. Highest Peak and Longest River by Country 
SELECT
	`c`.`country_name`,
    MAX(`p`.`elevation`) AS `highest_peak_elevation`,
    MAX(`r`.`length`) AS `longest_river_length`
FROM `countries` `c`
INNER JOIN `mountains_countries` `mc`
	ON `c`.`country_code` = `mc`.`country_code`
INNER JOIN `mountains` `m`
	ON `m`.`id` = `mc`.`mountain_id`
INNER JOIN `peaks` `p`
	ON `p`.`mountain_id` = `m`.`id`
INNER JOIN `countries_rivers` `cr`
	ON `cr`.`country_code` = `c`.`country_code`
INNER JOIN `rivers` `r`
	ON `r`.`id` = `cr`.`river_id`
GROUP BY `c`.`country_code`
ORDER BY `highest_peak_elevation` DESC, `longest_river_length` DESC
LIMIT 5;

#Display NULL when no data is available in some of the columns. --> not sure how to do it with so many joins
