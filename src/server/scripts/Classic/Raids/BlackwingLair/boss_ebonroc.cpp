////////////////////////////////////////////////////////////////////////////////
//
// Project-Hellscream https://hellscream.org
// Copyright (C) 2018-2020 Project-Hellscream-6.2
// Discord https://discord.gg/CWCF3C9
//
////////////////////////////////////////////////////////////////////////////////

/* ScriptData
SDName: Boss_Ebonroc
SD%Complete: 100
Dev: Hazor
SDCategory: Blackwing Lair
EndScriptData */

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "blackwing_lair.h"

enum Spells
{
	SPELL_SHADOWFLAME = 22539,
	SPELL_WINGBUFFET = 23339,
	SPELL_SHADOWOFEBONROC = 23340
};

enum Events
{
	EVENT_SHADOWFLAME = 1,
	EVENT_WINGBUFFET = 2,
	EVENT_SHADOWOFEBONROC = 3
};

class boss_ebonroc : public CreatureScript
{
public:
	boss_ebonroc() : CreatureScript("boss_ebonroc") { }

	struct boss_ebonrocAI : public BossAI
	{
		boss_ebonrocAI(Creature* creature) : BossAI(creature, DATA_EBONROC) { }

		void EnterCombat(Unit* /*who*/) override
		{
			if (instance && instance->GetBossState(DATA_BROODLORD_LASHLAYER) != DONE)
			{
				EnterEvadeMode();
				return;
			}
			_EnterCombat();

			events.ScheduleEvent(EVENT_SHADOWFLAME, urand(10000, 20000));
			events.ScheduleEvent(EVENT_WINGBUFFET, 30000);
			events.ScheduleEvent(EVENT_SHADOWOFEBONROC, urand(8000, 10000));
		}

		void UpdateAI(uint32 diff) override
		{
			if (!UpdateVictim())
				return;

			events.Update(diff);

			if (me->HasUnitState(UNIT_STATE_CASTING))
				return;

			while (uint32 eventId = events.ExecuteEvent())
			{
				switch (eventId)
				{
				case EVENT_SHADOWFLAME:
					DoCastVictim(SPELL_SHADOWFLAME);
					events.ScheduleEvent(EVENT_SHADOWFLAME, urand(10000, 20000));
					break;
				case EVENT_WINGBUFFET:
					DoCastVictim(SPELL_WINGBUFFET);
					events.ScheduleEvent(EVENT_WINGBUFFET, 30000);
					break;
				case EVENT_SHADOWOFEBONROC:
					DoCastVictim(SPELL_SHADOWOFEBONROC);
					events.ScheduleEvent(EVENT_SHADOWOFEBONROC, urand(8000, 10000));
					break;
				}
			}

			DoMeleeAttackIfReady();
		}
	};

	CreatureAI* GetAI(Creature* creature) const override
	{
		return new boss_ebonrocAI(creature);
	}
};

void AddSC_boss_ebonroc()
{
	new boss_ebonroc();
}