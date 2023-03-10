-- Remove emotes
UPDATE `creature_addon` SET `emote`=0 WHERE `guid` BETWEEN 87106 AND 87118;
UPDATE `creature_addon` SET `emote`=0 WHERE `guid`=87169;

-- Pathing
DELETE FROM `creature_formations` WHERE `leaderGUID`=87200;
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`) VALUES
(87200, 87200, 0, 0, 1),
(87200, 87201, 2, 90, 2);

-- Pathing for Silver Covenant Horseman Entry: 30263 'TDB FORMAT' 
SET @NPC := 87200;
SET @PATH := @NPC * 10;
UPDATE `creature` SET `spawndist`=0,`MovementType`=2,`position_x`=5067.709,`position_y`=-623.0535,`position_z`=216.2992 WHERE `guid` IN (@NPC, @NPC+1);
DELETE FROM `creature_addon` WHERE `guid`=@NPC;
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES (@NPC,@PATH,2410,0,1,0, '');
DELETE FROM `creature_addon` WHERE `guid`=@NPC+1;
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES (@NPC+1,0,2410,0,1,0, '');
DELETE FROM `waypoint_data` WHERE `id`=@PATH;
INSERT INTO `waypoint_data` (`id`,`point`,`position_x`,`position_y`,`position_z`,`orientation`,`delay`,`move_type`,`action`,`action_chance`,`wpguid`) VALUES
(@PATH,1,5067.709,-623.0535,216.2992,0,0,0,0,100,0), -- 20:33:40
(@PATH,2,5064.371,-619.6366,217.7106,0,0,0,0,100,0), -- 20:33:46
(@PATH,3,5064.18,-607.0121,219.5005,0,0,0,0,100,0), -- 20:33:50
(@PATH,4,5065.22,-602.5242,220.0495,0,0,0,0,100,0), -- 20:33:56
(@PATH,5,5064.4,-593.0133,220.2778,0,0,0,0,100,0), -- 20:33:59
(@PATH,6,5062.952,-571.7712,220.2518,0,0,0,0,100,0), -- 20:34:08
(@PATH,7,5062.632,-572.1309,220.0737,0,0,0,0,100,0), -- 20:34:17
(@PATH,8,5062.766,-572.0648,220.3171,0,0,0,0,100,0), -- 20:34:24
(@PATH,9,5064.708,-593.1912,220.1846,0,0,0,0,100,0), -- 20:34:32
(@PATH,10,5063.012,-612.4286,219.0811,0,0,0,0,100,0), -- 20:34:36
(@PATH,11,5066.325,-621.582,216.7641,0,0,0,0,100,0), -- 20:34:42
(@PATH,12,5067.825,-623.082,216.2641,0,0,0,0,100,0); -- 20:34:42
-- 0x1C392447601D8DC000000C000077FF13 .go 5067.709 -623.0535 216.2992

DELETE FROM `creature_formations` WHERE `leaderGUID`=887202;
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`) VALUES
(887202, 887202, 0, 0, 1),
(887202, 887203, 2, 90, 2);

