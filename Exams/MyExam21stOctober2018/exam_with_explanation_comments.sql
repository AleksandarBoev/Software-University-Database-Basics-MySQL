DROP DATABASE `colonial_journey_db`;
CREATE DATABASE `colonial_journey_db`; #after all table creation, Reverse engineer the db for a EER diagram
USE `colonial_journey_db`;

#00. Table Design 
CREATE TABLE `planets` (
    `id` INT AUTO_INCREMENT,
    `name` VARCHAR(30) NOT NULL,
    CONSTRAINT `pk_planets` PRIMARY KEY (`id`)
);

CREATE TABLE `spaceports` (
    `id` INT AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `planet_id` INT,
    CONSTRAINT `pk_spaceports` PRIMARY KEY (`id`),
    CONSTRAINT `fk_spaceports_planets` FOREIGN KEY (`planet_id`)
        REFERENCES `planets` (`id`)
);

CREATE TABLE `spaceships` (
    `id` INT AUTO_INCREMENT,
    `name` VARCHAR(50) NOT NULL,
    `manufacturer` VARCHAR(30) NOT NULL,
    `light_speed_rate` INT DEFAULT 0,
    CONSTRAINT `pk_spaceships` PRIMARY KEY (`id`)
);

CREATE TABLE `colonists` (
    `id` INT AUTO_INCREMENT,
    `first_name` VARCHAR(20) NOT NULL,
    `last_name` VARCHAR(20) NOT NULL,
    `ucn` CHAR(10) NOT NULL UNIQUE,
    `birth_date` DATE NOT NULL,
    CONSTRAINT `pk_colonists` PRIMARY KEY (`id`)
);

CREATE TABLE `journeys` (
    `id` INT AUTO_INCREMENT,
    `journey_start` DATETIME NOT NULL,
    `journey_end` DATETIME NOT NULL,
    `purpose` ENUM('Medical', 'Technical', 'Educational', 'Military'),
    `destination_spaceport_id` INT,
    `spaceship_id` INT,
    CONSTRAINT `pk_journeys` PRIMARY KEY (`id`),
    CONSTRAINT `fk_journeys_spaceports` FOREIGN KEY (`destination_spaceport_id`)
        REFERENCES `spaceports` (`id`),
    CONSTRAINT `fk_journeys_spaceships` FOREIGN KEY (`spaceship_id`)
        REFERENCES `spaceships` (`id`)
);

CREATE TABLE `travel_cards` (
    `id` INT AUTO_INCREMENT,
    `card_number` CHAR(10) NOT NULL UNIQUE,
    `job_during_journey` ENUM('Pilot', 'Engineer', 'Trooper', 'Cleaner', 'Cook'),
    `colonist_id` INT,
    `journey_id` INT,
    CONSTRAINT `pk_travel_cards` PRIMARY KEY (`id`),
    CONSTRAINT `fk_travel_cards_colonists` FOREIGN KEY (`colonist_id`)
        REFERENCES `colonists` (`id`),
    CONSTRAINT `fk_travel_cards_journeys` FOREIGN KEY (`journey_id`)
        REFERENCES `journeys` (`id`)
);

#01. Insert 
/*
You will have to INSERT records of data into the travel_cards table, based on the colonists table.
For colonists with id between 96 and 100(inclusive), insert data in the travel_cards table with the following values: 
•	For colonists born after ‘1980-01-01’, the card_number must be 
combination between the year of birth, day and the first 4 digits from the ucn. 
For the rest – year of birth, month and the last 4 digits from the ucn.
•	For colonists with id that can be divided by 2 without remainder, job must be ‘Pilot’,
 for colonists with id that can be divided by 3 without remainder – ‘Cook’, and everyone else – ‘Engineer’.
•	Journey id is the first digit from the colonist’s ucn.
*/
DROP TABLE `travel_cards2`;
CREATE TABLE `travel_cards2` AS SELECT * FROM `travel_cards`; #making a duplicate table, so that the original stays untouched
SELECT * FROM `travel_cards2`; #always looking the the table information to get a better grasp of the situation

SELECT EXTRACT(MONTH FROM '1980-01-01'); # this type of extracting needs to be used to get the month and day
SELECT SUBSTR('1980-01-01', 6, 2); # and not this... for some reason

