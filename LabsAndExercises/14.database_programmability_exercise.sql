#01. Employees with Salary Above 35000 (submitting code WITHOUT the delimiter rows)
#Setup
USE `soft_uni`;
DELIMITER $$

#Judge code
CREATE PROCEDURE `usp_get_employees_salary_above_35000`()
BEGIN
	SELECT
		`first_name`,
        `last_name`
	FROM `employees`
    WHERE `salary` > 35000
    ORDER BY `first_name` ASC, `last_name` ASC, `employee_id` ASC;
END 
#End of judge code --> same logic for the other codes below. Do NOT submit the call queries, delimiter queries
#and the custom delimiter after the END
$$

DELIMITER ;

CALL `usp_get_employees_salary_above_35000`;

#02. Employees with Salary Above Number 
DELIMITER $$
#Judge code start
CREATE PROCEDURE `usp_get_employees_salary_above`(`salary_amount` DOUBLE)
BEGIN
	SELECT
		`first_name`,
        `last_name`
	FROM `employees`
    WHERE `salary` >= `salary_amount`
    ORDER BY `first_name` ASC, `last_name` ASC, `employee_id` ASC;
END$$

DELIMITER ;
CALL `usp_get_employees_salary_above`(48100);

#03. Town Names Starting With 
DELIMITER $$

CREATE PROCEDURE `usp_get_towns_starting_with`(`town_name_start` VARCHAR(50))
BEGIN
	SELECT `name` AS `town_name` FROM `towns`
    WHERE LEFT(`town_name`, 1) = `town_name_start`
    ORDER BY `town_name` ASC;
END$$

CALL `usp_get_towns_starting_with`('B');

#04. Employees from Town 
DELIMITER $$

CREATE PROCEDURE `usp_get_employees_from_town`(`town_name` VARCHAR(30))
BEGIN
	SELECT 
		`first_name`,
        `last_name`
	FROM `employees` `e`
    INNER JOIN `addresses` `a`
		ON `a`.`address_id` = `e`.`address_id`
	INNER JOIN `towns` `t`
		ON `a`.`town_id` = `t`.`town_id`
	WHERE `t`.`name` LIKE `town_name`
    ORDER BY `e`.`first_name`, `e`.`last_name`, `e`.`employee_id`;
END$$

CALL `usp_get_employees_from_town`('Sofia'); #using ";" as a delimiter resets the delimiter to ";" I guess...

#05. Salary Level Function 
DELIMITER $$
CREATE FUNCTION `ufn_get_salary_level`(`salary_amount` DOUBLE)
RETURNS VARCHAR(7)
BEGIN
	DECLARE `answer` VARCHAR(40);
	
    CASE
		WHEN `salary_amount` < 30000 THEN SET `answer` := 'Low';
		WHEN `salary_amount` BETWEEN 30000 AND 50000 THEN SET `answer` := 'Average';
		ELSE SET `answer` := 'High';
	END CASE;
    
    
    RETURN `answer`;
END$$

SELECT `ufn_get_salary_level`(13500.00);
SELECT `ufn_get_salary_level`(43300.00);
SELECT `ufn_get_salary_level`(125500.00);

#06. Employees by Salary Level
DELIMITER $$

#Judge code start
CREATE FUNCTION `ufn_get_salary_level`(`salary_amount` DOUBLE)
RETURNS VARCHAR(7)
BEGIN
	DECLARE `answer` VARCHAR(40);
	
    CASE
		WHEN `salary_amount` < 30000 THEN SET `answer` := 'Low';
		WHEN `salary_amount` BETWEEN 30000 AND 50000 THEN SET `answer` := 'Average';
		ELSE SET `answer` := 'High';
	END CASE;
    
    RETURN `answer`;
END$$ #for judge to accept code then you must replace $$ with ;

CREATE PROCEDURE `usp_get_employees_by_salary_level`(`level_of_salary` VARCHAR(7))
BEGIN
	SELECT 
		`first_name`,
        `last_name`
	FROM `employees`
    WHERE (SELECT `ufn_get_salary_level`(`salary`)) LIKE `level_of_salary`
    ORDER BY `first_name` DESC, `last_name` DESC;
END$$ #for judge to accept code then you must replace $$ with ;
#Judge code end

CALL `usp_get_employees_by_salary_level`('high');

#07. Define Function 
DROP FUNCTION `ufn_is_word_comprised`;
DELIMITER $$