-- Pathing for Silver Covenant Horseman Entry: 30263 'TDB FORMAT' 
SET @NPC := 887202;
SET @PATH := @NPC * 10;
UPDATE `creature` SET `spawndist`=0,`MovementType`=2,`position_x`=5076.637,`position_y`=-639.3936,`position_z`=210.1455 WHERE `guid` IN (@NPC, @NPC+1);
DELETE FROM `creature_addon` WHERE `guid`=@NPC;
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES (@NPC,@PATH,2410,0,1,0, '');
DELETE FROM `creature_addon` WHERE `guid`=@NPC+1;
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES (@NPC+1,0,2410,0,1,0, '');
DELETE FROM `waypoint_data` WHERE `id`=@PATH;
INSERT INTO `waypoint_data` (`id`,`point`,`position_x`,`position_y`,`position_z`,`orientation`,`delay`,`move_type`,`action`,`action_chance`,`wpguid`) VALUES
(@PATH,1,5076.637,-639.3936,210.1455,0,0,0,0,100,0), -- 11:59:49
(@PATH,2,5079.917,-659.7036,200.968,0,0,0,0,100,0), -- 12:00:00
(@PATH,3,5079.445,-679.8152,193.9069,0,0,0,0,100,0), -- 12:00:08
(@PATH,4,5081.471,-688.5268,190.5579,0,0,0,0,100,0), -- 12:00:17
(@PATH,5,5091.792,-703.2252,184.7582,0,0,0,0,100,0), -- 12:00:22
(@PATH,6,5099.77,-708.3243,181.946,0,0,0,0,100,0), -- 12:00:29
(@PATH,7,5094.969,-706.1178,183.7631,0,0,0,0,100,0), -- 12:00:34
(@PATH,8,5082.577,-691.327,189.5212,0,0,0,0,100,0), -- 12:00:36
(@PATH,9,5080.255,-683.3011,192.4193,0,0,0,0,100,0), -- 12:00:45
(@PATH,10,5080.166,-662.0288,199.9953,0,0,0,0,100,0); -- 12:00:49
-- 0x1C392447601D8DC000000C000077FF7B .go 5076.637 -639.3936 210.1455

DELETE FROM `creature_formations` WHERE `leaderGUID`=87206;
INSERT INTO `creature_formations` (`leaderGUID`, `memberGUID`, `dist`, `angle`, `groupAI`) VALUES
(87206, 87206, 0, 0, 1),
(87206, 87207, 2, 90, 2);

