////////////////////////////////////////////////////////////////////////////////
//
// Project-Hellscream https://hellscream.org
// Copyright (C) 2018-2020 Project-Hellscream-6.2
// Discord https://discord.gg/CWCF3C9
//
////////////////////////////////////////////////////////////////////////////////

#ifndef CROSS
#include "GarrisonPlayerCondition.hpp"

#ifndef __clang_analyzer__
void AddSC_Garrison_PlayerConditions()
{
    new MS::Garrison::PlayerCondition_HasMine();
    new MS::Garrison::PlayerCondition_HasHerbGarden();
    new MS::Garrison::PlayerCondition_AlchemyLab_Level2();
    new MS::Garrison::PlayerCondition_AlchemyLab_Level3();
    new MS::Garrison::PlayerCondition_TailoringEmporium_Level2();
    new MS::Garrison::PlayerCondition_TailoringEmporium_Level3();
    new MS::Garrison::PlayerCondition_GemBoutique_Level2();
    new MS::Garrison::PlayerCondition_GemBoutique_Level3();
    new MS::Garrison::PlayerCondition_TheTannery_Level2();
    new MS::Garrison::PlayerCondition_TheTannery_Level3();
    new MS::Garrison::PlayerCondition_TheForge_Level2();
    new MS::Garrison::PlayerCondition_TheForge_Level3();
    new MS::Garrison::PlayerCondition_EnchanterStudy_Level2();
    new MS::Garrison::PlayerCondition_EnchanterStudy_Level3();
    new MS::Garrison::PlayerCondition_EngineeringWorks_Level2();
    new MS::Garrison::PlayerCondition_EngineeringWorks_Level3();
    new MS::Garrison::PlayerCondition_ScribesQuarters_Level2();
    new MS::Garrison::PlayerCondition_ScribesQuarters_Level3();
    new MS::Garrison::PlayerCondition_EnchanterStudy_Level2_Second();
    new MS::Garrison::PlayerCondition_EnchanterStudy_Level3_Second();
    new MS::Garrison::PlayerCondition_ScribesQuarters_Level2_Second();
    new MS::Garrison::PlayerCondition_ScribesQuarters_Level3_Second();
    new MS::Garrison::PlayerCondition_EngineeringWorks_Level2_Second();
    new MS::Garrison::PlayerCondition_EngineeringWorks_Level3_Second();
}
#endif
#endif
