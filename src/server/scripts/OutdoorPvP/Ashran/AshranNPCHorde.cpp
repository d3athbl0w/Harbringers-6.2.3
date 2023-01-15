////////////////////////////////////////////////////////////////////////////////
//
// Project-Hellscream https://hellscream.org
// Copyright (C) 2018-2020 Project-Hellscream-6.2
// Discord https://discord.gg/CWCF3C9
//
////////////////////////////////////////////////////////////////////////////////

#include "AshranMgr.hpp"
#include "GameObject.h"

/// 1116 - Draenor
class map_draenor : public WorldMapScript
{
public:
	map_draenor() : WorldMapScript("map_draenor", 1116) { }

	void OnPlayerEnter(Map* p_Map, Player* /*p_Player*/) override
	{
		p_Map->SetObjectVisibility(100.0f);
	}
};

/// Jeron Emberfall <Warspear Tower Guardian> - 88178
class npc_jeron_emberfall : public CreatureScript
{
    public:
        npc_jeron_emberfall() : CreatureScript("npc_jeron_emberfall") { }

        struct npc_jeron_emberfallAI : public ScriptedAI
        {
            npc_jeron_emberfallAI(Creature* p_Creature) : ScriptedAI(p_Creature)
            {
                m_CheckAroundingPlayersTimer = 0;
                m_PhoenixStrikeTimer = 0;
            }

            enum eSpells
            {
                Fireball                = 176652,
                Ignite                  = 176600,
                CombustionNova          = 176605,
                CombustionNovaStun      = 176608,
                LivingBomb              = 176670,
                SummonLavaFury          = 176664,

                TargetedByTheTowerMage  = 176076,
                PhoenixStrikeSearcher   = 176086,
                PhoenixStrikeMissile    = 176066,

                ConjureRefreshment      = 176351
            };

            enum eTalk
            {
                TalkAggro,
                TalkSlay,
                TalkDeath,
                TalkSpell,
                TalkLivingBomb
            };

            enum eEvents
            {
                EventFireball = 1,
                EventIgnite,
                EventLivingBomb,
                EventCombustionNova
            };

            EventMap m_Events;

            uint32 m_CheckAroundingPlayersTimer;
            uint32 m_PhoenixStrikeTimer;

            void Reset() override
            {
                m_Events.Reset();

                me->RemoveFlag(EUnitFields::UNIT_FIELD_FLAGS, eUnitFlags::UNIT_FLAG_DISARMED);
            }

            void EnterCombat(Unit* /*p_Attacker*/) override
            {
                Talk(eTalk::TalkAggro);

                m_Events.ScheduleEvent(eEvents::EventFireball, 4000);
                m_Events.ScheduleEvent(eEvents::EventIgnite, 8000);
                m_Events.ScheduleEvent(eEvents::EventLivingBomb, 12000);
                m_Events.ScheduleEvent(eEvents::EventCombustionNova, 15000);
            }

            void KilledUnit(Unit* p_Who) override
            {
                if (p_Who->IsPlayer())
                    Talk(eTalk::TalkSlay);
            }

            void JustDied(Unit* /*p_Killer*/) override
            {
                Talk(eTalk::TalkDeath);
            }

            void SpellHitTarget(Unit* p_Victim, SpellInfo const* p_SpellInfo) override
            {
                if (p_Victim == nullptr)
                    return;

                switch (p_SpellInfo->Id)
                {
                    case eSpells::PhoenixStrikeSearcher:
                        me->CastSpell(p_Victim, eSpells::PhoenixStrikeMissile, false);
                        break;
                    case eSpells::CombustionNova:
                        if (p_Victim->HasAura(eSpells::Ignite))
                            me->CastSpell(p_Victim, eSpells::CombustionNovaStun, true);
                        break;
                    default:
                        break;
                }
            }

            void UpdateAI(uint32 const p_Diff) override
            {
                if (!UpdateVictim())
                {
                    ScheduleTargetingPlayers(p_Diff);
                    SchedulePhoenixStrike(p_Diff);
                    return;
                }

                m_Events.Update(p_Diff);

                if (me->HasUnitState(UNIT_STATE_CASTING))
                    return;

                switch (m_Events.ExecuteEvent())
                {
                    case eEvents::EventFireball:
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_RANDOM))
                            me->CastSpell(l_Target, eSpells::Fireball, false);
                        m_Events.ScheduleEvent(eEvents::EventFireball, 10000);
                        break;
                    case eEvents::EventIgnite:
                        Talk(eTalk::TalkSpell);
                        me->CastSpell(me, eSpells::Ignite, true);
                        m_Events.ScheduleEvent(eEvents::EventIgnite, 9000);
                        break;
                    case eEvents::EventLivingBomb:
                        Talk(eTalk::TalkLivingBomb);
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_RANDOM))
                            me->CastSpell(l_Target, eSpells::LivingBomb, false);
                        m_Events.ScheduleEvent(eEvents::EventLivingBomb, 15000);
                        break;
                    case eEvents::EventCombustionNova:
                        Talk(eTalk::TalkSpell);
                        me->CastSpell(me, eSpells::CombustionNova, false);
                        m_Events.ScheduleEvent(eEvents::EventCombustionNova, 20000);
                        break;
                    default:
                        break;
                }

                EnterEvadeIfOutOfCombatArea(p_Diff);
                DoMeleeAttackIfReady();
            }

            void ScheduleTargetingPlayers(uint32 const p_Diff)
            {
                if (!m_CheckAroundingPlayersTimer)
                    return;

                if (m_CheckAroundingPlayersTimer <= p_Diff)
                {
                    m_CheckAroundingPlayersTimer = 2500;

                    std::list<Player*> l_PlayerList;
                    me->GetPlayerListInGrid(l_PlayerList, 200.0f);

                    l_PlayerList.remove_if([this](Player* p_Player) -> bool
                    {
                        if (p_Player == nullptr)
                            return true;

                        if (!me->IsValidAttackTarget(p_Player))
                            return true;

                        if (p_Player->HasAura(eSpells::TargetedByTheTowerMage))
                            return true;

                        return false;
                    });

                    for (Player* l_Player : l_PlayerList)
                        l_Player->CastSpell(l_Player, eSpells::TargetedByTheTowerMage, true, nullptr, nullptr, me->GetGUID());
                }
                else
                    m_CheckAroundingPlayersTimer -= p_Diff;
            }

            void SchedulePhoenixStrike(uint32 const p_Diff)
            {
                if (!m_PhoenixStrikeTimer)
                    return;

                if (m_PhoenixStrikeTimer <= p_Diff)
                {
                    if (!me->isInCombat())
                        me->CastSpell(me, eSpells::PhoenixStrikeSearcher, true);
                    m_PhoenixStrikeTimer = 10000;
                }
                else
                    m_PhoenixStrikeTimer -= p_Diff;
            }

            void sGossipSelect(Player* p_Player, uint32 /*p_Sender*/, uint32 /*p_Action*/) override
            {
                p_Player->PlayerTalkClass->SendCloseGossip();
                me->CastSpell(p_Player, eSpells::ConjureRefreshment, false);
            }
        };

        CreatureAI* GetAI(Creature* p_Creature) const override
        {
            return new npc_jeron_emberfallAI(p_Creature);
        }
};

/// Warspear Shaman - 82438
class npc_ashran_warspear_shaman : public CreatureScript
{
    public:
        npc_ashran_warspear_shaman() : CreatureScript("npc_ashran_warspear_shaman") { }

        struct npc_ashran_warspear_shamanAI : public ScriptedAI
        {
            npc_ashran_warspear_shamanAI(Creature* p_Creature) : ScriptedAI(p_Creature) { }

            enum eDatas
            {
                EventCosmetic       = 1,
                EarthFury           = 82200,
                NatureChanneling    = 164850
            };

            EventMap m_Events;

            void Reset() override
            {
                m_Events.ScheduleEvent(eDatas::EventCosmetic, 5000);
            }

            void UpdateAI(uint32 const p_Diff) override
            {
                m_Events.Update(p_Diff);

                if (m_Events.ExecuteEvent() == eDatas::EventCosmetic)
                {
                    if (Creature* l_EarthFury = me->FindNearestCreature(eDatas::EarthFury, 15.0f))
                        me->CastSpell(l_EarthFury, eDatas::NatureChanneling, false);
                }

                if (!UpdateVictim())
                    return;

                DoMeleeAttackIfReady();
            }
        };

        CreatureAI* GetAI(Creature* p_Creature) const override
        {
            return new npc_ashran_warspear_shamanAI(p_Creature);
        }
};

/// Illandria Belore - 88675
class npc_ashran_illandria_belore : public CreatureScript
{
    public:
        npc_ashran_illandria_belore() : CreatureScript("npc_ashran_illandria_belore") { }

        enum eTalks
        {
            First,
            Second,
            Third,
            Fourth,
            Fifth
        };

        enum eData
        {
            RahmFlameheart  = 88676,
            ActionInit      = 0,
            ActionLoop      = 1,
            EventLoop       = 1
        };

        struct npc_ashran_illandria_beloreAI : public MS::AI::CosmeticAI
        {
            npc_ashran_illandria_beloreAI(Creature* p_Creature) : MS::AI::CosmeticAI(p_Creature) { }

            bool m_Init;
            EventMap m_Events;

            void Reset() override
            {
                m_Init = false;

                if (Creature* l_Creature = me->FindNearestCreature(eData::RahmFlameheart, 15.0f))
                {
                    if (l_Creature->AI())
                    {
                        m_Init = true;
                        l_Creature->AI()->DoAction(eData::ActionInit);
                        ScheduleAllTalks();
                    }
                }
            }

            void DoAction(int32 const p_Action) override
            {
                switch (p_Action)
                {
                    case eData::ActionInit:
                        if (m_Init)
                            break;
                        m_Init = true;
                        ScheduleAllTalks();
                        break;
                    default:
                        break;
                }
            }

            void ScheduleAllTalks()
            {
                AddTimedDelayedOperation(1 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::First); });
                AddTimedDelayedOperation(18 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Second); });
                AddTimedDelayedOperation(36 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Third); });
                AddTimedDelayedOperation(66 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Fourth); });
                AddTimedDelayedOperation(83 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Fifth); });
            }

            void LastOperationCalled() override
            {
                m_Events.ScheduleEvent(eData::EventLoop, 48 * TimeConstants::IN_MILLISECONDS);
            }

            void UpdateAI(const uint32 p_Diff) override
            {
                MS::AI::CosmeticAI::UpdateAI(p_Diff);

                m_Events.Update(p_Diff);

                if (m_Events.ExecuteEvent() == eData::EventLoop)
                {
                    if (Creature* l_Creature = me->FindNearestCreature(eData::RahmFlameheart, 15.0f))
                    {
                        if (l_Creature->AI())
                        {
                            l_Creature->AI()->DoAction(eData::ActionLoop);
                            ScheduleAllTalks();
                        }
                    }
                }
            }
        };

        CreatureAI* GetAI(Creature* p_Creature) const override
        {
            return new npc_ashran_illandria_beloreAI(p_Creature);
        }
};

/// Examiner Rahm Flameheart <The Reliquary> - 88676
class npc_ashran_examiner_rahm_flameheart : public CreatureScript
{
    public:
        npc_ashran_examiner_rahm_flameheart() : CreatureScript("npc_ashran_examiner_rahm_flameheart") { }

        enum eTalks
        {
            First,
            Second,
            Third,
            Fourth
        };

        enum eData
        {
            IllandriaBelore = 88675,
            ActionInit      = 0,
            ActionLoop      = 1
        };

        struct npc_ashran_examiner_rahm_flameheartAI : public MS::AI::CosmeticAI
        {
            npc_ashran_examiner_rahm_flameheartAI(Creature* p_Creature) : MS::AI::CosmeticAI(p_Creature) { }

            bool m_Init;

            void Reset() override
            {
                m_Init = false;

                if (Creature* l_Creature = me->FindNearestCreature(eData::IllandriaBelore, 15.0f))
                {
                    if (l_Creature->AI())
                    {
                        m_Init = true;
                        l_Creature->AI()->DoAction(eData::ActionInit);
                        ScheduleAllTalks();
                    }
                }
            }

            void DoAction(int32 const p_Action) override
            {
                switch (p_Action)
                {
                    case eData::ActionInit:
                        m_Init = true;
                        ScheduleAllTalks();
                        break;
                    case eData::ActionLoop:
                        ScheduleAllTalks();
                        break;
                    default:
                        break;
                }
            }

            void ScheduleAllTalks()
            {
                AddTimedDelayedOperation(10 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::First); });
                AddTimedDelayedOperation(27 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Second); });
                AddTimedDelayedOperation(75 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Third); });
                AddTimedDelayedOperation(92 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Fourth); });
            }
        };

        CreatureAI* GetAI(Creature* p_Creature) const override
        {
            return new npc_ashran_examiner_rahm_flameheartAI(p_Creature);
        }
};

/// Centurion Firescream <Warspear Tactician> - 88771
class npc_ashran_centurion_firescream : public CreatureScript
{
    public:
        npc_ashran_centurion_firescream() : CreatureScript("npc_ashran_centurion_firescream") { }

        struct npc_ashran_centurion_firescreamAI : public MS::AI::CosmeticAI
        {
            npc_ashran_centurion_firescreamAI(Creature* p_Creature) : MS::AI::CosmeticAI(p_Creature) { }

            void Reset() override
            {
                AddTimedDelayedOperation(20 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(0); });
            }

            void LastOperationCalled() override
            {
                Reset();
            }
        };

        CreatureAI* GetAI(Creature* p_Creature) const override
        {
            return new npc_ashran_centurion_firescreamAI(p_Creature);
        }
};

/// Legionnaire Hellaxe <Warspear Strategist> - 88772
class npc_ashran_legionnaire_hellaxe : public CreatureScript
{
    public:
        npc_ashran_legionnaire_hellaxe() : CreatureScript("npc_ashran_legionnaire_hellaxe") { }

        struct npc_ashran_legionnaire_hellaxeAI : public MS::AI::CosmeticAI
        {
            npc_ashran_legionnaire_hellaxeAI(Creature* p_Creature) : MS::AI::CosmeticAI(p_Creature) { }

            void Reset() override
            {
                AddTimedDelayedOperation(30 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(0); });
            }

            void LastOperationCalled() override
            {
                Reset();
            }
        };

        CreatureAI* GetAI(Creature* p_Creature) const override
        {
            return new npc_ashran_legionnaire_hellaxeAI(p_Creature);
        }
};

/// Kalgan <Warspear Warrior Leader> - 83830
class npc_ashran_kalgan : public CreatureScript
{
    public:
        npc_ashran_kalgan() : CreatureScript("npc_ashran_kalgan") { }

        enum eGossip
        {
            RidersSummoned = 84923
        };

        bool OnGossipHello(Player* p_Player, Creature* p_Creature) override
        {
            ZoneScript* l_ZoneScript = sOutdoorPvPMgr->GetOutdoorPvPToZoneId(p_Creature->GetZoneId());
            if (l_ZoneScript == nullptr)
                return false;

            if (OutdoorPvPAshran* l_Ashran = (OutdoorPvPAshran*)l_ZoneScript)
            {
                if (l_Ashran->IsArtifactEventLaunched(TeamId::TEAM_HORDE, eArtifactsDatas::CountForWarriorPaladin))
                {
                    p_Player->PlayerTalkClass->ClearMenus();
                    p_Player->SEND_GOSSIP_MENU(eGossip::RidersSummoned, p_Creature->GetGUID());
                    return true;
                }
            }

            return false;
        }

        struct npc_ashran_kalganAI : public ScriptedAI
        {
            npc_ashran_kalganAI(Creature* p_Creature) : ScriptedAI(p_Creature) { }

            void sGossipSelect(Player* p_Player, uint32 /*p_Sender*/, uint32 p_Action) override
            {
                /// "Take all of my Artifact Fragments" is always 0
                if (p_Action)
                    return;

                ZoneScript* l_ZoneScript = sOutdoorPvPMgr->GetOutdoorPvPToZoneId(me->GetZoneId());
                if (l_ZoneScript == nullptr)
                    return;

                uint32 l_ArtifactCount = p_Player->GetCurrency(CurrencyTypes::CURRENCY_TYPE_ARTIFACT_FRAGEMENT, true);
                p_Player->ModifyCurrency(CurrencyTypes::CURRENCY_TYPE_ARTIFACT_FRAGEMENT, -int32(l_ArtifactCount * CURRENCY_PRECISION), false);

                if (OutdoorPvPAshran* l_Ashran = (OutdoorPvPAshran*)l_ZoneScript)
                {
                    l_Ashran->AddCollectedArtifacts(TeamId::TEAM_HORDE, eArtifactsDatas::CountForWarriorPaladin, l_ArtifactCount);
                    l_Ashran->RewardHonorAndReputation(l_ArtifactCount, p_Player);
                }
            }
        };

        CreatureAI* GetAI(Creature* p_Creature) const override
        {
            return new npc_ashran_kalganAI(p_Creature);
        }
};

/// Fura <Warspear Mage Leader> - 83995
class npc_ashran_fura : public CreatureScript
{
    public:
        npc_ashran_fura() : CreatureScript("npc_ashran_fura") { }

        enum eGossip
        {
            PortalInvoked = 84919
        };

        bool OnGossipHello(Player* p_Player, Creature* p_Creature) override
        {
            ZoneScript* l_ZoneScript = sOutdoorPvPMgr->GetOutdoorPvPToZoneId(p_Creature->GetZoneId());
            if (l_ZoneScript == nullptr)
                return false;

            if (OutdoorPvPAshran* l_Ashran = (OutdoorPvPAshran*)l_ZoneScript)
            {
                if (l_Ashran->IsArtifactEventLaunched(TeamId::TEAM_HORDE, eArtifactsDatas::CountForMage))
                {
                    p_Player->PlayerTalkClass->ClearMenus();
                    p_Player->SEND_GOSSIP_MENU(eGossip::PortalInvoked, p_Creature->GetGUID());
                    return true;
                }
            }

            return false;
        }

        struct npc_ashran_furaAI : public ScriptedAI
        {
            npc_ashran_furaAI(Creature* p_Creature) : ScriptedAI(p_Creature) { }

            void sGossipSelect(Player* p_Player, uint32 /*p_Sender*/, uint32 p_Action) override
            {
                /// "Take all of my Artifact Fragments" is always 0
                if (p_Action)
                    return;

                ZoneScript* l_ZoneScript = sOutdoorPvPMgr->GetOutdoorPvPToZoneId(me->GetZoneId());
                if (l_ZoneScript == nullptr)
                    return;

                uint32 l_ArtifactCount = p_Player->GetCurrency(CurrencyTypes::CURRENCY_TYPE_ARTIFACT_FRAGEMENT, true);
                p_Player->ModifyCurrency(CurrencyTypes::CURRENCY_TYPE_ARTIFACT_FRAGEMENT, -int32(l_ArtifactCount * CURRENCY_PRECISION), false);

                if (OutdoorPvPAshran* l_Ashran = (OutdoorPvPAshran*)l_ZoneScript)
                {
                    l_Ashran->AddCollectedArtifacts(TeamId::TEAM_HORDE, eArtifactsDatas::CountForMage, l_ArtifactCount);
                    l_Ashran->RewardHonorAndReputation(l_ArtifactCount, p_Player);
                }
            }
        };

