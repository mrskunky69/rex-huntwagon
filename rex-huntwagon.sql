CREATE TABLE IF NOT EXISTS `rex_hunting_wagons` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `citizenid` varchar(50) DEFAULT NULL,
    `plate` varchar(255) NOT NULL,
    `huntingcamp` varchar(50) DEFAULT NULL,
    `damaged` tinyint(4) DEFAULT NULL,
    `active` tinyint(4) DEFAULT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

CREATE TABLE IF NOT EXISTS `rex_hunting_inventory` (
    `id` int(11) NOT NULL AUTO_INCREMENT,
    `animalhash` int(25) DEFAULT NULL,
    `animallabel` varchar(50) DEFAULT NULL,
    `animallooted` int(11) DEFAULT NULL,
    `citizenid` varchar(50) DEFAULT NULL,
    `plate` varchar(255) NOT NULL,
    PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;
