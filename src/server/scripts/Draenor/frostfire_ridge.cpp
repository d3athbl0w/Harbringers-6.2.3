////////////////////////////////////////////////////////////////////////////////
//
// ██╗░░██╗░█████╗░██████╗░██████╗░██████╗░██╗███╗░░██╗░██████╗░███████╗██████╗░░██████╗
// ██║░░██║██╔══██╗██╔══██╗██╔══██╗██╔══██╗██║████╗░██║██╔════╝░██╔════╝██╔══██╗██╔════╝
// ███████║███████║██████╔╝██████╦╝██████╔╝██║██╔██╗██║██║░░██╗░█████╗░░██████╔╝╚█████╗░
// ██╔══██║██╔══██║██╔══██╗██╔══██╗██╔══██╗██║██║╚████║██║░░╚██╗██╔══╝░░██╔══██╗░╚═══██╗
// ██║░░██║██║░░██║██║░░██║██████╦╝██║░░██║██║██║░╚███║╚██████╔╝███████╗██║░░██║██████╔╝
// ╚═╝░░╚═╝╚═╝░░╚═╝╚═╝░░╚═╝╚═════╝░╚═╝░░╚═╝╚═╝╚═╝░░╚══╝░╚═════╝░╚══════╝╚═╝░░╚═╝╚═════╝░
//
//    Harbringers
// Warlords of Draenor
////////////////////////////////////////////////////////////////////////////////

#include "AreaTrigger.h"
#include "GameObject.h"
#include "GameObjectAI.h"
#include "ObjectMgr.h"
#include "ScriptMgr.h"
#include "ScriptedCreature.h"
#include "ScriptedGossip.h"
#include "ScriptedEscortAI.h"

enum
{
    QUEST_THE_HOME_OF_THE_FROSTWOLFES = 33868,
    QUEST_A_SONG_OF_FROST_AND_FIRE = 33815,
    QUEST_OF_WOLFES_AND_WARRIORS = 34402,

    QUEST_ESTABLISH_YOUR_GARRISON = 34378,
};

enum
{
    SpellEarthrendingSlam = 165907,
    SpellRampage = 148852
};

enum
{
    EventEarthrendingSlam = 1,
    EventRampage = 2,
};

enum
{
    NPC_DUROTAN_BEGIN = 78272,
    NPC_OF_WOLFES_AND_WARRIOR_KILL_CREDIT = 78407,
    NPC_ESTABLISH_YOUR_GARRISON_KILL_CREDIT = 79757,
};

enum
{
    SCENE_LANDING_TO_TOP_OF_HILL = 771,
    SCENE_TOP_OF_HILL_TO_GARRISON = 778,
    SCENE_PORTAL_OPENING = 789,
    SCENE_DUROTAN_DEPARTS = 798,
};


// 76411 - Drek'Thar - Start quest
class npc_drekthar_frostridge_begin : public CreatureScript
{
public:
    npc_drekthar_frostridge_begin() : CreatureScript("npc_drekthar_frostridge_begin") { }

    bool OnQuestAccept(Player* player, Creature* creature, Quest const* quest) override
    {

        if (quest->GetQuestId() == QUEST_A_SONG_OF_FROST_AND_FIRE)
        {
            player->PlayScene(SCENE_LANDING_TO_TOP_OF_HILL, player);
        }
        return true;
    }

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_drekthar_frostridge_beginAI(creature);
    }

    struct npc_drekthar_frostridge_beginAI : public ScriptedAI
    {
        npc_drekthar_frostridge_beginAI(Creature* creature) : ScriptedAI(creature) { }
        uint32 waitTime;

        void Reset() override
        {
            waitTime = 1000;
        }

        void UpdateAI(uint32 diff) override
        {
            if (waitTime > diff)
            {
                waitTime -= diff;
                return;
            }

            waitTime = 1000;

            std::list<Player*> playerList;
            me->GetPlayerListInGrid(playerList, 30.0f);

            for (Player* player : playerList)
            {
                if (player->GetQuestStatus(QUEST_THE_HOME_OF_THE_FROSTWOLFES) != QUEST_STATUS_NONE)
                    continue;

                if (const Quest* quest = sObjectMgr->GetQuestTemplate(QUEST_THE_HOME_OF_THE_FROSTWOLFES))
                    player->AddQuest(quest, me);
            }
        }
    };
};

// 78272 - Durotan
class npc_durotan_frostridge_begin : public CreatureScript
{
public:
    npc_durotan_frostridge_begin() : CreatureScript("npc_durotan_frostridge_begin") { }

    bool OnQuestAccept(Player* player, Creature* /*creature*/, Quest const* quest) override
    {
        if (quest->GetQuestId() == QUEST_OF_WOLFES_AND_WARRIORS)
        {

            player->PlayScene(SCENE_TOP_OF_HILL_TO_GARRISON, player);
        }
        return true;
    }


};

// Horde Banner Quest 34364
class horde_banner_q34364 : public GameObjectScript
{
public:
    horde_banner_q34364() : GameObjectScript("horde_banner_q34364") { }


    bool OnGossipHello(Player* player, GameObject* p_GameObject) override
    {
        if (player->GetQuestStatus(34364) == QUEST_STATUS_INCOMPLETE)
        {
            p_GameObject->AI()->DoAction(0);
            player->PlayScene(SCENE_PORTAL_OPENING, player);
            player->CastSpell(player, 81003, true);
            player->CastSpell(p_GameObject, 169421, false);
        }

        else if (player->GetQuestStatus(34364) == QUEST_STATE_COMPLETE)
        {
            return 0;
        }
        {
            return true;
        }
    }

