/* Toggle state */
var   int    Patch_ItemMap_State; // Kept across saving and loading, 1 = hidden

/* Marker texture name and size (cache) */
const string Patch_ItemMap_TexName    = "PATCH_ITEMMAP_MARKER.TGA";
const int    Patch_ItemMap_CoordShift = 0;
const int    Patch_ItemMap_MarkerSize = 8;

/* Minimum item value (default) */
const int    Patch_ItemMap_MinValue   = 0;

/* Maximum item radius (default) */
const int    Patch_ItemMap_Radius     = -1;

/* Color table (defaults) */
const int    Patch_ItemMap_NumItemCat = 8; // INV_CAT_MAX-1
const int    Patch_ItemMap_NumColors  = Patch_ItemMap_NumItemCat+1;
const int    Patch_ItemMap_Colors[Patch_ItemMap_NumColors] = {
    14826792, // COMBAT #E23D28 red
    16744192, // ARMOR  #FF7F00 orange
    16515324, // RUNE   #FC00FC purple
    16775680, // MAGIC  #FFFA00 yellow
    54104,    // FOOD   #00D358 green
    49151,    // POTION #00BFFF blue
    16577461, // DOCS   #FCF3B5 faint yellow/white
    9013641,  // OTHER  #898989 dark gray
    8343854   // CHEST  #7F512E brown
};
