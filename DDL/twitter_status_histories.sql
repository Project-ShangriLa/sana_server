CREATE TABLE `twitter_status_histories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `bases_id` int(11) DEFAULT NULL,
  `follower` int(11) DEFAULT NULL,
  `get_date` datetime DEFAULT NULL,
  `created_at` datetime DEFAULT NULL,
  `updated_at` datetime DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `index_twitter_status_histories_on_bases_id_and_get_date` (`bases_id`,`get_date`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_unicode_ci;