INSERT INTO `travel_cards2` (`card_number`, `job_during_journey`, `colonist_id`, `journey_id`) #change it back to travel_cards
SELECT
	CONCAT(
		EXTRACT(YEAR FROM `c`.`birth_date`), 
		IF (`c`.`birth_date` > '1980-01-01', 
			CONCAT( EXTRACT(DAY FROM `c`.`birth_date`), LEFT(`c`.`ucn`, 4)),
			CONCAT( EXTRACT(MONTH FROM `c`.`birth_date`), RIGHT(`c`.`ucn`, 4))
		)
	) AS `new_card_number`,
    CASE
		WHEN `c`.`id` MOD 2 = 0 THEN 'Pilot'
        WHEN `c`.`id` MOD 3 = 0 THEN 'Cook'
        ELSE 'Engineer'
	END AS `new_job_during_journey`,
    `c`.`id`,
    LEFT(`c`.`ucn`, 1) AS `new_journey_id`
FROM `colonists` `c`
WHERE `c`.`id` BETWEEN 96 AND 100
ORDER BY `c`.`id`;
	
#02. Update 
CREATE TABLE `journeys2` AS SELECT * FROM `journeys`;
DROP TABLE `journeys2`;
/*
UPDATE those journeys’ purpose, which meet the following conditions:
•	If the journey’s id is dividable by 2 without remainder – ‘Medical’.
•	If the journey’s id is dividable by 3 without remainder – ‘Technical’.
•	If the journey’s id is dividable by 5 without remainder – ‘Educational’.
•	If the journey’s id is dividable by 7 without remainder – ‘Military’. 
*/
SELECT * FROM `journeys2`; #from here to code row 131 make a query so that 2 tables can be viewed-1 before and 1 after update

UPDATE `journeys2`
SET `purpose` = (
	SELECT 
		CASE 
			WHEN `id` MOD 2 = 0 THEN 'Medical'
            WHEN `id` MOD 3 = 0 THEN 'Technical'
            WHEN `id` MOD 5 = 0 THEN 'Educational'
            WHEN `id` MOD 7 = 0 THEN 'Military'
		END
)
WHERE 
	`id` MOD 2 = 0 OR 
    `id` MOD 3 = 0 OR 
    `id` MOD 5 = 0 OR 
    `id` MOD 7 = 0;

SELECT * FROM `journeys2`;
#03. Delete 
# REMOVE from colonists, those which are not assigned to any journey.

SELECT #query which returns the ids of colonists not assigned to any journey
	`c`.`id`
FROM `colonists` `c`
LEFT JOIN `travel_cards` `tc`
	ON `c`.`id` = `tc`.`colonist_id`
LEFT JOIN `journeys` `j`
	ON `j`.`id` = `tc`.`journey_id`
WHERE `j`.`id` IS NULL;

#CREATE TABLE `colonists2` AS SELECT * FROM `colonists`;

DELETE FROM `colonists` 
WHERE `id` IN (
	SELECT * FROM( #need this additional query, or mysql will throw exception
		SELECT 
			`c`.`id`
		FROM `colonists` `c`
		LEFT JOIN `travel_cards` `tc`
			ON `c`.`id` = `tc`.`colonist_id`
		LEFT JOIN `journeys` `j`
			ON `j`.`id` = `tc`.`journey_id`
		WHERE `j`.`id` IS NULL
    ) AS `cq`
);

#04. Extract all travel cards 
/*
Extract from the database, all travel cards. Sort the results by card number ascending.
Required Columns
•	card_number
•	job_during_journey
*/
SELECT
	`card_number`,
    `job_during_journey`
FROM `travel_cards`
ORDER BY `card_number` ASC;

#05. Extract all colonists 
/*
Extract from the database, all colonists. 
Sort the results by first name, them by last name, and finally by id in ascending order.
Required Columns
•	id
•	full_name(first_name + last_name separated by a single space)
•	ucn
*/
SELECT
	`id`,
    CONCAT(`first_name`, ' ', `last_name`) AS `full_name`,
    `ucn`
