SELECT * FROM `students`;
SELECT * FROM `deleted_students`;

CREATE TABLE `deleted_students` AS SELECT * FROM `students`;
TRUNCATE `deleted_students`;

DELIMITER $$

CREATE TRIGGER `tr_deleted_employees`
AFTER DELETE
ON `students`
FOR EACH ROW
BEGIN
	INSERT INTO `deleted_students` 
		(`id`, `first_name`, `last_name`, `grade`, `start_date`, `end_date`, `course`, `town_id`)
	VALUES
		(OLD.`id`, OLD.`first_name`, OLD.`last_name`, OLD.`grade`, OLD.`start_date`, OLD.`end_date`, 
			OLD.`course`, OLD.`town_id`);
END$$


DELETE FROM `students`
WHERE `id` = 5;
#Result: Record from students is deleted, but put in another table.