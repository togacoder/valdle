SET CHARACTER_SET_CLIENT = utf8;
SET CHARACTER_SET_CONNECTION = utf8;

CREATE DATABASE valdle_db;
USE valdole_db;
CREATE TABLE IF NOT EXISTS `valdle_db`.`character` (
    `id`            INTEGER,
    `name`          VARCHAR(256),
    `rarity`        INTEGER,
    `type`          INTEGER,
    `attack`        VARCHAR(256),
    `tribe`         VARCHAR(256),
    `sex`           VARCHAR(256),
    `ground_sky`    VARCHAR(256),
    `skill_type`    INTEGER,
    `skill_name`    VARCHAR(256),
    PRIMARY KEY(`id`)
);