CREATE TABLE IF NOT EXISTS `safes` (
    `id` BIGINT NOT NULL,
    `owner` VARCHAR(64) NOT NULL,
    `type` VARCHAR(64) NOT NULL,
    `metadata` JSON NOT NULL,
    PRIMARY KEY (`id`)
);