-- Pathing for Silver Covenant Horseman Entry: 30263 'TDB FORMAT' 
SET @NPC := 87206;
SET @PATH := @NPC * 10;
UPDATE `creature` SET `spawndist`=0,`MovementType`=2,`position_x`=5060.026,`position_y`=-538.408,`position_z`=220.0076 WHERE `guid` IN (@NPC, @NPC+1);
DELETE FROM `creature_addon` WHERE `guid`=@NPC;
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES (@NPC,@PATH,2410,0,1,0, '');
DELETE FROM `creature_addon` WHERE `guid`=@NPC+1;
INSERT INTO `creature_addon` (`guid`,`path_id`,`mount`,`bytes1`,`bytes2`,`emote`,`auras`) VALUES (@NPC+1,0,2410,0,1,0, '');
DELETE FROM `waypoint_data` WHERE `id`=@PATH;
INSERT INTO `waypoint_data` (`id`,`point`,`position_x`,`position_y`,`position_z`,`orientation`,`delay`,`move_type`,`action`,`action_chance`,`wpguid`) VALUES
(@PATH,1,5060.026,-538.408,220.0076,0,0,0,0,100,0), -- 12:00:56
(@PATH,2,5059.559,-537.8341,220.0076,2.070161,0,0,0,100,0), -- 12:00:57
(@PATH,3,5058.987,-537.1638,220.0076,0,0,0,0,100,0), -- 12:00:57
(@PATH,4,5057.041,-534.8303,219.9673,0,0,0,0,100,0), -- 12:00:58
(@PATH,5,5055.152,-532.5667,219.8454,0,0,0,0,100,0), -- 12:00:59
(@PATH,6,5053.768,-528.5505,219.8488,0,0,0,0,100,0), -- 12:01:01
(@PATH,7,5054.296,-525.5225,219.4218,0,0,0,0,100,0), -- 12:01:02
(@PATH,8,5055.446,-521.4495,219.3181,0,0,0,0,100,0), -- 12:01:03
(@PATH,9,5057.875,-519.7457,218.8674,0,0,0,0,100,0), -- 12:01:04
(@PATH,10,5059.473,-518.8138,218.6286,0,0,0,0,100,0), -- 12:01:05
(@PATH,11,5061.776,-517.084,217.916,0,0,0,0,100,0), -- 12:01:07
(@PATH,12,5064.104,-515.4176,217.0972,0,0,0,0,100,0), -- 12:01:08
(@PATH,13,5065.635,-514.3111,215.9073,0,0,0,0,100,0), -- 12:01:09
(@PATH,14,5068.912,-512.2123,214.4262,0,0,0,0,100,0), -- 12:01:10
(@PATH,15,5070.144,-511.1482,213.5484,0,0,0,0,100,0), -- 12:01:12
(@PATH,16,5073.149,-509.0605,212.3315,0,0,0,0,100,0), -- 12:01:13
(@PATH,17,5074.678,-507.9399,211.4917,0,0,0,0,100,0), -- 12:01:14
(@PATH,18,5078.117,-505.9191,209.5764,0,0,0,0,100,0), -- 12:01:15
(@PATH,19,5079.734,-505.1035,208.2059,0,0,0,0,100,0), -- 12:01:16
(@PATH,20,5082.03,-503.8705,206.9615,0,0,0,0,100,0), -- 12:01:18
(@PATH,21,5085.192,-502.0856,205.0636,0,0,0,0,100,0), -- 12:01:19
(@PATH,22,5087.563,-500.825,203.5342,0,0,0,0,100,0), -- 12:01:20
(@PATH,23,5088.891,-500.0888,202.8326,0,0,0,0,100,0), -- 12:01:21
(@PATH,24,5090.603,-499.18,201.682,0,0,0,0,100,0), -- 12:01:23
(@PATH,25,5090.519,-499.2244,201.7328,-2.536886,0,0,0,100,0), -- 12:01:23
(@PATH,26,5089.623,-499.7004,202.2772,0,0,0,0,100,0), -- 12:01:24
(@PATH,27,5088.674,-500.0867,202.9039,0,0,0,0,100,0), -- 12:01:25
(@PATH,28,5085.627,-501.6739,204.7783,0,0,0,0,100,0), -- 12:01:26
(@PATH,29,5083.288,-502.9158,206.4351,0,0,0,0,100,0), -- 12:01:27
(@PATH,30,5081.008,-504.1263,207.5976,0,0,0,0,100,0), -- 12:01:29
(@PATH,31,5078.845,-505.3429,208.9937,0,0,0,0,100,0), -- 12:01:30
(@PATH,32,5076.814,-506.5785,210.2388,0,0,0,0,100,0), -- 12:01:31
(@PATH,33,5073.882,-508.545,211.8869,0,0,0,0,100,0), -- 12:01:32
(@PATH,34,5072.41,-509.5816,212.7734,0,0,0,0,100,0), -- 12:01:33
(@PATH,35,5069.576,-511.4619,214.2128,0,0,0,0,100,0), -- 12:01:35
(@PATH,36,5067.752,-512.8409,215.1404,0,0,0,0,100,0), -- 12:01:36
(@PATH,37,5064.977,-514.6848,216.6034,0,0,0,0,100,0), -- 12:01:37
(@PATH,38,5063.138,-516.0745,217.341,0,0,0,0,100,0), -- 12:01:38
(@PATH,39,5060.213,-518.0273,218.5601,0,0,0,0,100,0), -- 12:01:40
(@PATH,40,5056.744,-520.0189,219.1413,0,0,0,0,100,0), -- 12:01:41
(@PATH,41,5054.522,-524.2232,219.3947,0,0,0,0,100,0), -- 12:01:42
(@PATH,42,5053.996,-527.2253,219.6623,0,0,0,0,100,0), -- 12:01:43
(@PATH,43,5053.982,-531.1642,219.9596,0,0,0,0,100,0), -- 12:01:44
(@PATH,44,5056.037,-533.6272,219.9433,0,0,0,0,100,0), -- 12:01:46
(@PATH,45,5058.094,-536.0921,219.9923,0,0,0,0,100,0), -- 12:01:47
(@PATH,46,5060.026,-538.408,220.0076,0,0,0,0,100,0); -- 12:01:48
-- 0x1C392447601D8DC000000C0000F7FF07 .go 5060.026 -538.408 220.0076