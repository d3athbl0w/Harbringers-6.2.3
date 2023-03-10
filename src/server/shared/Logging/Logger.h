////////////////////////////////////////////////////////////////////////////////
//
// Project-Hellscream https://hellscream.org
// Copyright (C) 2018-2020 Project-Hellscream-6.2
// Discord https://discord.gg/CWCF3C9
//
////////////////////////////////////////////////////////////////////////////////

#ifndef LOGGER_H
#define LOGGER_H

#include "Appender.h"
#include "Common.h"

class Logger
{
    public:
        Logger();
        ~Logger();

        void Create(std::string const& name, LogFilterType type, LogLevel level);
        void addAppender(uint8 type, Appender *);
        void delAppender(uint8 type);

        std::string const& getName() const;
        LogFilterType getType() const;
        LogLevel getLogLevel() const;
        void setLogLevel(LogLevel level);
        void write(LogMessage& message);

    private:
        std::string name;
        LogFilterType type;
        LogLevel level;
        AppenderMap appenders;
};

#endif
