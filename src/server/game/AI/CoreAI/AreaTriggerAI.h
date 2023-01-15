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

#ifndef AREATRIGGERAI_H
#define AREATRIGGERAI_H

#include "Define.h"

class AreaTrigger;
class Unit;

class AreaTriggerAI
{
    protected:
        AreaTrigger* const at;
    public:
        explicit AreaTriggerAI(AreaTrigger* a);
        virtual ~AreaTriggerAI();

        // Called when the AreaTrigger has just been initialized, just before added to map
        virtual void OnInitialize() { }

        // Called when the AreaTrigger has just been created
        virtual void OnCreate() { }

        // Called on each AreaTrigger update
        virtual void OnUpdate(uint32 /*diff*/) { }

        // Called on each AreaTrigger proc, timer defined by at->SetPeriodicProcTimer(uint32)
        virtual void OnPeriodicProc() { }

        // Called when the AreaTrigger reach splineIndex
        virtual void OnSplineIndexReached(int /*splineIndex*/) { }

        // Called when the AreaTrigger reach its destination
        virtual void OnDestinationReached() { }

        // Called when an unit enter the AreaTrigger
        virtual void OnUnitEnter(Unit* /*unit*/) { }

        // Called when an unit exit the AreaTrigger, or when the AreaTrigger is removed
        virtual void OnUnitExit(Unit* /*unit*/) { }

        // Called when the AreaTrigger is removed
        virtual void OnRemove() { }

        // Pass parameters between AI
        virtual void DoAction(int32 /*param*/) { }
};

class NullAreaTriggerAI : public AreaTriggerAI
{
    public:
        explicit NullAreaTriggerAI(AreaTrigger* areaTrigger) : AreaTriggerAI(areaTrigger) { }
};

#endif