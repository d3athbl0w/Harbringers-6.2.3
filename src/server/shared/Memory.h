////////////////////////////////////////////////////////////////////////////////
//
// Project-Hellscream https://hellscream.org
//  Copyright 2014 Millenium-studio SARL
// Discord https://discord.gg/CWCF3C9
//
////////////////////////////////////////////////////////////////////////////////

#ifndef _MEMORY_H
#define _MEMORY_H

#include "DetourAlloc.h"

//  memory management
inline void* dtCustomAlloc(int size, dtAllocHint /*hint*/)
{
    return (void*)new unsigned char[size];
}

inline void dtCustomFree(void* ptr)
{
    delete [] (unsigned char*)ptr;
}

#endif