        CreatureAI* GetAI(Creature* p_Creature) const override
        {
            return new npc_ashran_furaAI(p_Creature);
        }
};

/// Nisstyr <Warspear Warlock Leader> - 83997
class npc_ashran_nisstyr : public CreatureScript
{
    public:
        npc_ashran_nisstyr() : CreatureScript("npc_ashran_nisstyr") { }

        enum eGossip
        {
            GatewaysInvoked = 85463
        };

        bool OnGossipHello(Player* p_Player, Creature* p_Creature) override
        {
            ZoneScript* l_ZoneScript = sOutdoorPvPMgr->GetOutdoorPvPToZoneId(p_Creature->GetZoneId());
            if (l_ZoneScript == nullptr)
                return false;

            if (OutdoorPvPAshran* l_Ashran = (OutdoorPvPAshran*)l_ZoneScript)
            {
                if (l_Ashran->IsArtifactEventLaunched(TeamId::TEAM_HORDE, eArtifactsDatas::CountForWarlock))
                {
                    p_Player->PlayerTalkClass->ClearMenus();
                    p_Player->SEND_GOSSIP_MENU(eGossip::GatewaysInvoked, p_Creature->GetGUID());
                    return true;
                }
            }

            return false;
        }

        struct npc_ashran_nisstyrAI : public ScriptedAI
        {
            npc_ashran_nisstyrAI(Creature* p_Creature) : ScriptedAI(p_Creature) { }

            void sGossipSelect(Player* p_Player, uint32 /*p_Sender*/, uint32 p_Action) override
            {
                /// "Take all of my Artifact Fragments" is always 0
                if (p_Action)
                    return;

                ZoneScript* l_ZoneScript = sOutdoorPvPMgr->GetOutdoorPvPToZoneId(me->GetZoneId());
                if (l_ZoneScript == nullptr)
                    return;

                uint32 l_ArtifactCount = p_Player->GetCurrency(CurrencyTypes::CURRENCY_TYPE_ARTIFACT_FRAGEMENT, true);
                p_Player->ModifyCurrency(CurrencyTypes::CURRENCY_TYPE_ARTIFACT_FRAGEMENT, -int32(l_ArtifactCount * CURRENCY_PRECISION), false);

                if (OutdoorPvPAshran* l_Ashran = (OutdoorPvPAshran*)l_ZoneScript)
                {
                    l_Ashran->AddCollectedArtifacts(TeamId::TEAM_HORDE, eArtifactsDatas::CountForWarlock, l_ArtifactCount);
                    l_Ashran->RewardHonorAndReputation(l_ArtifactCount, p_Player);
                }
            }
        };

        CreatureAI* GetAI(Creature* p_Creature) const override
        {
            return new npc_ashran_nisstyrAI(p_Creature);
        }
};

/// Atomik <Warspear Shaman Leader> - 82204
class npc_ashran_atomik : public CreatureScript
{
    public:
        npc_ashran_atomik() : CreatureScript("npc_ashran_atomik") { }

        enum eGossip
        {
            KronusInvoked = 89853
        };

        bool OnGossipHello(Player* p_Player, Creature* p_Creature) override
        {
            ZoneScript* l_ZoneScript = sOutdoorPvPMgr->GetOutdoorPvPToZoneId(p_Creature->GetZoneId());
            if (l_ZoneScript == nullptr)
                return false;

            if (OutdoorPvPAshran* l_Ashran = (OutdoorPvPAshran*)l_ZoneScript)
            {
                if (l_Ashran->IsArtifactEventLaunched(TeamId::TEAM_HORDE, eArtifactsDatas::CountForDruidShaman))
                {
                    p_Player->PlayerTalkClass->ClearMenus();
                    p_Player->SEND_GOSSIP_MENU(eGossip::KronusInvoked, p_Creature->GetGUID());
                    return true;
                }
            }

            return false;
        }

        struct npc_ashran_atomikAI : public ScriptedAI
        {
            npc_ashran_atomikAI(Creature* p_Creature) : ScriptedAI(p_Creature) { }

            void sGossipSelect(Player* p_Player, uint32 /*p_Sender*/, uint32 p_Action) override
            {
                /// "Take all of my Artifact Fragments" is always 0
                if (p_Action)
                    return;

                ZoneScript* l_ZoneScript = sOutdoorPvPMgr->GetOutdoorPvPToZoneId(me->GetZoneId());
                if (l_ZoneScript == nullptr)
                    return;

                uint32 l_ArtifactCount = p_Player->GetCurrency(CurrencyTypes::CURRENCY_TYPE_ARTIFACT_FRAGEMENT, true);
                p_Player->ModifyCurrency(CurrencyTypes::CURRENCY_TYPE_ARTIFACT_FRAGEMENT, -int32(l_ArtifactCount * CURRENCY_PRECISION), false);

                if (OutdoorPvPAshran* l_Ashran = (OutdoorPvPAshran*)l_ZoneScript)
                {
                    l_Ashran->AddCollectedArtifacts(TeamId::TEAM_HORDE, eArtifactsDatas::CountForDruidShaman, l_ArtifactCount);
                    l_Ashran->RewardHonorAndReputation(l_ArtifactCount, p_Player);
                }
            }
        };

        CreatureAI* GetAI(Creature* p_Creature) const override
        {
            return new npc_ashran_atomikAI(p_Creature);
        }
};

/// Zaram Sunraiser <Portal Guardian> - 84468
class npc_ashran_zaram_sunraiser : public CreatureScript
{
    public:
        npc_ashran_zaram_sunraiser() : CreatureScript("npc_ashran_zaram_sunraiser") { }

        enum eSpells
        {
            SpellMoltenArmor    = 79849,
            SpellFlamestrike    = 79856,
            SpellFireball       = 79854,
            SpellBlastWave      = 79857
        };

        enum eEvents
        {
            EventFlamestrike = 1,
            EventFireball,
            EventBlastWave
        };

        struct npc_ashran_zaram_sunraiserAI : public ScriptedAI
        {
            npc_ashran_zaram_sunraiserAI(Creature* p_Creature) : ScriptedAI(p_Creature) { }

            EventMap m_Events;

            void Reset() override
            {
                me->CastSpell(me, eSpells::SpellMoltenArmor, true);

                m_Events.Reset();
            }

            void EnterCombat(Unit* /*p_Attacker*/) override
            {
                me->CastSpell(me, eSpells::SpellMoltenArmor, true);

                m_Events.ScheduleEvent(eEvents::EventFlamestrike, 7000);
                m_Events.ScheduleEvent(eEvents::EventFireball, 3000);
                m_Events.ScheduleEvent(eEvents::EventBlastWave, 9000);
            }

            void JustDied(Unit* /*p_Killer*/) override
            {
                ZoneScript* l_ZoneScript = sOutdoorPvPMgr->GetOutdoorPvPToZoneId(me->GetZoneId());
                if (l_ZoneScript == nullptr)
                    return;

                if (OutdoorPvPAshran* l_Ashran = (OutdoorPvPAshran*)l_ZoneScript)
                    l_Ashran->EndArtifactEvent(TeamId::TEAM_HORDE, eArtifactsDatas::CountForMage);
            }

            void UpdateAI(uint32 const p_Diff) override
            {
                if (!UpdateVictim())
                    return;

                m_Events.Update(p_Diff);

                if (me->HasUnitState(UnitState::UNIT_STATE_CASTING))
                    return;

                switch (m_Events.ExecuteEvent())
                {
                    case eEvents::EventFlamestrike:
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_RANDOM))
                            me->CastSpell(l_Target, eSpells::SpellFlamestrike, false);
                        m_Events.ScheduleEvent(eEvents::EventFlamestrike, 15000);
                        break;
                    case eEvents::EventFireball:
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::SpellFireball, false);
                        m_Events.ScheduleEvent(eEvents::EventFireball, 10000);
                        break;
                    case eEvents::EventBlastWave:
                        me->CastSpell(me, eSpells::SpellBlastWave, false);
                        m_Events.ScheduleEvent(eEvents::EventBlastWave, 20000);
                        break;
                    default:
                        break;
                }

                DoMeleeAttackIfReady();
            }
        };

        CreatureAI* GetAI(Creature* p_Creature) const override
        {
            return new npc_ashran_zaram_sunraiserAI(p_Creature);
        }
};

/// Gayle Plagueheart <Gateway Guardian> - 84645
/// Ilya Plagueheart <Gateway Guardian> - 84646
class npc_ashran_horde_gateway_guardian : public CreatureScript
{
    public:
        npc_ashran_horde_gateway_guardian() : CreatureScript("npc_ashran_horde_gateway_guardian") { }

        enum eSpells
        {
            SpellChaosBolt  = 79939,
            SpellFelArmor   = 165735,
            SpellImmolate   = 79937,
            SpellIncinerate = 79938
        };

        enum eEvents
        {
            EventChaosBolt = 1,
            EventImmolate,
            EventIncinerate
        };

        struct npc_ashran_horde_gateway_guardianAI : public ScriptedAI
        {
            npc_ashran_horde_gateway_guardianAI(Creature* p_Creature) : ScriptedAI(p_Creature) { }

            EventMap m_Events;

            void Reset() override
            {
                me->CastSpell(me, eSpells::SpellFelArmor, true);

                m_Events.Reset();
            }

            void EnterCombat(Unit* /*p_Attacker*/) override
            {
                me->CastSpell(me, eSpells::SpellFelArmor, true);

                m_Events.ScheduleEvent(eEvents::EventImmolate, 1000);
                m_Events.ScheduleEvent(eEvents::EventIncinerate, 2000);
                m_Events.ScheduleEvent(eEvents::EventChaosBolt, 5000);
            }

            void JustDied(Unit* /*p_Killer*/) override
            {
                ZoneScript* l_ZoneScript = sOutdoorPvPMgr->GetOutdoorPvPToZoneId(me->GetZoneId());
                if (l_ZoneScript == nullptr)
                    return;

                if (OutdoorPvPAshran* l_Ashran = (OutdoorPvPAshran*)l_ZoneScript)
                    l_Ashran->EndArtifactEvent(TeamId::TEAM_HORDE, eArtifactsDatas::CountForWarlock);
            }

            void UpdateAI(uint32 const p_Diff) override
            {
                if (!UpdateVictim())
                    return;

                m_Events.Update(p_Diff);

                if (me->HasUnitState(UnitState::UNIT_STATE_CASTING))
                    return;

                switch (m_Events.ExecuteEvent())
                {
                    case eEvents::EventChaosBolt:
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::SpellChaosBolt, false);
                        m_Events.ScheduleEvent(eEvents::EventChaosBolt, 12000);
                        break;
                    case eEvents::EventImmolate:
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::SpellImmolate, false);
                        m_Events.ScheduleEvent(eEvents::EventImmolate, 9000);
                        break;
                    case eEvents::EventIncinerate:
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::SpellIncinerate, false);
                        m_Events.ScheduleEvent(eEvents::EventIncinerate, 5000);
                        break;
                    default:
                        break;
                }

                DoMeleeAttackIfReady();
            }
        };

        CreatureAI* GetAI(Creature* p_Creature) const override
        {
            return new npc_ashran_horde_gateway_guardianAI(p_Creature);
        }
};

/// Kronus <Horde Guardian> - 82201
class npc_ashran_kronus : public CreatureScript
{
    public:
        npc_ashran_kronus() : CreatureScript("npc_ashran_kronus") { }

        enum eSpells
        {
            AshranLaneMobScalingAura    = 164310,

            SpellFractureSearcher       = 170892,
            SpellFractureMissile        = 170893,   ///< Trigger 170894
            SpellGroundPound            = 170905,   ///< Periodic Trigger 177605
            SpellRockShield             = 175058,
            SpellStoneEmpowermentAura   = 170896
        };

        enum eEvents
        {
            EventFracture = 1,
            EventGroundPound,
            EventRockShield,
            EventMove
        };

        struct npc_ashran_kronusAI : public ScriptedAI
        {
            npc_ashran_kronusAI(Creature* p_Creature) : ScriptedAI(p_Creature) { }

            EventMap m_Events;
            EventMap m_MoveEvent;

            void InitializeAI() override
            {
                m_MoveEvent.ScheduleEvent(eEvents::EventMove, 1000);

                /// Kronus no longer scales their health based the number of players he's fighting.
                /// Each faction guardian's health now scales based on the number of enemy players active at the time when they're summoned.
                ZoneScript* l_ZoneScript = sOutdoorPvPMgr->GetOutdoorPvPToZoneId(me->GetZoneId());
                if (l_ZoneScript == nullptr)
                    return;

                uint32 l_PlayerCount = 0;
                if (OutdoorPvPAshran* l_Ashran = (OutdoorPvPAshran*)l_ZoneScript)
                    l_PlayerCount = l_Ashran->CountPlayersForTeam(TeamId::TEAM_ALLIANCE);

                if (Aura* l_Scaling = me->AddAura(eSpells::AshranLaneMobScalingAura, me))
                {
                    if (AuraEffect* l_Damage = l_Scaling->GetEffect(EFFECT_0))
                        l_Damage->ChangeAmount(eAshranDatas::HealthPCTAddedByHostileRef * l_PlayerCount);
                    if (AuraEffect* l_Health = l_Scaling->GetEffect(EFFECT_1))
                        l_Health->ChangeAmount(eAshranDatas::HealthPCTAddedByHostileRef * l_PlayerCount);
                }
            }

            void Reset() override
            {
                me->DisableHealthRegen();
                me->CastSpell(me, eSpells::SpellStoneEmpowermentAura, true);

                me->SetReactState(ReactStates::REACT_AGGRESSIVE);

                m_Events.Reset();
            }

            void EnterCombat(Unit* /*p_Attacker*/) override
            {
                Position l_Pos;
                me->GetPosition(&l_Pos);
                me->SetHomePosition(l_Pos);

                m_Events.ScheduleEvent(eEvents::EventFracture, 5000);
                m_Events.ScheduleEvent(eEvents::EventGroundPound, 12000);
                m_Events.ScheduleEvent(eEvents::EventRockShield, 9000);
            }

            void DamageTaken(Unit* /*p_Attacker*/, uint32& p_Damage, SpellInfo const* /*p_SpellInfo*/) override
            {
                if (p_Damage < me->GetHealth())
                    return;

                ZoneScript* l_ZoneScript = sOutdoorPvPMgr->GetOutdoorPvPToZoneId(me->GetZoneId());
                if (l_ZoneScript == nullptr)
                    return;

                if (OutdoorPvPAshran* l_Ashran = (OutdoorPvPAshran*)l_ZoneScript)
                {
                    if (l_Ashran->IsArtifactEventLaunched(TeamId::TEAM_HORDE, eArtifactsDatas::CountForDruidShaman))
                    {
                        l_Ashran->CastSpellOnTeam(me, TeamId::TEAM_ALLIANCE, eAshranSpells::SpellEventAllianceReward);
                        l_Ashran->EndArtifactEvent(TeamId::TEAM_HORDE, eArtifactsDatas::CountForDruidShaman);
                    }
                }
            }

            void SpellHitTarget(Unit* p_Target, SpellInfo const* p_SpellInfo) override
            {
                if (p_Target == nullptr)
                    return;

                if (p_SpellInfo->Id == eSpells::SpellFractureSearcher)
                    me->CastSpell(p_Target, eSpells::SpellFractureMissile, true);
            }

            void UpdateAI(uint32 const p_Diff) override
            {
                m_MoveEvent.Update(p_Diff);

                if (m_MoveEvent.ExecuteEvent() == eEvents::EventMove)
                {
                    me->SetWalk(true);
                    me->LoadPath(me->GetEntry());
                    me->SetDefaultMovementType(MovementGeneratorType::WAYPOINT_MOTION_TYPE);
                    me->GetMotionMaster()->Initialize();
                }

                if (!UpdateVictim())
                    return;

                m_Events.Update(p_Diff);

                if (me->HasUnitState(UnitState::UNIT_STATE_CASTING))
                    return;

                switch (m_Events.ExecuteEvent())
                {
                    case eEvents::EventFracture:
                        me->CastSpell(me, eSpells::SpellFractureSearcher, true);
                        m_Events.ScheduleEvent(eEvents::EventFracture, 16000);
                        break;
                    case eEvents::EventGroundPound:
                        me->CastSpell(me, eSpells::SpellGroundPound, false);
                        m_Events.ScheduleEvent(eEvents::EventGroundPound, 43000);
                        break;
                    case eEvents::EventRockShield:
                        me->CastSpell(me, eSpells::SpellRockShield, true);
                        m_Events.ScheduleEvent(eEvents::EventRockShield, 39000);
                        break;
                    default:
                        break;
                }

                DoMeleeAttackIfReady();
            }
        };

        CreatureAI* GetAI(Creature* p_Creature) const override
        {
            return new npc_ashran_kronusAI(p_Creature);
        }
};

/// Underpowered Earth Fury <Horde Guardian> - 82200
class npc_ashran_underpowered_earth_fury : public CreatureScript
{
    public:
        npc_ashran_underpowered_earth_fury() : CreatureScript("npc_ashran_underpowered_earth_fury") { }

        struct npc_ashran_underpowered_earth_furyAI : public ScriptedAI
        {
            npc_ashran_underpowered_earth_furyAI(Creature* p_Creature) : ScriptedAI(p_Creature) { }

            enum eData
            {
                WarspearShaman = 82438
            };

            EventMap m_Events;

            void Reset() override
            {
                std::list<Creature*> l_WarspearShamans;
                me->GetCreatureListWithEntryInGrid(l_WarspearShamans, eData::WarspearShaman, 20.0f);

                for (Creature* l_Creature : l_WarspearShamans)
                {
                    if (l_Creature->AI())
                        l_Creature->AI()->Reset();
                }
            }
        };

        CreatureAI* GetAI(Creature* p_Creature) const override
        {
            return new npc_ashran_underpowered_earth_furyAI(p_Creature);
        }
};

/// Warspear Gladiator - 85811
class npc_ashran_warspear_gladiator : public CreatureScript
{
    public:
        npc_ashran_warspear_gladiator() : CreatureScript("npc_ashran_warspear_gladiator") { }

        enum eSpells
        {
            SpellCleave         = 119419,
            SpellDevotionAura   = 165712,
            SpellMortalStrike   = 19643,
            SpellNet            = 81210,
            SpellSnapKick       = 15618
        };

        enum eEvents
        {
            EventCleave = 1,
            EventMortalStrike,
            EventNet,
            EventSnapKick
        };

        struct npc_ashran_warspear_gladiatorAI : public ScriptedAI
        {
            npc_ashran_warspear_gladiatorAI(Creature* p_Creature) : ScriptedAI(p_Creature) { }

            EventMap m_Events;

            void Reset() override
            {
                m_Events.Reset();

                me->CastSpell(me, eSpells::SpellDevotionAura, true);
            }

            void EnterCombat(Unit* p_Attacker) override
            {
                me->CastSpell(me, eSpells::SpellDevotionAura, true);
                me->CastSpell(p_Attacker, eSpells::SpellNet, true);

                m_Events.ScheduleEvent(eEvents::EventCleave, 3000);
                m_Events.ScheduleEvent(eEvents::EventMortalStrike, 5000);
                m_Events.ScheduleEvent(eEvents::EventNet, 8000);
                m_Events.ScheduleEvent(eEvents::EventSnapKick, 9000);
            }

