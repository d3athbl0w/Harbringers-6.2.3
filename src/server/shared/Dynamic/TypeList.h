////////////////////////////////////////////////////////////////////////////////
//
// Project-Hellscream https://hellscream.org
// Copyright (C) 2018-2020 Project-Hellscream-6.2
// Discord https://discord.gg/CWCF3C9
//
////////////////////////////////////////////////////////////////////////////////

#ifndef TRINITY_TYPELIST_H
#define TRINITY_TYPELIST_H

/*
  @struct TypeList
  TypeList is the most simple but yet the most powerfull class of all.  It holds
  at compile time the different type of objects in a linked list.
 */

class TypeNull;

template<typename HEAD, typename TAIL>
struct TypeList
{
    typedef HEAD Head;
    typedef TAIL Tail;
};

// enough for now.. can be expand at any point in time as needed
#define TYPELIST_1(T1)                      TypeList<T1, TypeNull>
#define TYPELIST_2(T1, T2)                  TypeList<T1, TYPELIST_1(T2) >
#define TYPELIST_3(T1, T2, T3)              TypeList<T1, TYPELIST_2(T2, T3) >
#define TYPELIST_4(T1, T2, T3, T4)          TypeList<T1, TYPELIST_3(T2, T3, T4) >
#define TYPELIST_5(T1, T2, T3, T4, T5)      TypeList<T1, TYPELIST_4(T2, T3, T4, T5) >
#define TYPELIST_6(T1, T2, T3, T4, T5, T6)  TypeList<T1, TYPELIST_5(T2, T3, T4, T5, T6) >
#endif

