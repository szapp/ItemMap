/*
 * Initialization function called by Ninja after "Init_Global" (G2) / "Init_<Levelname>" (G1)
 */
func void Ninja_ItemMap_Init() {
    // Initialize Ikarus
    MEM_InitAll();

    // Place hook on updating the map
    const int oCViewDocumentMap__UpdatePosition_drawItems_G1 = 7495977; //0x726129
    const int oCViewDocumentMap__UpdatePosition_drawItems_G2 = 6871204; //0x68D8A4

    HookEngineF(MEMINT_SwitchG1G2(oCViewDocumentMap__UpdatePosition_drawItems_G1,
                                  oCViewDocumentMap__UpdatePosition_drawItems_G2), 7, Ninja_ItemMap_AddItems);
};