            void UpdateAI(uint32 const p_Diff) override
            {
                if (!UpdateVictim())
                    return;

                m_Events.Update(p_Diff);

                if (me->HasUnitState(UnitState::UNIT_STATE_CASTING))
                    return;

                switch (m_Events.ExecuteEvent())
                {
                    case eEvents::EventCleave:
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::SpellCleave, true);
                        m_Events.ScheduleEvent(eEvents::EventCleave, 15000);
                        break;
                    case eEvents::EventMortalStrike:
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::SpellMortalStrike, true);
                        m_Events.ScheduleEvent(eEvents::EventMortalStrike, 10000);
                        break;
                    case eEvents::EventNet:
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::SpellNet, true);
                        m_Events.ScheduleEvent(eEvents::EventNet, 20000);
                        break;
                    case eEvents::EventSnapKick:
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::SpellSnapKick, true);
                        m_Events.ScheduleEvent(eEvents::EventSnapKick, 20000);
                        break;
                    default:
                        break;
                }

                DoMeleeAttackIfReady();
            }
        };

        CreatureAI* GetAI(Creature* p_Creature) const override
        {
            return new npc_ashran_warspear_gladiatorAI(p_Creature);
        }
};

/// Excavator Rustshiv - 88568
class npc_ashran_excavator_rustshiv : public CreatureScript
{
    public:
        npc_ashran_excavator_rustshiv() : CreatureScript("npc_ashran_excavator_rustshiv") { }

        enum eTalks
        {
            First,
            Second,
            Third,
            Fourth,
            Fifth,
            Sixth
        };

        enum eData
        {
            ExcavatorHardtooth  = 88567,
            ActionInit          = 0,
            ActionLoop          = 1,
            EventLoop           = 1
        };

        struct npc_ashran_excavator_rustshivAI : public MS::AI::CosmeticAI
        {
            npc_ashran_excavator_rustshivAI(Creature* p_Creature) : MS::AI::CosmeticAI(p_Creature) { }

            bool m_Init;
            EventMap m_Events;

            void Reset() override
            {
                m_Init = false;

                if (Creature* l_Creature = me->FindNearestCreature(eData::ExcavatorHardtooth, 15.0f))
                {
                    if (l_Creature->AI())
                    {
                        m_Init = true;
                        l_Creature->AI()->DoAction(eData::ActionInit);
                        ScheduleAllTalks();
                    }
                }
            }

            void DoAction(int32 const p_Action) override
            {
                switch (p_Action)
                {
                    case eData::ActionInit:
                        if (m_Init)
                            break;
                        m_Init = true;
                        ScheduleAllTalks();
                        break;
                    default:
                        break;
                }
            }

            void ScheduleAllTalks()
            {
                AddTimedDelayedOperation(1 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::First); });
                AddTimedDelayedOperation(18 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Second); });
                AddTimedDelayedOperation(36 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Third); });
                AddTimedDelayedOperation(67 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Fourth); });
                AddTimedDelayedOperation(84 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Fifth); });
                AddTimedDelayedOperation(101 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Sixth); });
            }

            void LastOperationCalled() override
            {
                m_Events.ScheduleEvent(eData::EventLoop, 31 * TimeConstants::IN_MILLISECONDS);
            }

            void UpdateAI(const uint32 p_Diff) override
            {
                MS::AI::CosmeticAI::UpdateAI(p_Diff);

                m_Events.Update(p_Diff);

                if (m_Events.ExecuteEvent() == eData::EventLoop)
                {
                    if (Creature* l_Creature = me->FindNearestCreature(eData::ExcavatorHardtooth, 15.0f))
                    {
                        if (l_Creature->AI())
                        {
                            l_Creature->AI()->DoAction(eData::ActionLoop);
                            ScheduleAllTalks();
                        }
                    }
                }
            }
        };

        CreatureAI* GetAI(Creature* p_Creature) const override
        {
            return new npc_ashran_excavator_rustshivAI(p_Creature);
        }
};

/// Excavator Hardtooth - 88567
class npc_ashran_excavator_hardtooth : public CreatureScript
{
public:
	npc_ashran_excavator_hardtooth() : CreatureScript("npc_ashran_excavator_hardtooth") { }

	enum eTalks
	{
		First,
		Second,
		Third,
		Fourth
	};

	enum eData
	{
		ExcavatorRustshiv = 88568,
		ActionInit = 0,
		ActionLoop = 1
	};

	struct npc_ashran_excavator_hardtoothAI : public MS::AI::CosmeticAI
	{
		npc_ashran_excavator_hardtoothAI(Creature* p_Creature) : MS::AI::CosmeticAI(p_Creature) { }

		bool m_Init;

		void Reset() override
		{
			m_Init = false;

			if (Creature* l_Creature = me->FindNearestCreature(eData::ExcavatorRustshiv, 15.0f))
			{
				if (l_Creature->AI())
				{
					m_Init = true;
					l_Creature->AI()->DoAction(eData::ActionInit);
					ScheduleAllTalks();
				}
			}
		}

		void DoAction(int32 const p_Action) override
		{
			switch (p_Action)
			{
			case eData::ActionInit:
				m_Init = true;
				ScheduleAllTalks();
				break;
			case eData::ActionLoop:
				ScheduleAllTalks();
				break;
			default:
				break;
			}
		}

		void ScheduleAllTalks()
		{
			AddTimedDelayedOperation(10 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::First); });
			AddTimedDelayedOperation(27 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Second); });
			AddTimedDelayedOperation(76 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Third); });
			AddTimedDelayedOperation(93 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Fourth); });
		}
	};

	CreatureAI* GetAI(Creature* p_Creature) const override
	{
		return new npc_ashran_excavator_hardtoothAI(p_Creature);
	}
};

/// Can be used by any WoD guards
class guard_wod_generic : public CreatureScript
{
public:
	guard_wod_generic() : CreatureScript("guard_wod_generic") {}

	enum eEvents
	{
		EventCheckPossible,
		EventCheckPlayer,
		EventReset,
		EventFight,
		EventAxes
	};

	struct guard_wod_genericAI : public ScriptedAI
	{
		guard_wod_genericAI(Creature* p_Creature) : ScriptedAI(p_Creature) {}

		EventMap m_Events;
		EventMap m_CosmeticEvents;

		bool m_Init;

		void Reset() override
		{
			m_Init = false;
			m_CosmeticEvents.ScheduleEvent(eEvents::EventCheckPossible, 1 * TimeConstants::IN_MILLISECONDS);
		}

		void UpdateAI(uint32 const p_Diff) override
		{
			UpdateOperations(p_Diff);

			m_CosmeticEvents.Update(p_Diff);

			switch (m_CosmeticEvents.ExecuteEvent())
			{
				case eEvents::EventCheckPossible:
				{
					if (!me->HasAura(73299))
						m_CosmeticEvents.ScheduleEvent(eEvents::EventCheckPlayer, 0.1 * TimeConstants::IN_MILLISECONDS);

					if (me->HasAura(73299) && me->HasAura(177851))
					{
						if (m_Init != true)
						{
							m_Init = true;
							m_CosmeticEvents.ScheduleEvent(eEvents::EventFight, urand(1500, 3000));
						}
					}

					if (me->HasAura(73299) && me->HasAura(205651))
					{
						if (m_Init != true)
						{
							m_Init = true;
							m_CosmeticEvents.ScheduleEvent(eEvents::EventAxes, urand(1500, 3000));
						}
					}
					break;
				}
				case eEvents::EventCheckPlayer:
				{
					if (me->FindNearestPlayer(5.0f, true) && m_Init != true)
					{
						DoAction(0);
						m_Init = true;
					}
					break;
				}
				case eEvents::EventFight:
				{
					std::list<Creature*> l_IronGrunt;
					me->GetCreatureListInGrid(l_IronGrunt, 1.0f);

					for (Creature* l_Itr : l_IronGrunt)
					{
						if (urand(0, 1))
							me->CastSpell(l_Itr, 106501, false);
						else
							me->CastSpell(l_Itr, 106502, false);

						m_Init = false;
					}
					break;
				}
				case eEvents::EventAxes:
				{
					std::list<Creature*> l_Marker;
					me->GetCreatureListWithEntryInGrid(l_Marker, 400002, 30.0f);

					if (l_Marker.size() > 1)
					{
						l_Marker.sort(JadeCore::ObjectDistanceOrderPred(me));
						l_Marker.resize(1);
					}

					for (Creature* l_Itr : l_Marker)
					{
						me->CastSpell(l_Itr, 131512, true);

						m_Init = false;
					}
					break;
				}
			default:
				break;
			}

			DoMeleeAttackIfReady();
		}

		void DoAction(int32 const p_Action) override
		{
			switch (p_Action)
			{
				case 0:
				{
					me->HandleEmoteCommand(66);

					AddTimedDelayedOperation(20 * TimeConstants::IN_MILLISECONDS, [this]() -> void 
					{ 
						DoAction(1);
					});
					break;
				}

				case 1:
				{
					m_Init = false;
					break;
				}
			default:
				break;
			}
		}
	};

	CreatureAI* GetAI(Creature* p_Creature) const override
	{
		return new guard_wod_genericAI(p_Creature);
	}
};

/// Rala Wildheart - 87566
class npc_ashran_rala_wildheart : public CreatureScript
{
public:
	npc_ashran_rala_wildheart() : CreatureScript("npc_ashran_rala_wildheart") { }

	enum eTalks
	{
		First,
		Second,
		Third,
		Fourth
	};

	enum eData
	{
		ShadowHunterAskia = 88138,
		ActionInit = 0,
		ActionLoop = 1,
		EventLoop = 1
	};

	struct npc_ashran_rala_wildheartAI : public MS::AI::CosmeticAI
	{
		npc_ashran_rala_wildheartAI(Creature* p_Creature) : MS::AI::CosmeticAI(p_Creature) { }

		bool m_Init;
		EventMap m_Events;

		void Reset() override
		{
			m_Init = false;

			if (Creature* l_Creature = me->FindNearestCreature(eData::ShadowHunterAskia, 15.0f))
			{
				if (l_Creature->AI())
				{
					m_Init = true;
					l_Creature->AI()->DoAction(eData::ActionInit);
					ScheduleAllTalks();
				}
			}
		}

		void DoAction(int32 const p_Action) override
		{
			switch (p_Action)
			{
			case eData::ActionInit:
				if (m_Init)
					break;
				m_Init = true;
				ScheduleAllTalks();
				break;
			default:
				break;
			}
		}

		void ScheduleAllTalks()
		{
			AddTimedDelayedOperation(1 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::First); });
			AddTimedDelayedOperation(18 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Second); });
			AddTimedDelayedOperation(36 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Third); });
			AddTimedDelayedOperation(67 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Fourth); });
		}

		void LastOperationCalled() override
		{
			m_Events.ScheduleEvent(eData::EventLoop, 31 * TimeConstants::IN_MILLISECONDS);
		}

		void UpdateAI(const uint32 p_Diff) override
		{
			MS::AI::CosmeticAI::UpdateAI(p_Diff);

			m_Events.Update(p_Diff);

			if (m_Events.ExecuteEvent() == eData::EventLoop)
			{
				if (Creature* l_Creature = me->FindNearestCreature(eData::ShadowHunterAskia, 15.0f))
				{
					if (l_Creature->AI())
					{
						l_Creature->AI()->DoAction(eData::ActionLoop);
						ScheduleAllTalks();
					}
				}
			}
		}
	};

	CreatureAI* GetAI(Creature* p_Creature) const override
	{
		return new npc_ashran_rala_wildheartAI(p_Creature);
	}
};

/// Shadow Hunter Askia - 88138
class npc_ashran_shadow_hunter_askia : public CreatureScript
{
public:
	npc_ashran_shadow_hunter_askia() : CreatureScript("npc_ashran_shadow_hunter_askia") { }

	enum eTalks
	{
		First,
		Second
	};

	enum eData
	{
		RalaWildheart = 87566,
		ActionInit = 0,
		ActionLoop = 1
	};

	struct npc_ashran_shadow_hunter_askiaAI : public MS::AI::CosmeticAI
	{
		npc_ashran_shadow_hunter_askiaAI(Creature* p_Creature) : MS::AI::CosmeticAI(p_Creature) { }

		bool m_Init;

		void Reset() override
		{
			m_Init = false;

			if (Creature* l_Creature = me->FindNearestCreature(eData::RalaWildheart, 15.0f))
			{
				if (l_Creature->AI())
				{
					m_Init = true;
					l_Creature->AI()->DoAction(eData::ActionInit);
					ScheduleAllTalks();
				}
			}
		}

		void DoAction(int32 const p_Action) override
		{
			switch (p_Action)
			{
			case eData::ActionInit:
				m_Init = true;
				ScheduleAllTalks();
				break;
			case eData::ActionLoop:
				ScheduleAllTalks();
				break;
			default:
				break;
			}
		}

		void ScheduleAllTalks()
		{
			AddTimedDelayedOperation(10 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::First); });
			AddTimedDelayedOperation(27 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Second); });
		}
	};

	CreatureAI* GetAI(Creature* p_Creature) const override
	{
		return new npc_ashran_shadow_hunter_askiaAI(p_Creature);
	}
};

/// Gordon Ray - 87567
class npc_ashran_gordon_ray : public CreatureScript
{
public:
	npc_ashran_gordon_ray() : CreatureScript("npc_ashran_gordon_ray") { }

	enum eTalks
	{
		First,
		Second,
		Third,
		Fourth
	};

	enum eData
	{
		WarspearGrunt = 864600,
		ActionInit = 0,
		ActionLoop = 1,
		EventLoop = 1
	};

	struct npc_ashran_gordon_rayAI : public MS::AI::CosmeticAI
	{
		npc_ashran_gordon_rayAI(Creature* p_Creature) : MS::AI::CosmeticAI(p_Creature) { }

		bool m_Init;
		EventMap m_Events;

		void Reset() override
		{
			m_Init = false;

			if (Creature* l_Creature = me->FindNearestCreature(eData::WarspearGrunt, 15.0f))
			{
				if (l_Creature->AI())
				{
					m_Init = true;
					l_Creature->AI()->DoAction(eData::ActionInit);
					ScheduleAllTalks();
				}
			}
		}

		void DoAction(int32 const p_Action) override
		{
			switch (p_Action)
			{
			case eData::ActionInit:
				if (m_Init)
					break;
				m_Init = true;
				ScheduleAllTalks();
				break;
			default:
				break;
			}
		}

		void ScheduleAllTalks()
		{
			AddTimedDelayedOperation(1 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::First); });
			AddTimedDelayedOperation(18 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Second); });
			AddTimedDelayedOperation(36 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Third); });
			AddTimedDelayedOperation(67 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Fourth); });
		}

		void LastOperationCalled() override
		{
			m_Events.ScheduleEvent(eData::EventLoop, 31 * TimeConstants::IN_MILLISECONDS);
		}

		void UpdateAI(const uint32 p_Diff) override
		{
			MS::AI::CosmeticAI::UpdateAI(p_Diff);

			m_Events.Update(p_Diff);

			if (m_Events.ExecuteEvent() == eData::EventLoop)
			{
				if (Creature* l_Creature = me->FindNearestCreature(eData::WarspearGrunt, 1.5f))
				{
					if (l_Creature->AI())
					{
						l_Creature->AI()->DoAction(eData::ActionLoop);
						ScheduleAllTalks();
					}
				}
			}
		}
	};

	CreatureAI* GetAI(Creature* p_Creature) const override
	{
		return new npc_ashran_gordon_rayAI(p_Creature);
	}
};

/// Warspear Grunt - 864600
class npc_ashran_warspear_grunt : public CreatureScript
{
public:
	npc_ashran_warspear_grunt() : CreatureScript("npc_ashran_warspear_grunt") { }

	enum eTalks
	{
		First,
		Second,
		Third
	};

	enum eData
	{
		GordonRay = 87567,
		ActionInit = 0,
		ActionLoop = 1
	};

	struct npc_ashran_warspear_gruntAI : public MS::AI::CosmeticAI
	{
		npc_ashran_warspear_gruntAI(Creature* p_Creature) : MS::AI::CosmeticAI(p_Creature) { }

		bool m_Init;

		void Reset() override
		{
			m_Init = false;

			if (Creature* l_Creature = me->FindNearestCreature(eData::GordonRay, 15.0f))
			{
				if (l_Creature->AI())
				{
					m_Init = true;
					l_Creature->AI()->DoAction(eData::ActionInit);
					ScheduleAllTalks();
				}
			}
		}

		void DoAction(int32 const p_Action) override
		{
			switch (p_Action)
			{
			case eData::ActionInit:
				m_Init = true;
				ScheduleAllTalks();
				break;
			case eData::ActionLoop:
				ScheduleAllTalks();
				break;
			default:
				break;
			}
		}

		void ScheduleAllTalks()
		{
			AddTimedDelayedOperation(10 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::First); });
			AddTimedDelayedOperation(27 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Second); });
			AddTimedDelayedOperation(76 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Third); });
		}
	};

	CreatureAI* GetAI(Creature* p_Creature) const override
	{
		return new npc_ashran_warspear_gruntAI(p_Creature);
	}
};

/// Brix Rocketcast - 86628
class npc_ashran_brix_rocketcast : public CreatureScript
{
public:
	npc_ashran_brix_rocketcast() : CreatureScript("npc_ashran_brix_rocketcast") { }

	enum eTalks
	{
		First,
		Second,
		Third,
		Fourth
	};

	enum eData
	{
		NinaDingzap = 87732,
		ActionInit = 0,
		ActionLoop = 1,
		EventLoop = 1
	};

	struct npc_ashran_brix_rocketcastAI : public MS::AI::CosmeticAI
	{
		npc_ashran_brix_rocketcastAI(Creature* p_Creature) : MS::AI::CosmeticAI(p_Creature) { }

		bool m_Init;
		EventMap m_Events;

		void Reset() override
		{
			m_Init = false;

			if (Creature* l_Creature = me->FindNearestCreature(eData::NinaDingzap, 30.0f))
			{
				if (l_Creature->AI())
				{
					m_Init = true;
					l_Creature->AI()->DoAction(eData::ActionInit);
					ScheduleAllTalks();
				}
			}
		}

		void DoAction(int32 const p_Action) override
		{
			switch (p_Action)
			{
			case eData::ActionInit:
				if (m_Init)
					break;
				m_Init = true;
				ScheduleAllTalks();
				break;
			default:
				break;
			}
		}

		void ScheduleAllTalks()
		{
			AddTimedDelayedOperation(1.5 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::First); });
			AddTimedDelayedOperation(23 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Second); });
			AddTimedDelayedOperation(36 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Third); });
			AddTimedDelayedOperation(52 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Fourth); });
		}

		void LastOperationCalled() override
		{
			m_Events.ScheduleEvent(eData::EventLoop, 31 * TimeConstants::IN_MILLISECONDS);
		}

		void UpdateAI(const uint32 p_Diff) override
		{
			MS::AI::CosmeticAI::UpdateAI(p_Diff);

			m_Events.Update(p_Diff);

			if (m_Events.ExecuteEvent() == eData::EventLoop)
			{
				if (Creature* l_Creature = me->FindNearestCreature(eData::NinaDingzap, 30.0f))
				{
					if (l_Creature->AI())
					{
						l_Creature->AI()->DoAction(eData::ActionLoop);
						ScheduleAllTalks();
					}
				}
			}
		}
	};

	CreatureAI* GetAI(Creature* p_Creature) const override
	{
		return new npc_ashran_brix_rocketcastAI(p_Creature);
	}
};