FROM `colonists`
ORDER BY `first_name` ASC, `last_name` ASC, `id` ASC;

#06. Extract all military journeys 
/*
Extract from the database, all Military journeys. Sort the results ascending by journey start.

Required Columns
•	id
•	journey_start
•	journey_end

*/
SELECT
	`id`,
    `journey_start`,
    `journey_end`
FROM `journeys`
WHERE `purpose` = 'Military'
ORDER BY `journey_start` ASC;

#07. Extract all pilots 
/*
Extract from the database all colonists, which have a pilot job. Sort the result by id, ascending.

Required Columns
•	id
•	full_name
*/
SELECT
	`c`.`id`,
    CONCAT(`c`.`first_name`, ' ', `c`.`last_name`) AS `full_name`
FROM `colonists` `c`
INNER JOIN `travel_cards` `tc`
	ON `tc`.`colonist_id` = `c`.`id`
WHERE `tc`.`job_during_journey` = 'Pilot'
ORDER BY `c`.`id` ASC;

#08. Count all colonists 
/*
Count all colonists, that are on technical journey. 

Required Columns
•	Count
*/
SELECT * FROM `colonists`; #like always, execute these three queries to better grasp the situation,
SELECT * FROM `travel_cards`; #they can be executed like a single query so that switching between them is easier
SELECT * FROM `journeys`;

SELECT
	COUNT(`c`.`id`)
FROM `colonists` `c`
INNER JOIN `travel_cards` `tc`
	ON `c`.`id` = `tc`.`colonist_id`
INNER JOIN `journeys` `j`
	ON `tc`.`journey_id` = `j`.`id`
WHERE `j`.`purpose` = 'Technical';

#09. Extract the fastest spaceship 
/*
Extract from the database the fastest spaceship and its destination spaceport name. 
In other words, the ship with the highest light speed rate.

Required Columns
•	spaceship_name
•	spaceport_name

*/
SELECT
	`ss`.`name` AS `spaceship_name`,
    `sp`.`name` AS `spaceport_name`
FROM `spaceships` `ss`
INNER JOIN `journeys` `j`
	ON `ss`.`id` = `j`.`spaceship_id`
INNER JOIN `spaceports` `sp`
	ON `sp`.`id` = `j`.`destination_spaceport_id`
ORDER BY `ss`.`light_speed_rate` DESC
LIMIT 1;

#10. Extract - pilots younger than 30 years 
/*
Extract from the database those spaceships, which have pilots, younger than 30 years old. 
In other words, 30 years from 01/01/2019. Sort the results alphabetically by spaceship name.

Required Columns
•	name
•	manufacturer
*/
SELECT 
	`ss`.`name` AS `spaceship_name`,
    `ss`.`manufacturer` AS `spaceship_manufacturer_name`
FROM `colonists` `c`
INNER JOIN `travel_cards` `tc`
	ON `tc`.`colonist_id` = `c`.`id`
INNER JOIN `journeys` `j`
	ON `tc`.`journey_id` = `j`.`id`
INNER JOIN `spaceships` `ss`
	ON `ss`.`id` = `j`.`spaceship_id`
WHERE `tc`.`job_during_journey` = 'Pilot' AND `c`.`birth_date` > '1989-01-01' #2019 - 30 = 1989
ORDER BY `ss`.`name` ASC;

#11. Extract all educational mission 
/*
Extract from the database names of all planets and their spaceports, which have educational missions/journeys. 
Sort the results by spaceport name in descending order.

Required Columns
•	planet_name
•	spaceport_name

*/
SELECT * FROM `planets`;
SELECT * FROM `spaceports`;
SELECT * FROM `journeys`;

SELECT
	`p`.`name` AS `planet_name`,
    `sp`.`name` AS `spaceport_name`
FROM `planets` `p`
INNER JOIN `spaceports` `sp`
	ON `sp`.`planet_id` = `p`.`id`
INNER JOIN `journeys` `j`
	ON `j`.`destination_spaceport_id` = `sp`.`id`
WHERE `j`.`purpose` = 'Educational'
ORDER BY `sp`.`name` DESC;

