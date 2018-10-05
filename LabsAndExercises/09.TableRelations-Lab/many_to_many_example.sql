CREATE TABLE `employees`(
  `employee_id` INT AUTO_INCREMENT PRIMARY KEY,
  `employee_name` VARCHAR(50)
);

CREATE TABLE `projects` (
    `project_id` INT AUTO_INCREMENT PRIMARY KEY,
    `project_name` VARCHAR(50)
);

CREATE TABLE `employees_projects` (
    `employee_id` INT,
    `project_id` INT,
    CONSTRAINT `pk_employees_projects` PRIMARY KEY (`employee_id` , `project_id`),
    CONSTRAINT `fk_employees_projects_employees` FOREIGN KEY (`employee_id`)
        REFERENCES `employees` (`employee_id`),
    CONSTRAINT `fk_employees_projects_projects` FOREIGN KEY (`project_id`)
        REFERENCES `projects` (`project_id`)
);

SELECT * FROM `employees`;
SELECT * FROM `projects`;
SELECT * FROM `employees_projects`;

INSERT INTO `employees` (`employee_name`) VALUES ('Aleksandar'), ('Pesho'), ('Gosho'), ('Tosho'), ('Sasho');

INSERT INTO `projects` (`project_name`) VALUES ('Blockchain'), ('IoT'), ('Web'), ('Desktop');

INSERT INTO `employees_projects` (`employee_id`, `project_id`) VALUES 
(1, 1), (1, 2), (1, 3), (2, 2), (2, 4), (3, 3), (4, 2), (5, 2), (5, 3);

SELECT
	CONCAT(`e`.`employee_id`, ' - ', `e`.`employee_name`) AS `Employee info`,
    CONCAT(`p`.`project_id`, ' - ', `p`.`project_name`) AS `Project info`
FROM `employees_projects` `ep`
JOIN `employees` `e`
	ON `e`.`employee_id` = `ep`.`employee_id`
JOIN `projects` `p`
	ON `p`.`project_id` = `ep`.`project_id`
ORDER BY `e`.`employee_id`; 