static std::array<G3D::Vector3, 5> g_NinaLeft =
{
	{
		{ 5450.6509f, -4141.1777f, 1.1620f   },
		{ 5454.8008f, -4138.1992f, 0.7208f   },
		{ 5459.5039f, -4136.6362f, 0.2876f   },
		{ 5461.4355f, -4137.7583f, 0.2757f   },
		{ 5462.3115f, -4136.6802f, 0.1279f   }
	}
};

static std::array<G3D::Vector3, 5> g_NinaCenter =
{
	{
		{ 5450.9233f, -4141.1392f, 1.1493f    },
		{ 5454.3818f, -4138.8320f, 0.7962f    },
		{ 5457.8013f, -4142.6792f, 0.8374f    },
		{ 5459.8223f, -4147.5361f, 0.7065f    },
		{ 5463.1924f, -4147.3657f, 0.1669f    }
	}
};

static std::array<G3D::Vector3, 5> g_NinaRight =
{
	{
		{ 5450.4487f, -4141.7808f, 1.1920f   },
		{ 5454.3672f, -4144.7397f, 1.0750f   },
		{ 5453.4727f, -4150.2168f, 1.1052f   },
		{ 5456.6841f, -4152.7397f, 0.6628f   },
		{ 5456.2891f, -4158.1802f, 0.1352f   }
	}
};

static std::array<G3D::Vector3, 5> g_NinaBack =
{
	{
		{ 5459.9878f, -4143.2144f, 0.7214f    },
		{ 5455.0913f, -4140.1504f, 0.8575f    },
		{ 5451.6431f, -4140.0566f, 1.0829f    },
		{ 5448.1460f, -4139.5889f, 1.2058f    },
		{ 5447.1133f, -4139.7114f, 1.2058f    }
	}
};

/// Nina Dingzap - 87732
class npc_ashran_nina_dingzap : public CreatureScript
{
public:
	npc_ashran_nina_dingzap() : CreatureScript("npc_ashran_nina_dingzap") { }

	enum eData
	{
		BrixRocketcast = 86628,
		ActionInit = 0,
		ActionLoop = 1
	};

	struct npc_ashran_nina_dingzapAI : public MS::AI::CosmeticAI
	{
		npc_ashran_nina_dingzapAI(Creature* p_Creature) : MS::AI::CosmeticAI(p_Creature) { }

		bool m_Init;

		void Reset() override
		{
			m_Init = false;

			if (Creature* l_Creature = me->FindNearestCreature(eData::BrixRocketcast, 30.0f))
			{
				if (l_Creature->AI())
				{
					m_Init = true;
					l_Creature->AI()->DoAction(eData::ActionInit);
					ScheduleAllTalks();
				}
			}
		}

		void DoAction(int32 const p_Action) override
		{
			switch (p_Action)
			{
			case eData::ActionInit:
				m_Init = true;
				ScheduleAllTalks();
				break;
			case eData::ActionLoop:
				ScheduleAllTalks();
				break;
			default:
				break;
			}
		}

		void ScheduleAllTalks()
		{
			AddTimedDelayedOperation(0.1 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->SetFacingTo(3.409194f);
			});

			AddTimedDelayedOperation(0.5 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->HandleEmoteCommand(539);
			});

			AddTimedDelayedOperation(1.5 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->HandleEmoteCommand(0);
				me->GetMotionMaster()->MoveSmoothPath(0, g_NinaLeft.data(), g_NinaLeft.size(), true);
			});

			AddTimedDelayedOperation(9 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->HandleEmoteCommand(539);
			});

			AddTimedDelayedOperation(11.5 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->HandleEmoteCommand(0);
				me->SummonCreature(87725, 5462.97f, -4134.20f, 0.427547f, 0.583373f, TEMPSUMMON_CORPSE_TIMED_DESPAWN, 15000);
			});

			AddTimedDelayedOperation(16 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->GetMotionMaster()->MoveSmoothPath(1, g_NinaBack.data(), g_NinaBack.size(), true);
			});

			AddTimedDelayedOperation(23.1 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->SetFacingTo(3.409194f);
			});

			AddTimedDelayedOperation(23.5 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->HandleEmoteCommand(539);
			});

			AddTimedDelayedOperation(25 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->HandleEmoteCommand(0);
				me->GetMotionMaster()->MoveSmoothPath(0, g_NinaCenter.data(), g_NinaCenter.size(), true);
			});

			AddTimedDelayedOperation(32.5 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->HandleEmoteCommand(539);
			});

			AddTimedDelayedOperation(35 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->HandleEmoteCommand(0);
				me->SummonCreature(87725, 5463.89f, -4147.88f, 0.358167f, 6.105512f, TEMPSUMMON_CORPSE_TIMED_DESPAWN, 15000);
			});

			AddTimedDelayedOperation(38.5 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->GetMotionMaster()->MoveSmoothPath(1, g_NinaBack.data(), g_NinaBack.size(), true);
			});

			AddTimedDelayedOperation(48.6 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->SetFacingTo(3.409194f);
			});

			AddTimedDelayedOperation(53 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->HandleEmoteCommand(539);
			});

			AddTimedDelayedOperation(54.5 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->HandleEmoteCommand(0);
				me->GetMotionMaster()->MoveSmoothPath(0, g_NinaRight.data(), g_NinaRight.size(), true);
			});

			AddTimedDelayedOperation(64 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->HandleEmoteCommand(539);
			});

			AddTimedDelayedOperation(65.5 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->HandleEmoteCommand(0);
				me->SummonCreature(87725, 5456.22, -4159.59, 0.716782, 5.104129, TEMPSUMMON_CORPSE_TIMED_DESPAWN, 15000);
			});

			AddTimedDelayedOperation(67 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->GetMotionMaster()->MoveSmoothPath(1, g_NinaBack.data(), g_NinaBack.size(), true);
			});

			AddTimedDelayedOperation(80 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->SetFacingTo(0.242519f);
			});
		}
	};

	CreatureAI* GetAI(Creature* p_Creature) const override
	{
		return new npc_ashran_nina_dingzapAI(p_Creature);
	}
};

 /// Joro'man - 86015
class npc_ashran_joroman : public CreatureScript
{
public:
	npc_ashran_joroman() : CreatureScript("npc_ashran_joroman") { }

	enum eTalks
	{
		First,
		Second,
		Third,
		Fourth
	};

	enum eData
	{
		Zikk = 88020,
		ActionInit = 0,
		ActionLoop = 1,
		EventLoop = 1
	};

	struct npc_ashran_joromanAI : public MS::AI::CosmeticAI
	{
		npc_ashran_joromanAI(Creature* p_Creature) : MS::AI::CosmeticAI(p_Creature) { }

		bool m_Init;
		EventMap m_Events;

		void Reset() override
		{
			m_Init = false;

			if (Creature* l_Creature = me->FindNearestCreature(eData::Zikk, 15.0f))
			{
				if (l_Creature->AI())
				{
					m_Init = true;
					l_Creature->AI()->DoAction(eData::ActionInit);
					ScheduleAllTalks();
				}
			}
		}

		void DoAction(int32 const p_Action) override
		{
			switch (p_Action)
			{
			case eData::ActionInit:
				if (m_Init)
					break;
				m_Init = true;
				ScheduleAllTalks();
				break;
			default:
				break;
			}
		}

		void ScheduleAllTalks()
		{
			AddTimedDelayedOperation(1 * TimeConstants::IN_MILLISECONDS, [this]() -> void 
			{ 
				if (Creature* l_Creature = me->FindNearestCreature(eData::Zikk, 15.0f))
				{
					me->SetFacingToObject(l_Creature);
				}

				me->HandleEmoteCommand(397);

				Talk(eTalks::First); 
			});

			AddTimedDelayedOperation(4 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->SetFacingTo(5.35816f);
			});
			
			AddTimedDelayedOperation(18 * TimeConstants::IN_MILLISECONDS, [this]() -> void 
			{ 
				if (Creature* l_Creature = me->FindNearestCreature(eData::Zikk, 15.0f))
				{
					me->SetFacingToObject(l_Creature);
				}
			});

			AddTimedDelayedOperation(19 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->HandleEmoteCommand(25);
				Talk(eTalks::Second);
			});

			AddTimedDelayedOperation(23 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->SetFacingTo(5.35816f);
			});
			
			AddTimedDelayedOperation(36 * TimeConstants::IN_MILLISECONDS, [this]() -> void 
			{ 
				Talk(eTalks::Third); 
			});
			
			AddTimedDelayedOperation(67 * TimeConstants::IN_MILLISECONDS, [this]() -> void 
			{ 
				Talk(eTalks::Fourth); 
			});
		}

		void LastOperationCalled() override
		{
			m_Events.ScheduleEvent(eData::EventLoop, 31 * TimeConstants::IN_MILLISECONDS);
		}

		void UpdateAI(const uint32 p_Diff) override
		{
			MS::AI::CosmeticAI::UpdateAI(p_Diff);

			m_Events.Update(p_Diff);

			if (m_Events.ExecuteEvent() == eData::EventLoop)
			{
				if (Creature* l_Creature = me->FindNearestCreature(eData::Zikk, 15.0f))
				{
					if (l_Creature->AI())
					{
						l_Creature->AI()->DoAction(eData::ActionLoop);
						ScheduleAllTalks();
					}
				}
			}
		}
	};

	CreatureAI* GetAI(Creature* p_Creature) const override
	{
		return new npc_ashran_joromanAI(p_Creature);
	}
};

static std::array<G3D::Vector3, 4> g_KikkFirst =
{
	{
		{ 5278.5464f, -4196.8101f, 1.9903f  },
		{ 5269.0718f, -4208.3281f, 3.4017f  },
		{ 5264.2666f, -4214.4272f, 3.8370f  },
		{ 5266.2515f, -4220.8237f, 3.8370f  }
	}
};

static std::array<G3D::Vector3, 6> g_KikkSecond =
{
	{
		{ 5266.1792f, -4218.7559f, 3.8370f   },
		{ 5263.7202f, -4214.3120f, 3.8370f   },
		{ 5274.0366f, -4203.0806f, 2.0444f   },
		{ 5287.4429f, -4199.0425f, 1.5541f   },
		{ 5291.4033f, -4202.7319f, 1.3226f   },
		{ 5290.7344f, -4204.0190f, 1.1358f   }
	}
};

static std::array<G3D::Vector3, 3> g_KikkThird =
{
	{
		{ 5293.3071f, -4203.2065f, 1.4317f  },
		{ 5293.1162f, -4199.4224f, 2.0422f  },
		{ 5288.9082f, -4200.7813f, 1.3609f  }
	}
};

/// Zikk - 88020
class npc_ashran_zikk : public CreatureScript
{
public:
	npc_ashran_zikk() : CreatureScript("npc_ashran_zikk") { }

	enum eTalks
	{
		First,
		Second,
		Third
	};

	enum eData
	{
		Joroman = 86015,
		ActionInit = 0,
		ActionLoop = 1
	};

	struct npc_ashran_zikkAI : public MS::AI::CosmeticAI
	{
		npc_ashran_zikkAI(Creature* p_Creature) : MS::AI::CosmeticAI(p_Creature) { }

		bool m_Init;

		void Reset() override
		{
			m_Init = false;

			if (Creature* l_Creature = me->FindNearestCreature(eData::Joroman, 15.0f))
			{
				if (l_Creature->AI())
				{
					m_Init = true;
					l_Creature->AI()->DoAction(eData::ActionInit);
					ScheduleAllTalks();
				}
			}
		}

		void DoAction(int32 const p_Action) override
		{
			switch (p_Action)
			{
			case eData::ActionInit:
				m_Init = true;
				ScheduleAllTalks();
				break;
			case eData::ActionLoop:
				ScheduleAllTalks();
				break;
			default:
				break;
			}
		}

		void ScheduleAllTalks()
		{
			AddTimedDelayedOperation(1 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->HandleEmoteCommand(54);
			});

			AddTimedDelayedOperation(2.5 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->GetMotionMaster()->MoveSmoothPath(0, g_KikkFirst.data(), g_KikkFirst.size(), false);
			});

			AddTimedDelayedOperation(9 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->HandleEmoteCommand(54);
				me->CastSpell(me, 175660, true);
			});

			AddTimedDelayedOperation(11 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->GetMotionMaster()->MoveSmoothPath(1, g_KikkSecond.data(), g_KikkSecond.size(), false);
			});

			AddTimedDelayedOperation(18 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				if (Creature* l_Creature = me->FindNearestCreature(eData::Joroman, 15.0f))
				{
					me->SetFacingToObject(l_Creature);
				}
			});

			AddTimedDelayedOperation(19 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->HandleEmoteCommand(25);
				me->RemoveAura(175660);
			});

			AddTimedDelayedOperation(21 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->GetMotionMaster()->MoveSmoothPath(1, g_KikkThird.data(), g_KikkThird.size(), false);
			});

			AddTimedDelayedOperation(23 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->SetFacingTo(3.701974f);
			});
		}
	};

	CreatureAI* GetAI(Creature* p_Creature) const override
	{
		return new npc_ashran_zikkAI(p_Creature);
	}
};

/// Warspear Grunt - 864721
class npc_ashran_warspear_grunt_flightmaster_1 : public CreatureScript
{
public:
	npc_ashran_warspear_grunt_flightmaster_1() : CreatureScript("npc_ashran_warspear_grunt_flightmaster_1") { }

	enum eTalks
	{
		First,
		Second,
		Third,
		Fourth,
		Fifth
	};

	enum eData
	{
		WarspearGrunt2 = 864601,
		ActionInit = 0,
		ActionLoop = 1,
		EventLoop = 1
	};

	struct npc_ashran_warspear_grunt_flightmaster_1AI : public MS::AI::CosmeticAI
	{
		npc_ashran_warspear_grunt_flightmaster_1AI(Creature* p_Creature) : MS::AI::CosmeticAI(p_Creature) { }

		bool m_Init;
		EventMap m_Events;

		void Reset() override
		{
			m_Init = false;

			if (Creature* l_Creature = me->FindNearestCreature(eData::WarspearGrunt2, 15.0f))
			{
				if (l_Creature->AI())
				{
					m_Init = true;
					l_Creature->AI()->DoAction(eData::ActionInit);
					ScheduleAllTalks();
				}
			}
		}

		void DoAction(int32 const p_Action) override
		{
			switch (p_Action)
			{
			case eData::ActionInit:
				if (m_Init)
					break;
				m_Init = true;
				ScheduleAllTalks();
				break;
			default:
				break;
			}
		}

		void ScheduleAllTalks()
		{
			AddTimedDelayedOperation(1 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::First); });
			AddTimedDelayedOperation(18 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Second); });
			AddTimedDelayedOperation(70 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Third); });
			AddTimedDelayedOperation(86 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Fourth); });
			AddTimedDelayedOperation(102 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Fifth); });
		}

		void LastOperationCalled() override
		{
			m_Events.ScheduleEvent(eData::EventLoop, 31 * TimeConstants::IN_MILLISECONDS);
		}

		void UpdateAI(const uint32 p_Diff) override
		{
			MS::AI::CosmeticAI::UpdateAI(p_Diff);

			m_Events.Update(p_Diff);

			if (m_Events.ExecuteEvent() == eData::EventLoop)
			{
				if (Creature* l_Creature = me->FindNearestCreature(eData::WarspearGrunt2, 1.5f))
				{
					if (l_Creature->AI())
					{
						l_Creature->AI()->DoAction(eData::ActionLoop);
						ScheduleAllTalks();
					}
				}
			}
		}
	};

	CreatureAI* GetAI(Creature* p_Creature) const override
	{
		return new npc_ashran_warspear_grunt_flightmaster_1AI(p_Creature);
	}
};

/// Warspear Grunt - 864601
class npc_ashran_warspear_grunt_flightmaster_2 : public CreatureScript
{
public:
	npc_ashran_warspear_grunt_flightmaster_2() : CreatureScript("npc_ashran_warspear_grunt_flightmaster_2") { }

	enum eTalks
	{
		First,
		Second,
		Third,
		Fourth,
		Fifth
	};

	enum eData
	{
		WarspearGrunt1 = 864721,
		ActionInit = 0,
		ActionLoop = 1
	};

	struct npc_ashran_warspear_grunt_flightmaster_2AI : public MS::AI::CosmeticAI
	{
		npc_ashran_warspear_grunt_flightmaster_2AI(Creature* p_Creature) : MS::AI::CosmeticAI(p_Creature) { }

		bool m_Init;

		void Reset() override
		{
			m_Init = false;

			if (Creature* l_Creature = me->FindNearestCreature(eData::WarspearGrunt1, 15.0f))
			{
				if (l_Creature->AI())
				{
					m_Init = true;
					l_Creature->AI()->DoAction(eData::ActionInit);
					ScheduleAllTalks();
				}
			}
		}

		void DoAction(int32 const p_Action) override
		{
			switch (p_Action)
			{
			case eData::ActionInit:
				m_Init = true;
				ScheduleAllTalks();
				break;
			case eData::ActionLoop:
				ScheduleAllTalks();
				break;
			default:
				break;
			}
		}

		void ScheduleAllTalks()
		{
			AddTimedDelayedOperation(10 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::First); });
			AddTimedDelayedOperation(27 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Second); });
			AddTimedDelayedOperation(78 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Third); });
			AddTimedDelayedOperation(94 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Fourth); });
			AddTimedDelayedOperation(110 * TimeConstants::IN_MILLISECONDS, [this]() -> void { Talk(eTalks::Fifth); });
		}
	};

	CreatureAI* GetAI(Creature* p_Creature) const override
	{
		return new npc_ashran_warspear_grunt_flightmaster_2AI(p_Creature);
	}
};

/// Hand-Written Sign - 237776
class gob_ashran_handwritten_sign : public GameObjectScript
{
public:
	gob_ashran_handwritten_sign() : GameObjectScript("gob_ashran_handwritten_sign") { }

	bool OnGossipHello(Player* p_Player, GameObject* p_GameObject) override
	{
		if (Creature* l_Jasa = p_GameObject->FindNearestCreature(86041, 15.0f))
		{
			l_Jasa->AI()->Talk(0);
		}

		return false;
	}
};

/// Shadow Hunter Gar'ant - 86040
class npc_ashran_shadowhunter_garant : public CreatureScript
{
public:
	npc_ashran_shadowhunter_garant() : CreatureScript("npc_ashran_shadowhunter_garant") { }

	enum eTalks
	{
		First,
		Second,
		Third,
		Fourth,
		Fifth,
		Sixth,
		Seventh,
		Eighth,
		Ninth,
		Tenth,
		Eleventh,
		Twelfth
	};

	enum eData
	{
		WarspearScout = 88531,
		ActionInit = 0,
		ActionLoop = 1,
		EventLoop = 1
	};

	struct npc_ashran_shadowhunter_garantAI : public MS::AI::CosmeticAI
	{
		npc_ashran_shadowhunter_garantAI(Creature* p_Creature) : MS::AI::CosmeticAI(p_Creature) { }

		bool m_Init;
		EventMap m_Events;

