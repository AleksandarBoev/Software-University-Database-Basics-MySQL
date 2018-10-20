CREATE DATABASE `instagraph_db`;
USE `instagraph_db`;

#01. Table Design 
CREATE TABLE `pictures`(
	`id` INT AUTO_INCREMENT,
    `path` VARCHAR(255) NOT NULL,
    `size` DECIMAL(10, 2) NOT NULL,
    CONSTRAINT `pk_pictures` PRIMARY KEY(`id`)
);

CREATE TABLE `users`(
	`id` INT AUTO_INCREMENT,
    `username` VARCHAR(30) NOT NULL UNIQUE,
    `password` VARCHAR(30) NOT NULL,
    `profile_picture_id` INT,
    CONSTRAINT `pk_users` PRIMARY KEY (`id`),
    CONSTRAINT `fk_users_pictures` FOREIGN KEY(`profile_picture_id`)
		REFERENCES `pictures`(`id`)
);

CREATE TABLE `posts`(
	`id` INT AUTO_INCREMENT,
    `caption` VARCHAR(255) NOT NULL,
    `user_id` INT NOT NULL,
    `picture_id` INT NOT NULL,
    CONSTRAINT `pk_posts` PRIMARY KEY (`id`),
    CONSTRAINT `fk_posts_users` FOREIGN KEY (`user_id`)
		REFERENCES `users`(`id`),
	CONSTRAINT `fk_posts_pictures` FOREIGN KEY (`picture_id`)
		REFERENCES `pictures`(`id`)
);

CREATE TABLE `comments`(
	`id` INT AUTO_INCREMENT,
    `content` VARCHAR(255) NOT NULL,
    `user_id` INT NOT NULL,
    `post_id` INT NOT NULL,
    CONSTRAINT `pk_comments` PRIMARY KEY (`id`),
    CONSTRAINT `fk_comments_suers` FOREIGN KEY (`user_id`)
		REFERENCES `users`(`id`),
	CONSTRAINT `fk_comments_posts` FOREIGN KEY(`post_id`)
		REFERENCES `posts`(`id`)
);

CREATE TABLE `users_followers`(
	`user_id` INT,
    `follower_id` INT,
    CONSTRAINT `fk_users_followers_users-user` FOREIGN KEY(`user_id`)
		REFERENCES `users`(`id`),
	CONSTRAINT `fk_users_followers_users-follower` FOREIGN KEY(`follower_id`)
		REFERENCES `users`(`id`)
);


#05. Users 
SELECT
	`id`,
    `username`
FROM `users`
ORDER BY `id` ASC
LIMIT 1000;

#06. Cheaters 
SELECT 
	`uf`.`user_id` AS `id`,
    `u`.`username`
FROM `users_followers` `uf`
INNER JOIN `users` `u`
	ON `u`.`id` = `uf`.`user_id`
WHERE `user_id` = `follower_id`
ORDER BY `user_id` ASC
LIMIT 1000;

#07. High Quality Pictures 
SELECT * FROM `pictures`
WHERE `size` > 50000 AND (`path` LIKE '%png%' OR `path` LIKE '%jpeg%')
ORDER BY `size` DESC
LIMIT 1000;

#08. Comments and Users 
SELECT 
	`c`.`id`,
    CONCAT(`u`.`username`, ' : ', `c`.`content`) AS `full_comment`
FROM `users` `u`
INNER JOIN `comments` `c`
	ON `u`.`id` = `c`.`user_id`
ORDER BY `c`.`id` DESC
LIMIT 1000;

#09. Profile Pictures - There has to be an easier way of doing this
SELECT 
	`u`.`id`,
    `u`.`username`,
    CONCAT(`p`.`size`, 'KB') AS `size`
FROM `users` `u`
INNER JOIN `pictures` `p`
	ON `p`.`id` = `u`.`profile_picture_id`
WHERE `profile_picture_id` IN (
	SELECT `profile_picture_id` FROM (
		SELECT 
			`profile_picture_id`,
			COUNT(`profile_picture_id`) AS `pic_count`
		FROM `users`
		GROUP BY `profile_picture_id`
		HAVING `pic_count` > 1 #if someone has NULL profile_pic_id then the COUNT is 0 and skipped
    ) AS `cq`
)
ORDER BY `u`.`id` ASC;

#10. Spam Posts 
SELECT 
	`p`.`id`,
    `p`.`caption`,
    COUNT(`c`.`id`) AS `comments`
FROM `posts` `p`
LEFT JOIN `comments` `c`
	ON `p`.`id` = `c`.`post_id`
GROUP BY `p`.`id`
ORDER BY `comments` DESC, `p`.`id` ASC
LIMIT 5;

#11. Most Popular User - Again, there has to be an easier way
SELECT 
	`cq`.`star`,
    `cq`.`star_name`,
    COUNT(`p`.`id`) AS `count_of_posts`,
    `cq`.`count_of_followers`
FROM (
	SELECT 
		`uf`.`user_id` AS `star`,
        `u`.`username` AS `star_name`,
		COUNT(`uf`.`follower_id`) AS `count_of_followers`
	FROM `users_followers` `uf`
	INNER JOIN `users` `u`
		ON `u`.`id` = `uf`.`user_id`
	GROUP BY `uf`.`user_id`
	ORDER BY `count_of_followers` DESC
) AS `cq`
INNER JOIN `posts` `p`
	ON `cq`.`star` = `p`.`user_id`
GROUP BY `cq`.`star`
LIMIT 1;

#12. Commenting Myself 
SELECT 
	`u`.`id`,
    `u`.`username`,
    COUNT(`c`.`id`) AS `self_comment_count`
FROM `users` `u`
LEFT JOIN `posts` `p`
	ON `p`.`user_id` = `u`.`id`
LEFT JOIN `comments` `c`
	ON `c`.`post_id` = `p`.`id` AND `c`.`user_id` = `u`.`id`
GROUP BY `u`.`id`
ORDER BY `self_comment_count` DESC, `u`.`id` ASC;


