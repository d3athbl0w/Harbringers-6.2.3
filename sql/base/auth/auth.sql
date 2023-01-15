-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               5.5.9-log - MySQL Community Server (GPL)
-- Server OS:                    Win32
-- HeidiSQL Version:             11.0.0.5919
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;


-- Dumping database structure for auth
CREATE DATABASE IF NOT EXISTS `auth` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `auth`;

-- Dumping structure for table auth.account
CREATE TABLE IF NOT EXISTS `account` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Identifier',
  `username` varchar(250) NOT NULL DEFAULT '',
  `sha_pass_hash` varchar(40) NOT NULL DEFAULT '',
  `sessionkey` varchar(80) NOT NULL DEFAULT '',
  `v` varchar(64) NOT NULL DEFAULT '',
  `s` varchar(64) NOT NULL DEFAULT '',
  `token_key` varchar(100) NOT NULL DEFAULT '',
  `email` varchar(254) NOT NULL DEFAULT '',
  `joindate` datetime NOT NULL,
  `last_ip` varchar(15) NOT NULL DEFAULT '127.0.0.1',
  `failed_logins` int(10) unsigned NOT NULL DEFAULT '0',
  `locked` smallint(3) NOT NULL DEFAULT '0',
  `last_login` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `online` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `expansion` tinyint(3) unsigned NOT NULL DEFAULT '5',
  `mutetime` bigint(20) NOT NULL DEFAULT '0',
  `locale` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `os` varchar(4) NOT NULL DEFAULT '',
  `recruiter` int(10) unsigned NOT NULL DEFAULT '0',
  `bnet2_pass_hash` varchar(256) NOT NULL DEFAULT '',
  `bnet2_salt` varchar(64) NOT NULL DEFAULT '',
  `google_auth` varchar(15) DEFAULT NULL,
  `rsa_clear` blob,
  `admin` tinyint(3) NOT NULL DEFAULT '0',
  `activate` tinyint(4) DEFAULT '0',
  `payment` tinyint(4) DEFAULT '0',
  `service_flags` int(10) unsigned NOT NULL DEFAULT '0',
  `custom_flags` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_username` (`username`),
  KEY `recruiterIndex` (`recruiter`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Account System';

-- Dumping data for table auth.account: ~0 rows (approximately)
DELETE FROM `account`;
/*!40000 ALTER TABLE `account` DISABLE KEYS */;
/*!40000 ALTER TABLE `account` ENABLE KEYS */;

-- Dumping structure for table auth.account_access
CREATE TABLE IF NOT EXISTS `account_access` (
  `id` int(10) unsigned NOT NULL,
  `gmlevel` tinyint(3) unsigned NOT NULL,
  `RealmID` int(11) NOT NULL DEFAULT '-1',
  `comment` text,
  PRIMARY KEY (`id`,`RealmID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table auth.account_access: ~0 rows (approximately)
DELETE FROM `account_access`;
/*!40000 ALTER TABLE `account_access` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_access` ENABLE KEYS */;

