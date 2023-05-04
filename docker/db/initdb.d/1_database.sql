SET CHARACTER_SET_CLIENT = utf8;
SET CHARACTER_SET_CONNECTION = utf8;

CREATE DATABASE valdle_db;
USE valdle_db;
CREATE TABLE IF NOT EXISTS `valdle_db`.`character` (
    `id`            INTEGER,
    `rarity`        VARCHAR(256),
    `name`          VARCHAR(256),
    `type`          VARCHAR(256),
    `attack`        VARCHAR(256),
    `tribe`         VARCHAR(256),
    `sex`           VARCHAR(256),
    `position`      VARCHAR(256),
    `attribute`     VARCHAR(256),
    `action_name`   VARCHAR(256),
    `limit_burst`   VARCHAR(256),
    PRIMARY KEY(`id`)
);