		void Reset() override
		{
			m_Init = false;

			if (Creature* l_Creature = me->FindNearestCreature(eData::WarspearScout, 300.0f))
			{
				if (l_Creature->AI())
				{
					m_Init = true;
					l_Creature->AI()->DoAction(eData::ActionInit);
					ScheduleAllTalks();
				}
			}
		}

		void DoAction(int32 const p_Action) override
		{
			switch (p_Action)
			{
			case eData::ActionInit:
				if (m_Init)
					break;
				m_Init = true;
				ScheduleAllTalks();
				break;
			default:
				break;
			}
		}

		void ScheduleAllTalks()
		{
			AddTimedDelayedOperation(47 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				Talk(eTalks::First);
			});

			AddTimedDelayedOperation(59 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				Talk(eTalks::Second);
			});

			AddTimedDelayedOperation(71 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				Talk(eTalks::Third);
			});

			AddTimedDelayedOperation(151 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				Talk(eTalks::Fourth);
			});

			AddTimedDelayedOperation(163 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				Talk(eTalks::Fifth);
			});

			AddTimedDelayedOperation(175 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				Talk(eTalks::Sixth);
			});

			AddTimedDelayedOperation(258 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				Talk(eTalks::Seventh);
			});

			AddTimedDelayedOperation(270 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				Talk(eTalks::Eighth);
			});

			AddTimedDelayedOperation(331 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				Talk(eTalks::Ninth);
			});

			AddTimedDelayedOperation(343 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				Talk(eTalks::Tenth);
			});

			AddTimedDelayedOperation(353 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				Talk(eTalks::Eleventh);
			});
		}

		void LastOperationCalled() override
		{
			m_Events.ScheduleEvent(eData::EventLoop, 31 * TimeConstants::IN_MILLISECONDS);
		}

		void UpdateAI(const uint32 p_Diff) override
		{
			MS::AI::CosmeticAI::UpdateAI(p_Diff);

			m_Events.Update(p_Diff);

			if (m_Events.ExecuteEvent() == eData::EventLoop)
			{
				if (Creature* l_Creature = me->FindNearestCreature(eData::WarspearScout, 300.0f))
				{
					if (l_Creature->AI())
					{
						l_Creature->AI()->DoAction(eData::ActionLoop);
						ScheduleAllTalks();
					}
				}
			}
		}
	};

	CreatureAI* GetAI(Creature* p_Creature) const override
	{
		return new npc_ashran_shadowhunter_garantAI(p_Creature);
	}
};

static std::array<G3D::Vector3, 12> g_ScoutFirst =
{
	{
		{ 5130.7192f, -3968.8635f, 6.2601f   },
		{ 5151.6724f, -3965.1477f, -0.2091f  },
		{ 5163.0903f, -3962.9993f, 1.6011f   },
		{ 5176.5488f, -3962.2869f, 3.8392f   },
		{ 5188.4385f, -3961.5542f, 4.8528f   },
		{ 5204.6216f, -3960.7212f, 3.2512f   },
		{ 5235.2544f, -3964.1348f, 9.0833f   },
		{ 5259.0474f, -3985.1365f, 14.0173f  },
		{ 5259.5640f, -3993.4067f, 14.1146f  },
		{ 5250.3076f, -4006.3616f, 13.8079f  },
		{ 5230.2676f, -4009.3096f, 18.5524f  },
		{ 5216.2876f, -4011.2200f, 18.2152f  }
	}
};

static std::array<G3D::Vector3, 12> g_ScoutBack =
{
	{
		{ 5216.2876f, -4011.2200f, 18.2152f  },
		{ 5230.2676f, -4009.3096f, 18.5524f  },
		{ 5250.3076f, -4006.3616f, 13.8079f  },
		{ 5259.5640f, -3993.4067f, 14.1146f  },
		{ 5259.0474f, -3985.1365f, 14.0173f  },
		{ 5235.2544f, -3964.1348f, 9.0833f   },
		{ 5204.6216f, -3960.7212f, 3.2512f   },
		{ 5188.4385f, -3961.5542f, 4.8528f   },
		{ 5176.5488f, -3962.2869f, 3.8392f   },
		{ 5163.0903f, -3962.9993f, 1.6011f   },
		{ 5151.6724f, -3965.1477f, -0.2091f  },
		{ 5130.7192f, -3968.8635f, 6.2601f   }

	}
};

/// Warspear Scout - 88531
class npc_ashran_warspear_scout : public CreatureScript
{
public:
	npc_ashran_warspear_scout() : CreatureScript("npc_ashran_warspear_scout") { }

	enum eTalks
	{
		First,
		Second,
		Third,
		Fourth,
		Fifth,
		Sixth,
		Seventh
	};

	enum eData
	{
		Garant = 86040,
		ActionInit = 0,
		ActionLoop = 1
	};

	struct npc_ashran_warspear_scoutAI : public MS::AI::CosmeticAI
	{
		npc_ashran_warspear_scoutAI(Creature* p_Creature) : MS::AI::CosmeticAI(p_Creature) { }

		bool m_Init;

		void Reset() override
		{
			m_Init = false;

			if (Creature* l_Creature = me->FindNearestCreature(eData::Garant, 300.0f))
			{
				if (l_Creature->AI())
				{
					m_Init = true;
					l_Creature->AI()->DoAction(eData::ActionInit);
					ScheduleAllTalks();
				}
			}
		}

		void DoAction(int32 const p_Action) override
		{
			switch (p_Action)
			{
			case eData::ActionInit:
				m_Init = true;
				ScheduleAllTalks();
				break;
			case eData::ActionLoop:
				ScheduleAllTalks();
				break;
			default:
				break;
			}
		}

		void ScheduleAllTalks()
		{
			AddTimedDelayedOperation(1 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->GetMotionMaster()->MoveSmoothPath(0, g_ScoutFirst.data(), g_ScoutFirst.size(), false);
			});

			AddTimedDelayedOperation(29 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				if (Creature* l_Creature = me->FindNearestCreature(eData::Garant, 15.0f))
				{
					me->SetFacingToObject(l_Creature);
				}

				Talk(eTalks::First);
			});

			AddTimedDelayedOperation(37 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				Talk(eTalks::Third);
			});

			AddTimedDelayedOperation(79 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				Talk(eTalks::Second);
			});

			AddTimedDelayedOperation(83 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->GetMotionMaster()->MoveSmoothPath(0, g_ScoutBack.data(), g_ScoutBack.size(), false);
			});

			AddTimedDelayedOperation(110 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->GetMotionMaster()->MoveSmoothPath(0, g_ScoutFirst.data(), g_ScoutFirst.size(), false);
			});

			AddTimedDelayedOperation(133.5 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				if (Creature* l_Creature = me->FindNearestCreature(eData::Garant, 15.0f))
				{
					me->SetFacingToObject(l_Creature);
				}

				Talk(eTalks::First);
			});

			AddTimedDelayedOperation(139 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				Talk(eTalks::Fourth);
			});

			AddTimedDelayedOperation(175 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				Talk(eTalks::Second);
			});

			AddTimedDelayedOperation(179 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->GetMotionMaster()->MoveSmoothPath(0, g_ScoutBack.data(), g_ScoutBack.size(), false);
			});

			AddTimedDelayedOperation(206 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->GetMotionMaster()->MoveSmoothPath(0, g_ScoutFirst.data(), g_ScoutFirst.size(), false);
			});

			AddTimedDelayedOperation(229 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				if (Creature* l_Creature = me->FindNearestCreature(eData::Garant, 15.0f))
				{
					me->SetFacingToObject(l_Creature);
				}

				Talk(eTalks::First);
			});

			AddTimedDelayedOperation(233 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				Talk(eTalks::Fifth);
			});

			AddTimedDelayedOperation(242 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				Talk(eTalks::Sixth);
			});

			AddTimedDelayedOperation(273 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				Talk(eTalks::Second);
			});

			AddTimedDelayedOperation(285 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
			me->GetMotionMaster()->MoveSmoothPath(0, g_ScoutBack.data(), g_ScoutBack.size(), false);
			});

			AddTimedDelayedOperation(296 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
			me->GetMotionMaster()->MoveSmoothPath(0, g_ScoutFirst.data(), g_ScoutFirst.size(), false);
			});

			AddTimedDelayedOperation(315 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				if (Creature* l_Creature = me->FindNearestCreature(eData::Garant, 15.0f))
				{
					me->SetFacingToObject(l_Creature);
				}

				Talk(eTalks::First);
			});

			AddTimedDelayedOperation(323 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				Talk(eTalks::Seventh);
			});

			AddTimedDelayedOperation(363 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				Talk(eTalks::Second);
			});

			AddTimedDelayedOperation(367 * TimeConstants::IN_MILLISECONDS, [this]() -> void
			{
				me->GetMotionMaster()->MoveSmoothPath(0, g_ScoutBack.data(), g_ScoutBack.size(), false);
			});
		}
	};

	CreatureAI* GetAI(Creature* p_Creature) const override
	{
		return new npc_ashran_warspear_scoutAI(p_Creature);
	}
};

/// Souchi Windpaw - 87765
class npc_ashran_souchi_windpaw : public CreatureScript
{
public:
	npc_ashran_souchi_windpaw() : CreatureScript("npc_ashran_souchi_windpaw") { }

	enum eAction
	{
		Heal0A = 0,
		Heal0B = 1,
		Heal1A = 2,
		Heal1B = 3,
		Heal2A = 4,
		Heal2B = 5,
	};

	struct npc_ashran_souchi_windpawAI : public ScriptedAI
	{
		npc_ashran_souchi_windpawAI(Creature* p_Creature) : ScriptedAI(p_Creature) { }

		void Reset() override
		{
			ClearDelayedOperations();

			DoAction(eAction::Heal0A);
		}

		void WaypointReached(uint32 waypointId)
		{
			switch (waypointId)
			{
				case 6:
				{
					if (me->GetPositionX() == 5253.497559f)
						me->AI()->DoAction(eAction::Heal0B);

					if (me->GetPositionX() == 5272.928223f)
						me->AI()->DoAction(eAction::Heal1B);

					if (me->GetPositionX() == 5267.468262f)
						me->AI()->DoAction(eAction::Heal2B);
				}
			}
		}

		void DoAction(int32 const p_Action) override
		{
			switch (p_Action)
			{
				case eAction::Heal0A:
				{
					AddTimedDelayedOperation(0 * TimeConstants::IN_MILLISECONDS, [this]() -> void
					{
						me->GetMotionMaster()->MovePath(8776504, false);
					});
					break;
				}

				case eAction::Heal0B: // When reached point 6
				{
					AddTimedDelayedOperation(0 * TimeConstants::IN_MILLISECONDS, [this]() -> void
					{
						me->AI()->Talk(urand(0, 2));
					});

					AddTimedDelayedOperation(1 * TimeConstants::IN_MILLISECONDS, [this]() -> void
					{
						std::list<Creature*> l_Peon;
						me->GetCreatureListWithEntryInGrid(l_Peon, 87766, 5.0f);

						for (auto itr : l_Peon)
						{
							me->CastSpell(itr, 174609, false);
						}
					});

					AddTimedDelayedOperation(11 * TimeConstants::IN_MILLISECONDS, [this]() -> void
					{
						me->CastStop();
						me->AI()->DoAction(eAction::Heal1A);
					});
					break;
				}

				case eAction::Heal1A:
				{
					AddTimedDelayedOperation(0 * TimeConstants::IN_MILLISECONDS, [this]() -> void
					{
						me->GetMotionMaster()->MovePath(8776501, false);
					});
					break;
				}

				case eAction::Heal1B: // When reached point 6
				{
					AddTimedDelayedOperation(0 * TimeConstants::IN_MILLISECONDS, [this]() -> void
					{
						me->AI()->Talk(urand(0, 2));
					});

					AddTimedDelayedOperation(1 * TimeConstants::IN_MILLISECONDS, [this]() -> void
					{
						std::list<Creature*> l_Peon;
						me->GetCreatureListWithEntryInGrid(l_Peon, 87766, 5.0f);

						for (auto itr : l_Peon)
						{
							me->CastSpell(itr, 174609, false);
						}
					});

					AddTimedDelayedOperation(11 * TimeConstants::IN_MILLISECONDS, [this]() -> void
					{
						me->CastStop();
						me->AI()->DoAction(eAction::Heal2A);
					});
					break;
				}

				case eAction::Heal2A:
				{
					AddTimedDelayedOperation(0 * TimeConstants::IN_MILLISECONDS, [this]() -> void
					{
						me->GetMotionMaster()->MovePath(8776502, false);
					});
					break;
				}

				case eAction::Heal2B: // When reached point 6
				{
					AddTimedDelayedOperation(0 * TimeConstants::IN_MILLISECONDS, [this]() -> void
					{
						me->AI()->Talk(urand(0, 2));
					});

					AddTimedDelayedOperation(1 * TimeConstants::IN_MILLISECONDS, [this]() -> void
					{
						std::list<Creature*> l_Peon;
						me->GetCreatureListWithEntryInGrid(l_Peon, 87766, 5.0f);

						for (auto itr : l_Peon)
						{
							me->CastSpell(itr, 174609, false);
						}
					});

					AddTimedDelayedOperation(11 * TimeConstants::IN_MILLISECONDS, [this]() -> void
					{
						me->CastStop();
						me->AI()->DoAction(eAction::Heal0A);
					});
					break;
				}
			default:
				break;
			}
		}

		void UpdateAI(const uint32 p_Diff) override
		{
			UpdateOperations(p_Diff);
		}
	};

	CreatureAI* GetAI(Creature* p_Creature) const override
	{
		return new npc_ashran_souchi_windpawAI(p_Creature);
	}
};

/// Vol'jin's Spear Battle Standard - 85383
class npc_ashran_voljins_spear_battle_standard : public CreatureScript
{
    public:
        npc_ashran_voljins_spear_battle_standard() : CreatureScript("npc_ashran_voljins_spear_battle_standard") { }

        struct npc_ashran_voljins_spear_battle_standardAI : public ScriptedAI
        {
            npc_ashran_voljins_spear_battle_standardAI(Creature* p_Creature) : ScriptedAI(p_Creature) { }

            void Reset() override
            {
                me->SetReactState(ReactStates::REACT_PASSIVE);
            }

            void JustDied(Unit* /*p_Killer*/) override
            {
                me->DespawnOrUnsummon();
            }
        };

        CreatureAI* GetAI(Creature* p_Creature) const override
        {
            return new npc_ashran_voljins_spear_battle_standardAI(p_Creature);
        }
};

/// Warspear Headhunter - 88691
class npc_ashran_warspear_headhunter : public CreatureScript
{
    public:
        npc_ashran_warspear_headhunter() : CreatureScript("npc_ashran_warspear_headhunter") { }

        enum eSpells
        {
            SpellShoot              = 163921,
            SpellKillShot           = 173642,
            SpellHeadhuntersMark    = 177203,
            SpellConcussiveShot     = 17174
        };

        enum eEvents
        {
            SearchTarget = 1,
            EventShoot,
            EventKillShot,
            EventHeadhuntersMark,
            EventConcussiveShot,
            EventClearEvade
        };

        struct npc_ashran_warspear_headhunterAI : public ScriptedAI
        {
            npc_ashran_warspear_headhunterAI(Creature* p_Creature) : ScriptedAI(p_Creature)
            {
                m_CosmeticEvent.Reset();
            }

            EventMap m_Events;
            EventMap m_CosmeticEvent;

            void Reset() override
            {
                m_Events.Reset();

                me->SetFlag(EUnitFields::UNIT_FIELD_FLAGS, eUnitFlags::UNIT_FLAG_DISABLE_MOVE);
                me->AddUnitState(UnitState::UNIT_STATE_ROOT);

                m_CosmeticEvent.ScheduleEvent(eEvents::SearchTarget, 1 * TimeConstants::IN_MILLISECONDS);
            }

            void EnterCombat(Unit* /*p_Attacker*/) override
            {
                m_Events.ScheduleEvent(eEvents::EventShoot, 1 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventKillShot, 1 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventHeadhuntersMark, 5 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventConcussiveShot, 10 * TimeConstants::IN_MILLISECONDS);
            }

            void EnterEvadeMode() override
            {
                me->ClearUnitState(UnitState::UNIT_STATE_ROOT);

                CreatureAI::EnterEvadeMode();

                m_CosmeticEvent.ScheduleEvent(eEvents::EventClearEvade, 500);
            }

