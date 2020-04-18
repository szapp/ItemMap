/* Toggle state */
var   int    Ninja_ItemMap_State;

/* Marker texture properties */
const string Ninja_ItemMap_TexName = "NINJA_ITEMMAP_MARKER.TGA";
const int    Ninja_ItemMap_TexNamePtr = 0;
// The arrow position is not properly centered: shift back (assumed arrow texture size 16x16 pixels)
const int    Ninja_ItemMap_TexShift = -(8/2 + 16/2); // TextureSize/2 + ArrowSize/2

/* Minimum item value */
const int    Ninja_ItemMap_MinValue = 0;

/* Color table */
const int    Ninja_ItemMap_Colors[/*INV_CAT_MAX-1*/8] = {
    14826792, // COMBAT #E23D28 red
    16744192, // ARMOR  #FF7F00 orange
    16515324, // RUNE   #FC00FC purple
    16775680, // MAGIC  #FFFA00 yellow
    54104,    // FOOD   #00D358 green
    49151,    // POTION #00BFFF blue
    16577461, // DOCS   #FCF3B5 faint yellow/white
    9013641   // OTHER  #898989 dark gray
};
