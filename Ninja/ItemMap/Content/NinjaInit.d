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

    // This code is only reached once: Do one-time initializations here
    MEM_InitAll();

    MEM_Info("ItemMap: Initializing entries in Gothic.ini.");

    if (!MEM_GothOptExists("ITEMMAP", "radius")) {
        MEM_SetGothOpt("ITEMMAP", "radius", "-1");
    };
    if (!MEM_GothOptExists("ITEMMAP", "minValue")) {
        MEM_SetGothOpt("ITEMMAP", "minValue", "0");
    };
    Patch_ItemMap_Radius = STR_ToInt(MEM_GetGothOpt("ITEMMAP", "radius"));
    Patch_ItemMap_MinValue = STR_ToInt(MEM_GetGothOpt("ITEMMAP", "minValue"));
    Patch_ItemMap_Colors[0] = Patch_ItemMap_ReadColor("combat", Patch_ItemMap_Colors[0]);
    Patch_ItemMap_Colors[1] = Patch_ItemMap_ReadColor("armor",  Patch_ItemMap_Colors[1]);
    Patch_ItemMap_Colors[2] = Patch_ItemMap_ReadColor("rune",   Patch_ItemMap_Colors[2]);
    Patch_ItemMap_Colors[3] = Patch_ItemMap_ReadColor("magic",  Patch_ItemMap_Colors[3]);
    Patch_ItemMap_Colors[4] = Patch_ItemMap_ReadColor("food",   Patch_ItemMap_Colors[4]);
    Patch_ItemMap_Colors[5] = Patch_ItemMap_ReadColor("potion", Patch_ItemMap_Colors[5]);
    Patch_ItemMap_Colors[6] = Patch_ItemMap_ReadColor("docs",   Patch_ItemMap_Colors[6]);
    Patch_ItemMap_Colors[7] = Patch_ItemMap_ReadColor("other",  Patch_ItemMap_Colors[7]);
    Patch_ItemMap_Colors[8] = Patch_ItemMap_ReadColor("chest",  Patch_ItemMap_Colors[8]);

    // Already square the distance
    if (Patch_ItemMap_Radius > 0) {
        Patch_ItemMap_Radius = Patch_ItemMap_Radius * Patch_ItemMap_Radius;
    };

    // Additional speed-up
    Patch_ItemMap_TexNamePtr = _@s(Patch_ItemMap_TexName);

    // Obtain player marker texture displacement for shifting the markers
    Patch_ItemMap_CoordShift = Patch_ItemMap_GetPositionMarkerSize() / 2;

    // Obtain item marker size
    Patch_ItemMap_MarkerSize = roundf(mulf(mkf(Patch_ItemMap_GetItemMarkerSize()), Bar_GetInterfaceScaling()));
};

/*
 * Initialization function called by Ninja after "Init_Global" (G2) / "Init_<Levelname>" (G1)
 */
func void Ninja_ItemMap_Init() {
    // Initialize Ikarus
    MEM_InitAll();

    const int oCDocumentManager__HandleEvent_G1              = 7490873; //0x724D39
    const int oCDocumentManager__HandleEvent_G2              = 6681689; //0x65F459
    const int oCViewDocumentMap__UpdatePosition_drawItems_G1 = 7495977; //0x726129
    const int oCViewDocumentMap__UpdatePosition_drawItems_G2 = 6871204; //0x68D8A4

    // Place hook on updating the map
    HookEngineF(MEMINT_SwitchG1G2(oCViewDocumentMap__UpdatePosition_drawItems_G1,
                                  oCViewDocumentMap__UpdatePosition_drawItems_G2), 7, Patch_ItemMap_AddItems);

    // Place hook on key events
    HookEngineF(MEMINT_SwitchG1G2(oCDocumentManager__HandleEvent_G1,
                                  oCDocumentManager__HandleEvent_G2), 6, Patch_ItemMap_HandleEvent);
};
