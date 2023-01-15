////////////////////////////////////////////////////////////////////////////////
//
// Project-Hellscream https://hellscream.org
// Copyright (C) 2018-2020 Project-Hellscream-6.2
// Discord https://discord.gg/CWCF3C9
//
////////////////////////////////////////////////////////////////////////////////

/* ScriptData
SDName: Orgrimmar
SD%Complete: 0
SDComment: Quest support:
SDCategory: Orgrimmar
EndScriptData */

/* ContentData
EndContentData */

#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "ScriptedGossip.h"
#include "Vehicle.h"


/// Watershed Telescope - Raggan - 39320
class npc_durotar_watershed_telescope_39320 : public CreatureScript
{
public:
	npc_durotar_watershed_telescope_39320() : CreatureScript("npc_durotar_watershed_telescope_39320") { }

	enum eQuest
	{
		EVENT_TIMEOUT = 1,
		EVENT_EMOTE = 2,
		EVENT_FINALE = 3,
	};

	struct npc_durotar_watershed_telescope_39320AI : public ScriptedAI
	{
		npc_durotar_watershed_telescope_39320AI(Creature* creature) : ScriptedAI(creature) { }

		uint64 m_playerGUID;
		uint64 m_homeGUID;
		EventMap m_events;
		Position pos;

		void InitializeAI() override
		{
			m_playerGUID = me->GetCharmerOrOwnerOrOwnGUID();
			m_events.ScheduleEvent(EVENT_TIMEOUT, 60000);
			me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NON_ATTACKABLE);
			if (Player* player = ObjectAccessor::GetPlayer(*me, m_playerGUID))
				if (GameObject* gobject = player->FindNearestGameObject(301050, 10.0f))
				{
					player->GetPosition(&pos);
					m_homeGUID = gobject->GetGUID();
				}
		}

		void PassengerBoarded(Unit* passenger, int8 seatId, bool apply) override
		{
			me->SetSpeed(MOVE_RUN, 12.0f);
			me->GetMotionMaster()->MovePath(3932001, false);
		}

		void MovementInform(uint32 type, uint32 pointId) override
		{
			if (type == WAYPOINT_MOTION_TYPE)
				if (pointId == 2)
					m_events.ScheduleEvent(EVENT_EMOTE, 4000);
				else if (pointId == 3)
					m_events.ScheduleEvent(EVENT_FINALE, 1000);
		}

		void UpdateAI(uint32 diff) override
		{
			m_events.Update(diff);

			while (uint32 eventId = m_events.ExecuteEvent())
			{
				switch (eventId)
				{
				case EVENT_TIMEOUT:
				{
					me->DespawnOrUnsummon(100);
					break;
				}
				case EVENT_EMOTE:
				{
					if (Creature* npc = me->FindNearestCreature(39326, 30.0f))
						npc->HandleEmoteCommand(EMOTE_ONESHOT_ROAR);
					break;
				}
				case EVENT_FINALE:
				{
					if (Player* player = ObjectAccessor::GetPlayer(*me, m_playerGUID))
						if (GameObject* go = ObjectAccessor::GetGameObject(*me, m_homeGUID))
						{
							player->KilledMonsterCredit(39357);
							player->ExitVehicle();
							player->NearTeleportTo(go->GetPositionX(), go->GetPositionY(), go->GetPositionZ(), go->GetOrientation());
							me->DespawnOrUnsummon(100);
						}
					break;
				}
				}
			}
		}
	};

	CreatureAI* GetAI(Creature* creature) const override
	{
		return new npc_durotar_watershed_telescope_39320AI(creature);
	}
};

/// Watershed Telescope - Tekla - 39345
class npc_durotar_watershed_telescope_39345 : public CreatureScript
{
public:
	npc_durotar_watershed_telescope_39345() : CreatureScript("npc_durotar_watershed_telescope_39345") { }

	enum eQuest
	{
		EVENT_TIMEOUT = 1,
		EVENT_FINALE = 2,
	};

	struct npc_durotar_watershed_telescope_39345AI : public ScriptedAI
	{
		npc_durotar_watershed_telescope_39345AI(Creature* creature) : ScriptedAI(creature) { }

		uint64 m_playerGUID;
		uint64 m_homeGUID;
		EventMap m_events;
		Position pos;

		void InitializeAI() override
		{
			m_playerGUID = me->GetCharmerOrOwnerOrOwnGUID();
			m_events.ScheduleEvent(EVENT_TIMEOUT, 60000);
			me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NON_ATTACKABLE);
			if (Player* player = ObjectAccessor::GetPlayer(*me, m_playerGUID))
				if (GameObject* gobject = player->FindNearestGameObject(301050, 10.0f))
				{
					player->GetPosition(&pos);
					m_homeGUID = gobject->GetGUID();
				}
		}

		void PassengerBoarded(Unit* passenger, int8 seatId, bool apply) override
		{
			me->SetSpeed(MOVE_RUN, 12.0f);
			me->GetMotionMaster()->MovePath(3934501, false);
		}

