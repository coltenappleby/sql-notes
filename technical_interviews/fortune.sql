CREATE TABLE IF NOT EXISTS `users` (
`id` int(6) unsigned NOT NULL,
`email` varchar(200) NOT NULL,
PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;
INSERT INTO `users` (`id`, `email`) VALUES
('1', '1@email.com'),
('2', '2@email.com'),
('3', '3@email.com');

CREATE TABLE IF NOT EXISTS `follow` (
`id` int(6) unsigned NOT NULL,
`user_id` int(6) unsigned NOT NULL,
`author` varchar(200) NOT NULL,
PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;
INSERT INTO `follow` (`id`, `user_id`, `author`) VALUES
('1','1', 'author1'),
('2','2', 'author2'),
('3','2', 'author3'),
('4','1', 'author2'),
('5','3', 'author2');

CREATE TABLE IF NOT EXISTS `clickdata` (
`id` int(6) unsigned NOT NULL,
`user_id` int(6) unsigned NOT NULL,
`url` varchar(200) NOT NULL,
PRIMARY KEY (`id`)
) DEFAULT CHARSET=utf8;
INSERT INTO `clickdata` (`id`, `user_id`, `url`) VALUES
('1','2', 'url2'),
('2','3', 'url2'),
('3','3', 'url3'),
('4','2', 'url2'),
('5','3', 'url3'),
('6','2', 'url4');