CREATE FUNCTION `ufn_is_word_comprised`(`set_of_letters` VARCHAR(50), `word` VARCHAR(50))
RETURNS TINYINT
BEGIN
	DECLARE `result` TINYINT;
	DECLARE `regex` VARCHAR(65);
    SET `regex` := CONCAT('^\[', `set_of_letters`, '\]+\$');
    
	IF LOWER(`word`) REGEXP LOWER(`regex`) = 1 THEN SET `result` := 1; 
    ELSE SET `result` := 0;
    END IF;
    
    RETURN `result`;
END$$

SELECT `ufn_is_word_comprised`('oistmiahf', 'Sofia');
SELECT `ufn_is_word_comprised`('oistmiahf', 'halves');
SELECT `ufn_is_word_comprised`('bobr', 'Rob');
SELECT `ufn_is_word_comprised`('pppp', 'Guy');

#08. Find Full Name 
CREATE DATABASE `bank_db`;
USE `bank_db`;
#Execute all queries from "bank_db" recourse
#Note: 'bank_db' uses DECIMAL(19, 4) for the column type of `balance` in `accounts`. 
#So I will use similar data type later on.
DELIMITER $$

CREATE PROCEDURE `usp_get_holders_full_name`()
BEGIN
	SELECT CONCAT(`first_name`, ' ',  `last_name`) AS `full_name` 
    FROM `account_holders`
    ORDER BY `full_name` ASC, `id` ASC;
END$$

CALL `usp_get_holders_full_name`;

#9. People with Balance Higher Than 
#The task condition is messed up
DELIMITER $$

CREATE PROCEDURE `usp_get_holders_with_balance_higher_than`(`amount` DOUBLE)
BEGIN
	SELECT 
		`ah`.`first_name`,
        `ah`.`last_name`
	FROM `account_holders` `ah`
    INNER JOIN `accounts` `a`
		ON `a`.`account_holder_id` = `ah`.`id`
	GROUP BY `a`.`account_holder_id`
    HAVING SUM(`balance`) > `amount`
    ORDER BY `a`.`id` ASC, `ah`.`first_name` ASC, `ah`.`last_name` ASC;
END$$

#10. Future Value Function 
DELIMITER $$

CREATE FUNCTION `ufn_calculate_future_value`(`initial_sum` DOUBLE, `yearly_interest_rate` DOUBLE(11, 4), `number_of_years` INT)
RETURNS DOUBLE
BEGIN
	DECLARE `result` DOUBLE;
    
    SET `result` := `initial_sum` * POW((1 + `yearly_interest_rate`), `number_of_years`);
    
    RETURN `result`;
END$$

SELECT `ufn_calculate_future_value`(1000, 0.1, 5);

#11. Calculating Interest
DELIMITER $$

CREATE PROCEDURE `usp_calculate_future_value_for_account`(`account_id` INT, `interest_rate` DECIMAL(19, 4))
BEGIN
	DECLARE `balance_after` DECIMAL(19, 4);
    
    DECLARE `balance_before` DECIMAL(19, 4);
    SET `balance_before` := 
		(SELECT `balance`
        FROM `accounts`
        WHERE `id` = `account_id`);
        
    SET `balance_after` := `balance_before` * POW((1 + `interest_rate`), 5);
    
    SELECT
		`a`.`id`,
        `ah`.`first_name`,
        `ah`.`last_name`,
        `balance_before` AS `current_balance`,
        `balance_after` AS `balance_in_5_years`
	FROM `accounts` `a`
    JOIN `account_holders` `ah`
		ON `a`.`account_holder_id` = `ah`.`id`
	WHERE `a`.`id` = `account_id`;
END$$

CALL `usp_calculate_future_value_for_account`(1, 0.1);


#12. Deposit Money - TODO 
CREATE TABLE `accounts_2` AS SELECT * FROM `accounts`; #duplicating table, so that original stays the same

DELIMITER $$

CREATE PROCEDURE `usp_deposit_money`(`account_id` INT, `money_amount` DECIMAL(19, 4))
BEGIN
	START TRANSACTION;
	UPDATE `accounts_2` #change this to `accounts`
    SET `balance` = `balance` + `money_amount`
    WHERE `id` = `account_id`;
    IF `money_amount` <= 0 THEN ROLLBACK;
    END IF;
END$$

