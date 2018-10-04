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
#Setup
USE `geography`;

#Judge code
SELECT `country_name`, `iso_code` FROM `countries`
WHERE `country_name` LIKE '%a%a%a%'
ORDER BY `iso_code` ASC
LIMIT 1000;

#11. Mix of Peak and River Names 
SELECT  `peaks`.`peak_name`, `rivers`.`river_name`, 
	LOWER(CONCAT(`peaks`.`peak_name`, SUBSTRING(`rivers`.`river_name`, 2))) AS 'mix'
	FROM `rivers`, `peaks`
WHERE RIGHT(`peaks`.`peak_name`, 1) = LEFT(`rivers`.`river_name`, 1)
ORDER BY `mix`
LIMIT 1000;

#12. Games From 2011 and 2012 Year 
#Setup
USE `diablo`;

#Judge code
SELECT `name`, DATE_FORMAT(`start`, '%Y-%m-%d') AS 'start' FROM `games`
WHERE EXTRACT(YEAR FROM `start`) IN (2011, 2012)
ORDER BY `start` ASC, `name` ASC
LIMIT 50;

#13. User Email Providers 
SELECT `user_name`, SUBSTRING(`email`, LOCATE('@', `email`) + 1) AS `Email Provider` FROM `users`
ORDER BY `Email Provider` ASC, `user_name` ASC
LIMIT 1000;

#14. Get Users with IP Address Like Pattern 
SELECT `user_name`, `ip_address` FROM `users`
WHERE `ip_address` LIKE '___.1%.%.___'
ORDER BY `user_name`
LIMIT 1000;

#15. Show All Games with Duration 
SELECT `name`, 
	IF(EXTRACT(HOUR FROM `start`) BETWEEN 0 AND 11, 'Morning', 
		IF (EXTRACT(HOUR FROM `start`) BETWEEN 12 AND 17, 'Afternoon', 'Evening')) AS `Part of the Day`,
	IF(`duration` <= 3, 'Extra Short', 
		IF (`duration` BETWEEN 4 AND 6, 'Short', 
			IF(`duration` BETWEEN 6 AND 10, 'Long', 'Extra Long'))) AS `Duration` 
FROM `games`
LIMIT 1000;

#16. Orders Table
#Setup 
USE `orders`;

#Judge code
SELECT `product_name`, `order_date`, 
(DATE_ADD(`order_date`, INTERVAL 3 DAY)) AS `pay_due`, 
(DATE_ADD(`order_date`, INTERVAL 1 MONTH)) AS `deliver_due` FROM `orders`;