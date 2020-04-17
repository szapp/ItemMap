/*
 * Menu initialization function called by Ninja every time a menu is opened
 */
func void Ninja_ItemMap_Menu() {
    // Only on game start
    const int once = 0;
    if (once) {
        return;
    };
    once = 1;

    // Initialize Ikarus
    MEM_InitAll();

    MEM_Info("ItemMap: Initializing entries in Gothic.ini.");

    if (!MEM_GothOptExists("ITEMMAP", "minValue")) {
        MEM_SetGothOpt("ITEMMAP", "minValue", "0");
    };
    Ninja_ItemMap_MinValue = STR_ToInt(MEM_GetGothOpt("ITEMMAP", "minValue"));
    Ninja_ItemMap_Colors[0] = Ninja_ItemMap_ReadColor("combat", Ninja_ItemMap_Colors[0]);
    Ninja_ItemMap_Colors[1] = Ninja_ItemMap_ReadColor("armor",  Ninja_ItemMap_Colors[1]);
    Ninja_ItemMap_Colors[2] = Ninja_ItemMap_ReadColor("rune",   Ninja_ItemMap_Colors[2]);
    Ninja_ItemMap_Colors[3] = Ninja_ItemMap_ReadColor("magic",  Ninja_ItemMap_Colors[3]);
    Ninja_ItemMap_Colors[4] = Ninja_ItemMap_ReadColor("food",   Ninja_ItemMap_Colors[4]);
    Ninja_ItemMap_Colors[5] = Ninja_ItemMap_ReadColor("potion", Ninja_ItemMap_Colors[5]);
    Ninja_ItemMap_Colors[6] = Ninja_ItemMap_ReadColor("docs",   Ninja_ItemMap_Colors[6]);
    Ninja_ItemMap_Colors[7] = Ninja_ItemMap_ReadColor("other",  Ninja_ItemMap_Colors[7]);
};

/*
 * Initialization function called by Ninja after "Init_Global" (G2) / "Init_<Levelname>" (G1)
 */
func void Ninja_ItemMap_Init() {
    // Initialize Ikarus
    MEM_InitAll();

    // Place hook on updating the map and on key events
    const int oCDocumentManager__HandleEvent_G1              = 7490873; //0x724D39
    const int oCDocumentManager__HandleEvent_G2              = 6681689; //0x65F459
    const int oCViewDocumentMap__UpdatePosition_drawItems_G1 = 7495977; //0x726129
    const int oCViewDocumentMap__UpdatePosition_drawItems_G2 = 6871204; //0x68D8A4

    HookEngineF(MEMINT_SwitchG1G2(oCViewDocumentMap__UpdatePosition_drawItems_G1,
                                  oCViewDocumentMap__UpdatePosition_drawItems_G2), 7, Ninja_ItemMap_AddItems);
    HookEngineF(MEMINT_SwitchG1G2(oCDocumentManager__HandleEvent_G1,
                                  oCDocumentManager__HandleEvent_G2), 6, Ninja_ItemMap_HandleEvent);
};
