CREATE DATABASE `practise_db`;
USE `practise_db`;

CREATE TABLE `regex_exercises` (
	`word` VARCHAR(255) NOT NULL
);
DROP TABLE `regex_exercises`;
TRUNCATE `regex_exercises`;

INSERT INTO `regex_exercises` VALUES ('ivan ivanov'), ('Ivan ivanov'), ('Ivan  Ivanov'), ('Ivan Ivanov');
INSERT INTO `regex_exercises` VALUES ('12345');

DELIMITER $$

CREATE PROCEDURE `usp_regex_testing`(`regex` VARCHAR(255))
BEGIN
	SELECT
		`word`,
		IF (`word` REGEXP `regex` = 1, 'TRUE', 'FALSE') AS `matches_regex`
	FROM `regex_exercises`;
END$$

DELIMITER ;

CALL `usp_regex_testing`('[A-Z][a-z]{3} [A-Z][a-z]{3}');
#Not sure which symbols have to be escaped and if this is case-insensitive. Regex in MySQL is not really a good idea.