-- Dumping structure for table auth.account_banned
CREATE TABLE IF NOT EXISTS `account_banned` (
  `id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Account id',
  `externalban` int(10) unsigned NOT NULL DEFAULT '0',
  `bandate` int(10) unsigned NOT NULL DEFAULT '0',
  `unbandate` int(10) unsigned NOT NULL DEFAULT '0',
  `bannedby` varchar(50) NOT NULL,
  `banreason` varchar(255) NOT NULL,
  `active` tinyint(3) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`,`bandate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Ban List';

-- Dumping data for table auth.account_banned: ~0 rows (approximately)
DELETE FROM `account_banned`;
/*!40000 ALTER TABLE `account_banned` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_banned` ENABLE KEYS */;

-- Dumping structure for table auth.account_battlepay
CREATE TABLE IF NOT EXISTS `account_battlepay` (
  `accountId` int(11) unsigned NOT NULL,
  `points` int(11) NOT NULL,
  PRIMARY KEY (`accountId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table auth.account_battlepay: ~0 rows (approximately)
DELETE FROM `account_battlepay`;
/*!40000 ALTER TABLE `account_battlepay` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_battlepay` ENABLE KEYS */;

-- Dumping structure for table auth.account_battlepet
CREATE TABLE IF NOT EXISTS `account_battlepet` (
  `id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `account` int(10) unsigned NOT NULL DEFAULT '0',
  `slot` int(11) NOT NULL DEFAULT '-1',
  `name` varchar(50) NOT NULL,
  `nameTimeStamp` int(10) unsigned NOT NULL DEFAULT '0',
  `species` int(10) unsigned NOT NULL DEFAULT '0',
  `quality` int(10) unsigned NOT NULL DEFAULT '0',
  `breed` int(10) unsigned NOT NULL DEFAULT '0',
  `level` int(10) unsigned NOT NULL DEFAULT '0',
  `xp` int(10) unsigned NOT NULL DEFAULT '0',
  `display` int(10) unsigned NOT NULL DEFAULT '0',
  `health` int(11) NOT NULL DEFAULT '0',
  `flags` int(10) unsigned NOT NULL DEFAULT '0',
  `infoPower` int(11) NOT NULL DEFAULT '0',
  `infoMaxHealth` int(11) NOT NULL DEFAULT '0',
  `infoSpeed` int(11) NOT NULL DEFAULT '0',
  `infoGender` int(11) NOT NULL DEFAULT '0',
  `declinedGenitive` varchar(50) NOT NULL,
  `declinedNative` varchar(50) NOT NULL,
  `declinedAccusative` varchar(50) NOT NULL,
  `declinedInstrumental` varchar(50) NOT NULL,
  `declinedPrepositional` varchar(50) NOT NULL,
  PRIMARY KEY (`id`),
  KEY `account` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table auth.account_battlepet: ~0 rows (approximately)
DELETE FROM `account_battlepet`;
/*!40000 ALTER TABLE `account_battlepet` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_battlepet` ENABLE KEYS */;

-- Dumping structure for table auth.account_heirlooms
CREATE TABLE IF NOT EXISTS `account_heirlooms` (
  `account_id` int(10) unsigned NOT NULL DEFAULT '0',
  `heirloom_id` int(10) unsigned NOT NULL DEFAULT '0',
  `upgrade_flags` int(10) unsigned NOT NULL DEFAULT '0',
  `groupRealmMask` int(10) unsigned NOT NULL,
  PRIMARY KEY (`account_id`,`heirloom_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table auth.account_heirlooms: ~0 rows (approximately)
DELETE FROM `account_heirlooms`;
/*!40000 ALTER TABLE `account_heirlooms` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_heirlooms` ENABLE KEYS */;

-- Dumping structure for table auth.account_log_ip
CREATE TABLE IF NOT EXISTS `account_log_ip` (
  `accountid` int(11) unsigned NOT NULL,
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `ip` varchar(30) NOT NULL DEFAULT '0.0.0.0',
  `date` datetime DEFAULT NULL,
  `error` int(10) unsigned NOT NULL DEFAULT '0',
  `source` int(10) unsigned NOT NULL DEFAULT '2',
  PRIMARY KEY (`accountid`,`ip`,`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Dumping data for table auth.account_log_ip: 0 rows
DELETE FROM `account_log_ip`;
/*!40000 ALTER TABLE `account_log_ip` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_log_ip` ENABLE KEYS */;

-- Dumping structure for table auth.account_loyalty
CREATE TABLE IF NOT EXISTS `account_loyalty` (
  `AccountID` int(11) unsigned NOT NULL,
  `LastClaim` int(11) NOT NULL DEFAULT '0',
  `LastEventReset` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`AccountID`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table auth.account_loyalty: ~0 rows (approximately)
DELETE FROM `account_loyalty`;
/*!40000 ALTER TABLE `account_loyalty` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_loyalty` ENABLE KEYS */;

-- Dumping structure for table auth.account_loyalty_event
CREATE TABLE IF NOT EXISTS `account_loyalty_event` (
  `AccountID` int(11) unsigned NOT NULL,
  `Event` int(11) unsigned NOT NULL DEFAULT '0',
  `Count` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`AccountID`,`Event`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table auth.account_loyalty_event: ~0 rows (approximately)
DELETE FROM `account_loyalty_event`;
/*!40000 ALTER TABLE `account_loyalty_event` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_loyalty_event` ENABLE KEYS */;

-- Dumping structure for table auth.account_note
CREATE TABLE IF NOT EXISTS `account_note` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `account_id` int(10) unsigned DEFAULT NULL,
  `note` text,
  `date` int(11) DEFAULT NULL,
  `notedby` varchar(255) DEFAULT NULL,
  KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table auth.account_note: ~0 rows (approximately)
DELETE FROM `account_note`;
/*!40000 ALTER TABLE `account_note` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_note` ENABLE KEYS */;

-- Dumping structure for table auth.account_premium
CREATE TABLE IF NOT EXISTS `account_premium` (
  `id` int(11) NOT NULL DEFAULT '0' COMMENT 'Account id',
  `setdate` bigint(40) NOT NULL DEFAULT '0',
  `unsetdate` bigint(40) NOT NULL DEFAULT '0',
  `premium_type` tinyint(4) unsigned NOT NULL DEFAULT '1',
  `gm` varchar(12) NOT NULL DEFAULT '0',
  `active` tinyint(4) NOT NULL DEFAULT '1',
  PRIMARY KEY (`id`,`setdate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table auth.account_premium: ~0 rows (approximately)
DELETE FROM `account_premium`;
/*!40000 ALTER TABLE `account_premium` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_premium` ENABLE KEYS */;

-- Dumping structure for table auth.account_spell
CREATE TABLE IF NOT EXISTS `account_spell` (
  `accountId` int(11) NOT NULL,
  `spell` int(10) NOT NULL,
  `active` tinyint(1) DEFAULT NULL,
  `disabled` tinyint(1) DEFAULT NULL,
  `IsMountFavorite` tinyint(1) NOT NULL DEFAULT '0',
  `groupRealmMask` int(10) unsigned NOT NULL,
  PRIMARY KEY (`accountId`,`spell`),
  KEY `account` (`accountId`) USING HASH,
  KEY `account_spell` (`accountId`,`spell`) USING HASH
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table auth.account_spell: ~0 rows (approximately)
DELETE FROM `account_spell`;
/*!40000 ALTER TABLE `account_spell` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_spell` ENABLE KEYS */;

-- Dumping structure for table auth.account_toys
CREATE TABLE IF NOT EXISTS `account_toys` (
  `account_id` int(10) unsigned NOT NULL,
  `item_id` int(10) unsigned NOT NULL,
  `is_favorite` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`account_id`,`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table auth.account_toys: ~0 rows (approximately)
DELETE FROM `account_toys`;
/*!40000 ALTER TABLE `account_toys` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_toys` ENABLE KEYS */;

-- Dumping structure for table auth.account_vote
CREATE TABLE IF NOT EXISTS `account_vote` (
  `account` int(11) unsigned NOT NULL,
  `remainingTime` int(11) unsigned NOT NULL,
  PRIMARY KEY (`account`),
  UNIQUE KEY `account` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table auth.account_vote: ~0 rows (approximately)
DELETE FROM `account_vote`;
/*!40000 ALTER TABLE `account_vote` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_vote` ENABLE KEYS */;

-- Dumping structure for table auth.autobroadcast
CREATE TABLE IF NOT EXISTS `autobroadcast` (
  `Expension` int(11) DEFAULT NULL,
  `RealmID` int(11) DEFAULT NULL,
  `Text` blob,
  `TextFR` blob,
  `TextES` blob,
  `textRU` blob
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table auth.autobroadcast: ~0 rows (approximately)
DELETE FROM `autobroadcast`;
/*!40000 ALTER TABLE `autobroadcast` DISABLE KEYS */;
/*!40000 ALTER TABLE `autobroadcast` ENABLE KEYS */;

-- Dumping structure for table auth.battlenet_modules
CREATE TABLE IF NOT EXISTS `battlenet_modules` (
  `Hash` varchar(64) NOT NULL,
  `Name` varchar(64) NOT NULL DEFAULT '',
  `Type` varchar(8) NOT NULL,
  `System` varchar(8) NOT NULL,
  `Data` text,
  PRIMARY KEY (`Name`,`System`),
  UNIQUE KEY `uk_name_type_system` (`Name`,`Type`,`System`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table auth.battlenet_modules: ~0 rows (approximately)
DELETE FROM `battlenet_modules`;
/*!40000 ALTER TABLE `battlenet_modules` DISABLE KEYS */;
/*!40000 ALTER TABLE `battlenet_modules` ENABLE KEYS */;

-- Dumping structure for table auth.bnet_allowed_build
CREATE TABLE IF NOT EXISTS `bnet_allowed_build` (
  `build` int(11) DEFAULT NULL,
  `version` varchar(40) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table auth.bnet_allowed_build: ~2 rows (approximately)
DELETE FROM `bnet_allowed_build`;
/*!40000 ALTER TABLE `bnet_allowed_build` DISABLE KEYS */;
INSERT INTO `bnet_allowed_build` (`build`, `version`) VALUES
	(20779, '6.2.3.20779'),
	(20726, '6.2.3.20726');
/*!40000 ALTER TABLE `bnet_allowed_build` ENABLE KEYS */;

-- Dumping structure for table auth.character_renderer_queue
CREATE TABLE IF NOT EXISTS `character_renderer_queue` (
  `guid` int(11) DEFAULT NULL,
  `race` tinyint(3) DEFAULT NULL,
  `gender` tinyint(3) DEFAULT NULL,
  `class` tinyint(3) DEFAULT NULL,
  `skinColor` tinyint(3) DEFAULT NULL,
  `face` tinyint(3) DEFAULT NULL,
  `hairStyle` tinyint(3) DEFAULT NULL,
  `hairColor` tinyint(3) DEFAULT NULL,
  `facialHair` tinyint(3) DEFAULT NULL,
  `equipment` blob
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_bin;

-- Dumping data for table auth.character_renderer_queue: ~0 rows (approximately)
DELETE FROM `character_renderer_queue`;
/*!40000 ALTER TABLE `character_renderer_queue` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_renderer_queue` ENABLE KEYS */;

-- Dumping structure for table auth.firewall_farms
CREATE TABLE IF NOT EXISTS `firewall_farms` (
  `ip` tinytext NOT NULL,
  `type` tinyint(1) unsigned NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table auth.firewall_farms: ~0 rows (approximately)
DELETE FROM `firewall_farms`;
/*!40000 ALTER TABLE `firewall_farms` DISABLE KEYS */;
/*!40000 ALTER TABLE `firewall_farms` ENABLE KEYS */;

-- Dumping structure for table auth.ip_banned
CREATE TABLE IF NOT EXISTS `ip_banned` (
  `ip` varchar(15) NOT NULL DEFAULT '127.0.0.1',
  `bandate` int(10) unsigned NOT NULL,
  `unbandate` int(10) NOT NULL,
  `bannedby` varchar(50) NOT NULL DEFAULT '[Console]',
  `banreason` varchar(255) NOT NULL DEFAULT 'no reason',
  PRIMARY KEY (`ip`,`bandate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Banned IPs';

-- Dumping data for table auth.ip_banned: ~0 rows (approximately)
DELETE FROM `ip_banned`;
/*!40000 ALTER TABLE `ip_banned` DISABLE KEYS */;
/*!40000 ALTER TABLE `ip_banned` ENABLE KEYS */;

-- Dumping structure for table auth.ip_to_country
CREATE TABLE IF NOT EXISTS `ip_to_country` (
  `IP_FROM` bigint(20) unsigned NOT NULL,
  `IP_TO` bigint(20) unsigned NOT NULL,
  `REGISTRY` char(7) NOT NULL,
  `ASSIGNED` bigint(20) NOT NULL,
  `CTRY` char(2) NOT NULL,
  `CNTRY` char(3) NOT NULL,
  `COUNTRY` varchar(100) NOT NULL,
  PRIMARY KEY (`IP_FROM`,`IP_TO`),
  KEY `IP_FROM` (`IP_FROM`),
  KEY `IP_TO` (`IP_TO`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Dumping data for table auth.ip_to_country: 0 rows
DELETE FROM `ip_to_country`;
/*!40000 ALTER TABLE `ip_to_country` DISABLE KEYS */;
/*!40000 ALTER TABLE `ip_to_country` ENABLE KEYS */;

-- Dumping structure for table auth.logs
CREATE TABLE IF NOT EXISTS `logs` (
  `time` int(10) unsigned NOT NULL,
  `realm` int(10) unsigned NOT NULL,
  `type` tinyint(3) unsigned NOT NULL,
  `level` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `string` text CHARACTER SET latin1
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table auth.logs: ~0 rows (approximately)
DELETE FROM `logs`;
/*!40000 ALTER TABLE `logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `logs` ENABLE KEYS */;

-- Dumping structure for table auth.log_vote
CREATE TABLE IF NOT EXISTS `log_vote` (
  `top_name` varchar(15) NOT NULL DEFAULT 'top',
  `ip` varchar(15) NOT NULL DEFAULT '0.0.0.0',
  `date` int(11) NOT NULL,
  PRIMARY KEY (`top_name`,`ip`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table auth.log_vote: ~0 rows (approximately)
DELETE FROM `log_vote`;
/*!40000 ALTER TABLE `log_vote` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_vote` ENABLE KEYS */;

-- Dumping structure for table auth.motd
CREATE TABLE IF NOT EXISTS `motd` (
  `RealmID` int(10) unsigned NOT NULL,
  `Text` text NOT NULL,
  `TextFR` text NOT NULL,
  `TextES` text NOT NULL,
  `TextRU` text NOT NULL,
  PRIMARY KEY (`RealmID`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table auth.motd: ~1 rows (approximately)
DELETE FROM `motd`;
/*!40000 ALTER TABLE `motd` DISABLE KEYS */;
INSERT INTO `motd` (`RealmID`, `Text`, `TextFR`, `TextES`, `TextRU`) VALUES
	(1, 'Welcome to our QA realm. [Project-Draenor]', 'Welcome to our QA realm. [Project-Draenor]', 'Welcome to our QA realm. [Project-Draenor]', 'Welcome to our QA realm. [Project-Draenor]');
/*!40000 ALTER TABLE `motd` ENABLE KEYS */;

-- Dumping structure for table auth.realmcharacters
CREATE TABLE IF NOT EXISTS `realmcharacters` (
  `realmid` int(10) unsigned NOT NULL DEFAULT '0',
  `acctid` int(10) unsigned NOT NULL,
  `numchars` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`realmid`,`acctid`),
  KEY `acctid` (`acctid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Realm Character Tracker';

-- Dumping data for table auth.realmcharacters: ~0 rows (approximately)
DELETE FROM `realmcharacters`;
/*!40000 ALTER TABLE `realmcharacters` DISABLE KEYS */;
/*!40000 ALTER TABLE `realmcharacters` ENABLE KEYS */;

-- Dumping structure for table auth.realmlist
CREATE TABLE IF NOT EXISTS `realmlist` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `name` varchar(32) NOT NULL DEFAULT '',
  `address` varchar(255) NOT NULL DEFAULT '127.0.0.1',
  `port` smallint(5) unsigned NOT NULL DEFAULT '8085',
  `icon` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `flag` tinyint(3) unsigned NOT NULL DEFAULT '2',
  `timezone` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `allowedSecurityLevel` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `motd` varchar(255) NOT NULL DEFAULT 'Welcome on our server.',
  `population` float unsigned NOT NULL DEFAULT '0',
  `gamebuild` int(10) unsigned NOT NULL DEFAULT '20779' COMMENT '20779 build 6.2.3',
  `online` int(10) DEFAULT '0',
  `delay` int(10) unsigned NOT NULL DEFAULT '0',
  `queue` int(10) unsigned NOT NULL DEFAULT '0',
  `lastupdate` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `idx_name` (`name`)
) ENGINE=InnoDB AUTO_INCREMENT=2 DEFAULT CHARSET=utf8 COMMENT='Realm System';

-- Dumping data for table auth.realmlist: ~1 rows (approximately)
DELETE FROM `realmlist`;
/*!40000 ALTER TABLE `realmlist` DISABLE KEYS */;
INSERT INTO `realmlist` (`id`, `name`, `address`, `port`, `icon`, `flag`, `timezone`, `allowedSecurityLevel`, `motd`, `population`, `gamebuild`, `online`, `delay`, `queue`, `lastupdate`) VALUES
	(1, 'Kilrogg', '127.0.0.1', 8085, 0, 1, 1, 0, 'Harbringers WoD Project 6.2.3', 0, 20779, 0, 10, 0, 1632931914);
/*!40000 ALTER TABLE `realmlist` ENABLE KEYS */;

-- Dumping structure for table auth.stat_lifetime_retention
CREATE TABLE IF NOT EXISTS `stat_lifetime_retention` (
  `minutes` int(11) NOT NULL,
  `usersPercentage` float(11,8) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table auth.stat_lifetime_retention: ~0 rows (approximately)
DELETE FROM `stat_lifetime_retention`;
/*!40000 ALTER TABLE `stat_lifetime_retention` DISABLE KEYS */;
/*!40000 ALTER TABLE `stat_lifetime_retention` ENABLE KEYS */;

-- Dumping structure for table auth.transferts
CREATE TABLE IF NOT EXISTS `transferts` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account` int(11) NOT NULL,
  `perso_guid` int(11) NOT NULL,
  `from` int(11) NOT NULL,
  `to` int(11) NOT NULL,
  `revision` blob NOT NULL,
  `dump` longtext NOT NULL,
  `last_error` blob NOT NULL,
  `nb_attempt` int(11) NOT NULL,
  `state` int(10) NOT NULL DEFAULT '0',
  `error` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table auth.transferts: ~0 rows (approximately)
DELETE FROM `transferts`;
/*!40000 ALTER TABLE `transferts` DISABLE KEYS */;
/*!40000 ALTER TABLE `transferts` ENABLE KEYS */;

-- Dumping structure for table auth.transferts_logs
CREATE TABLE IF NOT EXISTS `transferts_logs` (
  `id` int(11) DEFAULT NULL,
  `account` int(11) DEFAULT NULL,
  `perso_guid` int(11) DEFAULT NULL,
  `from` int(2) DEFAULT NULL,
  `to` int(2) DEFAULT NULL,
  `dump` longtext
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table auth.transferts_logs: ~0 rows (approximately)
DELETE FROM `transferts_logs`;
/*!40000 ALTER TABLE `transferts_logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `transferts_logs` ENABLE KEYS */;

-- Dumping structure for table auth.uptime
CREATE TABLE IF NOT EXISTS `uptime` (
  `realmid` int(10) unsigned NOT NULL,
  `starttime` int(10) unsigned NOT NULL DEFAULT '0',
  `uptime` int(10) unsigned NOT NULL DEFAULT '0',
  `maxplayers` smallint(5) unsigned NOT NULL DEFAULT '0',
  `revision` varchar(255) NOT NULL DEFAULT 'Trinitycore',
  PRIMARY KEY (`realmid`,`starttime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Uptime system';

-- Dumping data for table auth.uptime: ~0 rows (approximately)
DELETE FROM `uptime`;
/*!40000 ALTER TABLE `uptime` DISABLE KEYS */;
/*!40000 ALTER TABLE `uptime` ENABLE KEYS */;

-- Dumping structure for table auth.user_reporting
CREATE TABLE IF NOT EXISTS `user_reporting` (
  `ga` int(10) unsigned NOT NULL,
  `account_id` int(10) unsigned NOT NULL,
  `creation_date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `step` int(10) NOT NULL DEFAULT '0',
  `referer` varchar(255) NOT NULL,
  `last_ip` varchar(255) NOT NULL,
  `has_view_creation` tinyint(3) unsigned DEFAULT '0',
  PRIMARY KEY (`ga`,`account_id`),
  KEY `ga_idx` (`ga`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table auth.user_reporting: ~0 rows (approximately)
DELETE FROM `user_reporting`;
/*!40000 ALTER TABLE `user_reporting` DISABLE KEYS */;
/*!40000 ALTER TABLE `user_reporting` ENABLE KEYS */;

-- Dumping structure for table auth.webshop_delivery_interexp_transfer
CREATE TABLE IF NOT EXISTS `webshop_delivery_interexp_transfer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account` int(11) NOT NULL,
  `guid` int(11) NOT NULL,
  `dump` longtext NOT NULL,
  `destrealm` int(11) NOT NULL,
  `state` int(11) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table auth.webshop_delivery_interexp_transfer: ~0 rows (approximately)
DELETE FROM `webshop_delivery_interexp_transfer`;
/*!40000 ALTER TABLE `webshop_delivery_interexp_transfer` DISABLE KEYS */;
/*!40000 ALTER TABLE `webshop_delivery_interexp_transfer` ENABLE KEYS */;

-- Dumping structure for table auth.webshop_delivery_interrealm_transfer
CREATE TABLE IF NOT EXISTS `webshop_delivery_interrealm_transfer` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `account` int(11) unsigned NOT NULL DEFAULT '0',
  `guid` int(11) unsigned NOT NULL DEFAULT '0',
  `startrealm` int(11) unsigned NOT NULL DEFAULT '0',
  `destrealm` int(11) unsigned NOT NULL DEFAULT '0',
  `revision` blob,
  `dump` longtext,
  `last_error` blob,
  `nb_attempt` int(11) unsigned NOT NULL DEFAULT '0',
  `state` int(10) unsigned NOT NULL DEFAULT '1',
  `error` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `account` (`account`),
  KEY `guid` (`guid`),
  KEY `startrealm` (`startrealm`),
  KEY `destrealm` (`destrealm`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table auth.webshop_delivery_interrealm_transfer: ~0 rows (approximately)
DELETE FROM `webshop_delivery_interrealm_transfer`;
/*!40000 ALTER TABLE `webshop_delivery_interrealm_transfer` DISABLE KEYS */;
/*!40000 ALTER TABLE `webshop_delivery_interrealm_transfer` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