		void MovementInform(uint32 type, uint32 pointId) override
		{
			if (type == WAYPOINT_MOTION_TYPE && pointId == 3)
				m_events.ScheduleEvent(EVENT_FINALE, 1000);
		}

		void UpdateAI(uint32 diff) override
		{
			m_events.Update(diff);

			while (uint32 eventId = m_events.ExecuteEvent())
			{
				switch (eventId)
				{
				case EVENT_TIMEOUT:
				{
					me->DespawnOrUnsummon(100);
					break;
				}
				case EVENT_FINALE:
				{
					if (Player* player = ObjectAccessor::GetPlayer(*me, m_playerGUID))
						if (GameObject* go = ObjectAccessor::GetGameObject(*me, m_homeGUID))
						{
							player->KilledMonsterCredit(39358);
							player->ExitVehicle();
							player->NearTeleportTo(go->GetPositionX(), go->GetPositionY(), go->GetPositionZ(), go->GetOrientation());
							me->DespawnOrUnsummon(100);
						}
					break;
				}
				}
			}
		}
	};

	CreatureAI* GetAI(Creature* creature) const override
	{
		return new npc_durotar_watershed_telescope_39345AI(creature);
	}
};

/// Watershed Telescope - Misha - 39346
class npc_durotar_watershed_telescope_39346 : public CreatureScript
{
public:
	npc_durotar_watershed_telescope_39346() : CreatureScript("npc_durotar_watershed_telescope_39346") { }

	enum eQuest
	{
		EVENT_TIMEOUT = 1,
		EVENT_FINALE = 2,
	};

	struct npc_durotar_watershed_telescope_39346AI : public ScriptedAI
	{
		npc_durotar_watershed_telescope_39346AI(Creature* creature) : ScriptedAI(creature) { }

		uint64 m_playerGUID;
		uint64 m_homeGUID;
		EventMap m_events;
		Position pos;

		void InitializeAI() override
		{
			m_playerGUID = me->GetCharmerOrOwnerOrOwnGUID();
			m_events.ScheduleEvent(EVENT_TIMEOUT, 60000);
			me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NON_ATTACKABLE);
			if (Player* player = ObjectAccessor::GetPlayer(*me, m_playerGUID))
				if (GameObject* gobject = player->FindNearestGameObject(301050, 10.0f))
				{
					player->GetPosition(&pos);
					m_homeGUID = gobject->GetGUID();
				}
		}

		void PassengerBoarded(Unit* passenger, int8 seatId, bool apply) override
		{
			me->SetSpeed(MOVE_RUN, 12.0f);
			me->GetMotionMaster()->MovePath(3934601, false);
		}

		void MovementInform(uint32 type, uint32 pointId) override
		{
			if (type == WAYPOINT_MOTION_TYPE && pointId == 3)
				m_events.ScheduleEvent(EVENT_FINALE, 1000);
		}

		void UpdateAI(uint32 diff) override
		{
			m_events.Update(diff);

			while (uint32 eventId = m_events.ExecuteEvent())
			{
				switch (eventId)
				{
				case EVENT_TIMEOUT:
				{
					me->DespawnOrUnsummon(100);
					break;
				}
				case EVENT_FINALE:
				{
					if (Player* player = ObjectAccessor::GetPlayer(*me, m_playerGUID))
						if (GameObject* go = ObjectAccessor::GetGameObject(*me, m_homeGUID))
						{
							player->KilledMonsterCredit(39359);
							player->ExitVehicle();
							player->NearTeleportTo(go->GetPositionX(), go->GetPositionY(), go->GetPositionZ(), go->GetOrientation());
							me->DespawnOrUnsummon(100);
						}
					break;
				}
				}
			}
		}
	};

	CreatureAI* GetAI(Creature* creature) const override
	{
		return new npc_durotar_watershed_telescope_39346AI(creature);
	}
};

/// Watershed Telescope - Zen'Taji - 39347
class npc_durotar_watershed_telescope_39347 : public CreatureScript
{
public:
	npc_durotar_watershed_telescope_39347() : CreatureScript("npc_durotar_watershed_telescope_39347") { }

	enum eQuest
	{
		EVENT_TIMEOUT = 1,
		EVENT_FINALE = 2,
	};

	struct npc_durotar_watershed_telescope_39347AI : public ScriptedAI
	{
		npc_durotar_watershed_telescope_39347AI(Creature* creature) : ScriptedAI(creature) { }

		uint64 m_playerGUID;
		uint64 m_homeGUID;
		EventMap m_events;
		Position pos;

		void InitializeAI() override
		{
			m_playerGUID = me->GetCharmerOrOwnerOrOwnGUID();
			m_events.ScheduleEvent(EVENT_TIMEOUT, 60000);
			me->SetFlag(UNIT_FIELD_FLAGS, UNIT_FLAG_NON_ATTACKABLE);
			if (Player* player = ObjectAccessor::GetPlayer(*me, m_playerGUID))
				if (GameObject* gobject = player->FindNearestGameObject(301050, 10.0f))
				{
					player->GetPosition(&pos);
					m_homeGUID = gobject->GetGUID();
				}
		}

