DELETE FROM `creature_equip_template` WHERE `entry`=101988 AND `id`=1;
INSERT INTO `creature_equip_template` (`entry`, `id`, `itemEntry1`, `itemEntry2`, `itemEntry3`) VALUES (101988, 1, 29417, 71741, 0);
DELETE FROM `creature_equip_template` WHERE `entry`=101989 AND `id`=1;
INSERT INTO `creature_equip_template` (`entry`, `id`, `itemEntry1`, `itemEntry2`, `itemEntry3`) VALUES (101989, 1, 29417, 71741, 0);
DELETE FROM `creature_template` WHERE `entry`=101988;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `name`, `femaleName`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `exp`, `exp_req`, `faction`, `npcflag`, `npcflag2`, `speed_walk`, `speed_run`, `speed_fly`, `scale`, `rank`, `dmgschool`, `dmg_multiplier`, `baseattacktime`, `rangeattacktime`, `baseVariance`, `rangeVariance`, `unit_class`, `unit_flags`, `unit_flags2`, `unit_flags3`, `dynamicflags`, `WorldEffectID`, `family`, `trainer_type`, `trainer_spell`, `trainer_class`, `trainer_race`, `type`, `type_flags`, `type_flags2`, `lootid`, `pickpocketloot`, `skinloot`, `resistance1`, `resistance2`, `resistance3`, `resistance4`, `resistance5`, `resistance6`, `spell1`, `spell2`, `spell3`, `spell4`, `spell5`, `spell6`, `spell7`, `spell8`, `PetSpellDataId`, `VehicleId`, `mingold`, `maxgold`, `AIName`, `MovementType`, `InhabitType`, `HoverHeight`, `Health_mod`, `Mana_mod`, `Mana_mod_extra`, `Armor_mod`, `RacialLeader`, `questItem1`, `questItem2`, `questItem3`, `questItem4`, `questItem5`, `questItem6`, `movementId`, `TrackingQuestID`, `VignetteID`, `RegenHealth`, `equipment_id`, `mechanic_immune_mask`, `flags_extra`, `ScriptName`, `BuildVerified`) VALUES (101988, 47231, 0, 'Voidbinder Selebrembor', '', 'Item Upgrade', 'reforge', 0, 100, 100, 5, 0, 35, 0, 0, 1, 1.14286, 1.14286, 1, 0, 0, 1, 2000, 2000, 1, 1, 2, 512, 2048, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 3, 1, 3, 3, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '', 25549);
DELETE FROM `creature_template` WHERE `entry`=101989;
INSERT INTO `creature_template` (`entry`, `modelid1`, `modelid2`, `name`, `femaleName`, `subname`, `IconName`, `gossip_menu_id`, `minlevel`, `maxlevel`, `exp`, `exp_req`, `faction`, `npcflag`, `npcflag2`, `speed_walk`, `speed_run`, `speed_fly`, `scale`, `rank`, `dmgschool`, `dmg_multiplier`, `baseattacktime`, `rangeattacktime`, `baseVariance`, `rangeVariance`, `unit_class`, `unit_flags`, `unit_flags2`, `unit_flags3`, `dynamicflags`, `WorldEffectID`, `family`, `trainer_type`, `trainer_spell`, `trainer_class`, `trainer_race`, `type`, `type_flags`, `type_flags2`, `lootid`, `pickpocketloot`, `skinloot`, `resistance1`, `resistance2`, `resistance3`, `resistance4`, `resistance5`, `resistance6`, `spell1`, `spell2`, `spell3`, `spell4`, `spell5`, `spell6`, `spell7`, `spell8`, `PetSpellDataId`, `VehicleId`, `mingold`, `maxgold`, `AIName`, `MovementType`, `InhabitType`, `HoverHeight`, `Health_mod`, `Mana_mod`, `Mana_mod_extra`, `Armor_mod`, `RacialLeader`, `questItem1`, `questItem2`, `questItem3`, `questItem4`, `questItem5`, `questItem6`, `movementId`, `TrackingQuestID`, `VignetteID`, `RegenHealth`, `equipment_id`, `mechanic_immune_mask`, `flags_extra`, `ScriptName`, `BuildVerified`) VALUES (101989, 47231, 0, 'Voidbinder Tarazuuk', '', 'Item Upgrade', 'reforge', 0, 100, 100, 5, 0, 35, 0, 0, 1, 1.14286, 1.14286, 1, 0, 0, 1, 2000, 2000, 1, 1, 2, 512, 2048, 0, 0, 0, 0, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, '', 0, 3, 1, 3, 3, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, '', 25549);
DELETE FROM `creature` WHERE `guid`=610111962;
INSERT INTO `creature` (`guid`, `id`, `map`, `zoneId`, `areaId`, `spawnMask`, `phaseMask`, `modelid`, `equipment_id`, `position_x`, `position_y`, `position_z`, `orientation`, `spawntimesecs`, `spawndist`, `currentwaypoint`, `curhealth`, `curmana`, `MovementType`, `npcflag`, `npcflag2`, `unit_flags`, `unit_flags2`, `unit_flags3`, `dynamicflags`, `WorldEffectID`, `isActive`, `protec_anti_doublet`) VALUES (610111962, 101988, 1116, 6941, 7333, 1, 1, 0, 0, 5262.69, -4054.62, 22.8482, 5.0968, 300, 0, 0, 120, 0, 0, 0, 0, 0, 2048, 0, 0, 0, 0, NULL);