    void OnSpellHit(Player* player, GameObject* go)
    {
        player->KilledMonsterCredit(84768);
    }
    struct horde_banner_q34364AI : public GameObjectAI
    {
        horde_banner_q34364AI(GameObject* p_GameObject) : GameObjectAI(p_GameObject) { }

        enum eAction
        {
            Spawn = 0,
        };

        void Reset() override
        {
            ClearDelayedOperations();
        }

        void DoAction(int32 const p_Action) override
        {
            switch (p_Action)
            {
            case eAction::Spawn:
            {

                AddTimedDelayedOperation(17 * TimeConstants::IN_MILLISECONDS, [this]() -> void
                    {
                        std::list<Creature*> units;
                        go->GetCreatureListWithEntryInGrid(units, 78007, 10.0f);
                        if (units.empty())
                        {
                            go->SummonCreature(78007, 5628.799f, 4525.779f, 119.0159f, 2.895f, TEMPSUMMON_TIMED_DESPAWN, 120 * TimeConstants::IN_MILLISECONDS);
                        }
                        else
                        {
                            return;
                        }
                    });

                break;
            }
            }
        }


        void UpdateAI(const uint32 p_Diff) override
        {
            UpdateOperations(p_Diff);
        }
    };

    GameObjectAI* GetAI(GameObject* p_GameObject) const
    {
        return new horde_banner_q34364AI(p_GameObject);
    }
};

// Claiming Horde Flag Spell 169421
class spell_frostridge_claiming : public SpellScriptLoader
{
public:
    spell_frostridge_claiming() : SpellScriptLoader("spell_frostridge_claiming") { }

    class spell_frostridge_claiming_spellscript : public SpellScript
    {
        PrepareSpellScript(spell_frostridge_claiming_spellscript);

        void HandleDummy(SpellEffIndex /*effIndex*/)
        {
            if (!GetCaster())
                return;

            Player* player = GetCaster()->ToPlayer();

            if (!player)
                return;

            player->PlayScene(SCENE_PORTAL_OPENING, player);

        }

        void Register() override
        {
            OnEffectHitTarget += SpellEffectFn(spell_frostridge_claiming_spellscript::HandleDummy, EFFECT_0, SPELL_EFFECT_DUMMY);
        }
    };

    SpellScript* GetSpellScript() const override
    {
        return new spell_frostridge_claiming_spellscript();
    }
};


// 80167 - Groog
class npc_groog : public CreatureScript
{
public:
    npc_groog() : CreatureScript("npc_groog") { }

    CreatureAI* GetAI(Creature* creature) const override
    {
        return new npc_groogAI(creature);
    }

    struct npc_groogAI : public ScriptedAI
    {
        npc_groogAI(Creature* creature) : ScriptedAI(creature) { }

        EventMap m_Events;

        void Reset() override
        {
            me->setFaction(14);
        }

        void EnterCombat(Unit* /*p_Victim*/) override
        {
            m_Events.Reset();

            m_Events.ScheduleEvent(EventEarthrendingSlam, 3000);
            m_Events.ScheduleEvent(EventRampage, 7000);
        }

        void UpdateAI(uint32 diff) override
        {
            m_Events.Update(diff);

            if (me->HasUnitState(UNIT_STATE_CASTING) || !UpdateVictim())
                return;

            switch (m_Events.ExecuteEvent())
            {
            case EventEarthrendingSlam:
                me->CastSpell(me, SpellEarthrendingSlam, false);
                m_Events.ScheduleEvent(EventEarthrendingSlam, 15000);
                break;
            case EventRampage:
                me->AddAura(SpellRampage, me);
                m_Events.ScheduleEvent(EventRampage, 15000);
                break;
            }

            DoMeleeAttackIfReady();
        }
    };
};

/// Rampage - 148852
class spell_groog_rampage : public SpellScriptLoader
{
public:
    spell_groog_rampage() : SpellScriptLoader("spell_groog_rampage") { }

    class spell_groog_rampage_AuraScript : public AuraScript
    {
        PrepareAuraScript(spell_groog_rampage_AuraScript);

        void OnTick(AuraEffect const* /*aurEff*/)
        {
            Unit* caster = GetCaster();

            if (!caster)
                return;

            PreventDefaultAction();

            std::list<Player*> playerList;
            caster->GetPlayerListInGrid(playerList, 2.0f);

            caster->HandleEmoteCommand(EMOTE_ONESHOT_ATTACK1H);

            for (Player* player : playerList)
            {
                if (player->HasUnitState(UNIT_STATE_ROOT))
                    continue;

                player->KnockbackFrom(player->m_positionX, player->m_positionY, 10.0f, 10.0f);
            }
        }

        void Register() override
        {
            OnEffectPeriodic += AuraEffectPeriodicFn(spell_groog_rampage_AuraScript::OnTick, EFFECT_1, SPELL_AURA_PERIODIC_TRIGGER_SPELL);
        }
    };

    AuraScript* GetAuraScript() const override
    {
        return new spell_groog_rampage_AuraScript();
    }
};

void AddSC_frostfire_ridge()
{
    new npc_drekthar_frostridge_begin();
    new npc_durotan_frostridge_begin();

    new spell_frostridge_claiming();
    new horde_banner_q34364();

    /* BOSS */
    new npc_groog();
    new spell_groog_rampage();
}