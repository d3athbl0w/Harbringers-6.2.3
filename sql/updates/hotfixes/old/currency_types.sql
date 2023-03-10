-- --------------------------------------------------------
-- Host:                         logon.hellscream.org
-- Server version:               5.5.9-log - MySQL Community Server (GPL)
-- Server OS:                    Win32
-- HeidiSQL Version:             10.3.0.5771
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;

-- Dumping structure for table fixeslive.currency_types
CREATE TABLE IF NOT EXISTS `currency_types` (
  `ID` int(11) unsigned NOT NULL AUTO_INCREMENT,
  `Category` int(11) unsigned NOT NULL DEFAULT '0',
  `NameLang` text,
  `InventoryIcon` text,
  `InventoryIcon2` text,
  `SpellWeight` int(11) unsigned NOT NULL DEFAULT '0',
  `SpellCategory` int(11) unsigned NOT NULL DEFAULT '0',
  `TotalCap` int(11) unsigned NOT NULL DEFAULT '0',
  `WeekCap` int(11) unsigned NOT NULL DEFAULT '0',
  `Flags` int(11) unsigned NOT NULL DEFAULT '0',
  `Quality` int(11) unsigned NOT NULL DEFAULT '0',
  `DescriptionLang` text,
  `BuildVerified` int(11) unsigned NOT NULL DEFAULT '0',
  PRIMARY KEY (`ID`)
) ENGINE=InnoDB AUTO_INCREMENT=1021 DEFAULT CHARSET=latin1;

