#ifndef DEF_SCARLET_H
#define DEF_SCARLET_H

enum Data
{
	DATA_HOUNDMASTER_BRAUN,
	DATA_ARMSMASTER_HARLAN,
	DATA_FLAMEWEAVER_KOEGLER,
	MAX_ENCOUNTER,

	DATA_COMMANDER_LINDON,

	TEAM_IN_INSTANCE,
};

enum Creatures
{
	NPC_HOUNDMASTER_BRAUN = 59303,
	NPC_ARMSMASTER_HARLAN = 58632,
	NPC_FLAMEWEAVER_KOEGLER = 59150,

	NPC_HOODED_CRUSADER = 64738,
	NPC_HOODED_CRUSADER_2 = 64764, // in heroic

	NPC_VIGILANT_WATCHMAN = 58898,
	NPC_STARVING_HOUND = 58876,
	NPC_ANGRY_HOUND = 58674,
	NPC_REINFORCED_ARCHERY_TARGET = 59163,
	NPC_ARCHERY_TARGET_BASE = 60908, // is vehicle for 59163
	NPC_COMMANDER_LINDON = 59191,
	NPC_MASTER_ARCHER = 59175,
	NPC_OBEDIENT_HOUND = 59309,
	NPC_SERGEANT_VERDONE = 59302,
	NPC_SCARLET_MYRMIDON = 58683,
	NPC_SCARLET_SCOURGE_HEWER = 58684,
	NPC_SCARLET_EVANGELIST = 58685,
	NPC_SCARLET_CANNONEER = 59293,
	NPC_SCARLET_DEFENDER = 58676,
	NPC_SCARLET_EVOKER = 58756,
	NPC_SCARLET_TREASURER = 59241,
	NPC_SCARLET_HALL_GUARDIAN = 59240,
	NPC_SCARLET_PUPIL = 59373,
	NPC_SCARLET_SCHOLAR = 59372,

	MOB_BOOK = 59155
};

enum GameObjects
{
	ChallengeDoor = 211989
};

#define SCENARIO_ID 52

enum Criterias
{
	CRITERIA_BRAUN = 19266,
	CRITERIA_HARLAN = 19268,
	CRITERIA_KOEGLER = 19269,
	CRITERIA_ENEMIES = 20057,
};

#endif