CALL `usp_deposit_money`(1, 0.099);
CALL `usp_deposit_money`(1, -0.25);

SELECT 
	`id`,
	`account_holder_id`,
	`balance`
FROM `accounts_2`
WHERE `id` = 1;

#13. Withdraw Money - Task can be done easily with some if/case, before updating but this is practising transactions
TRUNCATE `accounts_2`; #delete all rows
INSERT INTO `accounts_2` SELECT * FROM `accounts`; #reinsert them

DELIMITER $$

CREATE PROCEDURE `usp_withdraw_money`(`account_id` INT, `money_amount` DECIMAL(19, 4))
BEGIN
	DECLARE `balance_before_withdraw` DECIMAL(19, 4);
    SET `balance_before_withdraw` = 
    (SELECT `balance` 
    FROM `accounts_2` 
    WHERE `id` = `account_id`);

	START TRANSACTION;
	UPDATE `accounts_2`
    SET `balance` = `balance` - `money_amount`
    WHERE `account_id` = `id`;
    
    IF `balance_before_withdraw` < `money_amount` OR `money_amount` < 0 THEN ROLLBACK;
    END IF;
END$$
DROP PROCEDURE `usp_withdraw_money`;
CALL `usp_withdraw_money`(1, 200);
SELECT * FROM `accounts_2` WHERE `id` = 1;

#14. Money Transfer
TRUNCATE `accounts_2`;
INSERT INTO `accounts_2` SELECT * FROM `accounts`;

DELIMITER $$
#Change `accounts_2` to `accounts`
CREATE PROCEDURE `usp_transfer_money`(`from_account_id` INT, `to_account_id` INT, `amount` DECIMAL(19, 4)) 
BEGIN
	DECLARE `from_account_check` INT;
    DECLARE `to_account_check` INT;
    SET `from_account_check` = (SELECT `id` FROM `accounts_2` WHERE `id` = `from_account_id`);
    SET `to_account_check` = (SELECT `id` FROM `accounts_2` WHERE `id` = `to_account_id`);

	START TRANSACTION;
    CASE
		WHEN `from_account_check` IS NULL THEN ROLLBACK;
        WHEN `to_account_check` IS NULL THEN ROLLBACK;
        WHEN (SELECT `balance` FROM `accounts_2` WHERE `id` = `from_account_id`) < `amount` THEN ROLLBACK;
        WHEN `from_account_check` = `to_account_check` THEN ROLLBACK;
        WHEN `amount` < 0 THEN ROLLBACK;
    ELSE 
		BEGIN
			UPDATE `accounts_2`
			SET `balance` = `balance` - `amount`
			WHERE `id` = `from_account_id`;
			
			UPDATE `accounts_2`
			SET `balance` = `balance` + `amount`
			WHERE `id` = `to_account_id`;
        END;
    END CASE;
END$$
DROP PROCEDURE `usp_transfer_money`;
CALL `usp_transfer_money`(1, 2, 10);

SELECT 
	`id`,
    `account_holder_id`,
    `balance`
FROM `accounts_2`
WHERE `id` IN (1, 2);

#15. Log Accounts Trigger - TODO
TRUNCATE `accounts_2`;
INSERT INTO `accounts_2` SELECT * FROM `accounts`;

CREATE TABLE `logs`(
	`log_id` INT AUTO_INCREMENT,
	`account_id` INT NOT NULL,
    `old_sum` DECIMAL(19, 4) NOT NULL,
    `new_sum` DECIMAL(19, 4) NOT NULL,
    CONSTRAINT `pk_logs` PRIMARY KEY (`log_id`)
);

DELIMITER$$

CREATE TRIGGER `tr_account_balance_change`
AFTER UPDATE
ON `accounts_2`
FOR EACH ROW
BEGIN
#	DECLARE `new_balance` DECIMAL (19, 4);
 #   SET `new_balance` = (SELECT `balance` FROM `accounts` WHERE ``)
    
	INSERT INTO `logs`(`account_id`, `old_sum`, `new_sum`) 
    VALUES (1, 2, 3);
END$$

SELECT * FROM `accounts_2` WHERE `id` = 1;
SELECT * FROM `logs`; 

UPDATE `accounts_2`
SET `balance` = `balance` + 10
WHERE `id` = 1;

SELECT * FROM `accounts_2` WHERE `id` = 1;
SELECT * FROM `logs`; 