-- Dumping data for table fixeslive.currency_types: ~75 rows (approximately)
DELETE FROM `currency_types`;
/*!40000 ALTER TABLE `currency_types` DISABLE KEYS */;
INSERT INTO `currency_types` (`ID`, `Category`, `NameLang`, `InventoryIcon`, `InventoryIcon2`, `SpellWeight`, `SpellCategory`, `TotalCap`, `WeekCap`, `Flags`, `Quality`, `DescriptionLang`, `BuildVerified`) VALUES
	(1, 0, 'Currency Token Test Token 4', 'INV_Misc_Coin_09', 'Text that describes this item can be found here.', 1, 0, 0, 0, 71682, 1, NULL, 19865),
	(2, 0, 'Currency Token Test Token 2', 'ability_cheapshot', NULL, 1, 2, 0, 0, 4105, 1, NULL, 19865),
	(4, 0, 'Currency Token Test Token 5', 'INV_Misc_Coin_07', NULL, 4, 3, 0, 0, 1, 1, NULL, 19865),
	(22, 0, 'Birmingham Test Item 3', 'INV-Sword_53', NULL, 0, 0, 0, 0, 0, 1, NULL, 19865),
	(42, 0, 'Badge of Justice', 'Spell_Holy_ChampionsBond', NULL, 0, 0, 0, 0, 0, 1, NULL, 19865),
	(61, 0, 'Dalaran Jewelcrafter\'s Token', 'INV_Misc_Gem_Variety_01', 'Tiffany Cartier\'s shop in Dalaran will gladly accept these tokens for unique jewelcrafting recipes.', 0, 0, 0, 0, 0, 1, NULL, 19865),
	(81, 0, 'Epicurean\'s Award', 'INV_Misc_Ribbon_01', 'Visit special cooking vendors in Dalaran and the capital cities to to purchase unusual cooking recipes, spices, and even a fine hat!', 0, 0, 0, 0, 0, 1, NULL, 19865),
	(101, 0, 'Emblem of Heroism', 'Spell_Holy_ProclaimChampion', NULL, 0, 0, 0, 0, 0, 1, NULL, 19865),
	(102, 0, 'Emblem of Valor', 'Spell_Holy_ProclaimChampion_02', NULL, 0, 0, 0, 0, 0, 1, NULL, 19865),
	(103, 0, 'Arena Points', 'Spell_Holy_ChampionsBond', NULL, 0, 0, 0, 0, 0, 1, NULL, 19865),
	(104, 0, 'Honor Points DEPRECATED', 'Spell_Holy_ChampionsBond', 'If you can read this, you\'ve found a bug. REPORT IT!', 0, 0, 0, 0, 0, 1, NULL, 19865),
	(121, 0, 'Alterac Valley Mark of Honor', 'INV_Jewelry_Necklace_21', NULL, 0, 0, 0, 0, 0, 1, NULL, 19865),
	(122, 0, 'Arathi Basin Mark of Honor', 'INV_Jewelry_Amulet_07', NULL, 0, 0, 0, 0, 0, 1, NULL, 19865),
	(123, 0, 'Eye of the Storm Mark of Honor', 'Spell_Nature_EyeOfTheStorm', NULL, 0, 0, 0, 0, 0, 1, NULL, 19865),
	(124, 0, 'Strand of the Ancients Mark of Honor', 'INV_Jewelry_Amulet_01', NULL, 0, 0, 0, 0, 0, 1, NULL, 19865),
	(125, 0, 'Warsong Gulch Mark of Honor', 'INV_Misc_Rune_07', NULL, 0, 0, 0, 0, 0, 1, NULL, 19865),
	(126, 0, 'Wintergrasp Mark of Honor', 'INV_Jewelry_Ring_66', NULL, 0, 0, 0, 0, 0, 1, NULL, 19865),
	(141, 0, 'zzzOLDDaily Quest Faction Token', 'Spell_Holy_ChampionsGrace', NULL, 0, 0, 0, 0, 0, 1, NULL, 19865),
	(161, 0, 'Stone Keeper\'s Shard', 'INV_Misc_Platnumdisks', NULL, 0, 0, 0, 0, 0, 1, NULL, 19865),
	(181, 0, 'Honor Points DEPRECATED2', 'INV_Banner_03', 'If you can read this, you\'ve found a bug. REPORT IT!', 0, 0, 0, 0, 0, 1, NULL, 19865),
	(201, 0, 'Venture Coin', 'INV_Misc_Coin_16', NULL, 0, 0, 0, 0, 0, 1, NULL, 19865),
	(221, 0, 'Emblem of Conquest', 'Spell_Holy_ChampionsGrace', NULL, 0, 0, 0, 0, 0, 1, NULL, 19865),
	(241, 0, 'Champion\'s Seal', 'Ability_Paladin_ArtofWar', 'Awarded for valiant acts in the Crusader\'s Coliseum.', 0, 0, 0, 0, 0, 1, NULL, 19865),
	(301, 0, 'Emblem of Triumph', 'spell_holy_summonchampion', NULL, 0, 0, 0, 0, 0, 1, NULL, 19865),
	(321, 0, 'Isle of Conquest Mark of Honor', 'INV_Jewelry_Necklace_27', NULL, 0, 0, 0, 0, 0, 1, NULL, 19865),
	(341, 0, 'Emblem of Frost', 'inv_misc_frostemblem_01', NULL, 0, 0, 0, 0, 0, 1, NULL, 19865),
	(361, 0, 'Illustrious Jewelcrafter\'s Token', 'inv_misc_token_argentdawn3', 'Awarded for demonstrating great skill in jewelcrafting, these tokens can be used to purchase unique jewelcrafting plans and the fabulous Chimera\'s Eye.', 0, 0, 0, 0, 0, 1, NULL, 19865),
	(384, 0, 'Dwarf Archaeology Fragment', 'trade_archaeology_dwarf_artifactfragment', NULL, 1, 5, 200, 0, 34, 1, NULL, 19865),
	(385, 0, 'Troll Archaeology Fragment', 'trade_archaeology_troll_artifactfragment', NULL, 1, 4, 200, 0, 34, 1, NULL, 19865),
	(390, 0, 'Conquest Points', 'pvpcurrency-conquest-horde', 'Used to purchase powerful PvP armor and weapons.', 0, 0, 0, 0, 20940, 1, NULL, 19865),
	(391, 0, 'Tol Barad Commendation', 'achievement_zone_tolbarad', 'Awarded for brave deeds performed on Tol Barad.', 0, 0, 0, 0, 2, 1, NULL, 19865),
	(392, 0, 'Honor Points', 'pvpcurrency-honor-horde', 'Used to purchase less-powerful PvP armor and weapons.', 0, 0, 400099, 0, 16840, 1, NULL, 19865),
	(393, 0, 'Fossil Archaeology Fragment', 'trade_archaeology_fossil_fern', NULL, 1, 8, 200, 0, 34, 1, NULL, 19865),
	(394, 0, 'Night Elf Archaeology Fragment', 'trade_archaeology_highborne_artifactfragment', NULL, 1, 9, 200, 0, 34, 1, NULL, 19865),
	(395, 0, 'Justice Points', 'pvecurrency-justice', 'Used to purchase less-powerful armor and weapons.', 0, 0, 1, 0, 8280, 1, NULL, 19865),
	(396, 0, 'Valor Points', 'pvecurrency-valor', 'Used to purchase powerful PvE armor and weapons.', 0, 0, 300099, 100000, 24648, 4, NULL, 19865),
	(397, 0, 'Orc Archaeology Fragment', 'trade_archaeology_orc_artifactfragment', NULL, 1, 10, 200, 0, 34, 1, NULL, 19865),
	(398, 0, 'Draenei Archaeology Fragment', 'trade_archaeology_draenei_artifactfragment', NULL, 1, 11, 200, 0, 34, 1, NULL, 19865),
	(399, 0, 'Vrykul Archaeology Fragment', 'trade_archaeology_vrykul_artifactfragment', NULL, 1, 12, 200, 0, 34, 1, NULL, 19865),
	(400, 0, 'Nerubian Archaeology Fragment', 'trade_archaeology_nerubian_artifactfragment', NULL, 1, 13, 200, 0, 34, 1, NULL, 19865),
	(401, 0, 'Tol\'vir Archaeology Fragment', 'trade_archaeology_titan_fragment', NULL, 1, 14, 200, 0, 34, 1, NULL, 19865),
	(402, 0, 'Ironpaw Token', 'inv_relics_idolofferocity', 'Represents your credit with the Ironpaw family of cooks. Can be redeemed for Cooking ingredients and other things at the Stockmaster in Halfhill Market.', 0, 0, 0, 0, 0, 1, NULL, 19865),
	(416, 0, 'Mark of the World Tree', 'inv_misc_markoftheworldtree', 'Granted by the Guardians of Hyjal. Can be used to purchase reinforcements for the Invasion of the Firelands.', 0, 0, 0, 0, 1024, 1, NULL, 19865),
	(483, 0, 'Conquest Arena Meta', 'pvpcurrency-conquest-horde', NULL, 0, 0, 0, 0, 1484, 1, NULL, 19865),
	(484, 0, 'Conquest Rated BG Meta', 'pvpcurrency-conquest-horde', NULL, 0, 0, 0, 0, 1484, 1, NULL, 19865),
	(515, 0, 'Darkmoon Prize Ticket', 'inv_misc_ticket_darkmoon_01', 'Awarded for winning games or doing favors at the Darkmoon Faire.', 0, 0, 0, 0, 2, 1, NULL, 19865),
	(614, 0, 'Mote of Darkness', 'spell_shadow_sealofkings', 'Extracted from the forces of Deathwing, this dark energy can be used to power amazing magics.', 0, 0, 0, 0, 1024, 1, NULL, 19865),
	(615, 0, 'Essence of Corrupted Deathwing', 'inv_elemental_primal_shadow', 'Extracted from Deathwing himself, this dark energy powers the most fearsome of incantations.', 0, 0, 0, 0, 1024, 1, NULL, 19865),
	(676, 0, 'Pandaren Archaeology Fragment', 'trade_archaeology_vrykul_artifactfragment', NULL, 1, 39, 200, 0, 34, 1, NULL, 19865),
	(677, 0, 'Mogu Archaeology Fragment', 'trade_archaeology_vrykul_artifactfragment', NULL, 1, 40, 200, 0, 34, 1, NULL, 19865),
	(692, 0, 'Conquest Random BG Meta', 'pvpcurrency-conquest-horde', NULL, 0, 0, 0, 0, 1484, 1, NULL, 19865),
	(697, 0, 'Elder Charm of Good Fortune', 'inv_misc_coin_17', 'Possession of the Elder Charm of Good Fortune allows its lucky owner to risk a coin to receive a bonus reward from Mogu\'shan Vaults, Heart of Fear, Terrace of Endless Spring, Sha of Anger, or Salyis\' Warband.', 0, 0, 20, 0, 2114, 1, NULL, 19865),
	(698, 0, 'Zen Jewelcrafter\'s Token', 'trade_archaeology_titan_fragment', 'Awarded for demonstrating great skill in jewelcrafting, these tokens can be used to purchase unique jewelcrafting plans and the beautiful Serpent\'s Eye.', 0, 0, 0, 0, 0, 1, NULL, 19865),
	(738, 0, 'Lesser Charm of Good Fortune', 'inv_misc_coin_18', 'Possession of the Lesser Charms of Good Fortune will result in great happiness and the eventual conversion into Warforged Seals, which allow players to risk a coin to receive a bonus reward from raid encounters.', 0, 0, 0, 0, 64, 1, NULL, 19865),
	(752, 0, 'Mogu Rune of Fate', 'archaeology_5_0_mogucoin', 'Possession of the Mogu Rune of Fate allows its lucky owner to risk a rune to receive a bonus reward from the Throne of Thunder, Nalak or Oondasta.', 0, 0, 20, 0, 2, 1, NULL, 19865),
	(754, 0, 'Mantid Archaeology Fragment', 'inv_misc_archaeology_mantidstatue_01', NULL, 1, 44, 200, 0, 34, 1, NULL, 19865),
	(776, 0, 'Warforged Seal', 'inv_arcane_orb', 'Possession of the Warforged Seal allows its lucky owner to risk a seal to receive a bonus reward from the Siege of Orgrimmar, the Celestial Trials, and Ordos.', 0, 0, 20, 0, 2, 1, NULL, 19865),
	(777, 0, 'Timeless Coin', 'timelesscoin', 'You feel the shadowy fingers of previous and future owners of this coin playing across your hand, as if time itself blurs. Spend upon the Timeless Isle to earn powerful and fluid rewards.', 0, 0, 0, 0, 16450, 1, NULL, 19865),
	(789, 0, 'Bloody Coin', 'timelesscoin-bloody', 'Pulled from the steaming corpses of foes vanquished in the mists of the Timeless Isle.', 0, 0, 0, 0, 16450, 1, NULL, 19865),
	(810, 0, 'Black Iron Fragment', 'inv_stone_15', 'Scavenged from the shattered armor and weapons of Iron Horde invaders.', 0, 0, 0, 0, 16450, 1, NULL, 19865),
	(821, 0, 'Draenor Clans Archaeology Fragment', 'achievement_character_orc_male_brn', NULL, 1, 45, 250, 0, 34, 1, NULL, 19865),
	(823, 0, 'Apexis Crystal', 'inv_apexis_draenor', 'The enduring legacy of a lost civilization, Apexis crystals contain untold reserves of magical power.', 0, 0, 60000, 0, 16386, 2, NULL, 19865),
	(824, 0, 'Garrison Resources', 'inv_garrison_resource', 'Earn resources to build-up and expand your garrison.', 0, 0, 10000, 0, 16386, 1, NULL, 19865),
	(828, 0, 'Ogre Archaeology Fragment', 'spell_nature_rockbiter', NULL, 1, 47, 250, 0, 34, 1, NULL, 19865),
	(829, 0, 'Arakkoa Archaeology Fragment', 'achievement_dungeon_arakkoaspires', NULL, 1, 46, 250, 0, 34, 1, NULL, 19865),
	(830, 0, 'n/a', NULL, NULL, 1, 48, 200, 0, 34, 1, NULL, 19865),
	(897, 0, 'UNUSED', 'inv_datacrystal06', NULL, 0, 0, 100, 0, 8194, 1, NULL, 19865),
	(910, 0, 'Secret of Draenor Alchemy', 'trade_alchemy', 'Allows you to obtain new Alchemy recipes from the Alchemist\'s Lab.', 0, 0, 0, 0, 0, 1, NULL, 19865),
	(944, 0, 'Artifact Fragment', 'inv_ashran_artifact', 'A tiny fragment of an Ashran lost artifact, treasured by the Highmaul Ogres.', 0, 0, 100000, 0, 8202, 1, NULL, 19865),
	(980, 0, 'Dingy Iron Coins', 'inv_misc_coin_09', 'Perhaps they\'re more valuable than they appear on the surface.', 0, 0, 1000000, 0, 8, 3, NULL, 19865),
	(994, 0, 'Seal of Tempered Fate', 'ability_animusorbs', 'Twists fate to provide an opportunity for additional treasure in Highmaul or Blackrock Foundry raids.', 0, 0, 20, 0, 16386, 1, NULL, 19865),
	(999, 0, 'Secret of Draenor Tailoring', 'trade_tailoring', 'Allows you to obtain Tailoring recipes from the Tailoring Emporium.', 0, 0, 0, 0, 0, 1, NULL, 19865),
	(1008, 0, 'Secret of Draenor Jewelcrafting', 'inv_misc_gem_01', 'Allows you to obtain new Jewelcrafting recipes.', 0, 0, 0, 0, 0, 1, NULL, 19865),
	(1017, 0, 'Secret of Draenor Leatherworking', 'trade_leatherworking', 'Allows you to obtain Leatherworking recipes from the Tannery.', 0, 0, 0, 0, 0, 1, NULL, 19865),
	(1020, 0, 'Secret of Draenor Blacksmithing', 'trade_blacksmithing', 'Allows you to obtain new Blacksmithing recipes.', 0, 0, 0, 0, 0, 1, NULL, 19865);
/*!40000 ALTER TABLE `currency_types` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IF(@OLD_FOREIGN_KEY_CHECKS IS NULL, 1, @OLD_FOREIGN_KEY_CHECKS) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