            void UpdateAI(uint32 const p_Diff) override
            {
                m_CosmeticEvent.Update(p_Diff);

                switch (m_CosmeticEvent.ExecuteEvent())
                {
                    case eEvents::SearchTarget:
                    {
                        if (Player* l_Player = me->FindNearestPlayer(40.0f))
                            AttackStart(l_Player);
                        else
                            m_CosmeticEvent.ScheduleEvent(eEvents::SearchTarget, 1 * TimeConstants::IN_MILLISECONDS);

                        break;
                    }
                    case eEvents::EventClearEvade:
                    {
                        me->ClearUnitState(UnitState::UNIT_STATE_EVADE);
                        break;
                    }
                    default:
                        break;
                }

                if (!UpdateVictim())
                    return;

                m_Events.Update(p_Diff);

                if (me->HasUnitState(UnitState::UNIT_STATE_CASTING))
                    return;

                switch (m_Events.ExecuteEvent())
                {
                    case eEvents::EventShoot:
                    {
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::SpellShoot, false);
                        m_Events.ScheduleEvent(eEvents::EventShoot, 5 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    case eEvents::EventKillShot:
                    {
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                        {
                            if (l_Target->HealthBelowPct(20))
                            {
                                me->CastSpell(l_Target, eSpells::SpellKillShot, false);
                                m_Events.ScheduleEvent(eEvents::EventKillShot, 10 * TimeConstants::IN_MILLISECONDS);
                                break;
                            }
                        }

                        m_Events.ScheduleEvent(eEvents::EventKillShot, 1 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    case eEvents::EventHeadhuntersMark:
                    {
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::SpellHeadhuntersMark, false);
                        m_Events.ScheduleEvent(eEvents::EventHeadhuntersMark, 18 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    case eEvents::EventConcussiveShot:
                    {
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::SpellConcussiveShot, false);
                        m_Events.ScheduleEvent(eEvents::EventConcussiveShot, 10 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    default:
                        break;
                }

                DoMeleeAttackIfReady();
            }
        };

        CreatureAI* GetAI(Creature* p_Creature) const override
        {
            return new npc_ashran_warspear_headhunterAI(p_Creature);
        }
};

/// Lord Mes <Horde Captain> - 80497
class npc_ashran_lord_mes : public CreatureScript
{
    public:
        npc_ashran_lord_mes() : CreatureScript("npc_ashran_lord_mes") { }

        enum eSpells
        {
            PlagueStrike    = 164063,
            DeathAndDecay   = 164334,
            DeathCoil       = 164064,
            DeathGrip       = 79894,
            DeathGripJump   = 168563
        };

        enum eEvents
        {
            EventPlagueStrike = 1,
            EventDeathAndDecay,
            EventDeathCoil,
            EventDeathGrip,
            EventMove
        };

        enum eTalks
        {
            Spawn,
            Death
        };

        enum eData
        {
            MountID = 25280
        };

        struct npc_ashran_lord_mesAI : public ScriptedAI
        {
            npc_ashran_lord_mesAI(Creature* p_Creature) : ScriptedAI(p_Creature)
            {
                m_Spawn = false;
            }

            EventMap m_Events;
            EventMap m_MoveEvent;
            bool m_Spawn;

            void InitializeAI() override
            {
                m_MoveEvent.ScheduleEvent(eEvents::EventMove, 1 * TimeConstants::IN_MILLISECONDS);

                Reset();
            }

            void Reset() override
            {
                m_Events.Reset();

                if (!m_Spawn)
                {
                    Talk(eTalks::Spawn);
                    m_Spawn = true;
                }

                me->Mount(eData::MountID);
            }

            void EnterCombat(Unit* /*p_Attacker*/) override
            {
                me->Mount(0);
                me->SetHomePosition(*me);

                m_Events.ScheduleEvent(eEvents::EventPlagueStrike, 2 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventDeathAndDecay, 5 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventDeathCoil, 8 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventDeathGrip, 1 * TimeConstants::IN_MILLISECONDS);
            }

            void JustDied(Unit* /*p_Killer*/) override
            {
                Talk(eTalks::Death);

                if (OutdoorPvPAshran* l_Ashran = (OutdoorPvPAshran*)me->GetZoneScript())
                    l_Ashran->HandleCaptainDeath(eSpecialSpawns::CaptainLordMes);
            }

            void SpellHitTarget(Unit* p_Target, SpellInfo const* p_SpellInfo) override
            {
                if (p_Target == nullptr)
                    return;

                if (p_SpellInfo->Id == eSpells::DeathGrip)
                    p_Target->CastSpell(*me, eSpells::DeathGripJump, true);
            }

            void UpdateAI(uint32 const p_Diff) override
            {
                m_MoveEvent.Update(p_Diff);

                if (m_MoveEvent.ExecuteEvent() == eEvents::EventMove)
                {
                    /// Use same path as Kronus
                    me->LoadPath(eCreatures::Kronus);
                    me->SetDefaultMovementType(MovementGeneratorType::WAYPOINT_MOTION_TYPE);
                    me->GetMotionMaster()->Initialize();
                }

                if (!UpdateVictim())
                    return;

                m_Events.Update(p_Diff);

                if (me->HasUnitState(UnitState::UNIT_STATE_CASTING))
                    return;

                switch (m_Events.ExecuteEvent())
                {
                    case eEvents::EventPlagueStrike:
                    {
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::PlagueStrike, false);
                        m_Events.ScheduleEvent(eEvents::EventPlagueStrike, 8 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    case eEvents::EventDeathAndDecay:
                    {
                        me->CastSpell(me, eSpells::DeathAndDecay, false);
                        m_Events.ScheduleEvent(eEvents::EventDeathAndDecay, 12 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    case eEvents::EventDeathCoil:
                    {
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::DeathCoil, false);
                        m_Events.ScheduleEvent(eEvents::EventDeathCoil, 10 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    case eEvents::EventDeathGrip:
                    {
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::DeathGrip, false);
                        m_Events.ScheduleEvent(eEvents::EventDeathGrip, 20 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    default:
                        break;
                }

                DoMeleeAttackIfReady();
            }
        };

        CreatureAI* GetAI(Creature* p_Creature) const override
        {
            return new npc_ashran_lord_mesAI(p_Creature);
        }
};

/// Mindbender Talbadar <Horde Captain> - 80490
class npc_ashran_mindbender_talbadar : public CreatureScript
{
    public:
        npc_ashran_mindbender_talbadar() : CreatureScript("npc_ashran_mindbender_talbadar") { }

        enum eSpells
        {
            DevouringPlague = 164452,
            Dispersion      = 164444,
            MindBlast       = 164448,
            MindSear        = 177402,
            PsychicScream   = 164443,
            ShadowWordPain  = 164446
        };

        enum eEvents
        {
            EventDevouringPlague = 1,
            EventDispersion,
            EventMindBlast,
            EventMindSear,
            EventPsychicScream,
            EventShadowWordPain,
            EventMove
        };

        enum eTalk
        {
            Spawn
        };

        struct npc_ashran_mindbender_talbadarAI : public ScriptedAI
        {
            npc_ashran_mindbender_talbadarAI(Creature* p_Creature) : ScriptedAI(p_Creature)
            {
                m_Spawn = false;
            }

            EventMap m_Events;
            EventMap m_MoveEvent;
            bool m_Spawn;

            void InitializeAI() override
            {
                m_MoveEvent.ScheduleEvent(eEvents::EventMove, 1 * TimeConstants::IN_MILLISECONDS);

                Reset();
            }

            void Reset() override
            {
                m_Events.Reset();

                if (!m_Spawn)
                {
                    Talk(eTalk::Spawn);
                    m_Spawn = true;
                }
            }

            void EnterCombat(Unit* /*p_Attacker*/) override
            {
                me->SetHomePosition(*me);

                m_Events.ScheduleEvent(eEvents::EventDevouringPlague, 10 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventDispersion, 1 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventMindBlast, 5 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventMindSear, 8 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventPsychicScream, 15 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventShadowWordPain, 1 * TimeConstants::IN_MILLISECONDS);
            }

            void JustDied(Unit* /*p_Killer*/) override
            {
                if (OutdoorPvPAshran* l_Ashran = (OutdoorPvPAshran*)me->GetZoneScript())
                    l_Ashran->HandleCaptainDeath(eSpecialSpawns::CaptainMindbenderTalbadar);
            }

            void UpdateAI(uint32 const p_Diff) override
            {
                m_MoveEvent.Update(p_Diff);

                if (m_MoveEvent.ExecuteEvent() == eEvents::EventMove)
                {
                    /// Use same path as Kronus
                    me->LoadPath(eCreatures::Kronus);
                    me->SetDefaultMovementType(MovementGeneratorType::WAYPOINT_MOTION_TYPE);
                    me->GetMotionMaster()->Initialize();
                }

                if (!UpdateVictim())
                    return;

                m_Events.Update(p_Diff);

                if (me->HasUnitState(UnitState::UNIT_STATE_CASTING))
                    return;

                switch (m_Events.ExecuteEvent())
                {
                    case eEvents::EventDevouringPlague:
                    {
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::DevouringPlague, false);
                        m_Events.ScheduleEvent(eEvents::EventDevouringPlague, 15 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    case eEvents::EventDispersion:
                    {
                        if (me->HealthBelowPct(50))
                            me->CastSpell(me, eSpells::Dispersion, true);
                        else
                            m_Events.ScheduleEvent(eEvents::EventDispersion, 1 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    case eEvents::EventMindBlast:
                    {
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::MindBlast, false);
                        m_Events.ScheduleEvent(eEvents::EventMindBlast, 10 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    case eEvents::EventMindSear:
                    {
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::MindSear, false);
                        m_Events.ScheduleEvent(eEvents::EventMindSear, 20 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    case eEvents::EventPsychicScream:
                    {
                        me->CastSpell(me, eSpells::PsychicScream, false);
                        m_Events.ScheduleEvent(eEvents::EventPsychicScream, 30 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    case eEvents::EventShadowWordPain:
                    {
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::ShadowWordPain, false);
                        m_Events.ScheduleEvent(eEvents::EventShadowWordPain, 12 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    default:
                        break;
                }

                DoMeleeAttackIfReady();
            }
        };

        CreatureAI* GetAI(Creature* p_Creature) const override
        {
            return new npc_ashran_mindbender_talbadarAI(p_Creature);
        }
};

/// Elliott Van Rook <Horde Captain> - 80493
class npc_ashran_elliott_van_rook : public CreatureScript
{
    public:
        npc_ashran_elliott_van_rook() : CreatureScript("npc_ashran_elliott_van_rook") { }

        enum eSpells
        {
            Blizzard    = 162610,
            FrostNova   = 164067,
            Frostbolt   = 162608,
            IceLance    = 162609
        };

        enum eEvents
        {
            EventBlizzard = 1,
            EventFrostNova,
            EventFrostbolt,
            EventIceLance,
            EventMove
        };

        enum eTalks
        {
            Slay,
            Death
        };

        enum eData
        {
            MountID = 51048
        };

        struct npc_ashran_elliott_van_rookAI : public ScriptedAI
        {
            npc_ashran_elliott_van_rookAI(Creature* p_Creature) : ScriptedAI(p_Creature) { }

            EventMap m_Events;
            EventMap m_MoveEvent;

            void InitializeAI() override
            {
                m_MoveEvent.ScheduleEvent(eEvents::EventMove, 1 * TimeConstants::IN_MILLISECONDS);

                Reset();
            }

            void Reset() override
            {
                m_Events.Reset();

                me->Mount(eData::MountID);
            }

            void EnterCombat(Unit* /*p_Attacker*/) override
            {
                me->Mount(0);
                me->SetHomePosition(*me);

                m_Events.ScheduleEvent(eEvents::EventBlizzard, 6 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventFrostNova, 5 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventFrostbolt, 1 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventIceLance, 10 * TimeConstants::IN_MILLISECONDS);
            }

            void KilledUnit(Unit* p_Killed) override
            {
                if (p_Killed->GetTypeId() == TypeID::TYPEID_PLAYER)
                    Talk(eTalks::Slay);
            }

            void JustDied(Unit* /*p_Killer*/) override
            {
                Talk(eTalks::Death);

                if (OutdoorPvPAshran* l_Ashran = (OutdoorPvPAshran*)me->GetZoneScript())
                    l_Ashran->HandleCaptainDeath(eSpecialSpawns::CaptainElliotVanRook);
            }

            void UpdateAI(uint32 const p_Diff) override
            {
                m_MoveEvent.Update(p_Diff);

                if (m_MoveEvent.ExecuteEvent() == eEvents::EventMove)
                {
                    /// Use same path as Kronus
                    me->LoadPath(eCreatures::Kronus);
                    me->SetDefaultMovementType(MovementGeneratorType::WAYPOINT_MOTION_TYPE);
                    me->GetMotionMaster()->Initialize();
                }

                if (!UpdateVictim())
                    return;

                m_Events.Update(p_Diff);

                if (me->HasUnitState(UnitState::UNIT_STATE_CASTING))
                    return;

                switch (m_Events.ExecuteEvent())
                {
                    case eEvents::EventBlizzard:
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::Blizzard, false);
                        m_Events.ScheduleEvent(eEvents::EventBlizzard, 20 * TimeConstants::IN_MILLISECONDS);
                        break;
                    case eEvents::EventFrostNova:
                        me->CastSpell(me, eSpells::FrostNova, false);
                        m_Events.ScheduleEvent(eEvents::EventFrostNova, 20 * TimeConstants::IN_MILLISECONDS);
                        break;
                    case eEvents::EventFrostbolt:
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::Frostbolt, false);
                        m_Events.ScheduleEvent(eEvents::EventFrostbolt, 5 * TimeConstants::IN_MILLISECONDS);
                        break;
                    case eEvents::EventIceLance:
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::IceLance, false);
                        m_Events.ScheduleEvent(eEvents::EventIceLance, 10 * TimeConstants::IN_MILLISECONDS);
                        break;
                    default:
                        break;
                }

                DoMeleeAttackIfReady();
            }
        };

        CreatureAI* GetAI(Creature* p_Creature) const override
        {
            return new npc_ashran_elliott_van_rookAI(p_Creature);
        }
};

/// Vanguard Samuelle <Horde Captain> - 80492
class npc_ashran_vanguard_samuelle : public CreatureScript
{
    public:
        npc_ashran_vanguard_samuelle() : CreatureScript("npc_ashran_vanguard_samuelle") { }

        enum eSpells
        {
            Judgment        = 162760,
            HammerOfWrath   = 162763,
            DivineShield    = 164410,
            DivineStorm     = 162641,
            HammerOfJustice = 162764,
            AvengingWrath   = 164397
        };

        enum eEvents
        {
            EventJudgment = 1,
            EventHammerOfWrath,
            EventDivineShield,
            EventDivineStorm,
            EventHammerOfJustice,
            EventAvengingWrath,
            EventMove
        };

        enum eTalks
        {
            Slay,
            Death
        };

        struct npc_ashran_vanguard_samuelleAI : public ScriptedAI
        {
            npc_ashran_vanguard_samuelleAI(Creature* p_Creature) : ScriptedAI(p_Creature) { }

            EventMap m_Events;
            EventMap m_MoveEvent;

            void InitializeAI() override
            {
                m_MoveEvent.ScheduleEvent(eEvents::EventMove, 1 * TimeConstants::IN_MILLISECONDS);

                Reset();
            }

            void Reset() override
            {
                m_Events.Reset();
            }

            void EnterCombat(Unit* /*p_Attacker*/) override
            {
                me->SetHomePosition(*me);

                m_Events.ScheduleEvent(eEvents::EventJudgment, 1 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventHammerOfWrath, 5 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventDivineShield, 1 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventDivineStorm, 8 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventHammerOfJustice, 7 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventAvengingWrath, 10 * TimeConstants::IN_MILLISECONDS);
            }

            void KilledUnit(Unit* p_Killed) override
            {
                if (p_Killed->GetTypeId() == TypeID::TYPEID_PLAYER)
                    Talk(eTalks::Slay);
            }

            void JustDied(Unit* /*p_Killer*/) override
            {
                Talk(eTalks::Death);

                if (OutdoorPvPAshran* l_Ashran = (OutdoorPvPAshran*)me->GetZoneScript())
                    l_Ashran->HandleCaptainDeath(eSpecialSpawns::CaptainVanguardSamuelle);
            }

            void UpdateAI(uint32 const p_Diff) override
            {
                m_MoveEvent.Update(p_Diff);

                if (m_MoveEvent.ExecuteEvent() == eEvents::EventMove)
                {
                    /// Use same path as Kronus
                    me->LoadPath(eCreatures::Kronus);
                    me->SetDefaultMovementType(MovementGeneratorType::WAYPOINT_MOTION_TYPE);
                    me->GetMotionMaster()->Initialize();
                }

                if (!UpdateVictim())
                    return;

                m_Events.Update(p_Diff);

                if (me->HasUnitState(UnitState::UNIT_STATE_CASTING))
                    return;

                switch (m_Events.ExecuteEvent())
                {
                    case eEvents::EventJudgment:
                    {
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::Judgment, false);
                        m_Events.ScheduleEvent(eEvents::EventJudgment, 15 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    case eEvents::EventHammerOfWrath:
                    {
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::HammerOfWrath, false);
                        m_Events.ScheduleEvent(eEvents::EventHammerOfWrath, 15 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    case eEvents::EventDivineShield:
                    {
                        if (me->HealthBelowPct(50))
                            me->CastSpell(me, eSpells::DivineShield, true);
                        else
                            m_Events.ScheduleEvent(eEvents::EventDivineShield, 1 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    case eEvents::EventDivineStorm:
                    {
                        me->CastSpell(me, eSpells::DivineStorm, false);
                        m_Events.ScheduleEvent(eEvents::EventDivineStorm, 15 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    case eEvents::EventHammerOfJustice:
                    {
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::HammerOfJustice, false);
                        m_Events.ScheduleEvent(eEvents::EventHammerOfJustice, 15 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    case eEvents::EventAvengingWrath:
                    {
                        me->CastSpell(me, eSpells::AvengingWrath, false);
                        m_Events.ScheduleEvent(eEvents::EventAvengingWrath, 45 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    default:
                        break;
                }

                DoMeleeAttackIfReady();
            }
        };

        CreatureAI* GetAI(Creature* p_Creature) const override
        {
            return new npc_ashran_vanguard_samuelleAI(p_Creature);
        }
};

/// Elementalist Novo <Horde Captain> - 80491
class npc_ashran_elementalist_novo : public CreatureScript
{
    public:
        npc_ashran_elementalist_novo() : CreatureScript("npc_ashran_elementalist_novo") { }

        enum eSpells
        {
            ChainLightning  = 178060,
            Hex             = 178064,
            LavaBurst       = 178091,
            LightningBolt   = 178059,
            MagmaTotem      = 178063,
            MagmaTotemAura  = 178062
        };

        enum eEvents
        {
            EventChainLightning = 1,
            EventHex,
            EventLavaBurst,
            EventLightningBolt,
            EventMagmaTotem,
            EventMove
        };

        enum eTalk
        {
            Death
        };

        struct npc_ashran_elementalist_novoAI : public ScriptedAI
        {
            npc_ashran_elementalist_novoAI(Creature* p_Creature) : ScriptedAI(p_Creature) { }

            EventMap m_Events;
            EventMap m_MoveEvent;

            void InitializeAI() override
            {
                m_MoveEvent.ScheduleEvent(eEvents::EventMove, 1 * TimeConstants::IN_MILLISECONDS);

                Reset();
            }

            void Reset() override
            {
                m_Events.Reset();

                /// Second equip is a shield
                me->SetCanDualWield(false);
            }

            void EnterCombat(Unit* /*p_Attacker*/) override
            {
                me->SetHomePosition(*me);

                m_Events.ScheduleEvent(eEvents::EventChainLightning, 5 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventHex, 10 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventLavaBurst, 8 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventLightningBolt, 2 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventMagmaTotem, 15 * TimeConstants::IN_MILLISECONDS);
            }

            void JustDied(Unit* /*p_Killer*/) override
            {
                Talk(eTalk::Death);

                if (OutdoorPvPAshran* l_Ashran = (OutdoorPvPAshran*)me->GetZoneScript())
                    l_Ashran->HandleCaptainDeath(eSpecialSpawns::CaptainElementalistNovo);
            }

            void JustSummoned(Creature* p_Summon) override
            {
                p_Summon->SetReactState(ReactStates::REACT_PASSIVE);
                p_Summon->AddAura(eSpells::MagmaTotemAura, p_Summon);
            }

            void UpdateAI(uint32 const p_Diff) override
            {
                m_MoveEvent.Update(p_Diff);

                if (m_MoveEvent.ExecuteEvent() == eEvents::EventMove)
                {
                    /// Use same path as Kronus
                    me->LoadPath(eCreatures::Kronus);
                    me->SetDefaultMovementType(MovementGeneratorType::WAYPOINT_MOTION_TYPE);
                    me->GetMotionMaster()->Initialize();
                }

                if (!UpdateVictim())
                    return;

                m_Events.Update(p_Diff);

                if (me->HasUnitState(UnitState::UNIT_STATE_CASTING))
                    return;

                switch (m_Events.ExecuteEvent())
                {
                    case eEvents::EventChainLightning:
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::ChainLightning, false);
                        m_Events.ScheduleEvent(eEvents::EventChainLightning, 8 * TimeConstants::IN_MILLISECONDS);
                        break;
                    case eEvents::EventHex:
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::Hex, false);
                        m_Events.ScheduleEvent(eEvents::EventHex, 30 * TimeConstants::IN_MILLISECONDS);
                        break;
                    case eEvents::EventLavaBurst:
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::LavaBurst, false);
                        m_Events.ScheduleEvent(eEvents::EventLavaBurst, 15 * TimeConstants::IN_MILLISECONDS);
                        break;
                    case eEvents::EventLightningBolt:
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::LightningBolt, false);
                        m_Events.ScheduleEvent(eEvents::EventLightningBolt, 6 * TimeConstants::IN_MILLISECONDS);
                        break;
                    case eEvents::EventMagmaTotem:
                        me->CastSpell(me, eSpells::MagmaTotem, false);
                        m_Events.ScheduleEvent(eEvents::EventMagmaTotem, 40 * TimeConstants::IN_MILLISECONDS);
                        break;
                    default:
                        break;
                }

                DoMeleeAttackIfReady();
            }
        };

        CreatureAI* GetAI(Creature* p_Creature) const override
        {
            return new npc_ashran_elementalist_novoAI(p_Creature);
        }
};

/// Captain Hoodrych <Horde Captain> - 79900
class npc_ashran_captain_hoodrych : public CreatureScript
{
    public:
        npc_ashran_captain_hoodrych() : CreatureScript("npc_ashran_captain_hoodrych") { }

        enum eSpells
        {
            SpellBladestorm = 164091,
            Shockwave       = 164092
        };

        enum eEvents
        {
            EventBladestorm = 1,
            EventShockwave,
            EventMove
        };

        enum eTalks
        {
            Slay,
            Bladestorm,
            Death
        };

        enum eData
        {
            MountID = 38607
        };

        struct npc_ashran_captain_hoodrychAI : public ScriptedAI
        {
            npc_ashran_captain_hoodrychAI(Creature* p_Creature) : ScriptedAI(p_Creature) { }

            EventMap m_Events;
            EventMap m_MoveEvent;

            void InitializeAI() override
            {
                m_MoveEvent.ScheduleEvent(eEvents::EventMove, 1 * TimeConstants::IN_MILLISECONDS);

                Reset();
            }

            void Reset() override
            {
                m_Events.Reset();

                me->Mount(eData::MountID);
            }

            void EnterCombat(Unit* /*p_Attacker*/) override
            {
                me->Mount(0);
                me->SetHomePosition(*me);

                m_Events.ScheduleEvent(eEvents::EventBladestorm, 5 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventShockwave, 10 * TimeConstants::IN_MILLISECONDS);
            }

            void KilledUnit(Unit* p_Killed) override
            {
                if (p_Killed->GetTypeId() == TypeID::TYPEID_PLAYER)
                    Talk(eTalks::Slay);
            }

            void EnterEvadeMode() override
            {
                me->InterruptNonMeleeSpells(true);

                CreatureAI::EnterEvadeMode();
            }

            void JustDied(Unit* /*p_Killer*/) override
            {
                Talk(eTalks::Death);

                if (OutdoorPvPAshran* l_Ashran = (OutdoorPvPAshran*)me->GetZoneScript())
                    l_Ashran->HandleCaptainDeath(eSpecialSpawns::CaptainCaptainHoodrych);
            }

            void UpdateAI(uint32 const p_Diff) override
            {
                m_MoveEvent.Update(p_Diff);

                if (m_MoveEvent.ExecuteEvent() == eEvents::EventMove)
                {
                    /// Use same path as Kronus
                    me->LoadPath(eCreatures::Kronus);
                    me->SetDefaultMovementType(MovementGeneratorType::WAYPOINT_MOTION_TYPE);
                    me->GetMotionMaster()->Initialize();
                }

                if (!UpdateVictim())
                    return;

                m_Events.Update(p_Diff);

                /// Update position during Bladestorm
                if (me->HasAura(eSpells::SpellBladestorm))
                {
                    if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                    {
                        me->GetMotionMaster()->MovePoint(0, *l_Target);
                        return;
                    }
                }

                /// Update target movements here to avoid some movements problems
                if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                {
                    if (!me->IsWithinMeleeRange(l_Target))
                    {
                        me->GetMotionMaster()->Clear();
                        me->GetMotionMaster()->MoveChase(l_Target);
                    }
                }

                if (me->HasUnitState(UnitState::UNIT_STATE_CASTING))
                    return;

                switch (m_Events.ExecuteEvent())
                {
                    case eEvents::EventBladestorm:
                        Talk(eTalks::Bladestorm);
                        me->CastSpell(me, eSpells::SpellBladestorm, false);
                        m_Events.ScheduleEvent(eEvents::EventBladestorm, 15 * TimeConstants::IN_MILLISECONDS);
                        break;
                    case eEvents::EventShockwave:
                        me->CastSpell(me, eSpells::Shockwave, false);
                        m_Events.ScheduleEvent(eEvents::EventShockwave, 20 * TimeConstants::IN_MILLISECONDS);
                        break;
                    default:
                        break;
                }

                DoMeleeAttackIfReady();
            }
        };

        CreatureAI* GetAI(Creature* p_Creature) const override
        {
            return new npc_ashran_captain_hoodrychAI(p_Creature);
        }
};

/// Soulbrewer Nadagast <Horde Captain> - 80489
class npc_ashran_soulbrewer_nadagast : public CreatureScript
{
    public:
        npc_ashran_soulbrewer_nadagast() : CreatureScript("npc_ashran_soulbrewer_nadagast") { }

        enum eSpells
        {
            ChaosBolt   = 178076,
            RainOfFire  = 178069
        };

        enum eEvents
        {
            EventChaosBolt = 1,
            EventRainOfFire,
            EventMove
        };

        enum eTalks
        {
            Spawn,
            Slay
        };

        struct npc_ashran_soulbrewer_nadagastAI : public ScriptedAI
        {
            npc_ashran_soulbrewer_nadagastAI(Creature* p_Creature) : ScriptedAI(p_Creature)
            {
                m_Spawn = false;
            }

            EventMap m_Events;
            EventMap m_MoveEvent;
            bool m_Spawn;

            void InitializeAI() override
            {
                m_MoveEvent.ScheduleEvent(eEvents::EventMove, 1 * TimeConstants::IN_MILLISECONDS);

                Reset();
            }

            void Reset() override
            {
                m_Events.Reset();

                if (!m_Spawn)
                {
                    m_Spawn = true;
                    Talk(eTalks::Spawn);
                }

                /// Second equip is a Off-hand Frill
                me->SetCanDualWield(false);
            }

            void EnterCombat(Unit* /*p_Attacker*/) override
            {
                me->SetHomePosition(*me);

                m_Events.ScheduleEvent(eEvents::EventChaosBolt, 3 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventRainOfFire, 6 * TimeConstants::IN_MILLISECONDS);
            }

            void KilledUnit(Unit* p_Killed) override
            {
                if (p_Killed->GetTypeId() == TypeID::TYPEID_PLAYER)
                    Talk(eTalks::Slay);
            }

            void JustDied(Unit* /*p_Killer*/) override
            {
                if (OutdoorPvPAshran* l_Ashran = (OutdoorPvPAshran*)me->GetZoneScript())
                    l_Ashran->HandleCaptainDeath(eSpecialSpawns::CaptainSoulbrewerNadagast);
            }

            void UpdateAI(uint32 const p_Diff) override
            {
                m_MoveEvent.Update(p_Diff);

                if (m_MoveEvent.ExecuteEvent() == eEvents::EventMove)
                {
                    /// Use same path as Kronus
                    me->LoadPath(eCreatures::Kronus);
                    me->SetDefaultMovementType(MovementGeneratorType::WAYPOINT_MOTION_TYPE);
                    me->GetMotionMaster()->Initialize();
                }

                if (!UpdateVictim())
                    return;

                m_Events.Update(p_Diff);

                if (me->HasUnitState(UnitState::UNIT_STATE_CASTING))
                    return;

                switch (m_Events.ExecuteEvent())
                {
                    case eEvents::EventChaosBolt:
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::ChaosBolt, false);
                        m_Events.ScheduleEvent(eEvents::EventChaosBolt, 15 * TimeConstants::IN_MILLISECONDS);
                        break;
                    case eEvents::EventRainOfFire:
                        me->CastSpell(me, eSpells::RainOfFire, false);
                        m_Events.ScheduleEvent(eEvents::EventRainOfFire, 20 * TimeConstants::IN_MILLISECONDS);
                        break;
                    default:
                        break;
                }

                DoMeleeAttackIfReady();
            }
        };

        CreatureAI* GetAI(Creature* p_Creature) const override
        {
            return new npc_ashran_soulbrewer_nadagastAI(p_Creature);
        }
};

/// Necrolord Azael <Horde Captain> - 80486
class npc_ashran_necrolord_azael : public CreatureScript
{
    public:
        npc_ashran_necrolord_azael() : CreatureScript("npc_ashran_necrolord_azael") { }

        enum eSpells
        {
            ChaosBolt   = 178076,
            RainOfFire  = 178069
        };

        enum eEvents
        {
            EventChaosBolt = 1,
            EventRainOfFire,
            EventMove
        };

        enum eTalks
        {
            Slay,
            Death
        };

        enum eData
        {
            MountID = 51048
        };

        struct npc_ashran_necrolord_azaelAI : public ScriptedAI
        {
            npc_ashran_necrolord_azaelAI(Creature* p_Creature) : ScriptedAI(p_Creature) { }

            EventMap m_Events;
            EventMap m_MoveEvent;

            void InitializeAI() override
            {
                m_MoveEvent.ScheduleEvent(eEvents::EventMove, 1 * TimeConstants::IN_MILLISECONDS);

                Reset();
            }

            void Reset() override
            {
                m_Events.Reset();

                me->Mount(eData::MountID);
            }

            void EnterCombat(Unit* /*p_Attacker*/) override
            {
                me->Mount(0);
                me->SetHomePosition(*me);

                m_Events.ScheduleEvent(eEvents::EventChaosBolt, 3 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventRainOfFire, 6 * TimeConstants::IN_MILLISECONDS);
            }

            void KilledUnit(Unit* p_Killed) override
            {
                if (p_Killed->GetTypeId() == TypeID::TYPEID_PLAYER)
                    Talk(eTalks::Slay);
            }

            void JustDied(Unit* /*p_Killer*/) override
            {
                Talk(eTalks::Death);

                if (OutdoorPvPAshran* l_Ashran = (OutdoorPvPAshran*)me->GetZoneScript())
                    l_Ashran->HandleCaptainDeath(eSpecialSpawns::CaptainNecrolordAzael);
            }

            void UpdateAI(uint32 const p_Diff) override
            {
                m_MoveEvent.Update(p_Diff);

                if (m_MoveEvent.ExecuteEvent() == eEvents::EventMove)
                {
                    /// Use same path as Kronus
                    me->LoadPath(eCreatures::Kronus);
                    me->SetDefaultMovementType(MovementGeneratorType::WAYPOINT_MOTION_TYPE);
                    me->GetMotionMaster()->Initialize();
                }

                if (!UpdateVictim())
                    return;

                m_Events.Update(p_Diff);

                if (me->HasUnitState(UnitState::UNIT_STATE_CASTING))
                    return;

                switch (m_Events.ExecuteEvent())
                {
                    case eEvents::EventChaosBolt:
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::ChaosBolt, false);
                        m_Events.ScheduleEvent(eEvents::EventChaosBolt, 15 * TimeConstants::IN_MILLISECONDS);
                        break;
                    case eEvents::EventRainOfFire:
                        me->CastSpell(me, eSpells::RainOfFire, false);
                        m_Events.ScheduleEvent(eEvents::EventRainOfFire, 20 * TimeConstants::IN_MILLISECONDS);
                        break;
                    default:
                        break;
                }

                DoMeleeAttackIfReady();
            }
        };

        CreatureAI* GetAI(Creature* p_Creature) const override
        {
            return new npc_ashran_necrolord_azaelAI(p_Creature);
        }
};

/// Rifthunter Yoske <Horde Captain> - 80496
class npc_ashran_rifthunter_yoske : public CreatureScript
{
    public:
        npc_ashran_rifthunter_yoske() : CreatureScript("npc_ashran_rifthunter_yoske") { }

        enum eSpells
        {
            Shoot           = 164095,
            SerpentSting    = 162754
        };

        enum eEvents
        {
            EventShoot = 1,
            EventSerpentSting,
            EventMove
        };

        enum eTalks
        {
            Slay,
            Death
        };

        struct npc_ashran_rifthunter_yoskeAI : public ScriptedAI
        {
            npc_ashran_rifthunter_yoskeAI(Creature* p_Creature) : ScriptedAI(p_Creature) { }

            EventMap m_Events;
            EventMap m_MoveEvent;

            void InitializeAI() override
            {
                m_MoveEvent.ScheduleEvent(eEvents::EventMove, 1 * TimeConstants::IN_MILLISECONDS);

                Reset();
            }

            void Reset() override
            {
                m_Events.Reset();
            }

            void EnterCombat(Unit* /*p_Attacker*/) override
            {
                me->SetHomePosition(*me);

                m_Events.ScheduleEvent(eEvents::EventShoot, 3 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventSerpentSting, 5 * TimeConstants::IN_MILLISECONDS);
            }

            void KilledUnit(Unit* p_Killed) override
            {
                if (p_Killed->GetTypeId() == TypeID::TYPEID_PLAYER)
                    Talk(eTalks::Slay);
            }

            void JustDied(Unit* /*p_Killer*/) override
            {
                Talk(eTalks::Death);

                if (OutdoorPvPAshran* l_Ashran = (OutdoorPvPAshran*)me->GetZoneScript())
                    l_Ashran->HandleCaptainDeath(eSpecialSpawns::CaptainRifthunterYoske);
            }

            void UpdateAI(uint32 const p_Diff) override
            {
                m_MoveEvent.Update(p_Diff);

                if (m_MoveEvent.ExecuteEvent() == eEvents::EventMove)
                {
                    /// Use same path as Kronus
                    me->LoadPath(eCreatures::Kronus);
                    me->SetDefaultMovementType(MovementGeneratorType::WAYPOINT_MOTION_TYPE);
                    me->GetMotionMaster()->Initialize();
                }

                if (!UpdateVictim())
                    return;

                m_Events.Update(p_Diff);

                if (me->HasUnitState(UnitState::UNIT_STATE_CASTING))
                    return;

                switch (m_Events.ExecuteEvent())
                {
                    case eEvents::EventShoot:
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::Shoot, false);
                        m_Events.ScheduleEvent(eEvents::EventShoot, 5 * TimeConstants::IN_MILLISECONDS);
                        break;
                    case eEvents::EventSerpentSting:
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::SerpentSting, false);
                        m_Events.ScheduleEvent(eEvents::EventSerpentSting, 12 * TimeConstants::IN_MILLISECONDS);
                        break;
                    default:
                        break;
                }

                DoMeleeAttackIfReady();
            }
        };

        CreatureAI* GetAI(Creature* p_Creature) const override
        {
            return new npc_ashran_rifthunter_yoskeAI(p_Creature);
        }
};

/// Mor'riz <The Ultimate Troll> - 85133
class npc_ashran_morriz : public CreatureScript
{
    public:
        npc_ashran_morriz() : CreatureScript("npc_ashran_morriz") { }

        enum eSpell
        {
            Typhoon = 164337
        };

        enum eEvents
        {
            EventTyphoon = 1,
            EventMove
        };

        struct npc_ashran_morrizAI : public ScriptedAI
        {
            npc_ashran_morrizAI(Creature* p_Creature) : ScriptedAI(p_Creature) { }

            EventMap m_Events;
            EventMap m_MoveEvent;

            void InitializeAI() override
            {
                m_MoveEvent.ScheduleEvent(eEvents::EventMove, 1 * TimeConstants::IN_MILLISECONDS);

                Reset();
            }

            void Reset() override
            {
                m_Events.Reset();
            }

            void EnterCombat(Unit* /*p_Attacker*/) override
            {
                me->SetHomePosition(*me);

                m_Events.ScheduleEvent(eEvents::EventTyphoon, 15 * TimeConstants::IN_MILLISECONDS);
            }

            void JustDied(Unit* /*p_Killer*/) override
            {
                if (OutdoorPvPAshran* l_Ashran = (OutdoorPvPAshran*)me->GetZoneScript())
                    l_Ashran->HandleCaptainDeath(eSpecialSpawns::CaptainMorriz);
            }

            void UpdateAI(uint32 const p_Diff) override
            {
                m_MoveEvent.Update(p_Diff);

                if (m_MoveEvent.ExecuteEvent() == eEvents::EventMove)
                {
                    /// Use same path as Kronus
                    me->LoadPath(eCreatures::Kronus);
                    me->SetDefaultMovementType(MovementGeneratorType::WAYPOINT_MOTION_TYPE);
                    me->GetMotionMaster()->Initialize();
                }

                if (!UpdateVictim())
                    return;

                m_Events.Update(p_Diff);

                if (me->HasUnitState(UnitState::UNIT_STATE_CASTING))
                    return;

                switch (m_Events.ExecuteEvent())
                {
                    case eEvents::EventTyphoon:
                    {
                        me->CastSpell(me, eSpell::Typhoon, false);
                        m_Events.ScheduleEvent(eEvents::EventTyphoon, 20 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    default:
                        break;
                }

                DoMeleeAttackIfReady();
            }
        };

        CreatureAI* GetAI(Creature* p_Creature) const override
        {
            return new npc_ashran_morrizAI(p_Creature);
        }
};

/// Kaz Endsky <Horde Captain> - 87690
class npc_ashran_kaz_endsky : public CreatureScript
{
    public:
        npc_ashran_kaz_endsky() : CreatureScript("npc_ashran_kaz_endsky") { }

        enum eSpells
        {
            PlagueStrike    = 164063,
            DeathAndDecay   = 164334,
            DeathCoil       = 164064,
            DeathGrip       = 79894,
            DeathGripJump   = 168563
        };

        enum eEvents
        {
            EventPlagueStrike = 1,
            EventDeathAndDecay,
            EventDeathCoil,
            EventDeathGrip,
            EventMove
        };

        enum eTalks
        {
            Slay,
            Death
        };

        enum eData
        {
            MountID = 25280
        };

        struct npc_ashran_kaz_endskyAI : public ScriptedAI
        {
            npc_ashran_kaz_endskyAI(Creature* p_Creature) : ScriptedAI(p_Creature) { }

            EventMap m_Events;
            EventMap m_MoveEvent;

            void InitializeAI() override
            {
                m_MoveEvent.ScheduleEvent(eEvents::EventMove, 1 * TimeConstants::IN_MILLISECONDS);

                Reset();
            }

            void Reset() override
            {
                m_Events.Reset();

                me->Mount(eData::MountID);
            }

            void EnterCombat(Unit* /*p_Attacker*/) override
            {
                me->Mount(0);
                me->SetHomePosition(*me);

                m_Events.ScheduleEvent(eEvents::EventPlagueStrike, 2 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventDeathAndDecay, 5 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventDeathCoil, 8 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventDeathGrip, 1 * TimeConstants::IN_MILLISECONDS);
            }

            void KilledUnit(Unit* p_Killed) override
            {
                if (p_Killed->GetTypeId() == TypeID::TYPEID_PLAYER)
                    Talk(eTalks::Slay);
            }

            void JustDied(Unit* /*p_Killer*/) override
            {
                Talk(eTalks::Death);

                if (OutdoorPvPAshran* l_Ashran = (OutdoorPvPAshran*)me->GetZoneScript())
                    l_Ashran->HandleCaptainDeath(eSpecialSpawns::CaptainKazEndsky);
            }

            void SpellHitTarget(Unit* p_Target, SpellInfo const* p_SpellInfo) override
            {
                if (p_Target == nullptr)
                    return;

                if (p_SpellInfo->Id == eSpells::DeathGrip)
                    p_Target->CastSpell(*me, eSpells::DeathGripJump, true);
            }

            void UpdateAI(uint32 const p_Diff) override
            {
                m_MoveEvent.Update(p_Diff);

                if (m_MoveEvent.ExecuteEvent() == eEvents::EventMove)
                {
                    /// Use same path as Kronus
                    me->LoadPath(eCreatures::Kronus);
                    me->SetDefaultMovementType(MovementGeneratorType::WAYPOINT_MOTION_TYPE);
                    me->GetMotionMaster()->Initialize();
                }

                if (!UpdateVictim())
                    return;

                m_Events.Update(p_Diff);

                if (me->HasUnitState(UnitState::UNIT_STATE_CASTING))
                    return;

                switch (m_Events.ExecuteEvent())
                {
                    case eEvents::EventPlagueStrike:
                    {
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::PlagueStrike, false);
                        m_Events.ScheduleEvent(eEvents::EventPlagueStrike, 8 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    case eEvents::EventDeathAndDecay:
                    {
                        me->CastSpell(me, eSpells::DeathAndDecay, false);
                        m_Events.ScheduleEvent(eEvents::EventDeathAndDecay, 12 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    case eEvents::EventDeathCoil:
                    {
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::DeathCoil, false);
                        m_Events.ScheduleEvent(eEvents::EventDeathCoil, 10 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    case eEvents::EventDeathGrip:
                    {
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::DeathGrip, false);
                        m_Events.ScheduleEvent(eEvents::EventDeathGrip, 20 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    default:
                        break;
                }

                DoMeleeAttackIfReady();
            }
        };

        CreatureAI* GetAI(Creature* p_Creature) const override
        {
            return new npc_ashran_kaz_endskyAI(p_Creature);
        }
};

/// Razor Guerra <Horde Captain> - 85138
class npc_ashran_razor_guerra : public CreatureScript
{
    public:
        npc_ashran_razor_guerra() : CreatureScript("npc_ashran_razor_guerra") { }

        enum eSpells
        {
            Blind           = 178058,
            CloakOfShadows  = 178055,
            Eviscerate      = 178054,
            FanOfKnives     = 178053,
            Hemorrhage      = 178052,
            Shadowstep      = 178056,
            WoundPoison     = 178050
        };

        enum eEvents
        {
            EventBlind = 1,
            EventCloakOfShadows,
            EventEviscerate,
            EventFanOfKnives,
            EventHemorrhage,
            EventShadowStep,
            EventWoundPoison,
            EventMove
        };

        enum eTalks
        {
            Slay,
            Death
        };

        enum eData
        {
            MountID = 51048
        };

        struct npc_ashran_razor_guerraAI : public ScriptedAI
        {
            npc_ashran_razor_guerraAI(Creature* p_Creature) : ScriptedAI(p_Creature) { }

            EventMap m_Events;
            EventMap m_MoveEvent;

            void InitializeAI() override
            {
                m_MoveEvent.ScheduleEvent(eEvents::EventMove, 1 * TimeConstants::IN_MILLISECONDS);

                Reset();
            }

            void Reset() override
            {
                m_Events.Reset();

                me->Mount(eData::MountID);
            }

            void EnterCombat(Unit* /*p_Attacker*/) override
            {
                me->Mount(0);
                me->SetHomePosition(*me);

                m_Events.ScheduleEvent(eEvents::EventBlind, 15 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventCloakOfShadows, 1 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventEviscerate, 10 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventFanOfKnives, 8 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventHemorrhage, 2 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventShadowStep, 1 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventWoundPoison, 5 * TimeConstants::IN_MILLISECONDS);
            }

            void KilledUnit(Unit* p_Killed) override
            {
                if (p_Killed->GetTypeId() == TypeID::TYPEID_PLAYER)
                    Talk(eTalks::Slay);
            }

            void JustDied(Unit* /*p_Killer*/) override
            {
                Talk(eTalks::Death);

                if (OutdoorPvPAshran* l_Ashran = (OutdoorPvPAshran*)me->GetZoneScript())
                    l_Ashran->HandleCaptainDeath(eSpecialSpawns::CaptainRazorGuerra);
            }

            void UpdateAI(uint32 const p_Diff) override
            {
                m_MoveEvent.Update(p_Diff);

                if (m_MoveEvent.ExecuteEvent() == eEvents::EventMove)
                {
                    /// Use same path as Kronus
                    me->LoadPath(eCreatures::Kronus);
                    me->SetDefaultMovementType(MovementGeneratorType::WAYPOINT_MOTION_TYPE);
                    me->GetMotionMaster()->Initialize();
                }

                if (!UpdateVictim())
                    return;

                m_Events.Update(p_Diff);

                if (me->HasUnitState(UnitState::UNIT_STATE_CASTING))
                    return;

                switch (m_Events.ExecuteEvent())
                {
                    case eEvents::EventBlind:
                    {
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::Blind, false);
                        m_Events.ScheduleEvent(eEvents::EventBlind, 30 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    case eEvents::EventCloakOfShadows:
                    {
                        if (me->HealthBelowPct(50))
                            me->CastSpell(me, eSpells::CloakOfShadows, true);
                        else
                            m_Events.ScheduleEvent(eEvents::EventCloakOfShadows, 1 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    case eEvents::EventEviscerate:
                    {
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::Eviscerate, false);
                        m_Events.ScheduleEvent(eEvents::EventEviscerate, 20 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    case eEvents::EventFanOfKnives:
                    {
                        me->CastSpell(me, eSpells::FanOfKnives, false);
                        m_Events.ScheduleEvent(eEvents::EventFanOfKnives, 10 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    case eEvents::EventHemorrhage:
                    {
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::Hemorrhage, false);
                        m_Events.ScheduleEvent(eEvents::EventHemorrhage, 15 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    case eEvents::EventShadowStep:
                    {
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::Shadowstep, false);
                        m_Events.ScheduleEvent(eEvents::EventShadowStep, 20 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    case eEvents::EventWoundPoison:
                    {
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::WoundPoison, false);
                        m_Events.ScheduleEvent(eEvents::EventWoundPoison, 12 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    default:
                        break;
                }

                DoMeleeAttackIfReady();
            }
        };

        CreatureAI* GetAI(Creature* p_Creature) const override
        {
            return new npc_ashran_razor_guerraAI(p_Creature);
        }
};

/// Jared V. Hellstrike <Horde Captain> - 85131
class npc_ashran_jared_v_hellstrike : public CreatureScript
{
    public:
        npc_ashran_jared_v_hellstrike() : CreatureScript("npc_ashran_jared_v_hellstrike") { }

        enum eSpells
        {
            BlackoutKick        = 164394,
            LegSweep            = 164392,
            RisingSunKick       = 127734,
            SpinningCraneKick   = 162759
        };

        enum eEvents
        {
            EventBlackoutKick = 1,
            EventLegSweep,
            EventRisingSunKick,
            EventSpinningCraneKick,
            EventMove
        };

        struct npc_ashran_jared_v_hellstrikeAI : public ScriptedAI
        {
            npc_ashran_jared_v_hellstrikeAI(Creature* p_Creature) : ScriptedAI(p_Creature) { }

            EventMap m_Events;
            EventMap m_MoveEvent;

            void InitializeAI() override
            {
                m_MoveEvent.ScheduleEvent(eEvents::EventMove, 1 * TimeConstants::IN_MILLISECONDS);

                Reset();
            }

            void Reset() override
            {
                m_Events.Reset();
            }

            void EnterCombat(Unit* /*p_Attacker*/) override
            {
                me->SetHomePosition(*me);

                m_Events.ScheduleEvent(eEvents::EventBlackoutKick, 5 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventLegSweep, 8 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventRisingSunKick, 10 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventSpinningCraneKick, 12 * TimeConstants::IN_MILLISECONDS);
            }

            void JustDied(Unit* /*p_Killer*/) override
            {
                if (OutdoorPvPAshran* l_Ashran = (OutdoorPvPAshran*)me->GetZoneScript())
                    l_Ashran->HandleCaptainDeath(eSpecialSpawns::CaptainJaredVHellstrike);
            }

            void UpdateAI(uint32 const p_Diff) override
            {
                m_MoveEvent.Update(p_Diff);

                if (m_MoveEvent.ExecuteEvent() == eEvents::EventMove)
                {
                    me->SetWalk(true);
                    /// Use same path as Kronus
                    me->LoadPath(eCreatures::Kronus);
                    me->SetDefaultMovementType(MovementGeneratorType::WAYPOINT_MOTION_TYPE);
                    me->GetMotionMaster()->Initialize();
                }

                if (!UpdateVictim())
                    return;

                m_Events.Update(p_Diff);

                if (me->HasUnitState(UnitState::UNIT_STATE_CASTING))
                    return;

                switch (m_Events.ExecuteEvent())
                {
                    case eEvents::EventBlackoutKick:
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::BlackoutKick, false);
                        m_Events.ScheduleEvent(eEvents::EventBlackoutKick, 10 * TimeConstants::IN_MILLISECONDS);
                        break;
                    case eEvents::EventLegSweep:
                        me->CastSpell(me, eSpells::LegSweep, false);
                        m_Events.ScheduleEvent(eEvents::EventLegSweep, 25 * TimeConstants::IN_MILLISECONDS);
                        break;
                    case eEvents::EventRisingSunKick:
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::RisingSunKick, false);
                        m_Events.ScheduleEvent(eEvents::EventRisingSunKick, 15 * TimeConstants::IN_MILLISECONDS);
                        break;
                    case eEvents::EventSpinningCraneKick:
                        me->CastSpell(me, eSpells::SpinningCraneKick, false);
                        m_Events.ScheduleEvent(eEvents::EventSpinningCraneKick, 20 * TimeConstants::IN_MILLISECONDS);
                        break;
                    default:
                        break;
                }

                DoMeleeAttackIfReady();
            }
        };

        CreatureAI* GetAI(Creature* p_Creature) const override
        {
            return new npc_ashran_jared_v_hellstrikeAI(p_Creature);
        }
};

/// Kimilyn <Forged in Flame> - 88109
class npc_ashran_kimilyn : public CreatureScript
{
    public:
        npc_ashran_kimilyn() : CreatureScript("npc_ashran_kimilyn") { }

        enum eSpells
        {
            DevouringPlague = 164452,
            Dispersion      = 164444,
            MindBlast       = 164448,
            MindSear        = 177402,
            PsychicScream   = 164443,
            ShadowWordPain  = 164446
        };

        enum eEvents
        {
            EventDevouringPlague = 1,
            EventDispersion,
            EventMindBlast,
            EventMindSear,
            EventPsychicScream,
            EventShadowWordPain,
            EventMove
        };

        enum eTalks
        {
            Spawn,
            Death
        };

        enum eData
        {
            MountID = 51048
        };

        struct npc_ashran_kimilynAI : public ScriptedAI
        {
            npc_ashran_kimilynAI(Creature* p_Creature) : ScriptedAI(p_Creature)
            {
                m_Spawn = false;
            }

            EventMap m_Events;
            EventMap m_MoveEvent;
            bool m_Spawn;

            void InitializeAI() override
            {
                m_MoveEvent.ScheduleEvent(eEvents::EventMove, 1 * TimeConstants::IN_MILLISECONDS);

                Reset();
            }

            void Reset() override
            {
                m_Events.Reset();

                if (!m_Spawn)
                {
                    Talk(eTalks::Spawn);
                    m_Spawn = true;
                }

                me->Mount(eData::MountID);
            }

            void EnterCombat(Unit* /*p_Attacker*/) override
            {
                me->Mount(0);
                me->SetHomePosition(*me);

                m_Events.ScheduleEvent(eEvents::EventDevouringPlague, 10 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventDispersion, 1 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventMindBlast, 5 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventMindSear, 8 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventPsychicScream, 15 * TimeConstants::IN_MILLISECONDS);
                m_Events.ScheduleEvent(eEvents::EventShadowWordPain, 1 * TimeConstants::IN_MILLISECONDS);
            }

            void JustDied(Unit* /*p_Killer*/) override
            {
                Talk(eTalks::Death);

                if (OutdoorPvPAshran* l_Ashran = (OutdoorPvPAshran*)me->GetZoneScript())
                    l_Ashran->HandleCaptainDeath(eSpecialSpawns::CaptainKimilyn);
            }

            void UpdateAI(uint32 const p_Diff) override
            {
                m_MoveEvent.Update(p_Diff);

                if (m_MoveEvent.ExecuteEvent() == eEvents::EventMove)
                {
                    /// Use same path as Kronus
                    me->LoadPath(eCreatures::Kronus);
                    me->SetDefaultMovementType(MovementGeneratorType::WAYPOINT_MOTION_TYPE);
                    me->GetMotionMaster()->Initialize();
                }

                if (!UpdateVictim())
                    return;

                m_Events.Update(p_Diff);

                if (me->HasUnitState(UnitState::UNIT_STATE_CASTING))
                    return;

                switch (m_Events.ExecuteEvent())
                {
                    case eEvents::EventDevouringPlague:
                    {
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::DevouringPlague, false);
                        m_Events.ScheduleEvent(eEvents::EventDevouringPlague, 15 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    case eEvents::EventDispersion:
                    {
                        if (me->HealthBelowPct(50))
                            me->CastSpell(me, eSpells::Dispersion, true);
                        else
                            m_Events.ScheduleEvent(eEvents::EventDispersion, 1 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    case eEvents::EventMindBlast:
                    {
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::MindBlast, false);
                        m_Events.ScheduleEvent(eEvents::EventMindBlast, 10 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    case eEvents::EventMindSear:
                    {
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::MindSear, false);
                        m_Events.ScheduleEvent(eEvents::EventMindSear, 20 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    case eEvents::EventPsychicScream:
                    {
                        me->CastSpell(me, eSpells::PsychicScream, false);
                        m_Events.ScheduleEvent(eEvents::EventPsychicScream, 30 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    case eEvents::EventShadowWordPain:
                    {
                        if (Unit* l_Target = SelectTarget(SelectAggroTarget::SELECT_TARGET_TOPAGGRO))
                            me->CastSpell(l_Target, eSpells::ShadowWordPain, false);
                        m_Events.ScheduleEvent(eEvents::EventShadowWordPain, 12 * TimeConstants::IN_MILLISECONDS);
                        break;
                    }
                    default:
                        break;
                }

                DoMeleeAttackIfReady();
            }
        };

        CreatureAI* GetAI(Creature* p_Creature) const override
        {
            return new npc_ashran_kimilynAI(p_Creature);
        }
};

/// Speedy Horde Racer - 82903
class npc_ashran_speedy_horde_racer : public CreatureScript
{
    public:
        npc_ashran_speedy_horde_racer() : CreatureScript("npc_ashran_speedy_horde_racer") { }

        enum eSpell
        {
            HordeRacer = 166819
        };

        struct npc_ashran_speedy_horde_racerAI : public MS::AI::CosmeticAI
        {
            npc_ashran_speedy_horde_racerAI(Creature* p_Creature) : MS::AI::CosmeticAI(p_Creature)
            {
                m_CheckCooldown = uint32(time(nullptr) + 5);
            }

            uint8 m_MoveIndex;
            uint32 m_CheckCooldown;

            void InitializeAI() override
            {
                Reset();
            }

            void Reset() override
            {
                me->CastSpell(me, eSpell::HordeRacer, true);
                me->ModifyAuraState(AuraStateType::AURA_STATE_UNKNOWN22, true);

                m_MoveIndex = 0;

                AddTimedDelayedOperation(500, [this]() -> void
                {
                    if (Creature* l_Rider = me->FindNearestCreature(eCreatures::HordeRider, 10.0f))
                        l_Rider->EnterVehicle(me);
                });

                AddTimedDelayedOperation(1 * TimeConstants::IN_MILLISECONDS, [this]() -> void
                {
                    me->GetMotionMaster()->MovePoint(m_MoveIndex, g_HordeRacingMoves[m_MoveIndex]);
                });
            }

            void MovementInform(uint32 p_Type, uint32 /*p_ID*/) override
            {
                if (p_Type != MovementGeneratorType::POINT_MOTION_TYPE)
                    return;

                ++m_MoveIndex;

                if (m_MoveIndex >= eAshranDatas::HordeRacingMovesCount)
                {
                    m_MoveIndex = 0;
                    IncreaseLapCount();
                }

                AddTimedDelayedOperation(100, [this]() -> void
                {
                    me->GetMotionMaster()->MovePoint(m_MoveIndex, g_HordeRacingMoves[m_MoveIndex]);
                });
            }

            void IncreaseLapCount()
            {
                OutdoorPvP* l_Outdoor = sOutdoorPvPMgr->GetOutdoorPvPToZoneId(me->GetZoneId());
                if (OutdoorPvPAshran* l_Ashran = (OutdoorPvPAshran*)l_Outdoor)
                    l_Ashran->SetEventData(eAshranEvents::EventStadiumRacing, TeamId::TEAM_HORDE, 1);
            }
        };

        CreatureAI* GetAI(Creature* p_Creature) const override
        {
            return new npc_ashran_speedy_horde_racerAI(p_Creature);
        }
};

#ifndef __clang_analyzer__
void AddSC_AshranNPCHorde()
{
	new map_draenor();

    new npc_jeron_emberfall();
    new npc_ashran_warspear_shaman();
    new npc_ashran_illandria_belore();
    new npc_ashran_examiner_rahm_flameheart();
    new npc_ashran_centurion_firescream();
    new npc_ashran_legionnaire_hellaxe();
    new npc_ashran_kalgan();
    new npc_ashran_fura();
    new npc_ashran_nisstyr();
    new npc_ashran_atomik();
    new npc_ashran_zaram_sunraiser();
    new npc_ashran_horde_gateway_guardian();
    new npc_ashran_kronus();
    new npc_ashran_underpowered_earth_fury();
    new npc_ashran_warspear_gladiator();
    new npc_ashran_excavator_rustshiv();
    new npc_ashran_excavator_hardtooth();
    new npc_ashran_voljins_spear_battle_standard();
    new npc_ashran_warspear_headhunter();
    new npc_ashran_lord_mes();
    new npc_ashran_mindbender_talbadar();
    new npc_ashran_elliott_van_rook();
    new npc_ashran_vanguard_samuelle();
    new npc_ashran_elementalist_novo();
    new npc_ashran_captain_hoodrych();
    new npc_ashran_soulbrewer_nadagast();
    new npc_ashran_necrolord_azael();
    new npc_ashran_rifthunter_yoske();
    new npc_ashran_morriz();
    new npc_ashran_kaz_endsky();
    new npc_ashran_razor_guerra();
    new npc_ashran_jared_v_hellstrike();
    new npc_ashran_kimilyn();
    new npc_ashran_speedy_horde_racer();
	new npc_ashran_rala_wildheart();
	new npc_ashran_shadow_hunter_askia();
	new npc_ashran_gordon_ray();
	new npc_ashran_warspear_grunt();
	new npc_ashran_brix_rocketcast();
	new npc_ashran_nina_dingzap();
	new npc_ashran_joroman();
	new npc_ashran_zikk();
	new npc_ashran_warspear_grunt_flightmaster_1();
	new npc_ashran_warspear_grunt_flightmaster_2();
	new gob_ashran_handwritten_sign();
	new npc_ashran_shadowhunter_garant();
	new npc_ashran_warspear_scout();

	// This can be improved with time
	new guard_wod_generic();

	new npc_ashran_souchi_windpaw();
}
#endif
