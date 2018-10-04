#1. Departments Info 
#Setup
USE `restaurant`;

#Judge code
SELECT `department_id`, COUNT(`id`) AS `Number of employees`
FROM `employees`
GROUP BY `department_id`
ORDER BY `department_id` ASC, `Number of employees` ASC
LIMIT 1000;

#2. Average Salary
SELECT `department_id`, ROUND(AVG(`salary`), 2) AS `Average_Salary`
FROM `employees`
GROUP BY `department_id`
ORDER BY `department_id` ASC
LIMIT 1000;

#3. Minimum Salary 
SELECT `department_id`, ROUND(MIN(`salary`), 2) AS `Min Salary`
FROM `employees`
GROUP BY `department_id`
HAVING `Min Salary` > 800
LIMIT 1000;

#4. Appetizers Count 
SELECT COUNT(`id`) AS `Count of appetizers with price over 8.00 and id = 2`
FROM `products`
WHERE `price` > 8.00
GROUP BY `category_id`
HAVING `category_id` = 2
LIMIT 1000;

#5. Menu Prices 
SELECT 
	`category_id`, 
    ROUND(AVG(`price`), 2) AS `Average Price`, 
    ROUND(MIN(`price`), 2) AS `Cheapest Product`, 
    ROUND(MAX(`price`), 2) AS `Most Expensive Product`
FROM `products`
GROUP BY `category_id`
LIMIT 1000;

#select
SELECT * FROM `employees`;