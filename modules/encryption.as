/**
 * kmodule����Í����Ɋւ��鏈����؂�o��������
 */

#ifndef machine_base64
    #include "machine_base64.as"
#endif

#module encryption
    /**
     * �^����ꂽ��������Í�������
     */
    #defcfunc local EncStr str p1_
        len = strlen(p1_)
        sdim p1, len + 1
        sdim encdata, int(1.5 * len) + 3
        p1 = p1_
        randomize 3141
        repeat len
            poke p1, cnt, (peek(p1, cnt) xor rnd(256))
        loop
        randomize 5926
        repeat len
            poke p1, cnt, (peek(p1, cnt) xor rnd(256))
        loop
        randomize 5358
        repeat len
            poke p1, cnt, (peek(p1, cnt) xor rnd(256))
        loop
        Encode@machine_base64 p1, len, encData
        encData = strf("%02X%s", len, encData)
        strrep encData, "\n", ""
    return encData

    /**
     * �^����ꂽ��������Í�������
     */
    #defcfunc local DecStr var p1_
        len = int("$" + strmid(p1_, 0,2 ))
        sdim p1, strlen(p1_) + 1
        sdim decData, len + 10
        p1 = strmid(p1_, 2, strlen(p1_) - 2)
        Decode@machine_base64 p1, strlen(p1), decData
        randomize 3141
        repeat len
            poke decData, cnt, (peek(decData, cnt) xor rnd(256))
        loop
        randomize 5926
        repeat len
            poke decData, cnt, (peek(decData, cnt) xor rnd(256))
        loop
        randomize 5358
        repeat len
            poke decData, cnt, (peek(decData, cnt) xor rnd(256))
        loop
    return decData
#global
