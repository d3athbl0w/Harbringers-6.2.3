////////////////////////////////////////////////////////////////////////////////
//
//  MILLENIUM-STUDIO
//  Copyright 2016 Millenium-studio SARL
//  All Rights Reserved.
//
////////////////////////////////////////////////////////////////////////////////

#ifndef CROSS
#include "HLumberMill.hpp"
#include "GarrisonMgr.hpp"
#include "../../../GarrisonScriptData.hpp"
#include "../../../Sites/GarrisonSiteBase.hpp"

namespace MS { namespace Garrison
{
    //////////////////////////////////////////////////////////////////////////
    /// 85048 - Lumber Lord Oktron                                         ///
    //////////////////////////////////////////////////////////////////////////

    namespace npc_LumberLordOktronData
    {
        InitSequenceFunction FnLevel1 = [](GarrisonNPCAI* /*p_This*/, Creature* /*p_Me*/)
        {
        };

        InitSequenceFunction FnLevel2 = [](GarrisonNPCAI* /*p_This*/, Creature* /*p_Me*/)
        {

        };

        InitSequenceFunction FnLevel3 = [](GarrisonNPCAI* /*p_This*/, Creature* /*p_Me*/)
        {

        };
    }

    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////
    //////////////////////////////////////////////////////////////////////////

    /// Constructor
    npc_LumberLordOktron::npc_LumberLordOktron()
        : CreatureScript("npc_LumberLordOktron_Garr")
    {
    }

    /// Constructor
    /// @p_Creature : AI Owner
    npc_LumberLordOktronAI::npc_LumberLordOktronAI(Creature* p_Creature)
        : SimpleSequenceCosmeticScriptAI(p_Creature)
    {
    }

    bool npc_LumberLordOktron::OnGossipHello(Player* p_Player, Creature* p_Creature)
    {
        Quest const* l_FirstQuest  = sObjectMgr->GetQuestTemplate(Quests::Horde_EasingIntoLumberjacking);
        Quest const* l_SecondQuest = sObjectMgr->GetQuestTemplate(Quests::Horde_TurningTimberIntoProfit);

        if (l_FirstQuest == nullptr || l_SecondQuest == nullptr)
            return true;

        if (p_Player->IsQuestRewarded(Quests::Horde_EasingIntoLumberjacking) ||
            (p_Player->GetQuestStatus(Quests::Horde_EasingIntoLumberjacking) == QUEST_STATUS_INCOMPLETE))
        {
            if (p_Player->GetQuestStatus(Quests::Horde_TurningTimberIntoProfit) == QUEST_STATUS_NONE)
            {
                p_Player->PlayerTalkClass->SendQuestGiverQuestDetails(l_SecondQuest, p_Creature->GetGUID());
                return true;
            }
            else if (p_Player->GetQuestStatus(Quests::Horde_TurningTimberIntoProfit) == QUEST_STATUS_COMPLETE)
            {
                p_Player->PlayerTalkClass->SendCloseGossip();
                p_Player->PlayerTalkClass->SendQuestGiverOfferReward(l_SecondQuest, p_Creature->GetGUID());
                return true;
            }

            p_Player->ADD_GOSSIP_ITEM_DB(GarrisonGossipMenus::MenuID::DefaultMenuGreetings, GarrisonGossipMenus::GossipOption::DefaultWorkOrder, GOSSIP_SENDER_MAIN, GOSSIP_ACTION_INFO_DEF + 1);
            p_Player->SEND_GOSSIP_MENU(DEFAULT_GOSSIP_MESSAGE, p_Creature->GetGUID());
        }
        else if (p_Player->GetQuestStatus(Quests::Horde_EasingIntoLumberjacking) == QUEST_STATUS_NONE)
            p_Player->PlayerTalkClass->SendQuestGiverQuestDetails(l_FirstQuest, p_Creature->GetGUID());
        else if (p_Player->GetQuestStatus(Quests::Horde_EasingIntoLumberjacking) == QUEST_STATUS_COMPLETE)
        {
            p_Player->PlayerTalkClass->SendCloseGossip();
            p_Player->PlayerTalkClass->SendQuestGiverOfferReward(l_FirstQuest, p_Creature->GetGUID());
        }

        return true;
    }

    bool npc_LumberLordOktron::OnGossipSelect(Player* p_Player, Creature* p_Creature, uint32 /*p_Sender*/, uint32 p_Action)
    {
        GarrisonNPCAI* l_AI = p_Creature->ToGarrisonNPCAI();

        if (l_AI == nullptr)
            return true;

        p_Player->PlayerTalkClass->ClearMenus();

        if (p_Action == GOSSIP_ACTION_INFO_DEF + 1)
            l_AI->SendShipmentCrafterUI(p_Player);

        return true;
    }

    bool npc_LumberLordOktron::OnQuestAccept(Player* p_Player, Creature* /*p_Creature*/, const Quest* /*p_Quest*/)
    {
        p_Player->CastSpell(p_Player, Spells::SpellApprenticeLogging, true);

        return true;
    }

    void npc_LumberLordOktron::OnShipmentCreated(Player* p_Player, Creature* /*p_Creature*/, uint32 p_BuildingID)
    {
        if (p_BuildingID == Building::ID::LumberMill_LumberMill_Level1)
        {
            if (p_Player->GetQuestStatus(Quests::Horde_TurningTimberIntoProfit) == QUEST_STATUS_INCOMPLETE)
                p_Player->QuestObjectiveSatisfy(ObjectIDs::TimberWorkOrderHorde, 1, QuestObjectiveType::QUEST_OBJECTIVE_TYPE_CRITERIA_TREE);
        }
    }

    /// Called when a CreatureAI object is needed for the creature.
    /// @p_Creature : Target creature instance
    CreatureAI* npc_LumberLordOktron::GetAI(Creature* p_Creature) const
    {
        return new npc_LumberLordOktronAI(p_Creature);
    }
}   ///< namespace Garrison
}   ///< namespace MS
#endif
