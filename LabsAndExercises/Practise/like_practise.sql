USE `practise_db`;

CREATE TABLE `like_practise`(
	`word` VARCHAR(255) NOT NULL
);

INSERT INTO `like_practise`(`word`)
VALUES ('Ivan Ivanov'), ('Ivan ivanov'), ('ivan Ivanov'), ('Ivan Ivanov'), ('Iv Ivanov'); 

DELIMITER $$

CREATE PROCEDURE `usp_like_practise`(`like_expression` VARCHAR(100))
BEGIN
	SELECT 
		`word`,
		IF (`word` LIKE `like_expression`, 'TRUE', 'FALSE') AS `matches`
	FROM `like_practise`;
END$$

DELIMITER ;

CALL `usp_like_practise`('i___ i_____'); #looks like it is case-insensitive