		void PassengerBoarded(Unit* passenger, int8 seatId, bool apply) override
		{
			me->SetSpeed(MOVE_RUN, 12.0f);
			me->GetMotionMaster()->MovePath(3934701, false);
		}

		void MovementInform(uint32 type, uint32 pointId) override
		{
			if (type == WAYPOINT_MOTION_TYPE && pointId == 3)
				m_events.ScheduleEvent(EVENT_FINALE, 1000);
		}

		void UpdateAI(uint32 diff) override
		{
			m_events.Update(diff);

			while (uint32 eventId = m_events.ExecuteEvent())
			{
				switch (eventId)
				{
				case EVENT_TIMEOUT:
				{
					me->DespawnOrUnsummon(100);
					break;
				}
				case EVENT_FINALE:
				{
					if (Player* player = ObjectAccessor::GetPlayer(*me, m_playerGUID))
						if (GameObject* go = ObjectAccessor::GetGameObject(*me, m_homeGUID))
						{
							player->KilledMonsterCredit(39360);
							player->ExitVehicle();
							player->NearTeleportTo(go->GetPositionX(), go->GetPositionY(), go->GetPositionZ(), go->GetOrientation());
							me->DespawnOrUnsummon(100);
						}
					break;
				}
				}
			}
		}
	};

	CreatureAI* GetAI(Creature* creature) const override
	{
		return new npc_durotar_watershed_telescope_39347AI(creature);
	}
};

/// Muddy Crawfish - 42548
class npc_muddy_crawfish_42548 : public CreatureScript
{
public:
	npc_muddy_crawfish_42548() : CreatureScript("npc_muddy_crawfish_42548") { }

	struct npc_muddy_crawfish_42548AI : public ScriptedAI
	{
		npc_muddy_crawfish_42548AI(Creature* creature) : ScriptedAI(creature) { }

		void OnSpellClick(Unit* clicker)  override
		{
			if (Player* player = clicker->ToPlayer())
				if (player->GetQuestStatus(26226) == QUEST_STATUS_INCOMPLETE)
					me->DespawnOrUnsummon(500);
		}
	};

	CreatureAI* GetAI(Creature* creature) const override
	{
		return new npc_muddy_crawfish_42548AI(creature);
	}
};

/// Spell: Waters of Farseeing - 94687
class spell_waters_of_farseeing_94687 : public SpellScriptLoader
{
public:
	spell_waters_of_farseeing_94687() : SpellScriptLoader("spell_waters_of_farseeing_94687") { }

	class spell_waters_of_farseeing_94687_AuraScript : public AuraScript
	{
		PrepareAuraScript(spell_waters_of_farseeing_94687_AuraScript);

		void OnApply(AuraEffect const* aurEff, AuraEffectHandleModes mode)
		{
			if (aurEff->GetMiscValue() == 807)
				if (Unit* caster = GetCaster())
					if (Player* player = caster->ToPlayer())
						if (player->GetQuestStatus(28805) == QUEST_STATUS_INCOMPLETE || player->GetQuestStatus(28826) == QUEST_STATUS_INCOMPLETE)
							player->KilledMonsterCredit(50054);
		}

		void Register()
		{
			OnEffectApply += AuraEffectApplyFn(spell_waters_of_farseeing_94687_AuraScript::OnApply, EFFECT_0, SPELL_AURA_SCREEN_EFFECT, AURA_EFFECT_HANDLE_REAL);
		}
	};

	AuraScript* GetAuraScript() const override
	{
		return new spell_waters_of_farseeing_94687_AuraScript();
	}
};


/// Thonk's Spyglass - 52514 
class item_thonks_spyglass_52514 : public ItemScript
{
public:
	item_thonks_spyglass_52514() : ItemScript("item_thonks_spyglass_52514") { }

	bool OnUse(Player* player, Item* item, SpellCastTargets const& targets) override
	{
		if (player->GetQuestStatus(25187) == QUEST_STATUS_INCOMPLETE)
		{
			if (!player->GetReqKillOrCastCurrentCount(25187, 39357))
				player->CastSpell(player, 73741, TRIGGERED_NONE);
			else if (!player->GetReqKillOrCastCurrentCount(25187, 39358))
				player->CastSpell(player, 73763, TRIGGERED_NONE);
			else if (!player->GetReqKillOrCastCurrentCount(25187, 39359))
				player->CastSpell(player, 73764, TRIGGERED_NONE);
			else if (!player->GetReqKillOrCastCurrentCount(25187, 39360))
				player->CastSpell(player, 73765, TRIGGERED_NONE);
		}

		return false;
	}
};


void AddSC_orgrimmar()
{
	/// Npcs
	new npc_durotar_watershed_telescope_39320();
	new npc_durotar_watershed_telescope_39345();
	new npc_durotar_watershed_telescope_39346();
	new npc_durotar_watershed_telescope_39347();
	new npc_muddy_crawfish_42548();

	/// Spells
	new spell_waters_of_farseeing_94687();

	/// Items
	new item_thonks_spyglass_52514();
}