#12. Extract all planets and their journey count 
/*
Extract from the database all planets’ names and their journeys count. --> LEFT JOIN x2 to have planets with 0 sp. and j.
Order the results by journeys count, descending and by planet name ascending.
Required Columns
•	planet_name
•	journeys_count
*/
SELECT * FROM `planets`;
SELECT * FROM `spaceports`;
SELECT * FROM `journeys`;

SELECT 
	`p`.`name` AS `planet_name`,
    COUNT(`j`.`id`) AS `journeys_count`
FROM `planets` `p`
INNER JOIN `spaceports` `sp`
	ON `p`.`id` = `sp`.`planet_id`
INNER JOIN `journeys` `j`
	ON `j`.`destination_spaceport_id` = `sp`.`id`
GROUP BY `p`.`id`
ORDER BY `journeys_count` DESC, `p`.`name` ASC;

#13. Extract the shortest journey - TODO
/*
Extract from the database the shortest journey, its destination spaceport name, planet name and purpose.
EDIT by me: Shortes in terms of time.
Required Columns
•	Id
•	planet_name
•	spaceport_name
•	journey_purpose
*/
#SELECT TIME(ABS(TIMEDIFF( "13:10:10", "14:10:11")));
SELECT * FROM `journeys`;
SELECT TIMEDIFF('2019-02-09 17:02:46', '2049-04-20 22:39:54');
SELECT TIME(ABS(TIMEDIFF(TIME('2019-02-09 17:02:46'), TIME('2049-04-20 22:39:54'))));

SELECT TIMESTAMPDIFF(SECOND, '2019-02-09 17:02:46', '2049-04-20 22:39:54'); #this is the solution! But can it hold such a big number?

SELECT
	`j`.`id`,
    TIMESTAMPDIFF(SECOND, `j`.`journey_start`, `j`.`journey_end`) AS `time_difference_in_seconds`
FROM `journeys` `j`
ORDER BY `time_difference_in_seconds` DESC; #works

SELECT
	`j`.`id`,
    `p`.`name` AS `planet_name`,
    `sp`.`name` AS `spaceport_name`,
    `j`.`purpose` AS `journey_purpose`
FROM `journeys` `j`
INNER JOIN `spaceports` `sp`
	ON `sp`.`id` = `j`.`destination_spaceport_id`
INNER JOIN `planets` `p`
	ON `p`.`id` = `sp`.`planet_id`
ORDER BY TIMESTAMPDIFF(SECOND, `j`.`journey_start`, `j`.`journey_end`) ASC
LIMIT 1;

#14. Extract the less popular job 
/*
Extract from the database the less popular job in the longest journey. 
In other words, the job with less assign colonists.

Required Columns
•	job_name
*/
SELECT * FROM `journeys`;
SELECT * FROM `travel_cards`;

SELECT
	`j`.`id`
FROM `journeys` `j`
ORDER BY TIMESTAMPDIFF(SECOND, `j`.`journey_start`, `j`.`journey_end`) DESC
LIMIT 1; #query which gets the id of the longest journey

SELECT #query which holds information about the longest journey. The jobs during journey can be seen
	*
FROM `journeys` `j`
INNER JOIN `travel_cards` `tc` 
	ON `j`.`id` = `tc`.`journey_id`
WHERE `j`.`id` = (
	SELECT
		`j`.`id`
	FROM `journeys` `j`
	ORDER BY TIMESTAMPDIFF(SECOND, `j`.`journey_start`, `j`.`journey_end`) DESC
	LIMIT 1 #query which gets the id of the longest journey
);


SELECT #groups by and counts jobs
	*,
    COUNT(`tc`.`colonist_id`) AS `count_of_people_with_this_job`
FROM `journeys` `j`
INNER JOIN `travel_cards` `tc` 
	ON `j`.`id` = `tc`.`journey_id`
WHERE `j`.`id` = (
	SELECT
		`j`.`id`
	FROM `journeys` `j`
	ORDER BY TIMESTAMPDIFF(SECOND, `j`.`journey_start`, `j`.`journey_end`) DESC
	LIMIT 1 
)
GROUP BY `tc`.`job_during_journey`
ORDER BY `count_of_people_with_this_job` ASC;

