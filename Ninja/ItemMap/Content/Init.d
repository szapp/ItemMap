/*
 * This file is part of ItemMap.
 * Copyright (C) 2020-2024  Sören Zapp
 *
 * ItemMap is free software: you can redistribute it and/or
 * modify it under the terms of the MIT License.
 * On redistribution this notice must remain intact and all copies must
 * identify the original author.
 */

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

    // This code is only reached once: Do one-time initialization here
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

    // Obtain player marker texture displacement for shifting the markers
    Patch_ItemMap_CoordShift = Patch_ItemMap_GetPositionMarkerSize() / 2;

    // Obtain item marker size
    Patch_ItemMap_MarkerSize = roundf(mulf(mkf(Patch_ItemMap_GetItemMarkerSize()), Bar_GetInterfaceScaling()));

    // Place hooks
    const int oCDocumentManager__HandleEvent_start[4]  = {/*G1*/7490873, /*G1A*/7740553, /*G2*/7802633, /*G2A*/6681689};
    const int oCViewDocumentMap__UpdatePosition_drw[4] = {/*G1*/7495977, /*G1A*/7747210, /*G2*/7809140, /*G2A*/6871204};

    // Place hook on updating the map
    HookEngineF(oCViewDocumentMap__UpdatePosition_drw[ItemMap_EXE], 7, Patch_ItemMap_AddItems);

    // Place hook on key events
    HookEngineF(oCDocumentManager__HandleEvent_start[ItemMap_EXE],  6, Patch_ItemMap_HandleEvent);
};
