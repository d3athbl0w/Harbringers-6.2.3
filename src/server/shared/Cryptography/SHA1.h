////////////////////////////////////////////////////////////////////////////////
//
// Project-Hellscream https://hellscream.org
// Copyright (C) 2018-2020 Project-Hellscream-6.2
// Discord https://discord.gg/CWCF3C9
//
////////////////////////////////////////////////////////////////////////////////

#ifndef _AUTH_SHA1_H
#define _AUTH_SHA1_H

#include "Define.h"
#include <string>
#include <openssl/sha.h>

class BigNumber;

class SHA1Hash
{
    public:
        SHA1Hash();
        ~SHA1Hash();

        void UpdateBigNumbers(BigNumber* bn0, ...);

        void UpdateData(const uint8 *dta, int len);
        void UpdateData(const std::string &str);

        void Initialize();
        void Finalize();

        uint8 *GetDigest(void) { return mDigest; };
        int GetLength(void) const { return SHA_DIGEST_LENGTH; };

    private:
        SHA_CTX mC;
        uint8 mDigest[SHA_DIGEST_LENGTH];
};
#endif

