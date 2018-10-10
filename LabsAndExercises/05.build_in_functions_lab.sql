#01. Find Book Titles 
#Setup
USE `book_library`;

#Judge Code
SELECT `title` FROM `books`
WHERE LEFT(`title`, 3) = 'The';

#02. Replace Titles 
SELECT REPLACE(`title`, 'The', '***') FROM `books`
WHERE LEFT(`title`, 3) = 'The';
#Another more complex solution, but the idea of it is not bad:
#SELECT REPLACE(`title`, 'The', REPEAT('*', CHAR_LENGTH('The'))) FROM `books`
#WHERE LEFT(`title`, CHAR_LENGTH('The')) = 'The';

#03. Sum Cost of All Books 
SELECT ROUND(SUM(`cost`), 2) FROM `books`;

#04. Days Lived 
CREATE VIEW `v_days_lived_authors` AS #practising views
SELECT CONCAT(`first_name`, ' ', `last_name`) AS 'Full Name', 
	TIMESTAMPDIFF(DAY, `born`, `died`) AS 'Days Lived' 
FROM `authors`;

SELECT * FROM `v_days_lived_authors`;

#05. Harry Potter Books 
SELECT `title` FROM `books`
WHERE `title` LIKE '%Harry Potter%'; #LIKE is faster than REGEXP, but is more limited
#WHERE `title` REGEXP('Harry Potter'); #also works