SELECT `job_during_journey` AS `least_worked_job` #final solution
FROM (
	SELECT
		`tc`.`job_during_journey`,
		COUNT(`tc`.`colonist_id`) AS `count_of_people_with_this_job`
	FROM `journeys` `j`
	INNER JOIN `travel_cards` `tc` 
		ON `j`.`id` = `tc`.`journey_id`
	WHERE `j`.`id` = ( #extract the information only from the longest journey
		SELECT
			`j`.`id`
		FROM `journeys` `j`
		ORDER BY TIMESTAMPDIFF(SECOND, `j`.`journey_start`, `j`.`journey_end`) DESC
		LIMIT 1 
	)
	GROUP BY `tc`.`job_during_journey` #extracted information from the longest journey should be grouped by
	ORDER BY `count_of_people_with_this_job` ASC
	LIMIT 1
) AS `cq`;

#15. Get colonists count 
/*
Create a user defined function with the name 
udf_count_colonists_by_destination_planet (planet_name VARCHAR (30)) 
that receives planet name and returns the count of all colonists sent to that planet.
*/
SET GLOBAL log_bin_trust_function_creators = 1; #fixing a mysql problem
DROP FUNCTION `udf_count_colonists_by_destination_planet`;
DELIMITER $$

CREATE FUNCTION `udf_count_colonists_by_destination_planet` (`planet_name` VARCHAR (30))
RETURNS INT
BEGIN
	RETURN (
	SELECT `colonist_count` FROM (
		SELECT 
			`p`.`id`,
			`p`.`name`,
			COUNT(`tc`.`colonist_id`) AS `colonist_count`
		FROM `planets` `p`
		LEFT JOIN `spaceports` `sp` #planet can have NO spaceports
			ON `p`.`id` = `sp`.`planet_id`
		LEFT JOIN `journeys` `j` #there can be NO journeys, which have a destination the spaceport
			ON `j`.`destination_spaceport_id` = `sp`.`id`
		LEFT JOIN `travel_cards` `tc` #there can be journeys without ANY people in them...
			ON `tc`.`journey_id` = `j`.`id`
		GROUP BY `p`.`id`
		ORDER BY `p`.`id` ASC
    ) AS `cq`
    WHERE `name` = `planet_name`
    );
END$$

SELECT 
	'Otroyphus', 
    `udf_count_colonists_by_destination_planet`('Otroyphus') AS `colonists_count`;

    
#16. Modify spaceship 
/*
Create a user defined stored procedure with the name 
udp_modify_spaceship_light_speed_rate(spaceship_name VARCHAR(50), light_speed_rate_increse INT(11)) 
that receives a spaceship name and light speed increase value and increases 
spaceship light speed only if the given spaceship exists. 
If the modifying is not successful rollback any changes and throw an exception with 
error code ‘45000’ and message: “Spaceship you are trying to modify does not exists.” 
*/
CREATE TABLE `spaceships2` AS SELECT * FROM `spaceships`;
SELECT * FROM `spaceships2`;

DELIMITER $$

CREATE PROCEDURE `udp_modify_spaceship_light_speed_rate`(`spaceship_name` VARCHAR(50), `light_speed_rate_increse` INT(11))
BEGIN
	DECLARE `space_ship_found` INT;
    
    SET `space_ship_found` = ( #returns 0 if NO spaceship is found with this name. Or returns the id of the spaceship
		SELECT COUNT(`id`) 
        FROM `spaceships`
        WHERE `name` = `spaceship_name`
    );
    
    CASE 
		WHEN `space_ship_found` = 0 
			THEN SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Spaceship you are trying to modify does not exists.';
	ELSE
		UPDATE `spaceships2` #change to `spaceships` for judge
        SET `light_speed_rate` = `light_speed_rate` + `light_speed_rate_increse`
        WHERE `name` = `spaceship_name`;
	END CASE;
END$$

CALL `udp_modify_spaceship_light_speed_rate` ('Na Pesho koraba', 1914); #returns an sql error with the message I set

CALL `udp_modify_spaceship_light_speed_rate` ('USS Templar', 5);

SELECT 
	`name`, 
    `light_speed_rate` 
FROM `spaceships2`
WHERE `name` = 'USS Templar';

