/*
 * Determine a color by item type
 */
func int Patch_ItemMap_GetItemColor(var int mainflag) {
    const int ITEM_KAT_NONE    = 1 <<  0;
    const int ITEM_KAT_NF      = 1 <<  1;
    const int ITEM_KAT_FF      = 1 <<  2;
    const int ITEM_KAT_MUN     = 1 <<  3;
    const int ITEM_KAT_ARMOR   = 1 <<  4;
    const int ITEM_KAT_FOOD    = 1 <<  5;
    const int ITEM_KAT_DOCS    = 1 <<  6;
    const int ITEM_KAT_POTIONS = 1 <<  7;
    const int ITEM_KAT_LIGHT   = 1 <<  8;
    const int ITEM_KAT_RUNE    = 1 <<  9;
    const int ITEM_KAT_MAGIC   = 1 << 31;

    const int COL_INVALID      = 255<<24;

    const int categories[Patch_ItemMap_NumItemCat] = {
        ITEM_KAT_NF | ITEM_KAT_FF | ITEM_KAT_MUN, // INV_WEAPON  COMBAT
        ITEM_KAT_ARMOR,                           // INV_ARMOR   ARMOR
        ITEM_KAT_RUNE,                            // INV_RUNE    RUNE
        ITEM_KAT_MAGIC,                           // INV_MAGIC   MAGIC
        ITEM_KAT_FOOD,                            // INV_FOOD    FOOD
        ITEM_KAT_POTIONS,                         // INV_POTION  POTION
        ITEM_KAT_DOCS,                            // INV_DOC     DOCS
        ITEM_KAT_NONE | ITEM_KAT_LIGHT            // INV_MISC    OTHER
    };

    // Match category
    repeat(i, Patch_ItemMap_NumItemCat); var int i;
        if (mainflag & MEM_ReadStatArr(_@(categories), i)) {
            return MEM_ReadStatArr(_@(Patch_ItemMap_Colors), i);
        };
    end;

    // Should never be reached
    return COL_INVALID;
};

/*
 * Read/write color values from/to Gothic.ini
 */
func int Patch_ItemMap_ReadColor(var string value, var int default) {
    var string entry; entry = MEM_GetGothOpt("ITEMMAP", value);
    var zString str; str = _^(_@s(entry));
    const int COL_INVALID = 255<<24;

    if (str.len != 7) {

        // Mark to skip
        if (Hlp_StrCmp(entry, "0")) || (Hlp_StrCmp(entry, "FALSE")) {
            return COL_INVALID;
        };

        // Write default value to INI
        if (default == COL_INVALID) {
            entry = "FALSE";
        } else {
            entry = "#";
            entry = ConcatStrings(entry, MEMINT_ByteToKeyHex(default>>16));
            entry = ConcatStrings(entry, MEMINT_ByteToKeyHex(default>>8));
            entry = ConcatStrings(entry, MEMINT_ByteToKeyHex(default));
        };
        MEM_SetGothOpt("ITEMMAP", value, entry);
        return default;
    };

    var int res; res = 0;
    res += MEMINT_HexCharToInt(MEM_ReadByte(str.ptr + 1)) << 20;
    res += MEMINT_HexCharToInt(MEM_ReadByte(str.ptr + 2)) << 16;
    res += MEMINT_HexCharToInt(MEM_ReadByte(str.ptr + 3)) << 12;
    res += MEMINT_HexCharToInt(MEM_ReadByte(str.ptr + 4)) << 8;
    res += MEMINT_HexCharToInt(MEM_ReadByte(str.ptr + 5)) << 4;
    res += MEMINT_HexCharToInt(MEM_ReadByte(str.ptr + 6));

    return res;
};
