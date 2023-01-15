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


-- Dumping database structure for chars
CREATE DATABASE IF NOT EXISTS `chars` /*!40100 DEFAULT CHARACTER SET latin1 */;
USE `chars`;

-- Dumping structure for table chars.account_achievement
CREATE TABLE IF NOT EXISTS `account_achievement` (
  `account` int(10) unsigned NOT NULL,
  `first_guid` int(10) unsigned NOT NULL,
  `achievement` smallint(5) unsigned NOT NULL,
  `date` int(10) unsigned NOT NULL,
  PRIMARY KEY (`account`,`achievement`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.account_achievement: ~0 rows (approximately)
DELETE FROM `account_achievement`;
/*!40000 ALTER TABLE `account_achievement` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_achievement` ENABLE KEYS */;

-- Dumping structure for table chars.account_achievement_progress
CREATE TABLE IF NOT EXISTS `account_achievement_progress` (
  `account` int(10) unsigned NOT NULL,
  `criteria` smallint(5) unsigned NOT NULL,
  `counter` int(10) unsigned NOT NULL,
  `date` int(10) unsigned NOT NULL,
  PRIMARY KEY (`account`,`criteria`),
  KEY `Account` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.account_achievement_progress: ~0 rows (approximately)
DELETE FROM `account_achievement_progress`;
/*!40000 ALTER TABLE `account_achievement_progress` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_achievement_progress` ENABLE KEYS */;

-- Dumping structure for table chars.account_data
CREATE TABLE IF NOT EXISTS `account_data` (
  `accountId` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Account Identifier',
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `time` int(10) unsigned NOT NULL DEFAULT '0',
  `data` blob NOT NULL,
  PRIMARY KEY (`accountId`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.account_data: ~0 rows (approximately)
DELETE FROM `account_data`;
/*!40000 ALTER TABLE `account_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_data` ENABLE KEYS */;

-- Dumping structure for table chars.account_instance_times
CREATE TABLE IF NOT EXISTS `account_instance_times` (
  `accountId` int(10) unsigned NOT NULL,
  `instanceId` int(10) unsigned NOT NULL DEFAULT '0',
  `releaseTime` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`accountId`,`instanceId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.account_instance_times: ~0 rows (approximately)
DELETE FROM `account_instance_times`;
/*!40000 ALTER TABLE `account_instance_times` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_instance_times` ENABLE KEYS */;

-- Dumping structure for table chars.account_social
CREATE TABLE IF NOT EXISTS `account_social` (
  `account_id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Account Identifier',
  `friend` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Friend Global Unique Identifier',
  `flags` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Friend Flags',
  `note` varchar(48) NOT NULL DEFAULT '' COMMENT 'Friend Note',
  PRIMARY KEY (`account_id`,`friend`,`flags`),
  KEY `friend` (`friend`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Player System';

-- Dumping data for table chars.account_social: ~0 rows (approximately)
DELETE FROM `account_social`;
/*!40000 ALTER TABLE `account_social` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_social` ENABLE KEYS */;

-- Dumping structure for table chars.account_toys
CREATE TABLE IF NOT EXISTS `account_toys` (
  `account_id` int(10) unsigned NOT NULL,
  `item_id` int(10) unsigned NOT NULL,
  `is_favorite` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`account_id`,`item_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.account_toys: ~0 rows (approximately)
DELETE FROM `account_toys`;
/*!40000 ALTER TABLE `account_toys` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_toys` ENABLE KEYS */;

-- Dumping structure for table chars.account_tutorial
CREATE TABLE IF NOT EXISTS `account_tutorial` (
  `accountId` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Account Identifier',
  `tut0` int(10) unsigned NOT NULL DEFAULT '0',
  `tut1` int(10) unsigned NOT NULL DEFAULT '0',
  `tut2` int(10) unsigned NOT NULL DEFAULT '0',
  `tut3` int(10) unsigned NOT NULL DEFAULT '0',
  `tut4` int(10) unsigned NOT NULL DEFAULT '0',
  `tut5` int(10) unsigned NOT NULL DEFAULT '0',
  `tut6` int(10) unsigned NOT NULL DEFAULT '0',
  `tut7` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`accountId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.account_tutorial: ~0 rows (approximately)
DELETE FROM `account_tutorial`;
/*!40000 ALTER TABLE `account_tutorial` DISABLE KEYS */;
/*!40000 ALTER TABLE `account_tutorial` ENABLE KEYS */;

-- Dumping structure for table chars.addons
CREATE TABLE IF NOT EXISTS `addons` (
  `name` varchar(120) NOT NULL DEFAULT '',
  `crc` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Addons';

-- Dumping data for table chars.addons: ~0 rows (approximately)
DELETE FROM `addons`;
/*!40000 ALTER TABLE `addons` DISABLE KEYS */;
/*!40000 ALTER TABLE `addons` ENABLE KEYS */;

-- Dumping structure for table chars.arena_team
CREATE TABLE IF NOT EXISTS `arena_team` (
  `arenaTeamId` int(10) unsigned NOT NULL DEFAULT '0',
  `name` varchar(24) NOT NULL,
  `captainGuid` int(10) unsigned NOT NULL DEFAULT '0',
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `rating` smallint(5) unsigned NOT NULL DEFAULT '0',
  `seasonGames` smallint(5) unsigned NOT NULL DEFAULT '0',
  `seasonWins` smallint(5) unsigned NOT NULL DEFAULT '0',
  `weekGames` smallint(5) unsigned NOT NULL DEFAULT '0',
  `weekWins` smallint(5) unsigned NOT NULL DEFAULT '0',
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  `backgroundColor` int(10) unsigned NOT NULL DEFAULT '0',
  `emblemStyle` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `emblemColor` int(10) unsigned NOT NULL DEFAULT '0',
  `borderStyle` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `borderColor` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`arenaTeamId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.arena_team: ~0 rows (approximately)
DELETE FROM `arena_team`;
/*!40000 ALTER TABLE `arena_team` DISABLE KEYS */;
/*!40000 ALTER TABLE `arena_team` ENABLE KEYS */;

-- Dumping structure for table chars.arena_team_member
CREATE TABLE IF NOT EXISTS `arena_team_member` (
  `arenaTeamId` int(10) unsigned NOT NULL DEFAULT '0',
  `guid` int(10) unsigned NOT NULL DEFAULT '0',
  `weekGames` smallint(5) unsigned NOT NULL DEFAULT '0',
  `weekWins` smallint(5) unsigned NOT NULL DEFAULT '0',
  `seasonGames` smallint(5) unsigned NOT NULL DEFAULT '0',
  `seasonWins` smallint(5) unsigned NOT NULL DEFAULT '0',
  `personalRating` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`arenaTeamId`,`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.arena_team_member: ~0 rows (approximately)
DELETE FROM `arena_team_member`;
/*!40000 ALTER TABLE `arena_team_member` DISABLE KEYS */;
/*!40000 ALTER TABLE `arena_team_member` ENABLE KEYS */;

-- Dumping structure for table chars.auctionhouse
CREATE TABLE IF NOT EXISTS `auctionhouse` (
  `id` int(10) unsigned NOT NULL DEFAULT '0',
  `auctioneerguid` int(10) unsigned NOT NULL DEFAULT '0',
  `itemguid` int(10) unsigned NOT NULL DEFAULT '0',
  `itemowner` int(10) unsigned NOT NULL DEFAULT '0',
  `buyoutprice` bigint(20) unsigned NOT NULL DEFAULT '0',
  `time` int(10) unsigned NOT NULL DEFAULT '0',
  `buyguid` int(10) unsigned NOT NULL DEFAULT '0',
  `lastbid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `startbid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `deposit` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  UNIQUE KEY `item_guid` (`itemguid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.auctionhouse: ~0 rows (approximately)
DELETE FROM `auctionhouse`;
/*!40000 ALTER TABLE `auctionhouse` DISABLE KEYS */;
/*!40000 ALTER TABLE `auctionhouse` ENABLE KEYS */;

-- Dumping structure for table chars.autobroadcast
CREATE TABLE IF NOT EXISTS `autobroadcast` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `text` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Dumping data for table chars.autobroadcast: 0 rows
DELETE FROM `autobroadcast`;
/*!40000 ALTER TABLE `autobroadcast` DISABLE KEYS */;
/*!40000 ALTER TABLE `autobroadcast` ENABLE KEYS */;

-- Dumping structure for table chars.blackmarket
CREATE TABLE IF NOT EXISTS `blackmarket` (
  `id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Identifier',
  `templateId` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Reference to world.blackmarket_template',
  `startTime` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Start time of the bid',
  `bid` bigint(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Amount of the actual bid',
  `bidder` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Player guid (highest bid)',
  `bidderCount` int(10) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.blackmarket: ~0 rows (approximately)
DELETE FROM `blackmarket`;
/*!40000 ALTER TABLE `blackmarket` DISABLE KEYS */;
/*!40000 ALTER TABLE `blackmarket` ENABLE KEYS */;

-- Dumping structure for table chars.bugreport
CREATE TABLE IF NOT EXISTS `bugreport` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT COMMENT 'Identifier',
  `type` longtext NOT NULL,
  `content` longtext NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Debug System';

-- Dumping data for table chars.bugreport: ~0 rows (approximately)
DELETE FROM `bugreport`;
/*!40000 ALTER TABLE `bugreport` DISABLE KEYS */;
/*!40000 ALTER TABLE `bugreport` ENABLE KEYS */;

-- Dumping structure for table chars.calendar_events
CREATE TABLE IF NOT EXISTS `calendar_events` (
  `id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `creator` int(10) unsigned NOT NULL DEFAULT '0',
  `title` varchar(255) NOT NULL DEFAULT '',
  `description` varchar(255) NOT NULL DEFAULT '',
  `type` tinyint(1) unsigned NOT NULL DEFAULT '4',
  `dungeon` int(10) NOT NULL DEFAULT '-1',
  `eventtime` int(10) unsigned NOT NULL DEFAULT '0',
  `flags` int(10) unsigned NOT NULL DEFAULT '0',
  `time2` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.calendar_events: ~0 rows (approximately)
DELETE FROM `calendar_events`;
/*!40000 ALTER TABLE `calendar_events` DISABLE KEYS */;
/*!40000 ALTER TABLE `calendar_events` ENABLE KEYS */;

-- Dumping structure for table chars.calendar_invites
CREATE TABLE IF NOT EXISTS `calendar_invites` (
  `id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `event` bigint(20) unsigned NOT NULL DEFAULT '0',
  `invitee` int(10) unsigned NOT NULL DEFAULT '0',
  `sender` int(10) unsigned NOT NULL DEFAULT '0',
  `status` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `statustime` int(10) unsigned NOT NULL DEFAULT '0',
  `rank` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `text` varchar(255) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.calendar_invites: ~0 rows (approximately)
DELETE FROM `calendar_invites`;
/*!40000 ALTER TABLE `calendar_invites` DISABLE KEYS */;
/*!40000 ALTER TABLE `calendar_invites` ENABLE KEYS */;

-- Dumping structure for table chars.channels
CREATE TABLE IF NOT EXISTS `channels` (
  `name` varchar(128) NOT NULL,
  `team` int(10) unsigned NOT NULL,
  `announce` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `ownership` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `password` varchar(32) DEFAULT NULL,
  `bannedList` text,
  `lastUsed` int(10) unsigned NOT NULL,
  PRIMARY KEY (`name`,`team`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Channel System';

-- Dumping data for table chars.channels: ~0 rows (approximately)
DELETE FROM `channels`;
/*!40000 ALTER TABLE `channels` DISABLE KEYS */;
/*!40000 ALTER TABLE `channels` ENABLE KEYS */;

-- Dumping structure for table chars.characters
CREATE TABLE IF NOT EXISTS `characters` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier',
  `account` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Account Identifier',
  `name` varchar(12) NOT NULL DEFAULT '',
  `slot` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `race` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `class` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `gender` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `level` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `xp` int(10) unsigned NOT NULL DEFAULT '0',
  `money` bigint(20) unsigned NOT NULL DEFAULT '0',
  `playerBytes` int(10) unsigned NOT NULL DEFAULT '0',
  `playerBytes2` int(10) unsigned NOT NULL DEFAULT '0',
  `playerFlags` int(10) unsigned NOT NULL DEFAULT '0',
  `playerFlagsEx` int(10) unsigned NOT NULL DEFAULT '0',
  `position_x` float NOT NULL DEFAULT '0',
  `position_y` float NOT NULL DEFAULT '0',
  `position_z` float NOT NULL DEFAULT '0',
  `map` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'Map Identifier',
  `instance_id` int(10) unsigned NOT NULL DEFAULT '0',
  `DungeonDifficulty` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `orientation` float NOT NULL DEFAULT '0',
  `taximask` text NOT NULL,
  `online` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `cinematic` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `totaltime` int(10) unsigned NOT NULL DEFAULT '0',
  `leveltime` int(10) unsigned NOT NULL DEFAULT '0',
  `logout_time` int(10) NOT NULL DEFAULT '0',
  `is_logout_resting` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `rest_bonus` float NOT NULL DEFAULT '0',
  `resettalents_cost` int(10) unsigned NOT NULL DEFAULT '0',
  `resettalents_time` int(10) unsigned NOT NULL DEFAULT '0',
  `resetspecialization_cost` int(10) NOT NULL DEFAULT '0',
  `resetspecialization_time` int(10) NOT NULL DEFAULT '0',
  `talentTree` varchar(10) NOT NULL DEFAULT '0 0',
  `trans_x` float NOT NULL DEFAULT '0',
  `trans_y` float NOT NULL DEFAULT '0',
  `trans_z` float NOT NULL DEFAULT '0',
  `trans_o` float NOT NULL DEFAULT '0',
  `transguid` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `extra_flags` smallint(5) unsigned NOT NULL DEFAULT '0',
  `stable_slots` tinyint(3) unsigned DEFAULT NULL,
  `at_login` smallint(5) unsigned NOT NULL DEFAULT '0',
  `zone` smallint(5) unsigned NOT NULL DEFAULT '0',
  `death_expire_time` int(10) unsigned NOT NULL DEFAULT '0',
  `taxi_path` text,
  `totalKills` int(10) unsigned NOT NULL DEFAULT '0',
  `todayKills` smallint(5) unsigned NOT NULL DEFAULT '0',
  `yesterdayKills` smallint(5) unsigned NOT NULL DEFAULT '0',
  `chosenTitle` int(10) unsigned NOT NULL DEFAULT '0',
  `watchedFaction` int(10) unsigned NOT NULL DEFAULT '0',
  `drunk` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `health` int(10) unsigned NOT NULL DEFAULT '0',
  `power1` int(10) unsigned NOT NULL DEFAULT '0',
  `power2` int(10) unsigned NOT NULL DEFAULT '0',
  `power3` int(10) unsigned NOT NULL DEFAULT '0',
  `power4` int(10) unsigned NOT NULL DEFAULT '0',
  `power5` int(10) unsigned NOT NULL DEFAULT '0',
  `power6` int(10) unsigned NOT NULL DEFAULT '0',
  `latency` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `speccount` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `activespec` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `specialization1` int(11) NOT NULL,
  `specialization2` int(11) NOT NULL,
  `exploredZones` longtext,
  `equipmentCache` longtext,
  `knownTitles` longtext,
  `actionBars` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `currentpetslot` tinyint(3) unsigned DEFAULT NULL,
  `petslotused` int(10) unsigned DEFAULT '0',
  `grantableLevels` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `guildId` int(10) unsigned NOT NULL DEFAULT '0',
  `deleteInfos_Account` int(10) unsigned DEFAULT NULL,
  `deleteInfos_Name` varchar(12) DEFAULT NULL,
  `deleteDate` int(10) unsigned DEFAULT NULL,
  `RaidDifficulty` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `LegacyRaidDifficuly` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `xprate` float unsigned NOT NULL DEFAULT '1',
  `lastbattlepet` int(10) unsigned NOT NULL DEFAULT '0',
  `ilvl` int(10) unsigned NOT NULL DEFAULT '0',
  `end_sales` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`),
  KEY `idx_account` (`account`),
  KEY `idx_online` (`online`),
  KEY `idx_name` (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Player System';

-- Dumping data for table chars.characters: ~0 rows (approximately)
DELETE FROM `characters`;
/*!40000 ALTER TABLE `characters` DISABLE KEYS */;
/*!40000 ALTER TABLE `characters` ENABLE KEYS */;

-- Dumping structure for table chars.characters_boss_looted
CREATE TABLE IF NOT EXISTS `characters_boss_looted` (
  `guid` int(10) unsigned NOT NULL,
  `boss_entry` int(10) unsigned NOT NULL,
  `boss_model_id` int(10) unsigned NOT NULL,
  PRIMARY KEY (`guid`,`boss_entry`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.characters_boss_looted: ~0 rows (approximately)
DELETE FROM `characters_boss_looted`;
/*!40000 ALTER TABLE `characters_boss_looted` DISABLE KEYS */;
/*!40000 ALTER TABLE `characters_boss_looted` ENABLE KEYS */;

-- Dumping structure for table chars.character_account_data
CREATE TABLE IF NOT EXISTS `character_account_data` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0',
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `time` int(10) unsigned NOT NULL DEFAULT '0',
  `data` blob NOT NULL,
  PRIMARY KEY (`guid`,`type`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.character_account_data: ~0 rows (approximately)
DELETE FROM `character_account_data`;
/*!40000 ALTER TABLE `character_account_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_account_data` ENABLE KEYS */;

-- Dumping structure for table chars.character_achievement
CREATE TABLE IF NOT EXISTS `character_achievement` (
  `guid` int(10) unsigned NOT NULL,
  `achievement` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`guid`,`achievement`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.character_achievement: ~0 rows (approximately)
DELETE FROM `character_achievement`;
/*!40000 ALTER TABLE `character_achievement` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_achievement` ENABLE KEYS */;

-- Dumping structure for table chars.character_achievement_count
CREATE TABLE IF NOT EXISTS `character_achievement_count` (
  `guid` bigint(11) NOT NULL DEFAULT '0',
  `count` int(11) DEFAULT '0',
  PRIMARY KEY (`guid`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Dumping data for table chars.character_achievement_count: 0 rows
DELETE FROM `character_achievement_count`;
/*!40000 ALTER TABLE `character_achievement_count` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_achievement_count` ENABLE KEYS */;

-- Dumping structure for table chars.character_achievement_progress
CREATE TABLE IF NOT EXISTS `character_achievement_progress` (
  `guid` int(10) unsigned NOT NULL,
  `criteria` smallint(5) unsigned NOT NULL,
  `counter` int(10) unsigned NOT NULL,
  `date` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`,`criteria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.character_achievement_progress: ~0 rows (approximately)
DELETE FROM `character_achievement_progress`;
/*!40000 ALTER TABLE `character_achievement_progress` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_achievement_progress` ENABLE KEYS */;

-- Dumping structure for table chars.character_action
CREATE TABLE IF NOT EXISTS `character_action` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0',
  `spec` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `button` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `action` int(10) unsigned NOT NULL DEFAULT '0',
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`,`spec`,`button`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.character_action: ~0 rows (approximately)
DELETE FROM `character_action`;
/*!40000 ALTER TABLE `character_action` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_action` ENABLE KEYS */;

-- Dumping structure for table chars.character_archaeology
CREATE TABLE IF NOT EXISTS `character_archaeology` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0',
  `counts` text,
  `projects` text,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.character_archaeology: ~0 rows (approximately)
DELETE FROM `character_archaeology`;
/*!40000 ALTER TABLE `character_archaeology` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_archaeology` ENABLE KEYS */;

-- Dumping structure for table chars.character_archaeology_projects
CREATE TABLE IF NOT EXISTS `character_archaeology_projects` (
  `guid` int(10) unsigned NOT NULL,
  `project` int(8) unsigned NOT NULL,
  `count` int(8) unsigned NOT NULL,
  `first_date` int(8) unsigned NOT NULL,
  PRIMARY KEY (`guid`,`project`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.character_archaeology_projects: ~0 rows (approximately)
DELETE FROM `character_archaeology_projects`;
/*!40000 ALTER TABLE `character_archaeology_projects` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_archaeology_projects` ENABLE KEYS */;

-- Dumping structure for table chars.character_archaeology_sites
CREATE TABLE IF NOT EXISTS `character_archaeology_sites` (
  `guid` int(11) unsigned NOT NULL,
  `map` int(11) unsigned NOT NULL,
  `sites` text NOT NULL,
  PRIMARY KEY (`guid`,`map`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.character_archaeology_sites: ~0 rows (approximately)
DELETE FROM `character_archaeology_sites`;
/*!40000 ALTER TABLE `character_archaeology_sites` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_archaeology_sites` ENABLE KEYS */;

-- Dumping structure for table chars.character_arena_data
CREATE TABLE IF NOT EXISTS `character_arena_data` (
  `guid` int(11) NOT NULL,
  `rating0` int(10) DEFAULT '0',
  `bestRatingOfWeek0` int(10) unsigned NOT NULL DEFAULT '0',
  `bestRatingOfSeason0` int(10) unsigned NOT NULL DEFAULT '0',
  `matchMakerRating0` int(10) DEFAULT '0',
  `weekGames0` int(10) DEFAULT '0',
  `weekWins0` int(10) DEFAULT '0',
  `prevWeekWins0` int(10) unsigned NOT NULL DEFAULT '0',
  `prevWeekGames0` int(10) unsigned NOT NULL DEFAULT '0',
  `seasonGames0` int(10) DEFAULT '0',
  `seasonWins0` int(10) DEFAULT '0',
  `rating1` int(10) DEFAULT '0',
  `bestRatingOfWeek1` int(10) unsigned NOT NULL DEFAULT '0',
  `bestRatingOfSeason1` int(10) unsigned NOT NULL DEFAULT '0',
  `matchMakerRating1` int(10) DEFAULT '0',
  `weekGames1` int(10) DEFAULT '0',
  `weekWins1` int(10) DEFAULT '0',
  `prevWeekWins1` int(10) unsigned NOT NULL DEFAULT '0',
  `prevWeekGames1` int(10) unsigned NOT NULL DEFAULT '0',
  `seasonGames1` int(10) DEFAULT '0',
  `seasonWins1` int(10) DEFAULT '0',
  `rating2` int(10) DEFAULT '0',
  `bestRatingOfWeek2` int(10) unsigned NOT NULL DEFAULT '0',
  `bestRatingOfSeason2` int(10) unsigned NOT NULL DEFAULT '0',
  `matchMakerRating2` int(10) DEFAULT '0',
  `weekGames2` int(10) DEFAULT '0',
  `weekWins2` int(10) DEFAULT '0',
  `prevWeekWins2` int(10) unsigned NOT NULL DEFAULT '0',
  `prevWeekGames2` int(10) unsigned NOT NULL DEFAULT '0',
  `seasonGames2` int(10) DEFAULT '0',
  `seasonWins2` int(10) DEFAULT '0',
  `rating3` int(10) unsigned NOT NULL DEFAULT '0',
  `bestRatingOfWeek3` int(10) unsigned NOT NULL DEFAULT '0',
  `bestRatingOfSeason3` int(10) unsigned NOT NULL DEFAULT '0',
  `matchMakerRating3` int(10) NOT NULL DEFAULT '1500',
  `weekGames3` int(10) unsigned NOT NULL DEFAULT '0',
  `weekWins3` int(10) unsigned NOT NULL DEFAULT '0',
  `prevWeekWins3` int(10) unsigned NOT NULL DEFAULT '0',
  `prevWeekGames3` int(10) unsigned NOT NULL DEFAULT '0',
  `seasonGames3` int(10) unsigned NOT NULL DEFAULT '0',
  `seasonWins3` int(10) unsigned NOT NULL DEFAULT '0',
  `rating4` int(10) unsigned DEFAULT '0',
  `bestRatingOfWeek4` int(10) unsigned NOT NULL DEFAULT '0',
  `bestRatingOfSeason4` int(10) unsigned NOT NULL DEFAULT '0',
  `matchMakerRating4` int(10) DEFAULT '0',
  `weekGames4` int(10) unsigned DEFAULT '0',
  `weekWins4` int(10) unsigned DEFAULT '0',
  `prevWeekWins4` int(10) unsigned NOT NULL DEFAULT '0',
  `prevWeekGames4` int(10) unsigned NOT NULL DEFAULT '0',
  `seasonGames4` int(10) unsigned DEFAULT '0',
  `seasonWins4` int(10) unsigned DEFAULT '0',
  `rating5` int(10) unsigned DEFAULT '0',
  `bestRatingOfWeek5` int(10) unsigned NOT NULL DEFAULT '0',
  `bestRatingOfSeason5` int(10) unsigned NOT NULL DEFAULT '0',
  `matchMakerRating5` int(10) DEFAULT '0',
  `weekGames5` int(10) unsigned DEFAULT '0',
  `weekWins5` int(10) unsigned DEFAULT '0',
  `prevWeekWins5` int(10) unsigned NOT NULL DEFAULT '0',
  `prevWeekGames5` int(10) unsigned NOT NULL DEFAULT '0',
  `seasonGames5` int(10) unsigned DEFAULT '0',
  `seasonWins5` int(10) unsigned DEFAULT '0',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.character_arena_data: ~0 rows (approximately)
DELETE FROM `character_arena_data`;
/*!40000 ALTER TABLE `character_arena_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_arena_data` ENABLE KEYS */;

-- Dumping structure for table chars.character_arena_stats
CREATE TABLE IF NOT EXISTS `character_arena_stats` (
  `guid` int(10) NOT NULL,
  `slot` tinyint(3) NOT NULL,
  `matchMakerRating` smallint(5) NOT NULL,
  PRIMARY KEY (`guid`,`slot`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.character_arena_stats: ~0 rows (approximately)
DELETE FROM `character_arena_stats`;
/*!40000 ALTER TABLE `character_arena_stats` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_arena_stats` ENABLE KEYS */;

-- Dumping structure for table chars.character_aura
CREATE TABLE IF NOT EXISTS `character_aura` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier',
  `slot` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `caster_guid` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'Full Global Unique Identifier',
  `item_guid` bigint(20) unsigned NOT NULL DEFAULT '0',
  `spell` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `effect_mask` int(11) unsigned NOT NULL DEFAULT '0',
  `recalculate_mask` int(11) unsigned NOT NULL DEFAULT '0',
  `stackcount` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `maxduration` int(11) NOT NULL DEFAULT '0',
  `remaintime` int(11) NOT NULL DEFAULT '0',
  `remaincharges` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `castItemLevel` int(11) NOT NULL DEFAULT '-1',
  PRIMARY KEY (`guid`,`caster_guid`,`item_guid`,`spell`,`effect_mask`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Player System';

-- Dumping data for table chars.character_aura: ~0 rows (approximately)
DELETE FROM `character_aura`;
/*!40000 ALTER TABLE `character_aura` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_aura` ENABLE KEYS */;

-- Dumping structure for table chars.character_aura_effect
CREATE TABLE IF NOT EXISTS `character_aura_effect` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0',
  `slot` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `effect` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `baseamount` int(11) NOT NULL DEFAULT '0',
  `amount` int(11) NOT NULL,
  `data` blob,
  PRIMARY KEY (`guid`,`slot`,`effect`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.character_aura_effect: ~0 rows (approximately)
DELETE FROM `character_aura_effect`;
/*!40000 ALTER TABLE `character_aura_effect` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_aura_effect` ENABLE KEYS */;

-- Dumping structure for table chars.character_banned
CREATE TABLE IF NOT EXISTS `character_banned` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier',
  `bandate` int(10) unsigned NOT NULL DEFAULT '0',
  `unbandate` int(10) unsigned NOT NULL DEFAULT '0',
  `bannedby` varchar(50) NOT NULL,
  `banreason` varchar(255) NOT NULL,
  `active` tinyint(3) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`guid`,`bandate`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Ban List';

-- Dumping data for table chars.character_banned: ~0 rows (approximately)
DELETE FROM `character_banned`;
/*!40000 ALTER TABLE `character_banned` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_banned` ENABLE KEYS */;

-- Dumping structure for table chars.character_battleground_data
CREATE TABLE IF NOT EXISTS `character_battleground_data` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier',
  `instanceId` int(10) unsigned NOT NULL COMMENT 'Instance Identifier',
  `team` smallint(5) unsigned NOT NULL,
  `joinX` float NOT NULL DEFAULT '0',
  `joinY` float NOT NULL DEFAULT '0',
  `joinZ` float NOT NULL DEFAULT '0',
  `joinO` float NOT NULL DEFAULT '0',
  `joinMapId` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'Map Identifier',
  `taxiStart` int(10) unsigned NOT NULL DEFAULT '0',
  `taxiEnd` int(10) unsigned NOT NULL DEFAULT '0',
  `mountSpell` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `lastActiveSpec` smallint(6) DEFAULT NULL,
  `bgTypeId` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Player System';

-- Dumping data for table chars.character_battleground_data: ~0 rows (approximately)
DELETE FROM `character_battleground_data`;
/*!40000 ALTER TABLE `character_battleground_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_battleground_data` ENABLE KEYS */;

-- Dumping structure for table chars.character_battleground_random
CREATE TABLE IF NOT EXISTS `character_battleground_random` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.character_battleground_random: ~0 rows (approximately)
DELETE FROM `character_battleground_random`;
/*!40000 ALTER TABLE `character_battleground_random` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_battleground_random` ENABLE KEYS */;

-- Dumping structure for table chars.character_completed_challenges
CREATE TABLE IF NOT EXISTS `character_completed_challenges` (
  `guid` int(10) unsigned NOT NULL,
  `map_id` int(10) unsigned NOT NULL DEFAULT '0',
  `best_time` int(10) unsigned NOT NULL DEFAULT '0',
  `last_time` int(10) unsigned NOT NULL DEFAULT '0',
  `best_medal` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `best_medal_date` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`,`map_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.character_completed_challenges: ~0 rows (approximately)
DELETE FROM `character_completed_challenges`;
/*!40000 ALTER TABLE `character_completed_challenges` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_completed_challenges` ENABLE KEYS */;

-- Dumping structure for table chars.character_cuf_profiles
CREATE TABLE IF NOT EXISTS `character_cuf_profiles` (
  `guid` int(10) unsigned NOT NULL COMMENT 'Character Guid',
  `id` tinyint(3) unsigned NOT NULL COMMENT 'Profile Id (0-4)',
  `Name` varchar(50) NOT NULL COMMENT 'Profile Name',
  `FrameHeight` smallint(5) unsigned NOT NULL DEFAULT '0',
  `FrameWidth` smallint(5) unsigned NOT NULL DEFAULT '0',
  `SortBy` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `HealthText` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `KeepGroupsTogether` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `DisplayPets` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `DisplayMainTankAndAssist` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `DisplayHealPrediction` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `DisplayAggroHighlight` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `DisplayOnlyDispellableDebuffs` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `DisplayPowerBar` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `DisplayBorder` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `UseClassColors` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `HorizontalGroups` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `DisplayNonBossDebuffs` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `DynamicPosition` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `TopPoint` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `BottomPoint` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `LeftPoint` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `TopOffset` smallint(5) unsigned NOT NULL DEFAULT '0',
  `BottomOffset` smallint(5) unsigned NOT NULL DEFAULT '0',
  `LeftOffset` smallint(5) unsigned NOT NULL DEFAULT '0',
  `Locked` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `Shown` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `AutoActivate2Players` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `AutoActivate3Players` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `AutoActivate5Players` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `AutoActivate10Players` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `AutoActivate15Players` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `AutoActivate25Players` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `AutoActivate40Players` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `AutoActivateSpec1` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `AutoActivateSpec2` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `AutoActivatePvP` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `AutoActivatePvE` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`,`id`),
  KEY `index` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.character_cuf_profiles: ~0 rows (approximately)
DELETE FROM `character_cuf_profiles`;
/*!40000 ALTER TABLE `character_cuf_profiles` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_cuf_profiles` ENABLE KEYS */;

-- Dumping structure for table chars.character_currency
CREATE TABLE IF NOT EXISTS `character_currency` (
  `guid` int(11) unsigned NOT NULL,
  `currency` smallint(5) unsigned NOT NULL,
  `total_count` int(11) unsigned NOT NULL,
  `week_count` int(11) unsigned NOT NULL,
  `season_total` int(11) DEFAULT '0',
  `flags` int(10) unsigned DEFAULT NULL,
  `weekCap` int(10) unsigned NOT NULL DEFAULT '0',
  `needResetCap` tinyint(1) unsigned NOT NULL DEFAULT '1',
  PRIMARY KEY (`guid`,`currency`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.character_currency: ~0 rows (approximately)
DELETE FROM `character_currency`;
/*!40000 ALTER TABLE `character_currency` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_currency` ENABLE KEYS */;

-- Dumping structure for table chars.character_daily_loot_cooldown
CREATE TABLE IF NOT EXISTS `character_daily_loot_cooldown` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0',
  `entry` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`,`entry`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.character_daily_loot_cooldown: ~0 rows (approximately)
DELETE FROM `character_daily_loot_cooldown`;
/*!40000 ALTER TABLE `character_daily_loot_cooldown` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_daily_loot_cooldown` ENABLE KEYS */;

-- Dumping structure for table chars.character_declinedname
CREATE TABLE IF NOT EXISTS `character_declinedname` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier',
  `genitive` varchar(15) NOT NULL DEFAULT '',
  `dative` varchar(15) NOT NULL DEFAULT '',
  `accusative` varchar(15) NOT NULL DEFAULT '',
  `instrumental` varchar(15) NOT NULL DEFAULT '',
  `prepositional` varchar(15) NOT NULL DEFAULT '',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.character_declinedname: ~0 rows (approximately)
DELETE FROM `character_declinedname`;
/*!40000 ALTER TABLE `character_declinedname` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_declinedname` ENABLE KEYS */;

-- Dumping structure for table chars.character_dynamic_difficulty_maps
CREATE TABLE IF NOT EXISTS `character_dynamic_difficulty_maps` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Player GUID',
  `mapId` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'Map Id',
  PRIMARY KEY (`guid`,`mapId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.character_dynamic_difficulty_maps: ~0 rows (approximately)
DELETE FROM `character_dynamic_difficulty_maps`;
/*!40000 ALTER TABLE `character_dynamic_difficulty_maps` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_dynamic_difficulty_maps` ENABLE KEYS */;

-- Dumping structure for table chars.character_equipmentsets
CREATE TABLE IF NOT EXISTS `character_equipmentsets` (
  `guid` int(10) NOT NULL DEFAULT '0',
  `setguid` bigint(20) NOT NULL AUTO_INCREMENT,
  `setindex` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `name` varchar(31) NOT NULL,
  `iconname` varchar(100) NOT NULL,
  `ignore_mask` int(11) unsigned NOT NULL DEFAULT '0',
  `item0` int(11) unsigned NOT NULL DEFAULT '0',
  `item1` int(11) unsigned NOT NULL DEFAULT '0',
  `item2` int(11) unsigned NOT NULL DEFAULT '0',
  `item3` int(11) unsigned NOT NULL DEFAULT '0',
  `item4` int(11) unsigned NOT NULL DEFAULT '0',
  `item5` int(11) unsigned NOT NULL DEFAULT '0',
  `item6` int(11) unsigned NOT NULL DEFAULT '0',
  `item7` int(11) unsigned NOT NULL DEFAULT '0',
  `item8` int(11) unsigned NOT NULL DEFAULT '0',
  `item9` int(11) unsigned NOT NULL DEFAULT '0',
  `item10` int(11) unsigned NOT NULL DEFAULT '0',
  `item11` int(11) unsigned NOT NULL DEFAULT '0',
  `item12` int(11) unsigned NOT NULL DEFAULT '0',
  `item13` int(11) unsigned NOT NULL DEFAULT '0',
  `item14` int(11) unsigned NOT NULL DEFAULT '0',
  `item15` int(11) unsigned NOT NULL DEFAULT '0',
  `item16` int(11) unsigned NOT NULL DEFAULT '0',
  `item17` int(11) unsigned NOT NULL DEFAULT '0',
  `item18` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`setguid`),
  UNIQUE KEY `idx_set` (`guid`,`setguid`,`setindex`),
  KEY `Idx_setindex` (`setindex`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.character_equipmentsets: ~0 rows (approximately)
DELETE FROM `character_equipmentsets`;
/*!40000 ALTER TABLE `character_equipmentsets` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_equipmentsets` ENABLE KEYS */;

-- Dumping structure for table chars.character_garrison
CREATE TABLE IF NOT EXISTS `character_garrison` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `character_guid` int(10) unsigned NOT NULL,
  `level` int(10) NOT NULL DEFAULT '1',
  `blue_recipes` text NOT NULL,
  `specializations` text NOT NULL,
  `num_follower_activation` int(10) unsigned NOT NULL DEFAULT '1',
  `num_follower_activation_regen_timestamp` int(10) unsigned NOT NULL DEFAULT '0',
  `cache_last_usage` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `character_guid` (`character_guid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.character_garrison: ~0 rows (approximately)
DELETE FROM `character_garrison`;
/*!40000 ALTER TABLE `character_garrison` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_garrison` ENABLE KEYS */;

-- Dumping structure for table chars.character_garrison_building
CREATE TABLE IF NOT EXISTS `character_garrison_building` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `garrison_id` int(10) unsigned NOT NULL,
  `plot_instance_id` int(10) unsigned NOT NULL,
  `building_id` int(10) unsigned NOT NULL,
  `spec_id` int(10) unsigned NOT NULL DEFAULT '0',
  `time_built_start` int(10) unsigned NOT NULL DEFAULT '0',
  `time_built_end` int(10) unsigned NOT NULL DEFAULT '0',
  `follower_assigned` int(10) unsigned DEFAULT '0',
  `active` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `gathering_data` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `garrison_id` (`garrison_id`),
  KEY `id_garrison_id` (`id`,`garrison_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.character_garrison_building: ~0 rows (approximately)
DELETE FROM `character_garrison_building`;
/*!40000 ALTER TABLE `character_garrison_building` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_garrison_building` ENABLE KEYS */;

-- Dumping structure for table chars.character_garrison_daily_tavern_data
CREATE TABLE IF NOT EXISTS `character_garrison_daily_tavern_data` (
  `CharacterGuid` int(10) unsigned NOT NULL DEFAULT '0',
  `NpcEntry` int(8) NOT NULL,
  PRIMARY KEY (`CharacterGuid`,`NpcEntry`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Dumping data for table chars.character_garrison_daily_tavern_data: 0 rows
DELETE FROM `character_garrison_daily_tavern_data`;
/*!40000 ALTER TABLE `character_garrison_daily_tavern_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_garrison_daily_tavern_data` ENABLE KEYS */;

-- Dumping structure for table chars.character_garrison_follower
CREATE TABLE IF NOT EXISTS `character_garrison_follower` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `garrison_id` int(10) unsigned NOT NULL DEFAULT '0',
  `follower_id` int(10) unsigned NOT NULL DEFAULT '0',
  `level` int(10) unsigned NOT NULL DEFAULT '0',
  `xp` int(10) unsigned NOT NULL DEFAULT '0',
  `quality` int(10) unsigned NOT NULL DEFAULT '0',
  `item_level_armor` int(10) unsigned NOT NULL DEFAULT '0',
  `item_level_weapon` int(10) unsigned NOT NULL DEFAULT '0',
  `current_mission_id` int(10) unsigned NOT NULL DEFAULT '0',
  `current_building_id` int(10) unsigned NOT NULL DEFAULT '0',
  `abilities` text NOT NULL,
  `flags` int(10) unsigned NOT NULL DEFAULT '0',
  `ship_name` text NOT NULL,
  PRIMARY KEY (`id`),
  KEY `garrison_id_id` (`id`,`garrison_id`),
  KEY `garrison_id` (`garrison_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.character_garrison_follower: ~0 rows (approximately)
DELETE FROM `character_garrison_follower`;
/*!40000 ALTER TABLE `character_garrison_follower` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_garrison_follower` ENABLE KEYS */;

-- Dumping structure for table chars.character_garrison_mission
CREATE TABLE IF NOT EXISTS `character_garrison_mission` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `garrison_id` int(10) unsigned NOT NULL DEFAULT '0',
  `mission_id` int(10) unsigned NOT NULL DEFAULT '0',
  `offer_time` int(10) unsigned NOT NULL DEFAULT '0',
  `offer_max_duration` int(10) unsigned NOT NULL DEFAULT '0',
  `start_time` int(10) unsigned NOT NULL DEFAULT '0',
  `state` int(10) unsigned NOT NULL DEFAULT '10',
  PRIMARY KEY (`id`),
  KEY `garrison_id` (`garrison_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.character_garrison_mission: ~0 rows (approximately)
DELETE FROM `character_garrison_mission`;
/*!40000 ALTER TABLE `character_garrison_mission` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_garrison_mission` ENABLE KEYS */;

-- Dumping structure for table chars.character_garrison_weekly_tavern_data
CREATE TABLE IF NOT EXISTS `character_garrison_weekly_tavern_data` (
  `CharacterGUID` int(10) DEFAULT NULL,
  `FollowerID` int(10) DEFAULT NULL,
  `Abilities` blob
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.character_garrison_weekly_tavern_data: ~0 rows (approximately)
DELETE FROM `character_garrison_weekly_tavern_data`;
/*!40000 ALTER TABLE `character_garrison_weekly_tavern_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_garrison_weekly_tavern_data` ENABLE KEYS */;

-- Dumping structure for table chars.character_garrison_work_order
CREATE TABLE IF NOT EXISTS `character_garrison_work_order` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `garrison_id` int(10) unsigned NOT NULL,
  `plot_instance_id` int(10) unsigned NOT NULL,
  `shipment_id` int(10) unsigned NOT NULL,
  `creation_time` int(10) unsigned NOT NULL,
  `complete_time` int(10) unsigned NOT NULL,
  PRIMARY KEY (`id`),
  KEY `garrison_id` (`garrison_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.character_garrison_work_order: ~0 rows (approximately)
DELETE FROM `character_garrison_work_order`;
/*!40000 ALTER TABLE `character_garrison_work_order` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_garrison_work_order` ENABLE KEYS */;

-- Dumping structure for table chars.character_gifts
CREATE TABLE IF NOT EXISTS `character_gifts` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0',
  `item_guid` int(10) unsigned NOT NULL DEFAULT '0',
  `entry` int(10) unsigned NOT NULL DEFAULT '0',
  `flags` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`item_guid`),
  KEY `idx_guid` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.character_gifts: ~0 rows (approximately)
DELETE FROM `character_gifts`;
/*!40000 ALTER TABLE `character_gifts` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_gifts` ENABLE KEYS */;

-- Dumping structure for table chars.character_glyphs
CREATE TABLE IF NOT EXISTS `character_glyphs` (
  `guid` int(10) unsigned NOT NULL,
  `spec` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `glyph1` smallint(5) unsigned NOT NULL DEFAULT '0',
  `glyph2` smallint(5) unsigned DEFAULT '0',
  `glyph3` smallint(5) unsigned DEFAULT '0',
  `glyph4` smallint(5) unsigned DEFAULT '0',
  `glyph5` smallint(5) unsigned DEFAULT '0',
  `glyph6` smallint(5) unsigned DEFAULT '0',
  PRIMARY KEY (`guid`,`spec`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.character_glyphs: ~0 rows (approximately)
DELETE FROM `character_glyphs`;
/*!40000 ALTER TABLE `character_glyphs` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_glyphs` ENABLE KEYS */;

-- Dumping structure for table chars.character_homebind
CREATE TABLE IF NOT EXISTS `character_homebind` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier',
  `mapId` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'Map Identifier',
  `zoneId` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'Zone Identifier',
  `posX` float NOT NULL DEFAULT '0',
  `posY` float NOT NULL DEFAULT '0',
  `posZ` float NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Player System';

-- Dumping data for table chars.character_homebind: ~0 rows (approximately)
DELETE FROM `character_homebind`;
/*!40000 ALTER TABLE `character_homebind` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_homebind` ENABLE KEYS */;

-- Dumping structure for table chars.character_instance
CREATE TABLE IF NOT EXISTS `character_instance` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0',
  `instance` int(10) unsigned NOT NULL DEFAULT '0',
  `permanent` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`,`instance`),
  KEY `instance` (`instance`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.character_instance: ~0 rows (approximately)
DELETE FROM `character_instance`;
/*!40000 ALTER TABLE `character_instance` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_instance` ENABLE KEYS */;

-- Dumping structure for table chars.character_inventory
CREATE TABLE IF NOT EXISTS `character_inventory` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier',
  `bag` int(10) unsigned NOT NULL DEFAULT '0',
  `slot` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `item` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Item Global Unique Identifier',
  PRIMARY KEY (`item`),
  UNIQUE KEY `guid` (`guid`,`bag`,`slot`),
  KEY `idx_guid` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Player System';

-- Dumping data for table chars.character_inventory: ~0 rows (approximately)
DELETE FROM `character_inventory`;
/*!40000 ALTER TABLE `character_inventory` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_inventory` ENABLE KEYS */;

-- Dumping structure for table chars.character_lf_guild_params
CREATE TABLE IF NOT EXISTS `character_lf_guild_params` (
  `guid` int(10) unsigned NOT NULL,
  `guild_interests` smallint(5) unsigned DEFAULT NULL,
  `availability` smallint(5) unsigned DEFAULT NULL,
  `class_roles` smallint(5) unsigned DEFAULT NULL,
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.character_lf_guild_params: ~0 rows (approximately)
DELETE FROM `character_lf_guild_params`;
/*!40000 ALTER TABLE `character_lf_guild_params` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_lf_guild_params` ENABLE KEYS */;

-- Dumping structure for table chars.character_pet
CREATE TABLE IF NOT EXISTS `character_pet` (
  `id` int(10) unsigned NOT NULL DEFAULT '0',
  `entry` int(10) unsigned NOT NULL DEFAULT '0',
  `owner` int(10) unsigned NOT NULL DEFAULT '0',
  `modelid` int(10) unsigned DEFAULT '0',
  `CreatedBySpell` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `PetType` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `level` smallint(5) unsigned NOT NULL DEFAULT '1',
  `exp` int(10) unsigned NOT NULL DEFAULT '0',
  `Reactstate` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `name` varchar(21) NOT NULL DEFAULT 'Pet',
  `renamed` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `slot` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `curhealth` int(10) unsigned NOT NULL DEFAULT '1',
  `curmana` int(10) unsigned NOT NULL DEFAULT '0',
  `savetime` int(10) unsigned NOT NULL DEFAULT '0',
  `abdata` text,
  `specialization` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `owner` (`owner`),
  KEY `idx_slot` (`slot`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Pet System';

-- Dumping data for table chars.character_pet: ~0 rows (approximately)
DELETE FROM `character_pet`;
/*!40000 ALTER TABLE `character_pet` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_pet` ENABLE KEYS */;

-- Dumping structure for table chars.character_pet_declinedname
CREATE TABLE IF NOT EXISTS `character_pet_declinedname` (
  `id` int(10) unsigned NOT NULL DEFAULT '0',
  `owner` int(10) unsigned NOT NULL DEFAULT '0',
  `genitive` varchar(12) NOT NULL DEFAULT '',
  `dative` varchar(12) NOT NULL DEFAULT '',
  `accusative` varchar(12) NOT NULL DEFAULT '',
  `instrumental` varchar(12) NOT NULL DEFAULT '',
  `prepositional` varchar(12) NOT NULL DEFAULT '',
  PRIMARY KEY (`id`),
  KEY `owner_key` (`owner`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.character_pet_declinedname: ~0 rows (approximately)
DELETE FROM `character_pet_declinedname`;
/*!40000 ALTER TABLE `character_pet_declinedname` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_pet_declinedname` ENABLE KEYS */;

-- Dumping structure for table chars.character_queststatus
CREATE TABLE IF NOT EXISTS `character_queststatus` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier',
  `quest` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Quest Identifier',
  `status` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `explored` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `timer` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`,`quest`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Player System';

-- Dumping data for table chars.character_queststatus: ~0 rows (approximately)
DELETE FROM `character_queststatus`;
/*!40000 ALTER TABLE `character_queststatus` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_queststatus` ENABLE KEYS */;

-- Dumping structure for table chars.character_queststatus_daily
CREATE TABLE IF NOT EXISTS `character_queststatus_daily` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier',
  `quest` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Quest Identifier',
  `time` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`,`quest`),
  KEY `idx_guid` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Player System';

-- Dumping data for table chars.character_queststatus_daily: ~0 rows (approximately)
DELETE FROM `character_queststatus_daily`;
/*!40000 ALTER TABLE `character_queststatus_daily` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_queststatus_daily` ENABLE KEYS */;

-- Dumping structure for table chars.character_queststatus_monthly
CREATE TABLE IF NOT EXISTS `character_queststatus_monthly` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier',
  `quest` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Quest Identifier',
  PRIMARY KEY (`guid`,`quest`),
  KEY `idx_guid` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Player System';

-- Dumping data for table chars.character_queststatus_monthly: ~0 rows (approximately)
DELETE FROM `character_queststatus_monthly`;
/*!40000 ALTER TABLE `character_queststatus_monthly` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_queststatus_monthly` ENABLE KEYS */;

-- Dumping structure for table chars.character_queststatus_objective
CREATE TABLE IF NOT EXISTS `character_queststatus_objective` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0',
  `objectiveId` int(10) unsigned NOT NULL DEFAULT '0',
  `amount` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`objectiveId`,`guid`),
  KEY `guid` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.character_queststatus_objective: ~0 rows (approximately)
DELETE FROM `character_queststatus_objective`;
/*!40000 ALTER TABLE `character_queststatus_objective` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_queststatus_objective` ENABLE KEYS */;

-- Dumping structure for table chars.character_queststatus_rewarded
CREATE TABLE IF NOT EXISTS `character_queststatus_rewarded` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier',
  `quest` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Quest Identifier',
  PRIMARY KEY (`guid`,`quest`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Player System';

-- Dumping data for table chars.character_queststatus_rewarded: ~0 rows (approximately)
DELETE FROM `character_queststatus_rewarded`;
/*!40000 ALTER TABLE `character_queststatus_rewarded` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_queststatus_rewarded` ENABLE KEYS */;

-- Dumping structure for table chars.character_queststatus_seasonal
CREATE TABLE IF NOT EXISTS `character_queststatus_seasonal` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier',
  `quest` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Quest Identifier',
  `event` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Event Identifier',
  PRIMARY KEY (`guid`,`quest`),
  KEY `idx_guid` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Player System';

-- Dumping data for table chars.character_queststatus_seasonal: ~0 rows (approximately)
DELETE FROM `character_queststatus_seasonal`;
/*!40000 ALTER TABLE `character_queststatus_seasonal` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_queststatus_seasonal` ENABLE KEYS */;

-- Dumping structure for table chars.character_queststatus_weekly
CREATE TABLE IF NOT EXISTS `character_queststatus_weekly` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier',
  `quest` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Quest Identifier',
  PRIMARY KEY (`guid`,`quest`),
  KEY `idx_guid` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Player System';

-- Dumping data for table chars.character_queststatus_weekly: ~0 rows (approximately)
DELETE FROM `character_queststatus_weekly`;
/*!40000 ALTER TABLE `character_queststatus_weekly` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_queststatus_weekly` ENABLE KEYS */;

-- Dumping structure for table chars.character_rates
CREATE TABLE IF NOT EXISTS `character_rates` (
  `guid` bigint(20) NOT NULL DEFAULT '0',
  `rate` tinyint(2) DEFAULT '0',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.character_rates: ~0 rows (approximately)
DELETE FROM `character_rates`;
/*!40000 ALTER TABLE `character_rates` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_rates` ENABLE KEYS */;

-- Dumping structure for table chars.character_reputation
CREATE TABLE IF NOT EXISTS `character_reputation` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier',
  `faction` smallint(5) unsigned NOT NULL DEFAULT '0',
  `standing` int(11) NOT NULL DEFAULT '0',
  `flags` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`,`faction`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Player System';

-- Dumping data for table chars.character_reputation: ~0 rows (approximately)
DELETE FROM `character_reputation`;
/*!40000 ALTER TABLE `character_reputation` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_reputation` ENABLE KEYS */;

-- Dumping structure for table chars.character_skills
CREATE TABLE IF NOT EXISTS `character_skills` (
  `guid` int(10) unsigned NOT NULL COMMENT 'Global Unique Identifier',
  `skill` smallint(5) unsigned NOT NULL,
  `value` smallint(5) unsigned NOT NULL,
  `max` smallint(5) unsigned NOT NULL,
  PRIMARY KEY (`guid`,`skill`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Player System';

-- Dumping data for table chars.character_skills: ~0 rows (approximately)
DELETE FROM `character_skills`;
/*!40000 ALTER TABLE `character_skills` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_skills` ENABLE KEYS */;

-- Dumping structure for table chars.character_spell
CREATE TABLE IF NOT EXISTS `character_spell` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier',
  `spell` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'Spell Identifier',
  `active` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `disabled` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `IsMountFavorite` tinyint(1) NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`,`spell`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Player System';

-- Dumping data for table chars.character_spell: ~0 rows (approximately)
DELETE FROM `character_spell`;
/*!40000 ALTER TABLE `character_spell` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_spell` ENABLE KEYS */;

-- Dumping structure for table chars.character_spell_charges
CREATE TABLE IF NOT EXISTS `character_spell_charges` (
  `guid` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier, Low part',
  `categoryId` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'SpellCategory.dbc Identifier',
  `rechargeStart` int(10) unsigned NOT NULL DEFAULT '0',
  `rechargeEnd` int(10) unsigned NOT NULL DEFAULT '0',
  KEY `idx_guid` (`guid`) USING BTREE
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.character_spell_charges: ~0 rows (approximately)
DELETE FROM `character_spell_charges`;
/*!40000 ALTER TABLE `character_spell_charges` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_spell_charges` ENABLE KEYS */;

-- Dumping structure for table chars.character_spell_cooldown
CREATE TABLE IF NOT EXISTS `character_spell_cooldown` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier, Low part',
  `spell` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'Spell Identifier',
  `item` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Item Identifier',
  `time` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`,`spell`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.character_spell_cooldown: ~0 rows (approximately)
DELETE FROM `character_spell_cooldown`;
/*!40000 ALTER TABLE `character_spell_cooldown` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_spell_cooldown` ENABLE KEYS */;

-- Dumping structure for table chars.character_stats
CREATE TABLE IF NOT EXISTS `character_stats` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier, Low part',
  `maxhealth` int(10) unsigned NOT NULL DEFAULT '0',
  `maxpower1` int(10) unsigned NOT NULL DEFAULT '0',
  `maxpower2` int(10) unsigned NOT NULL DEFAULT '0',
  `maxpower3` int(10) unsigned NOT NULL DEFAULT '0',
  `maxpower4` int(10) unsigned NOT NULL DEFAULT '0',
  `maxpower5` int(10) unsigned NOT NULL DEFAULT '0',
  `maxpower6` int(10) unsigned NOT NULL DEFAULT '0',
  `strength` int(10) unsigned NOT NULL DEFAULT '0',
  `agility` int(10) unsigned NOT NULL DEFAULT '0',
  `stamina` int(10) unsigned NOT NULL DEFAULT '0',
  `intellect` int(10) unsigned NOT NULL DEFAULT '0',
  `spirit` int(10) unsigned NOT NULL DEFAULT '0',
  `armor` int(10) unsigned NOT NULL DEFAULT '0',
  `resHoly` int(10) unsigned NOT NULL DEFAULT '0',
  `resFire` int(10) unsigned NOT NULL DEFAULT '0',
  `resNature` int(10) unsigned NOT NULL DEFAULT '0',
  `resFrost` int(10) unsigned NOT NULL DEFAULT '0',
  `resShadow` int(10) unsigned NOT NULL DEFAULT '0',
  `resArcane` int(10) unsigned NOT NULL DEFAULT '0',
  `blockPct` float unsigned NOT NULL DEFAULT '0',
  `dodgePct` float unsigned NOT NULL DEFAULT '0',
  `parryPct` float unsigned NOT NULL DEFAULT '0',
  `critPct` float unsigned NOT NULL DEFAULT '0',
  `rangedCritPct` float unsigned NOT NULL DEFAULT '0',
  `spellCritPct` float unsigned NOT NULL DEFAULT '0',
  `attackPower` int(10) unsigned NOT NULL DEFAULT '0',
  `rangedAttackPower` int(10) unsigned NOT NULL DEFAULT '0',
  `spellPower` int(10) unsigned NOT NULL DEFAULT '0',
  `resilience` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.character_stats: ~0 rows (approximately)
DELETE FROM `character_stats`;
/*!40000 ALTER TABLE `character_stats` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_stats` ENABLE KEYS */;

-- Dumping structure for table chars.character_stats_wod
CREATE TABLE IF NOT EXISTS `character_stats_wod` (
  `guid` int(11) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier, Low part',
  `strength` int(10) unsigned NOT NULL DEFAULT '0',
  `agility` int(10) unsigned NOT NULL DEFAULT '0',
  `stamina` int(10) unsigned NOT NULL DEFAULT '0',
  `intellect` int(10) unsigned NOT NULL DEFAULT '0',
  `critPct` float unsigned NOT NULL DEFAULT '0',
  `haste` float unsigned NOT NULL DEFAULT '0',
  `mastery` float unsigned NOT NULL DEFAULT '0',
  `spirit` int(10) unsigned NOT NULL DEFAULT '0',
  `armorBonus` int(10) unsigned NOT NULL DEFAULT '0',
  `multistrike` float unsigned NOT NULL DEFAULT '0',
  `leech` float unsigned NOT NULL DEFAULT '0',
  `versatility` float unsigned NOT NULL DEFAULT '0',
  `avoidance` float unsigned NOT NULL DEFAULT '0',
  `attackDamage` varchar(255) NOT NULL,
  `attackPower` int(10) unsigned NOT NULL DEFAULT '0',
  `attackSpeed` float unsigned NOT NULL DEFAULT '0',
  `spellPower` int(10) unsigned NOT NULL DEFAULT '0',
  `manaRegen` int(10) unsigned NOT NULL DEFAULT '0',
  `armor` int(10) unsigned NOT NULL DEFAULT '0',
  `dodgePct` float unsigned NOT NULL DEFAULT '0',
  `parryPct` float unsigned NOT NULL DEFAULT '0',
  `blockPct` float unsigned NOT NULL DEFAULT '0',
  `ilvl` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.character_stats_wod: ~0 rows (approximately)
DELETE FROM `character_stats_wod`;
/*!40000 ALTER TABLE `character_stats_wod` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_stats_wod` ENABLE KEYS */;

-- Dumping structure for table chars.character_talent
CREATE TABLE IF NOT EXISTS `character_talent` (
  `guid` int(10) unsigned NOT NULL,
  `spell` mediumint(8) unsigned NOT NULL,
  `spec` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`,`spell`,`spec`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.character_talent: ~0 rows (approximately)
DELETE FROM `character_talent`;
/*!40000 ALTER TABLE `character_talent` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_talent` ENABLE KEYS */;

-- Dumping structure for table chars.character_template
CREATE TABLE IF NOT EXISTS `character_template` (
  `id` int(10) unsigned NOT NULL DEFAULT '1',
  `class` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `name` varchar(256) NOT NULL,
  `description` varchar(2048) NOT NULL,
  `level` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `money` bigint(20) unsigned NOT NULL DEFAULT '0',
  `alianceX` float DEFAULT '0',
  `alianceY` float NOT NULL DEFAULT '0',
  `alianceZ` float NOT NULL DEFAULT '0',
  `alianceO` float NOT NULL DEFAULT '0',
  `alianceMap` smallint(6) NOT NULL DEFAULT '0',
  `hordeX` float NOT NULL DEFAULT '0',
  `hordeY` float NOT NULL DEFAULT '0',
  `hordeZ` float NOT NULL DEFAULT '0',
  `hordeO` float NOT NULL DEFAULT '0',
  `hordeMap` smallint(6) NOT NULL DEFAULT '0',
  `disabled` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `allianceDefaultRace` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `hordeDefaultRace` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.character_template: ~0 rows (approximately)
DELETE FROM `character_template`;
/*!40000 ALTER TABLE `character_template` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_template` ENABLE KEYS */;

-- Dumping structure for table chars.character_void_storage
CREATE TABLE IF NOT EXISTS `character_void_storage` (
  `itemId` bigint(20) unsigned NOT NULL,
  `playerGuid` int(10) unsigned NOT NULL,
  `itemEntry` mediumint(8) unsigned NOT NULL,
  `slot` tinyint(3) unsigned NOT NULL,
  `creatorGuid` int(10) unsigned NOT NULL DEFAULT '0',
  `randomProperty` int(10) unsigned NOT NULL DEFAULT '0',
  `suffixFactor` int(10) unsigned NOT NULL DEFAULT '0',
  `bonuses` text NOT NULL,
  PRIMARY KEY (`itemId`),
  UNIQUE KEY `idx_player_slot` (`playerGuid`,`slot`),
  KEY `idx_player` (`playerGuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.character_void_storage: ~0 rows (approximately)
DELETE FROM `character_void_storage`;
/*!40000 ALTER TABLE `character_void_storage` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_void_storage` ENABLE KEYS */;

-- Dumping structure for table chars.character_weekly_boss_kills
CREATE TABLE IF NOT EXISTS `character_weekly_boss_kills` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Player GUID',
  `entry` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'Boss Entry',
  `mapId` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'Map Id',
  `difficulty` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'Difficulty',
  `looted` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Boss looted',
  PRIMARY KEY (`guid`,`entry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Loot-based Lockout System';

-- Dumping data for table chars.character_weekly_boss_kills: ~0 rows (approximately)
DELETE FROM `character_weekly_boss_kills`;
/*!40000 ALTER TABLE `character_weekly_boss_kills` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_weekly_boss_kills` ENABLE KEYS */;

-- Dumping structure for table chars.character_worldstates
CREATE TABLE IF NOT EXISTS `character_worldstates` (
  `guid` int(10) unsigned NOT NULL,
  `worldstate` int(10) unsigned NOT NULL,
  `value` bigint(20) unsigned NOT NULL,
  PRIMARY KEY (`guid`,`worldstate`),
  UNIQUE KEY `unique` (`guid`,`worldstate`),
  KEY `guid` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.character_worldstates: ~0 rows (approximately)
DELETE FROM `character_worldstates`;
/*!40000 ALTER TABLE `character_worldstates` DISABLE KEYS */;
/*!40000 ALTER TABLE `character_worldstates` ENABLE KEYS */;

-- Dumping structure for table chars.corpse
CREATE TABLE IF NOT EXISTS `corpse` (
  `corpseGuid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier',
  `guid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Character Global Unique Identifier',
  `posX` float NOT NULL DEFAULT '0',
  `posY` float NOT NULL DEFAULT '0',
  `posZ` float NOT NULL DEFAULT '0',
  `orientation` float NOT NULL DEFAULT '0',
  `mapId` smallint(5) unsigned NOT NULL DEFAULT '0' COMMENT 'Map Identifier',
  `phaseMask` smallint(5) unsigned NOT NULL DEFAULT '1',
  `displayId` int(10) unsigned NOT NULL DEFAULT '0',
  `itemCache` text NOT NULL,
  `bytes1` int(10) unsigned NOT NULL DEFAULT '0',
  `bytes2` int(10) unsigned NOT NULL DEFAULT '0',
  `flags` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `dynFlags` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `time` int(10) unsigned NOT NULL DEFAULT '0',
  `corpseType` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `instanceId` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Instance Identifier',
  PRIMARY KEY (`corpseGuid`),
  KEY `idx_type` (`corpseType`),
  KEY `idx_instance` (`instanceId`),
  KEY `idx_player` (`guid`),
  KEY `idx_time` (`time`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Death System';

-- Dumping data for table chars.corpse: ~0 rows (approximately)
DELETE FROM `corpse`;
/*!40000 ALTER TABLE `corpse` DISABLE KEYS */;
/*!40000 ALTER TABLE `corpse` ENABLE KEYS */;

-- Dumping structure for table chars.creature_respawn
CREATE TABLE IF NOT EXISTS `creature_respawn` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier',
  `respawnTime` int(10) unsigned NOT NULL DEFAULT '0',
  `mapId` smallint(10) unsigned NOT NULL DEFAULT '0',
  `instanceId` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Instance Identifier',
  PRIMARY KEY (`guid`,`instanceId`),
  KEY `idx_instance` (`instanceId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Grid Loading System';

-- Dumping data for table chars.creature_respawn: ~0 rows (approximately)
DELETE FROM `creature_respawn`;
/*!40000 ALTER TABLE `creature_respawn` DISABLE KEYS */;
/*!40000 ALTER TABLE `creature_respawn` ENABLE KEYS */;

-- Dumping structure for table chars.cuf_profile
CREATE TABLE IF NOT EXISTS `cuf_profile` (
  `guid` int(10) unsigned NOT NULL,
  `name` varchar(128) NOT NULL,
  `data` tinyblob,
  PRIMARY KEY (`guid`,`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.cuf_profile: ~0 rows (approximately)
DELETE FROM `cuf_profile`;
/*!40000 ALTER TABLE `cuf_profile` DISABLE KEYS */;
/*!40000 ALTER TABLE `cuf_profile` ENABLE KEYS */;

-- Dumping structure for table chars.daily_players_reports
CREATE TABLE IF NOT EXISTS `daily_players_reports` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0',
  `creation_time` int(10) unsigned NOT NULL DEFAULT '0',
  `average` float NOT NULL DEFAULT '0',
  `total_reports` bigint(20) unsigned NOT NULL DEFAULT '0',
  `speed_reports` bigint(20) unsigned NOT NULL DEFAULT '0',
  `fly_reports` bigint(20) unsigned NOT NULL DEFAULT '0',
  `jump_reports` bigint(20) unsigned NOT NULL DEFAULT '0',
  `waterwalk_reports` bigint(20) unsigned NOT NULL DEFAULT '0',
  `teleportplane_reports` bigint(20) unsigned NOT NULL DEFAULT '0',
  `climb_reports` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.daily_players_reports: ~0 rows (approximately)
DELETE FROM `daily_players_reports`;
/*!40000 ALTER TABLE `daily_players_reports` DISABLE KEYS */;
/*!40000 ALTER TABLE `daily_players_reports` ENABLE KEYS */;

-- Dumping structure for table chars.encounter_damage_log
CREATE TABLE IF NOT EXISTS `encounter_damage_log` (
  `encounterId` int(11) unsigned NOT NULL,
  `encounterStartTime` bigint(20) unsigned NOT NULL,
  `logTime` bigint(20) unsigned NOT NULL,
  `attackerGuid` int(11) unsigned NOT NULL,
  `damage` int(11) unsigned NOT NULL,
  `spellId` int(11) unsigned NOT NULL,
  KEY `encounterId` (`encounterId`,`encounterStartTime`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.encounter_damage_log: ~0 rows (approximately)
DELETE FROM `encounter_damage_log`;
/*!40000 ALTER TABLE `encounter_damage_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `encounter_damage_log` ENABLE KEYS */;

-- Dumping structure for table chars.encounter_group_dump
CREATE TABLE IF NOT EXISTS `encounter_group_dump` (
  `encounterId` int(11) unsigned NOT NULL,
  `encounterStartTime` bigint(20) unsigned NOT NULL,
  `dumpTime` bigint(20) unsigned NOT NULL,
  `dump` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.encounter_group_dump: ~0 rows (approximately)
DELETE FROM `encounter_group_dump`;
/*!40000 ALTER TABLE `encounter_group_dump` DISABLE KEYS */;
/*!40000 ALTER TABLE `encounter_group_dump` ENABLE KEYS */;

-- Dumping structure for table chars.gameobject_respawn
CREATE TABLE IF NOT EXISTS `gameobject_respawn` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier',
  `respawnTime` int(10) unsigned NOT NULL DEFAULT '0',
  `mapId` smallint(10) unsigned NOT NULL DEFAULT '0',
  `instanceId` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Instance Identifier',
  PRIMARY KEY (`guid`,`instanceId`),
  KEY `idx_instance` (`instanceId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Grid Loading System';

-- Dumping data for table chars.gameobject_respawn: ~0 rows (approximately)
DELETE FROM `gameobject_respawn`;
/*!40000 ALTER TABLE `gameobject_respawn` DISABLE KEYS */;
/*!40000 ALTER TABLE `gameobject_respawn` ENABLE KEYS */;

-- Dumping structure for table chars.game_event_condition_save
CREATE TABLE IF NOT EXISTS `game_event_condition_save` (
  `eventEntry` tinyint(3) unsigned NOT NULL,
  `condition_id` int(10) unsigned NOT NULL DEFAULT '0',
  `done` float DEFAULT '0',
  PRIMARY KEY (`eventEntry`,`condition_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.game_event_condition_save: ~0 rows (approximately)
DELETE FROM `game_event_condition_save`;
/*!40000 ALTER TABLE `game_event_condition_save` DISABLE KEYS */;
/*!40000 ALTER TABLE `game_event_condition_save` ENABLE KEYS */;

-- Dumping structure for table chars.game_event_save
CREATE TABLE IF NOT EXISTS `game_event_save` (
  `eventEntry` tinyint(3) unsigned NOT NULL,
  `state` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `next_start` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`eventEntry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.game_event_save: ~0 rows (approximately)
DELETE FROM `game_event_save`;
/*!40000 ALTER TABLE `game_event_save` DISABLE KEYS */;
/*!40000 ALTER TABLE `game_event_save` ENABLE KEYS */;

-- Dumping structure for table chars.gm_subsurveys
CREATE TABLE IF NOT EXISTS `gm_subsurveys` (
  `surveyId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `subsurveyId` int(10) unsigned NOT NULL DEFAULT '0',
  `rank` int(10) unsigned NOT NULL DEFAULT '0',
  `comment` text NOT NULL,
  PRIMARY KEY (`surveyId`,`subsurveyId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Player System';

-- Dumping data for table chars.gm_subsurveys: ~0 rows (approximately)
DELETE FROM `gm_subsurveys`;
/*!40000 ALTER TABLE `gm_subsurveys` DISABLE KEYS */;
/*!40000 ALTER TABLE `gm_subsurveys` ENABLE KEYS */;

-- Dumping structure for table chars.gm_surveys
CREATE TABLE IF NOT EXISTS `gm_surveys` (
  `surveyId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `guid` int(10) unsigned NOT NULL DEFAULT '0',
  `mainSurvey` int(10) unsigned NOT NULL DEFAULT '0',
  `overallComment` longtext NOT NULL,
  `createTime` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`surveyId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Player System';

-- Dumping data for table chars.gm_surveys: ~0 rows (approximately)
DELETE FROM `gm_surveys`;
/*!40000 ALTER TABLE `gm_surveys` DISABLE KEYS */;
/*!40000 ALTER TABLE `gm_surveys` ENABLE KEYS */;

-- Dumping structure for table chars.gm_tickets
CREATE TABLE IF NOT EXISTS `gm_tickets` (
  `ticketId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `guid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier of ticket creator',
  `name` varchar(12) NOT NULL COMMENT 'Name of ticket creator',
  `message` text NOT NULL,
  `createTime` int(10) unsigned NOT NULL DEFAULT '0',
  `mapId` int(10) unsigned NOT NULL DEFAULT '0',
  `posX` float NOT NULL DEFAULT '0',
  `posY` float NOT NULL DEFAULT '0',
  `posZ` float NOT NULL DEFAULT '0',
  `lastModifiedTime` int(10) unsigned NOT NULL DEFAULT '0',
  `closedBy` int(10) NOT NULL DEFAULT '0',
  `assignedTo` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'GUID of admin to whom ticket is assigned',
  `comment` text NOT NULL,
  `completed` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `escalated` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `viewed` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `haveTicket` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `response` text,
  PRIMARY KEY (`ticketId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Player System';

-- Dumping data for table chars.gm_tickets: ~0 rows (approximately)
DELETE FROM `gm_tickets`;
/*!40000 ALTER TABLE `gm_tickets` DISABLE KEYS */;
/*!40000 ALTER TABLE `gm_tickets` ENABLE KEYS */;

-- Dumping structure for table chars.groups
CREATE TABLE IF NOT EXISTS `groups` (
  `guid` int(10) unsigned NOT NULL,
  `leaderGuid` int(10) unsigned NOT NULL,
  `lootMethod` tinyint(3) unsigned NOT NULL,
  `looterGuid` int(10) unsigned NOT NULL,
  `lootThreshold` tinyint(3) unsigned NOT NULL,
  `icon1` int(10) unsigned NOT NULL,
  `icon2` int(10) unsigned NOT NULL,
  `icon3` int(10) unsigned NOT NULL,
  `icon4` int(10) unsigned NOT NULL,
  `icon5` int(10) unsigned NOT NULL,
  `icon6` int(10) unsigned NOT NULL,
  `icon7` int(10) unsigned NOT NULL,
  `icon8` int(10) unsigned NOT NULL,
  `groupType` tinyint(3) unsigned NOT NULL,
  `difficulty` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `raiddifficulty` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `legacyraiddifficulty` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`),
  KEY `leaderGuid` (`leaderGuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Groups';

-- Dumping data for table chars.groups: ~0 rows (approximately)
DELETE FROM `groups`;
/*!40000 ALTER TABLE `groups` DISABLE KEYS */;
/*!40000 ALTER TABLE `groups` ENABLE KEYS */;

-- Dumping structure for table chars.group_completed_challenges
CREATE TABLE IF NOT EXISTS `group_completed_challenges` (
  `map_id` int(10) unsigned NOT NULL,
  `attempt_id` int(10) unsigned NOT NULL DEFAULT '0',
  `completion_time` int(10) unsigned NOT NULL DEFAULT '0',
  `completion_date` int(10) unsigned NOT NULL DEFAULT '0',
  `medal_earned` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `group_members` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `group_1_guid` int(10) unsigned NOT NULL DEFAULT '0',
  `group_1_spec` int(10) unsigned NOT NULL DEFAULT '0',
  `group_2_guid` int(10) unsigned NOT NULL DEFAULT '0',
  `group_2_spec` int(10) unsigned NOT NULL DEFAULT '0',
  `group_3_guid` int(10) unsigned NOT NULL DEFAULT '0',
  `group_3_spec` int(10) unsigned NOT NULL DEFAULT '0',
  `group_4_guid` int(10) unsigned NOT NULL DEFAULT '0',
  `group_4_spec` int(10) unsigned NOT NULL DEFAULT '0',
  `group_5_guid` int(10) unsigned NOT NULL DEFAULT '0',
  `group_5_spec` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`map_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.group_completed_challenges: ~0 rows (approximately)
DELETE FROM `group_completed_challenges`;
/*!40000 ALTER TABLE `group_completed_challenges` DISABLE KEYS */;
/*!40000 ALTER TABLE `group_completed_challenges` ENABLE KEYS */;

-- Dumping structure for table chars.group_instance
CREATE TABLE IF NOT EXISTS `group_instance` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0',
  `instance` int(10) unsigned NOT NULL DEFAULT '0',
  `permanent` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`,`instance`),
  KEY `instance` (`instance`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.group_instance: ~0 rows (approximately)
DELETE FROM `group_instance`;
/*!40000 ALTER TABLE `group_instance` DISABLE KEYS */;
/*!40000 ALTER TABLE `group_instance` ENABLE KEYS */;

-- Dumping structure for table chars.group_member
CREATE TABLE IF NOT EXISTS `group_member` (
  `guid` int(10) unsigned NOT NULL,
  `memberGuid` int(10) unsigned NOT NULL,
  `memberFlags` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `subgroup` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `roles` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `class` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `specId` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`memberGuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Groups';

-- Dumping data for table chars.group_member: ~0 rows (approximately)
DELETE FROM `group_member`;
/*!40000 ALTER TABLE `group_member` DISABLE KEYS */;
/*!40000 ALTER TABLE `group_member` ENABLE KEYS */;

-- Dumping structure for table chars.guild
CREATE TABLE IF NOT EXISTS `guild` (
  `guildid` int(10) unsigned NOT NULL DEFAULT '0',
  `name` varchar(24) NOT NULL DEFAULT '',
  `leaderguid` int(10) unsigned NOT NULL DEFAULT '0',
  `EmblemStyle` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `EmblemColor` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `BorderStyle` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `BorderColor` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `BackgroundColor` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `info` text NOT NULL,
  `motd` varchar(128) NOT NULL DEFAULT '',
  `createdate` int(10) unsigned NOT NULL DEFAULT '0',
  `BankMoney` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guildid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Guild System';

-- Dumping data for table chars.guild: ~0 rows (approximately)
DELETE FROM `guild`;
/*!40000 ALTER TABLE `guild` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild` ENABLE KEYS */;

-- Dumping structure for table chars.guild_achievement
CREATE TABLE IF NOT EXISTS `guild_achievement` (
  `guildId` int(10) unsigned NOT NULL,
  `achievement` smallint(5) unsigned NOT NULL,
  `date` int(10) unsigned NOT NULL DEFAULT '0',
  `guids` text NOT NULL,
  PRIMARY KEY (`guildId`,`achievement`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.guild_achievement: ~0 rows (approximately)
DELETE FROM `guild_achievement`;
/*!40000 ALTER TABLE `guild_achievement` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_achievement` ENABLE KEYS */;

-- Dumping structure for table chars.guild_achievement_progress
CREATE TABLE IF NOT EXISTS `guild_achievement_progress` (
  `guildId` int(10) unsigned NOT NULL,
  `criteria` smallint(5) unsigned NOT NULL,
  `counter` int(10) unsigned NOT NULL,
  `date` int(10) unsigned NOT NULL DEFAULT '0',
  `completedGuid` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guildId`,`criteria`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.guild_achievement_progress: ~0 rows (approximately)
DELETE FROM `guild_achievement_progress`;
/*!40000 ALTER TABLE `guild_achievement_progress` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_achievement_progress` ENABLE KEYS */;

-- Dumping structure for table chars.guild_bank_eventlog
CREATE TABLE IF NOT EXISTS `guild_bank_eventlog` (
  `guildid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Guild Identificator',
  `LogGuid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Log record identificator - auxiliary column',
  `TabId` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Guild bank TabId',
  `EventType` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Event type',
  `PlayerGuid` int(10) unsigned NOT NULL DEFAULT '0',
  `ItemOrMoney` int(10) unsigned NOT NULL DEFAULT '0',
  `ItemStackCount` smallint(5) unsigned NOT NULL DEFAULT '0',
  `DestTabId` tinyint(3) unsigned NOT NULL DEFAULT '0' COMMENT 'Destination Tab Id',
  `TimeStamp` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Event UNIX time',
  PRIMARY KEY (`guildid`,`LogGuid`,`TabId`),
  KEY `guildid_key` (`guildid`),
  KEY `Idx_PlayerGuid` (`PlayerGuid`),
  KEY `Idx_LogGuid` (`LogGuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.guild_bank_eventlog: ~0 rows (approximately)
DELETE FROM `guild_bank_eventlog`;
/*!40000 ALTER TABLE `guild_bank_eventlog` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_bank_eventlog` ENABLE KEYS */;

-- Dumping structure for table chars.guild_bank_item
CREATE TABLE IF NOT EXISTS `guild_bank_item` (
  `guildid` int(10) unsigned NOT NULL DEFAULT '0',
  `TabId` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `SlotId` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `item_guid` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guildid`,`TabId`,`SlotId`),
  KEY `guildid_key` (`guildid`),
  KEY `Idx_item_guid` (`item_guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.guild_bank_item: ~0 rows (approximately)
DELETE FROM `guild_bank_item`;
/*!40000 ALTER TABLE `guild_bank_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_bank_item` ENABLE KEYS */;

-- Dumping structure for table chars.guild_bank_right
CREATE TABLE IF NOT EXISTS `guild_bank_right` (
  `guildid` int(10) unsigned NOT NULL DEFAULT '0',
  `TabId` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `rid` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `gbright` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `SlotPerDay` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guildid`,`TabId`,`rid`),
  KEY `guildid_key` (`guildid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.guild_bank_right: ~0 rows (approximately)
DELETE FROM `guild_bank_right`;
/*!40000 ALTER TABLE `guild_bank_right` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_bank_right` ENABLE KEYS */;

-- Dumping structure for table chars.guild_bank_tab
CREATE TABLE IF NOT EXISTS `guild_bank_tab` (
  `guildid` int(10) unsigned NOT NULL DEFAULT '0',
  `TabId` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `TabName` varchar(16) NOT NULL DEFAULT '',
  `TabIcon` varchar(100) NOT NULL DEFAULT '',
  `TabText` varchar(500) DEFAULT NULL,
  PRIMARY KEY (`guildid`,`TabId`),
  KEY `guildid_key` (`guildid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.guild_bank_tab: ~0 rows (approximately)
DELETE FROM `guild_bank_tab`;
/*!40000 ALTER TABLE `guild_bank_tab` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_bank_tab` ENABLE KEYS */;

-- Dumping structure for table chars.guild_challenges
CREATE TABLE IF NOT EXISTS `guild_challenges` (
  `GuildId` int(10) unsigned NOT NULL,
  `ChallengeType` int(1) NOT NULL DEFAULT '0',
  `ChallengeCount` int(1) DEFAULT NULL,
  PRIMARY KEY (`GuildId`,`ChallengeType`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.guild_challenges: ~0 rows (approximately)
DELETE FROM `guild_challenges`;
/*!40000 ALTER TABLE `guild_challenges` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_challenges` ENABLE KEYS */;

-- Dumping structure for table chars.guild_completed_challenges
CREATE TABLE IF NOT EXISTS `guild_completed_challenges` (
  `map_id` int(10) unsigned NOT NULL,
  `guild_id` int(10) unsigned NOT NULL,
  `attempt_id` int(10) unsigned NOT NULL DEFAULT '0',
  `completion_time` int(10) unsigned NOT NULL DEFAULT '0',
  `completion_date` int(10) unsigned NOT NULL DEFAULT '0',
  `medal_earned` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `guild_members` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `guild_1_guid` int(10) unsigned NOT NULL DEFAULT '0',
  `guild_1_spec` int(10) unsigned NOT NULL DEFAULT '0',
  `guild_2_guid` int(10) unsigned NOT NULL DEFAULT '0',
  `guild_2_spec` int(10) unsigned NOT NULL DEFAULT '0',
  `guild_3_guid` int(10) unsigned NOT NULL DEFAULT '0',
  `guild_3_spec` int(10) unsigned NOT NULL DEFAULT '0',
  `guild_4_guid` int(10) unsigned NOT NULL DEFAULT '0',
  `guild_4_spec` int(10) unsigned NOT NULL DEFAULT '0',
  `guild_5_guid` int(10) unsigned NOT NULL DEFAULT '0',
  `guild_5_spec` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`map_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.guild_completed_challenges: ~0 rows (approximately)
DELETE FROM `guild_completed_challenges`;
/*!40000 ALTER TABLE `guild_completed_challenges` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_completed_challenges` ENABLE KEYS */;

-- Dumping structure for table chars.guild_eventlog
CREATE TABLE IF NOT EXISTS `guild_eventlog` (
  `guildid` int(10) unsigned NOT NULL COMMENT 'Guild Identificator',
  `LogGuid` int(10) unsigned NOT NULL COMMENT 'Log record identificator - auxiliary column',
  `EventType` tinyint(3) unsigned NOT NULL COMMENT 'Event type',
  `PlayerGuid1` int(10) unsigned NOT NULL COMMENT 'Player 1',
  `PlayerGuid2` int(10) unsigned NOT NULL COMMENT 'Player 2',
  `NewRank` tinyint(3) unsigned NOT NULL COMMENT 'New rank(in case promotion/demotion)',
  `TimeStamp` int(10) unsigned NOT NULL COMMENT 'Event UNIX time',
  PRIMARY KEY (`guildid`,`LogGuid`),
  KEY `Idx_PlayerGuid1` (`PlayerGuid1`),
  KEY `Idx_PlayerGuid2` (`PlayerGuid2`),
  KEY `Idx_LogGuid` (`LogGuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Guild Eventlog';

-- Dumping data for table chars.guild_eventlog: ~0 rows (approximately)
DELETE FROM `guild_eventlog`;
/*!40000 ALTER TABLE `guild_eventlog` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_eventlog` ENABLE KEYS */;

-- Dumping structure for table chars.guild_finder_applicant
CREATE TABLE IF NOT EXISTS `guild_finder_applicant` (
  `guildId` int(10) unsigned DEFAULT NULL,
  `playerGuid` int(10) unsigned DEFAULT NULL,
  `availability` tinyint(3) unsigned DEFAULT '0',
  `classRole` tinyint(3) unsigned DEFAULT '0',
  `interests` tinyint(3) unsigned DEFAULT '0',
  `comment` varchar(255) DEFAULT NULL,
  `submitTime` int(10) unsigned DEFAULT NULL,
  UNIQUE KEY `guildId` (`guildId`,`playerGuid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.guild_finder_applicant: ~0 rows (approximately)
DELETE FROM `guild_finder_applicant`;
/*!40000 ALTER TABLE `guild_finder_applicant` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_finder_applicant` ENABLE KEYS */;

-- Dumping structure for table chars.guild_finder_guild_settings
CREATE TABLE IF NOT EXISTS `guild_finder_guild_settings` (
  `guildId` int(10) unsigned NOT NULL,
  `availability` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `classRoles` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `interests` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `level` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `listed` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `comment` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`guildId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.guild_finder_guild_settings: ~0 rows (approximately)
DELETE FROM `guild_finder_guild_settings`;
/*!40000 ALTER TABLE `guild_finder_guild_settings` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_finder_guild_settings` ENABLE KEYS */;

-- Dumping structure for table chars.guild_member
CREATE TABLE IF NOT EXISTS `guild_member` (
  `guildid` int(10) unsigned NOT NULL COMMENT 'Guild Identificator',
  `guid` int(10) unsigned NOT NULL,
  `rank` tinyint(3) unsigned NOT NULL,
  `pnote` varchar(31) NOT NULL DEFAULT '',
  `offnote` varchar(31) NOT NULL DEFAULT '',
  `BankResetTimeMoney` int(10) unsigned NOT NULL DEFAULT '0',
  `BankRemMoney` int(10) unsigned NOT NULL DEFAULT '0',
  `BankResetTimeTab0` int(10) unsigned NOT NULL DEFAULT '0',
  `BankRemSlotsTab0` int(10) unsigned NOT NULL DEFAULT '0',
  `BankResetTimeTab1` int(10) unsigned NOT NULL DEFAULT '0',
  `BankRemSlotsTab1` int(10) unsigned NOT NULL DEFAULT '0',
  `BankResetTimeTab2` int(10) unsigned NOT NULL DEFAULT '0',
  `BankRemSlotsTab2` int(10) unsigned NOT NULL DEFAULT '0',
  `BankResetTimeTab3` int(10) unsigned NOT NULL DEFAULT '0',
  `BankRemSlotsTab3` int(10) unsigned NOT NULL DEFAULT '0',
  `BankResetTimeTab4` int(10) unsigned NOT NULL DEFAULT '0',
  `BankRemSlotsTab4` int(10) unsigned NOT NULL DEFAULT '0',
  `BankResetTimeTab5` int(10) unsigned NOT NULL DEFAULT '0',
  `BankRemSlotsTab5` int(10) unsigned NOT NULL DEFAULT '0',
  `BankResetTimeTab6` int(10) unsigned NOT NULL DEFAULT '0',
  `BankRemSlotsTab6` int(10) unsigned NOT NULL DEFAULT '0',
  `BankResetTimeTab7` int(10) unsigned NOT NULL DEFAULT '0',
  `BankRemSlotsTab7` int(10) unsigned NOT NULL DEFAULT '0',
  UNIQUE KEY `guid_key` (`guid`),
  KEY `guildid_key` (`guildid`),
  KEY `guildid_rank_key` (`guildid`,`rank`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Guild System';

-- Dumping data for table chars.guild_member: ~0 rows (approximately)
DELETE FROM `guild_member`;
/*!40000 ALTER TABLE `guild_member` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_member` ENABLE KEYS */;

-- Dumping structure for table chars.guild_news_log
CREATE TABLE IF NOT EXISTS `guild_news_log` (
  `guild` int(10) unsigned NOT NULL,
  `id` int(10) unsigned NOT NULL,
  `eventType` int(10) unsigned NOT NULL,
  `playerGuid` bigint(20) unsigned NOT NULL,
  `data` int(10) unsigned NOT NULL,
  `flags` int(10) unsigned NOT NULL,
  `date` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guild`,`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.guild_news_log: ~0 rows (approximately)
DELETE FROM `guild_news_log`;
/*!40000 ALTER TABLE `guild_news_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_news_log` ENABLE KEYS */;

-- Dumping structure for table chars.guild_rank
CREATE TABLE IF NOT EXISTS `guild_rank` (
  `guildid` int(10) unsigned NOT NULL DEFAULT '0',
  `rid` tinyint(3) unsigned NOT NULL,
  `rname` varchar(20) NOT NULL DEFAULT '',
  `rights` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `BankMoneyPerDay` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guildid`,`rid`),
  KEY `Idx_rid` (`rid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Guild System';

-- Dumping data for table chars.guild_rank: ~0 rows (approximately)
DELETE FROM `guild_rank`;
/*!40000 ALTER TABLE `guild_rank` DISABLE KEYS */;
/*!40000 ALTER TABLE `guild_rank` ENABLE KEYS */;

-- Dumping structure for table chars.instance
CREATE TABLE IF NOT EXISTS `instance` (
  `id` int(10) unsigned NOT NULL DEFAULT '0',
  `map` smallint(5) unsigned NOT NULL DEFAULT '0',
  `resettime` int(10) unsigned NOT NULL DEFAULT '0',
  `difficulty` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `completedEncounters` int(10) unsigned NOT NULL DEFAULT '0',
  `data` tinytext NOT NULL,
  PRIMARY KEY (`id`),
  KEY `map` (`map`),
  KEY `resettime` (`resettime`),
  KEY `difficulty` (`difficulty`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.instance: ~0 rows (approximately)
DELETE FROM `instance`;
/*!40000 ALTER TABLE `instance` DISABLE KEYS */;
/*!40000 ALTER TABLE `instance` ENABLE KEYS */;

-- Dumping structure for table chars.instance_reset
CREATE TABLE IF NOT EXISTS `instance_reset` (
  `mapid` smallint(5) unsigned NOT NULL DEFAULT '0',
  `difficulty` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `resettime` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`mapid`,`difficulty`),
  KEY `difficulty` (`difficulty`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.instance_reset: ~0 rows (approximately)
DELETE FROM `instance_reset`;
/*!40000 ALTER TABLE `instance_reset` DISABLE KEYS */;
/*!40000 ALTER TABLE `instance_reset` ENABLE KEYS */;

-- Dumping structure for table chars.item_instance
CREATE TABLE IF NOT EXISTS `item_instance` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0',
  `itemEntry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `owner_guid` int(10) unsigned NOT NULL DEFAULT '0',
  `creatorGuid` int(10) unsigned NOT NULL DEFAULT '0',
  `giftCreatorGuid` int(10) unsigned NOT NULL DEFAULT '0',
  `count` int(10) unsigned NOT NULL DEFAULT '1',
  `duration` int(10) NOT NULL DEFAULT '0',
  `charges` tinytext,
  `flags` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `enchantments` text NOT NULL,
  `randomPropertyId` smallint(5) NOT NULL DEFAULT '0',
  `transmogrifyId` int(10) NOT NULL DEFAULT '0',
  `bonuses` text,
  `upgradeId` mediumint(8) DEFAULT NULL,
  `durability` smallint(5) unsigned NOT NULL DEFAULT '0',
  `playedTime` int(10) unsigned NOT NULL DEFAULT '0',
  `text` text,
  `custom_flags` int(10) unsigned NOT NULL DEFAULT '0',
  `enchantIllusionId` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`),
  KEY `idx_owner_guid` (`owner_guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Item System';

-- Dumping data for table chars.item_instance: ~0 rows (approximately)
DELETE FROM `item_instance`;
/*!40000 ALTER TABLE `item_instance` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_instance` ENABLE KEYS */;

-- Dumping structure for table chars.item_refund_instance
CREATE TABLE IF NOT EXISTS `item_refund_instance` (
  `item_guid` int(10) unsigned NOT NULL COMMENT 'Item GUID',
  `player_guid` int(10) unsigned NOT NULL COMMENT 'Player GUID',
  `paidMoney` int(10) unsigned NOT NULL DEFAULT '0',
  `paidExtendedCost` smallint(5) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`item_guid`,`player_guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Item Refund System';

-- Dumping data for table chars.item_refund_instance: ~0 rows (approximately)
DELETE FROM `item_refund_instance`;
/*!40000 ALTER TABLE `item_refund_instance` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_refund_instance` ENABLE KEYS */;

-- Dumping structure for table chars.item_soulbound_trade_data
CREATE TABLE IF NOT EXISTS `item_soulbound_trade_data` (
  `itemGuid` int(10) unsigned NOT NULL COMMENT 'Item GUID',
  `allowedPlayers` text NOT NULL COMMENT 'Space separated GUID list of players who can receive this item in trade',
  PRIMARY KEY (`itemGuid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Item Refund System';

-- Dumping data for table chars.item_soulbound_trade_data: ~0 rows (approximately)
DELETE FROM `item_soulbound_trade_data`;
/*!40000 ALTER TABLE `item_soulbound_trade_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_soulbound_trade_data` ENABLE KEYS */;

-- Dumping structure for table chars.item_template
CREATE TABLE IF NOT EXISTS `item_template` (
  `entry` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `class` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `subclass` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `name` varchar(255) NOT NULL DEFAULT '',
  `Quality` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `spellid_1` int(11) unsigned NOT NULL,
  `spellid_2` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`entry`),
  KEY `idx_name` (`name`),
  KEY `items_index` (`class`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8 ROW_FORMAT=FIXED COMMENT='Item System';

-- Dumping data for table chars.item_template: 0 rows
DELETE FROM `item_template`;
/*!40000 ALTER TABLE `item_template` DISABLE KEYS */;
/*!40000 ALTER TABLE `item_template` ENABLE KEYS */;

-- Dumping structure for table chars.lag_reports
CREATE TABLE IF NOT EXISTS `lag_reports` (
  `reportId` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `guid` int(10) unsigned NOT NULL DEFAULT '0',
  `lagType` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `mapId` smallint(5) unsigned NOT NULL DEFAULT '0',
  `posX` float NOT NULL DEFAULT '0',
  `posY` float NOT NULL DEFAULT '0',
  `posZ` float NOT NULL DEFAULT '0',
  `latency` int(10) unsigned NOT NULL DEFAULT '0',
  `createTime` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`reportId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Player System';

-- Dumping data for table chars.lag_reports: ~0 rows (approximately)
DELETE FROM `lag_reports`;
/*!40000 ALTER TABLE `lag_reports` DISABLE KEYS */;
/*!40000 ALTER TABLE `lag_reports` ENABLE KEYS */;

-- Dumping structure for table chars.lfg_data
CREATE TABLE IF NOT EXISTS `lfg_data` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier',
  `dungeon` int(10) unsigned NOT NULL DEFAULT '0',
  `state` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='LFG Data';

-- Dumping data for table chars.lfg_data: ~0 rows (approximately)
DELETE FROM `lfg_data`;
/*!40000 ALTER TABLE `lfg_data` DISABLE KEYS */;
/*!40000 ALTER TABLE `lfg_data` ENABLE KEYS */;

-- Dumping structure for table chars.log_arena
CREATE TABLE IF NOT EXISTS `log_arena` (
  `id` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `timestamp` int(11) DEFAULT NULL,
  `string` blob,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.log_arena: ~0 rows (approximately)
DELETE FROM `log_arena`;
/*!40000 ALTER TABLE `log_arena` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_arena` ENABLE KEYS */;

-- Dumping structure for table chars.log_faction_change
CREATE TABLE IF NOT EXISTS `log_faction_change` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `guid` int(16) NOT NULL,
  `account` int(11) NOT NULL,
  `OldRace` int(11) NOT NULL,
  `NewRace` int(11) NOT NULL,
  `date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- Dumping data for table chars.log_faction_change: 0 rows
DELETE FROM `log_faction_change`;
/*!40000 ALTER TABLE `log_faction_change` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_faction_change` ENABLE KEYS */;

-- Dumping structure for table chars.log_gm
CREATE TABLE IF NOT EXISTS `log_gm` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL,
  `gm_account_id` bigint(20) NOT NULL,
  `gm_account_name` blob NOT NULL,
  `gm_character_id` bigint(20) NOT NULL,
  `gm_character_name` blob NOT NULL,
  `gm_last_ip` tinytext,
  `sc_account_id` bigint(20) NOT NULL,
  `sc_account_name` blob NOT NULL,
  `sc_character_id` bigint(20) NOT NULL,
  `sc_character_name` blob NOT NULL,
  `command` blob NOT NULL,
  PRIMARY KEY (`id`),
  KEY `gm_account_id` (`gm_account_id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.log_gm: ~0 rows (approximately)
DELETE FROM `log_gm`;
/*!40000 ALTER TABLE `log_gm` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_gm` ENABLE KEYS */;

-- Dumping structure for table chars.log_gm_chat
CREATE TABLE IF NOT EXISTS `log_gm_chat` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `type` int(11) NOT NULL,
  `date` datetime NOT NULL,
  `from_account_id` bigint(20) NOT NULL,
  `from_account_name` blob NOT NULL,
  `from_character_id` bigint(20) NOT NULL,
  `from_character_name` blob NOT NULL,
  `to_account_id` bigint(20) NOT NULL,
  `to_account_name` blob NOT NULL,
  `to_character_id` bigint(20) NOT NULL,
  `to_character_name` blob NOT NULL,
  `message` blob NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.log_gm_chat: ~0 rows (approximately)
DELETE FROM `log_gm_chat`;
/*!40000 ALTER TABLE `log_gm_chat` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_gm_chat` ENABLE KEYS */;

-- Dumping structure for table chars.log_mail
CREATE TABLE IF NOT EXISTS `log_mail` (
  `id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Identifier',
  `messageType` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `stationery` tinyint(3) NOT NULL DEFAULT '41',
  `mailTemplateId` smallint(5) unsigned NOT NULL DEFAULT '0',
  `sender` int(10) unsigned NOT NULL DEFAULT '0',
  `receiver` int(10) unsigned NOT NULL DEFAULT '0',
  `subject` longtext,
  `body` longtext,
  `has_items` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `expire_time` int(10) unsigned NOT NULL DEFAULT '0',
  `deliver_time` int(10) unsigned NOT NULL DEFAULT '0',
  `money` bigint(20) DEFAULT NULL,
  `cod` bigint(20) unsigned NOT NULL DEFAULT '0',
  `checked` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.log_mail: ~0 rows (approximately)
DELETE FROM `log_mail`;
/*!40000 ALTER TABLE `log_mail` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_mail` ENABLE KEYS */;

-- Dumping structure for table chars.log_rename
CREATE TABLE IF NOT EXISTS `log_rename` (
  `guid` int(11) unsigned NOT NULL,
  `date` datetime NOT NULL,
  `oldName` tinytext NOT NULL,
  `newName` tinytext NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.log_rename: ~0 rows (approximately)
DELETE FROM `log_rename`;
/*!40000 ALTER TABLE `log_rename` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_rename` ENABLE KEYS */;

-- Dumping structure for table chars.log_store_gold
CREATE TABLE IF NOT EXISTS `log_store_gold` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `transaction` int(11) NOT NULL DEFAULT '0',
  `guid` int(11) NOT NULL DEFAULT '0',
  `gold` int(11) NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.log_store_gold: ~0 rows (approximately)
DELETE FROM `log_store_gold`;
/*!40000 ALTER TABLE `log_store_gold` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_store_gold` ENABLE KEYS */;

-- Dumping structure for table chars.log_store_item
CREATE TABLE IF NOT EXISTS `log_store_item` (
  `id` int(11) NOT NULL DEFAULT '0',
  `transaction` int(11) DEFAULT '0',
  `guid` int(11) DEFAULT '0',
  `itemid` int(11) DEFAULT '0',
  `count` int(5) DEFAULT '1',
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.log_store_item: ~0 rows (approximately)
DELETE FROM `log_store_item`;
/*!40000 ALTER TABLE `log_store_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_store_item` ENABLE KEYS */;

-- Dumping structure for table chars.log_store_title
CREATE TABLE IF NOT EXISTS `log_store_title` (
  `id` int(10) unsigned NOT NULL AUTO_INCREMENT,
  `transaction` int(10) unsigned NOT NULL,
  `guid` int(10) unsigned NOT NULL,
  `title` int(10) unsigned NOT NULL,
  `date` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  UNIQUE KEY `id` (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.log_store_title: ~0 rows (approximately)
DELETE FROM `log_store_title`;
/*!40000 ALTER TABLE `log_store_title` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_store_title` ENABLE KEYS */;

-- Dumping structure for table chars.log_trade
CREATE TABLE IF NOT EXISTS `log_trade` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `date` datetime NOT NULL,
  `sc_accountid` int(11) DEFAULT NULL,
  `sc_guid` int(11) DEFAULT NULL,
  `sc_name` text,
  `tar_accountid` int(11) DEFAULT NULL,
  `tar_guid` int(11) DEFAULT NULL,
  `tar_name` text,
  `item_name` tinytext,
  `item_entry` int(11) DEFAULT NULL,
  `item_count` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.log_trade: ~0 rows (approximately)
DELETE FROM `log_trade`;
/*!40000 ALTER TABLE `log_trade` DISABLE KEYS */;
/*!40000 ALTER TABLE `log_trade` ENABLE KEYS */;

-- Dumping structure for table chars.lvl100_fr
CREATE TABLE IF NOT EXISTS `lvl100_fr` (
  `account` int(11) unsigned NOT NULL DEFAULT '0',
  UNIQUE KEY `account` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.lvl100_fr: ~0 rows (approximately)
DELETE FROM `lvl100_fr`;
/*!40000 ALTER TABLE `lvl100_fr` DISABLE KEYS */;
/*!40000 ALTER TABLE `lvl100_fr` ENABLE KEYS */;

-- Dumping structure for table chars.mail
CREATE TABLE IF NOT EXISTS `mail` (
  `id` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Identifier',
  `messageType` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `stationery` tinyint(3) NOT NULL DEFAULT '41',
  `mailTemplateId` smallint(5) unsigned NOT NULL DEFAULT '0',
  `sender` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Character Global Unique Identifier',
  `receiver` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Character Global Unique Identifier',
  `subject` longtext,
  `body` longtext,
  `has_items` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `expire_time` int(10) unsigned NOT NULL DEFAULT '0',
  `deliver_time` int(10) unsigned NOT NULL DEFAULT '0',
  `money` bigint(20) unsigned NOT NULL DEFAULT '0',
  `cod` bigint(20) unsigned NOT NULL DEFAULT '0',
  `checked` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`id`),
  KEY `idx_receiver` (`receiver`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Mail System';

-- Dumping data for table chars.mail: ~0 rows (approximately)
DELETE FROM `mail`;
/*!40000 ALTER TABLE `mail` DISABLE KEYS */;
/*!40000 ALTER TABLE `mail` ENABLE KEYS */;

-- Dumping structure for table chars.mail_items
CREATE TABLE IF NOT EXISTS `mail_items` (
  `mail_id` int(10) unsigned NOT NULL DEFAULT '0',
  `item_guid` int(10) unsigned NOT NULL DEFAULT '0',
  `receiver` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Character Global Unique Identifier',
  PRIMARY KEY (`item_guid`),
  KEY `idx_receiver` (`receiver`),
  KEY `idx_mail_id` (`mail_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 ROW_FORMAT=DYNAMIC;

-- Dumping data for table chars.mail_items: ~0 rows (approximately)
DELETE FROM `mail_items`;
/*!40000 ALTER TABLE `mail_items` DISABLE KEYS */;
/*!40000 ALTER TABLE `mail_items` ENABLE KEYS */;

-- Dumping structure for table chars.petition
CREATE TABLE IF NOT EXISTS `petition` (
  `ownerguid` int(10) unsigned NOT NULL,
  `petitionguid` int(10) unsigned DEFAULT '0',
  `name` varchar(24) NOT NULL,
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`ownerguid`,`type`),
  UNIQUE KEY `index_ownerguid_petitionguid` (`ownerguid`,`petitionguid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Guild System';

-- Dumping data for table chars.petition: ~0 rows (approximately)
DELETE FROM `petition`;
/*!40000 ALTER TABLE `petition` DISABLE KEYS */;
/*!40000 ALTER TABLE `petition` ENABLE KEYS */;

-- Dumping structure for table chars.petition_sign
CREATE TABLE IF NOT EXISTS `petition_sign` (
  `ownerguid` int(10) unsigned NOT NULL,
  `petitionguid` int(10) unsigned NOT NULL DEFAULT '0',
  `playerguid` int(10) unsigned NOT NULL DEFAULT '0',
  `player_account` int(10) unsigned NOT NULL DEFAULT '0',
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`petitionguid`,`playerguid`),
  KEY `Idx_playerguid` (`playerguid`),
  KEY `Idx_ownerguid` (`ownerguid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Guild System';

-- Dumping data for table chars.petition_sign: ~0 rows (approximately)
DELETE FROM `petition_sign`;
/*!40000 ALTER TABLE `petition_sign` DISABLE KEYS */;
/*!40000 ALTER TABLE `petition_sign` ENABLE KEYS */;

-- Dumping structure for table chars.pet_aura
CREATE TABLE IF NOT EXISTS `pet_aura` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier',
  `slot` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `caster_guid` bigint(20) unsigned NOT NULL DEFAULT '0' COMMENT 'Full Global Unique Identifier',
  `spell` mediumint(8) unsigned NOT NULL DEFAULT '0',
  `effect_mask` int(11) unsigned NOT NULL DEFAULT '0',
  `recalculate_mask` int(11) unsigned NOT NULL DEFAULT '0',
  `stackcount` tinyint(3) unsigned NOT NULL DEFAULT '1',
  `maxduration` int(11) NOT NULL DEFAULT '0',
  `remaintime` int(11) NOT NULL DEFAULT '0',
  `remaincharges` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`,`spell`,`slot`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Pet System';

-- Dumping data for table chars.pet_aura: ~0 rows (approximately)
DELETE FROM `pet_aura`;
/*!40000 ALTER TABLE `pet_aura` DISABLE KEYS */;
/*!40000 ALTER TABLE `pet_aura` ENABLE KEYS */;

-- Dumping structure for table chars.pet_aura_effect
CREATE TABLE IF NOT EXISTS `pet_aura_effect` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0',
  `slot` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `effect` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `amount` int(11) NOT NULL DEFAULT '0',
  `baseamount` int(11) NOT NULL DEFAULT '0',
  `data` blob,
  PRIMARY KEY (`guid`,`slot`,`effect`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.pet_aura_effect: ~0 rows (approximately)
DELETE FROM `pet_aura_effect`;
/*!40000 ALTER TABLE `pet_aura_effect` DISABLE KEYS */;
/*!40000 ALTER TABLE `pet_aura_effect` ENABLE KEYS */;

-- Dumping structure for table chars.pet_spell
CREATE TABLE IF NOT EXISTS `pet_spell` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier',
  `spell` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'Spell Identifier',
  `active` tinyint(3) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`,`spell`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Pet System';

-- Dumping data for table chars.pet_spell: ~0 rows (approximately)
DELETE FROM `pet_spell`;
/*!40000 ALTER TABLE `pet_spell` DISABLE KEYS */;
/*!40000 ALTER TABLE `pet_spell` ENABLE KEYS */;

-- Dumping structure for table chars.pet_spell_cooldown
CREATE TABLE IF NOT EXISTS `pet_spell_cooldown` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Global Unique Identifier, Low part',
  `spell` mediumint(8) unsigned NOT NULL DEFAULT '0' COMMENT 'Spell Identifier',
  `time` int(10) unsigned NOT NULL DEFAULT '0',
  `categoryId` int(10) unsigned NOT NULL DEFAULT '0' COMMENT 'Spell category Id',
  `categoryEnd` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`,`spell`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.pet_spell_cooldown: ~0 rows (approximately)
DELETE FROM `pet_spell_cooldown`;
/*!40000 ALTER TABLE `pet_spell_cooldown` DISABLE KEYS */;
/*!40000 ALTER TABLE `pet_spell_cooldown` ENABLE KEYS */;

-- Dumping structure for table chars.players_reports_status
CREATE TABLE IF NOT EXISTS `players_reports_status` (
  `guid` int(10) unsigned NOT NULL DEFAULT '0',
  `creation_time` int(10) unsigned NOT NULL DEFAULT '0',
  `average` float NOT NULL DEFAULT '0',
  `total_reports` bigint(20) unsigned NOT NULL DEFAULT '0',
  `speed_reports` bigint(20) unsigned NOT NULL DEFAULT '0',
  `fly_reports` bigint(20) unsigned NOT NULL DEFAULT '0',
  `jump_reports` bigint(20) unsigned NOT NULL DEFAULT '0',
  `waterwalk_reports` bigint(20) unsigned NOT NULL DEFAULT '0',
  `teleportplane_reports` bigint(20) unsigned NOT NULL DEFAULT '0',
  `climb_reports` bigint(20) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.players_reports_status: ~0 rows (approximately)
DELETE FROM `players_reports_status`;
/*!40000 ALTER TABLE `players_reports_status` DISABLE KEYS */;
/*!40000 ALTER TABLE `players_reports_status` ENABLE KEYS */;

-- Dumping structure for table chars.pool_quest_save
CREATE TABLE IF NOT EXISTS `pool_quest_save` (
  `pool_id` int(10) unsigned NOT NULL DEFAULT '0',
  `quest_id` int(10) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`pool_id`,`quest_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.pool_quest_save: ~0 rows (approximately)
DELETE FROM `pool_quest_save`;
/*!40000 ALTER TABLE `pool_quest_save` DISABLE KEYS */;
/*!40000 ALTER TABLE `pool_quest_save` ENABLE KEYS */;

-- Dumping structure for table chars.reserved_name
CREATE TABLE IF NOT EXISTS `reserved_name` (
  `name` varchar(12) NOT NULL DEFAULT '',
  PRIMARY KEY (`name`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Player Reserved Names';

-- Dumping data for table chars.reserved_name: ~0 rows (approximately)
DELETE FROM `reserved_name`;
/*!40000 ALTER TABLE `reserved_name` DISABLE KEYS */;
/*!40000 ALTER TABLE `reserved_name` ENABLE KEYS */;

-- Dumping structure for table chars.store_gold
CREATE TABLE IF NOT EXISTS `store_gold` (
  `guid` int(11) unsigned NOT NULL,
  `gold` int(11) unsigned DEFAULT NULL,
  `transaction` int(11) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`transaction`),
  UNIQUE KEY `transaction` (`transaction`),
  KEY `guid` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.store_gold: ~0 rows (approximately)
DELETE FROM `store_gold`;
/*!40000 ALTER TABLE `store_gold` DISABLE KEYS */;
/*!40000 ALTER TABLE `store_gold` ENABLE KEYS */;

-- Dumping structure for table chars.store_item
CREATE TABLE IF NOT EXISTS `store_item` (
  `itemid` int(11) NOT NULL DEFAULT '0',
  `guid` int(11) unsigned NOT NULL,
  `count` int(11) unsigned NOT NULL,
  `transaction` int(11) NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`transaction`),
  UNIQUE KEY `transaction` (`transaction`),
  KEY `guid` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.store_item: ~0 rows (approximately)
DELETE FROM `store_item`;
/*!40000 ALTER TABLE `store_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `store_item` ENABLE KEYS */;

-- Dumping structure for table chars.store_level
CREATE TABLE IF NOT EXISTS `store_level` (
  `guid` int(11) unsigned NOT NULL DEFAULT '0',
  `level` int(11) unsigned NOT NULL DEFAULT '80',
  `transaction` int(11) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`transaction`),
  UNIQUE KEY `transaction` (`transaction`),
  KEY `guid` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.store_level: ~0 rows (approximately)
DELETE FROM `store_level`;
/*!40000 ALTER TABLE `store_level` DISABLE KEYS */;
/*!40000 ALTER TABLE `store_level` ENABLE KEYS */;

-- Dumping structure for table chars.store_metier
CREATE TABLE IF NOT EXISTS `store_metier` (
  `guid` int(11) unsigned NOT NULL,
  `skill` int(11) unsigned NOT NULL,
  `value` int(11) unsigned NOT NULL,
  `transaction` int(11) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`transaction`),
  UNIQUE KEY `NewIndex1` (`skill`,`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.store_metier: ~0 rows (approximately)
DELETE FROM `store_metier`;
/*!40000 ALTER TABLE `store_metier` DISABLE KEYS */;
/*!40000 ALTER TABLE `store_metier` ENABLE KEYS */;

-- Dumping structure for table chars.store_profession
CREATE TABLE IF NOT EXISTS `store_profession` (
  `guid` int(11) unsigned NOT NULL,
  `skill` int(11) unsigned NOT NULL,
  `recipe` int(11) unsigned NOT NULL,
  PRIMARY KEY (`guid`,`skill`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.store_profession: ~0 rows (approximately)
DELETE FROM `store_profession`;
/*!40000 ALTER TABLE `store_profession` DISABLE KEYS */;
/*!40000 ALTER TABLE `store_profession` ENABLE KEYS */;

-- Dumping structure for table chars.store_title
CREATE TABLE IF NOT EXISTS `store_title` (
  `guid` int(10) unsigned NOT NULL,
  `title` int(10) unsigned NOT NULL,
  `transaction` int(10) unsigned NOT NULL AUTO_INCREMENT,
  PRIMARY KEY (`guid`),
  KEY `transaction` (`transaction`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.store_title: ~0 rows (approximately)
DELETE FROM `store_title`;
/*!40000 ALTER TABLE `store_title` DISABLE KEYS */;
/*!40000 ALTER TABLE `store_title` ENABLE KEYS */;

-- Dumping structure for table chars.time_diff_log
CREATE TABLE IF NOT EXISTS `time_diff_log` (
  `id` int(10) NOT NULL AUTO_INCREMENT,
  `time` int(10) unsigned DEFAULT '0',
  `average` int(10) unsigned DEFAULT '0',
  `max` int(10) unsigned DEFAULT '0',
  `players` int(10) unsigned DEFAULT '0',
  PRIMARY KEY (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- Dumping data for table chars.time_diff_log: 0 rows
DELETE FROM `time_diff_log`;
/*!40000 ALTER TABLE `time_diff_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `time_diff_log` ENABLE KEYS */;

-- Dumping structure for table chars.warden_action
CREATE TABLE IF NOT EXISTS `warden_action` (
  `wardenId` smallint(5) unsigned NOT NULL,
  `action` tinyint(3) unsigned DEFAULT NULL,
  PRIMARY KEY (`wardenId`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.warden_action: ~0 rows (approximately)
DELETE FROM `warden_action`;
/*!40000 ALTER TABLE `warden_action` DISABLE KEYS */;
/*!40000 ALTER TABLE `warden_action` ENABLE KEYS */;

-- Dumping structure for table chars.webshop_delivery_currency
CREATE TABLE IF NOT EXISTS `webshop_delivery_currency` (
  `transaction` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `guid` int(11) unsigned NOT NULL DEFAULT '0',
  `currency` int(11) unsigned NOT NULL DEFAULT '0',
  `amount` int(11) unsigned NOT NULL DEFAULT '0',
  `delivery` tinyint(1) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`transaction`),
  KEY `guid` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.webshop_delivery_currency: ~0 rows (approximately)
DELETE FROM `webshop_delivery_currency`;
/*!40000 ALTER TABLE `webshop_delivery_currency` DISABLE KEYS */;
/*!40000 ALTER TABLE `webshop_delivery_currency` ENABLE KEYS */;

-- Dumping structure for table chars.webshop_delivery_gold
CREATE TABLE IF NOT EXISTS `webshop_delivery_gold` (
  `transaction` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `guid` int(11) unsigned NOT NULL DEFAULT '0',
  `gold` int(11) unsigned NOT NULL DEFAULT '0',
  `delivery` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `purchase_id` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`transaction`),
  KEY `guid` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.webshop_delivery_gold: ~0 rows (approximately)
DELETE FROM `webshop_delivery_gold`;
/*!40000 ALTER TABLE `webshop_delivery_gold` DISABLE KEYS */;
/*!40000 ALTER TABLE `webshop_delivery_gold` ENABLE KEYS */;

-- Dumping structure for table chars.webshop_delivery_item
CREATE TABLE IF NOT EXISTS `webshop_delivery_item` (
  `transaction` int(11) NOT NULL AUTO_INCREMENT,
  `itemid` int(11) NOT NULL DEFAULT '0',
  `guid` int(11) unsigned NOT NULL,
  `count` int(11) unsigned NOT NULL,
  `delivery` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `ItemBonus` varchar(255) NOT NULL DEFAULT '0',
  `purchase_id` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`transaction`),
  KEY `guid` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- Dumping data for table chars.webshop_delivery_item: ~0 rows (approximately)
DELETE FROM `webshop_delivery_item`;
/*!40000 ALTER TABLE `webshop_delivery_item` DISABLE KEYS */;
/*!40000 ALTER TABLE `webshop_delivery_item` ENABLE KEYS */;

-- Dumping structure for table chars.webshop_delivery_level
CREATE TABLE IF NOT EXISTS `webshop_delivery_level` (
  `transaction` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `guid` int(11) unsigned NOT NULL DEFAULT '0',
  `level` int(11) unsigned NOT NULL DEFAULT '0',
  `delivery` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `purchase_id` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`transaction`),
  KEY `guid` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.webshop_delivery_level: ~0 rows (approximately)
DELETE FROM `webshop_delivery_level`;
/*!40000 ALTER TABLE `webshop_delivery_level` DISABLE KEYS */;
/*!40000 ALTER TABLE `webshop_delivery_level` ENABLE KEYS */;

-- Dumping structure for table chars.webshop_delivery_premade
CREATE TABLE IF NOT EXISTS `webshop_delivery_premade` (
  `transaction` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `delivery` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `templateId` int(11) unsigned NOT NULL DEFAULT '0',
  `faction` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `account` int(11) unsigned NOT NULL DEFAULT '0',
  `type` tinyint(3) unsigned NOT NULL DEFAULT '0',
  `purchase_id` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`transaction`),
  UNIQUE KEY `transaction` (`transaction`),
  KEY `account` (`account`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.webshop_delivery_premade: ~0 rows (approximately)
DELETE FROM `webshop_delivery_premade`;
/*!40000 ALTER TABLE `webshop_delivery_premade` DISABLE KEYS */;
/*!40000 ALTER TABLE `webshop_delivery_premade` ENABLE KEYS */;

-- Dumping structure for table chars.webshop_delivery_profession
CREATE TABLE IF NOT EXISTS `webshop_delivery_profession` (
  `transaction` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `guid` int(11) unsigned NOT NULL DEFAULT '0',
  `skill` int(11) unsigned NOT NULL DEFAULT '0',
  `recipe` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `delivery` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `purchase_id` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`transaction`),
  KEY `transaction` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.webshop_delivery_profession: ~0 rows (approximately)
DELETE FROM `webshop_delivery_profession`;
/*!40000 ALTER TABLE `webshop_delivery_profession` DISABLE KEYS */;
/*!40000 ALTER TABLE `webshop_delivery_profession` ENABLE KEYS */;

-- Dumping structure for table chars.webshop_delivery_title
CREATE TABLE IF NOT EXISTS `webshop_delivery_title` (
  `transaction` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `guid` int(11) unsigned NOT NULL DEFAULT '0',
  `level` int(11) unsigned NOT NULL DEFAULT '0',
  `delivery` tinyint(1) unsigned NOT NULL DEFAULT '0',
  `purchase_id` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`transaction`),
  KEY `guid` (`guid`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

-- Dumping data for table chars.webshop_delivery_title: ~0 rows (approximately)
DELETE FROM `webshop_delivery_title`;
/*!40000 ALTER TABLE `webshop_delivery_title` DISABLE KEYS */;
/*!40000 ALTER TABLE `webshop_delivery_title` ENABLE KEYS */;

-- Dumping structure for table chars.worldstates
CREATE TABLE IF NOT EXISTS `worldstates` (
  `entry` int(10) unsigned NOT NULL DEFAULT '0',
  `value` int(10) unsigned NOT NULL DEFAULT '0',
  `comment` tinytext,
  PRIMARY KEY (`entry`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8 COMMENT='Variable Saves';

-- Dumping data for table chars.worldstates: ~0 rows (approximately)
DELETE FROM `worldstates`;
/*!40000 ALTER TABLE `worldstates` DISABLE KEYS */;
/*!40000 ALTER TABLE `worldstates` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
