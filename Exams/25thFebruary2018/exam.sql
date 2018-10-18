CREATE DATABASE `buhtig_db`;
USE `buhtig_db`;

#01. Table Design 
CREATE TABLE `users` (
    `id` INT AUTO_INCREMENT,
    `username` VARCHAR(30) NOT NULL UNIQUE,
    `password` VARCHAR(30) NOT NULL,
    `email` VARCHAR(50) NOT NULL,
    CONSTRAINT `pk_users` PRIMARY KEY (`id`)
);

CREATE TABLE `repositories` (
    `id` INT NOT NULL AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    CONSTRAINT `pk_repositories` PRIMARY KEY (`id`)
);

CREATE TABLE `repositories_contributors` (
    `repository_id` INT,
    `contributor_id` INT,
    CONSTRAINT `fk_repositories_contributors_repositories` FOREIGN KEY (`repository_id`)
        REFERENCES `repositories` (`id`),
    CONSTRAINT `fk_repositories_contributors_users` FOREIGN KEY (`contributor_id`)
        REFERENCES `users` (`id`)
);

CREATE TABLE `issues` (
    `id` INT AUTO_INCREMENT,
    `title` VARCHAR(255) NOT NULL,
    `issue_status` VARCHAR(6) NOT NULL,
    `repository_id` INT NOT NULL,
    `assignee_id` INT NOT NULL,
    CONSTRAINT `pk_issues` PRIMARY KEY (`id`),
    CONSTRAINT `fk_issues_repositories` FOREIGN KEY (`repository_id`)
        REFERENCES `repositories` (`id`),
    CONSTRAINT `fk_issues_users` FOREIGN KEY (`assignee_id`)
        REFERENCES `users` (`id`)
);

CREATE TABLE `commits` (
    `id` INT AUTO_INCREMENT,
    `message` VARCHAR(255) NOT NULL,
    `issue_id` INT,
    `repository_id` INT NOT NULL,
    `contributor_id` INT NOT NULL,
    CONSTRAINT `pk_commits` PRIMARY KEY (`id`),
    CONSTRAINT `fk_commits_issues` FOREIGN KEY (`issue_id`)
        REFERENCES `issues` (`id`),
    CONSTRAINT `fk_commits_repositories` FOREIGN KEY (`repository_id`)
        REFERENCES `repositories` (`id`),
    CONSTRAINT `fk_commits_users` FOREIGN KEY (`contributor_id`)
        REFERENCES `users` (`id`)
);

CREATE TABLE `files` (
	`id` INT AUTO_INCREMENT,
    `name` VARCHAR(100) NOT NULL,
    `size` DECIMAL(10, 2) NOT NULL,
    `parent_id` INT,
    `commit_id` INT NOT NULL,
    CONSTRAINT `pk_files` PRIMARY KEY (`id`),
    CONSTRAINT `fk_files_files` FOREIGN KEY (`parent_id`)
		REFERENCES `files` (`id`),
	CONSTRAINT `fk_commits` FOREIGN KEY (`commit_id`)
		REFERENCES `commits` (`id`)
);

#02. Insert 

#05. Users 
SELECT `id`, `username` FROM `users`
ORDER BY `id` ASC
LIMIT 1000;

#06. Lucky Numbers 
SELECT `repository_id`, `contributor_id` FROM `repositories_contributors`
WHERE `repository_id` = `contributor_id`
ORDER BY `repository_id` ASC
LIMIT 1000;

#07. Heavy HTML 
SELECT `id`, `name`, `size` FROM `files`
WHERE `size` > 1000.0 AND `name` LIKE ('%html%')
ORDER BY `size` DESC
LIMIT 1000;

#08. IssuesAndUsers 
SELECT
	`i`.`id`,
	CONCAT(`u`.`username`, ' : ', `i`.`title`) AS `issue_assignee`
FROM `issues` `i`
INNER JOIN `users` `u`
	ON `u`.`id` = `i`.`assignee_id`
ORDER BY `i`.`id` DESC
LIMIT 1000;

#09. NonDirectoryFiles 
SELECT 
	`id`, 
    `name`, 
    CONCAT(`size`, 'KB') AS `size` 
FROM `files`
WHERE `id` NOT IN 
	(
    SELECT `parent_id` FROM `files`
    WHERE `parent_id` IS NOT NULL #if not added result table would be empty
    )
ORDER BY `id` ASC
LIMIT 1000;

#10. ActiveRepositories 
SELECT
	`r`.`id`,
    `r`.`name`,
    COUNT(`i`.`id`) AS `issues_count`
FROM `repositories` `r`
INNER JOIN `issues` `i`
	ON `i`.`repository_id` = `r`.`id`
GROUP BY `r`.`id`
ORDER BY `issues_count` DESC, `r`.`id` ASC
LIMIT 5;

#11. MostContributedRepository 


    







