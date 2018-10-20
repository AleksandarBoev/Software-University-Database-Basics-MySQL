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
    `size` DECIMAL(10 , 2 ) NOT NULL,
    `parent_id` INT,
    `commit_id` INT NOT NULL,
    CONSTRAINT `pk_files` PRIMARY KEY (`id`),
    CONSTRAINT `fk_files_files` FOREIGN KEY (`parent_id`)
        REFERENCES `files` (`id`),
    CONSTRAINT `fk_commits` FOREIGN KEY (`commit_id`)
        REFERENCES `commits` (`id`)
);

#02. Insert 
INSERT INTO `issues`(`title`, `issue_status`, `repository_id`, `assignee_id`)
SELECT 
	CONCAT('Critical Problem With ', `f`.`name`, '!') AS `title`, 
    'open',
    CEILING(`f`.`id` * 2 / 3) AS `repository_id`, 
    `c`.`contributor_id`
FROM `files` `f`
INNER JOIN `commits` `c`
	ON `c`.`id` = `f`.`commit_id`
WHERE `f`.`id` BETWEEN 46 AND 50;

#03. Update 
UPDATE `repositories_contributors` `rc2`
SET `rc2`.`repository_id` = (
	SELECT * FROM( #needs to be enveloped in another select, so that an error does not happen
		SELECT MIN(`r`.`id`) FROM `repositories` `r`
		LEFT JOIN `repositories_contributors` `rc`
			ON `r`.`id` = `rc`.`repository_id`
		WHERE `rc`.`repository_id` IS NULL
    ) AS `cq`
)
WHERE `rc2`.`contributor_id` = `rc2`.`repository_id`;

#04. Delete 
DELETE FROM `repositories`
WHERE `id` NOT IN (
	SELECT `repository_id` FROM `issues`
);

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
SELECT 
	`rc`.`repository_id`, 
    `r`.`name`,
    (
	SELECT COUNT(`id`) 
	FROM `commits`
	WHERE `repository_id` = `r`.`id`
    ) AS `commits`,
    COUNT(`rc`.`contributor_id`) AS `contributor_count`
FROM `repositories_contributors` `rc`
LEFT JOIN `repositories` `r`
	ON `rc`.`repository_id` = `r`.`id`
GROUP BY `repository_id`
ORDER BY `contributor_count` DESC, `r`.`id` ASC
LIMIT 1;

#12. FixingMyOwnProblems 
SELECT 
	`u`.`id` AS `user_id`,
    `u`.`username`,
    ( 
    SELECT COUNT(`c`.`id`) #this table produces only 1 column with 1 value
	FROM `commits` `c`
    INNER JOIN `issues` `i`
		ON `c`.`issue_id` = `i`.`id`
    WHERE `i`.`assignee_id` = `u`.`id` AND `c`.`contributor_id` = `u`.`id` #current user
    )
    AS `count_of_commits`
FROM `users` `u`
ORDER BY `count_of_commits` DESC, `u`.`id` ASC;

#13. RecursiveCommits - the count of the name should be searched in the message part of ALL comments
SELECT
	LEFT(`f1`.`name`, LOCATE('.', `f1`.`name`) - 1) AS `file_name`,
	(
		SELECT COUNT(`c2`.`id`)
        FROM `commits` `c2`
        WHERE `c2`.`message` LIKE CONCAT('%', `f1`.`name`, '%')
     ) AS `recursive_count`
FROM `files` `f1`
INNER JOIN `files` `f2`
	ON `f1`.`parent_id` = `f2`.`id` AND `f2`.`parent_id` = `f1`.`id`
INNER JOIN `commits` `c`
	ON `c`.`id` = `f1`.`commit_id`
WHERE `f1`.`id` <> `f2`.`id`;

#14. RepositoriesAndCommits 
SELECT 
	`r`.`id`, 
    `r`.`name`,
	(
	SELECT 
		COUNT(DISTINCT(`c`.`contributor_id`))
	) AS `users`
FROM `repositories` `r`
LEFT JOIN `commits` `c`
	ON `r`.`id` = `c`.`repository_id`
GROUP BY `r`.`id`
ORDER BY `users` DESC, `r`.`id` ASC;

#15. Commit 
DELIMITER $$

CREATE PROCEDURE `udp_commit`(`username` VARCHAR(30), `password` VARCHAR(30), `message` VARCHAR(255), `issue_id` INT)
BEGIN
	CASE
		WHEN `username` NOT IN 
        (
        SELECT `username` 
        FROM `users` 
        WHERE `username` IS NOT NULL
        ) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'No such user!';
        WHEN `password` NOT IN 
        (
        SELECT `password` 
        FROM `users` `u`
        WHERE `u`.`username` = `username`
        ) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Password is incorrect!';
        WHEN `issue_id` NOT IN
        (
        SELECT `id` FROM `issues`
        ) THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'The issue does not exist!';
        ELSE 
			BEGIN
				DECLARE `user_id` INT;
                DECLARE `new_repository_id` INT;
                
                SET `user_id` = (SELECT `u`.`id` FROM `users` `u` WHERE `username` = `u`.`username` AND `password` = `u`.`password`);
                
                SET `new_repository_id` = (
					SELECT `repository_id`
                    FROM `issues`
                    WHERE `issues`.`id` = `issue_id`
                );
                
                INSERT INTO `commits2`(`message`, `issue_id`, `repository_id`, `contributor_id`) #change form commits2 to commits
                VALUES (`message`, `issue_id`, `new_repository_id`, `user_id`);
            END;
    END CASE;
END$$

#16. Filter Extensions 
DELIMITER $$

CREATE PROCEDURE `udp_findbyextension`(`extension` VARCHAR(30))
BEGIN
	SELECT 
		`id`,
        `name` AS `caption`,
        CONCAT(`size`, 'KB') AS `user`
	FROM `files`
    WHERE `name` LIKE CONCAT('%.', `extension`);
END$$

DROP PROCEDURE `udp_findbyextension`;

CALL `udp_findbyextension`('html');

