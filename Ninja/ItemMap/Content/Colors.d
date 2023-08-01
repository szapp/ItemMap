/*
 * Determine a color by item type
 */
func int Patch_ItemMap_GetItemColor(var int mainflag) {
    const int categories[Patch_ItemMap_NumItemCat] = {
        /*ITEM_KAT_NF*/      (1 <<  1) | /*ITEM_KAT_FF*/ (1 << 2) | /*ITEM_KAT_MUN*/ (1 << 3), // INV_WEAPON  COMBAT
        /*ITEM_KAT_ARMOR*/   (1 <<  4),                                                        // INV_ARMOR   ARMOR
        /*ITEM_KAT_RUNE*/    (1 <<  9),                                                        // INV_RUNE    RUNE
        /*ITEM_KAT_MAGIC*/   (1 << 31),                                                        // INV_MAGIC   MAGIC
        /*ITEM_KAT_FOOD*/    (1 <<  5),                                                        // INV_FOOD    FOOD
        /*ITEM_KAT_POTIONS*/ (1 <<  7),                                                        // INV_POTION  POTION
        /*ITEM_KAT_DOCS*/    (1 <<  6),                                                        // INV_DOC     DOCS
        /*ITEM_KAT_NONE*/    (1 <<  0) | /*ITEM_KAT_LIGHT*/ (1 <<  8)                          // INV_MISC    OTHER
    };

    // Match category
    repeat(i, Patch_ItemMap_NumItemCat); var int i;
        if (mainflag & MEM_ReadStatArr(_@(categories), i)) {
            return MEM_ReadStatArr(_@(Patch_ItemMap_Colors), i);
        };
    end;

    // Should never be reached
    return -1;
};

/*
 * Fix function from Ikarus: Based on MEMINT_ByteToKeyHex
 * Taken from https://forum.worldofplayers.de/forum/threads/?p=25717007
 */
func string Patch_ItemMap_Byte2hex(var int byte) {
    const int ASCII_0 = 48;
    const int ASCII_A = 65;
    byte = byte & 255;

    // Fix ASCII characters (A to F)
    var int c1; c1 = (byte >> 4);
    if (c1 >= 10) {
        c1 += ASCII_A-ASCII_0-10;
    };
    var int c2; c2 = (byte & 15);
    if (c2 >= 10) {
        c2 += ASCII_A-ASCII_0-10;
    };

    const int mem = 0;
    if (!mem) { mem = MEM_Alloc(3); };

    MEM_WriteByte(mem    , c1 + ASCII_0);
    MEM_WriteByte(mem + 1, c2 + ASCII_0);
    return STR_FromChar(mem);
};
func int Patch_ItemMap_Hex2Bytes(var int c) {
    const int ASCII_Ac = 65;
    const int ASCII_a = 97;
    const int ASCII_0 = 48;
    if (c >= ASCII_0 && c < ASCII_0 + 10) {
        return c - ASCII_0;
    } else if (c >= ASCII_a && c < ASCII_a + 6) {
        return 10 + c - ASCII_a;
    } else if (c >= ASCII_Ac && c < ASCII_Ac + 6) {
        return 10 + c - ASCII_Ac;
    } else {
        MEM_Error(ConcatStrings("Invalid Hex Char: ", IntToString(c)));
        return 0;
    };
};

/*
 * Read/write color values from/to Gothic.ini
 */
func int Patch_ItemMap_ReadColor(var string value, var int default) {
    var string entry; entry = MEM_GetGothOpt("ITEMMAP", value);
    var zString str; str = _^(_@s(entry));

    if (str.len != 7) {

        // Mark to skip
        if (Hlp_StrCmp(entry, "0")) || (Hlp_StrCmp(entry, "FALSE")) {
            return 255<<24;
        };

        // Write default value to INI
        if (default == (255<<24)) {
            entry = "FALSE";
        } else {
            entry = "#";
            entry = ConcatStrings(entry, Patch_ItemMap_Byte2hex(default>>16));
            entry = ConcatStrings(entry, Patch_ItemMap_Byte2hex(default>>8));
            entry = ConcatStrings(entry, Patch_ItemMap_Byte2hex(default));
        };
        MEM_SetGothOpt("ITEMMAP", value, entry);
        return default;
    };

    var int res; res = 0;
    res += Patch_ItemMap_Hex2Bytes(MEM_ReadByte(str.ptr + 1)) << 20;
    res += Patch_ItemMap_Hex2Bytes(MEM_ReadByte(str.ptr + 2)) << 16;
    res += Patch_ItemMap_Hex2Bytes(MEM_ReadByte(str.ptr + 3)) << 12;
    res += Patch_ItemMap_Hex2Bytes(MEM_ReadByte(str.ptr + 4)) << 8;
    res += Patch_ItemMap_Hex2Bytes(MEM_ReadByte(str.ptr + 5)) << 4;
    res += Patch_ItemMap_Hex2Bytes(MEM_ReadByte(str.ptr + 6));

    return res;
};
