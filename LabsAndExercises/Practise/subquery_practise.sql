USE `soft_uni`;

#Get the first name and salary of all employees who have a salary above the average
SELECT
	`first_name`,
    `salary`
FROM `employees`
WHERE `salary` > 
	(SELECT #subquery is executed only once
		AVG(`salary`) AS `average_salary`
        #`first_name` # if this line stayed, there would be an error code: Operand should contain 1 column(s)
	FROM `employees`);
    
#This code does not work. Error code: Subquery returns more than 1 row
SELECT
	`first_name`,
    `salary`
FROM `employees`
WHERE `salary` > #would work with IN, although the query would give useless information. But it could be useful in other situations
	(SELECT 
		AVG(`salary`) AS `average_salary`
	FROM `employees`
    GROUP BY `department_id`);

#This code gives information about employees who have a salary between maximum and minimum salary 
#Stupid example, but the tehnique could be used in a more useful scenario.
SELECT
	`first_name`,
    `salary`
FROM `employees`
WHERE `salary` BETWEEN
	(SELECT 
		MIN(`salary`)
	FROM `employees`
    )
AND
	(SELECT 
		MAX(`salary`)
	FROM `employees`);
    
/*
	Conclusion: When using a subquery in a where clause and using operands for comparison, the subquery MUST
produce 1 column with 1 row. 
	There could be more rows if instead of comparison I were to use IN, which would
check if the value on the left is equal to ANY of the rows from the subquery.
	More than 1 subquery could be used in a where clause.
*/
    
#Another way of using a subquery:
SELECT 
	CONCAT(`first_name`, ' ', `last_name`) AS `Full name`,
    `salary` - 
		(SELECT AVG(`salary`) FROM `employees`)
    AS `Difference between average salary and current salary`
    FROM `employees`;
    
#Aaand one more way of using a subquery. Again, not a very smart example...
SELECT 
	`inner_query`.`Full name`,
    `inner_query`.`Department Info`
FROM (
	SELECT 
		CONCAT(`first_name`, ' ', `last_name`) AS `Full name`,
		`department_id` AS `Department info`
    FROM `employees`
    ) AS `inner_query`;

    
    
    
    
