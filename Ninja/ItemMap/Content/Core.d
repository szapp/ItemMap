/*
 * Find all items in the current world
 */
func int Ninja_ItemMap_GetItems() {
    const int zCWorld__SearchVobListByBaseClass_G1 = 6250016; //0x5F5E20
    const int zCWorld__SearchVobListByBaseClass_G2 = 6439712; //0x624320
    const int oCItem__classDef_G1 =  9284224; //0x8DAA80
    const int oCItem__classDef_G2 = 11211112; //0xAB1168

    var int arrPtr;     arrPtr     = MEM_ArrayCreate();
    var int vobTreePtr; vobTreePtr = _@(MEM_Vobtree);
    var int worldPtr;   worldPtr   = _@(MEM_World);

    const int call = 0;
    if (CALL_Begin(call)) {
        CALL_PtrParam(_@(vobTreePtr));
        CALL_PtrParam(_@(arrPtr));
        CALL_PtrParam(MEMINT_SwitchG1G2(_@(oCItem__classDef_G1), _@(oCItem__classDef_G2)));
        CALL__thiscall(_@(worldPtr), MEMINT_SwitchG1G2(zCWorld__SearchVobListByBaseClass_G1,
                                                       zCWorld__SearchVobListByBaseClass_G2));
        call = CALL_End();
    };

    return arrPtr;
};

/*
 * Draw an item into the parent document
 */
func void Ninja_ItemMap_DrawItem(var int parentPtr, var int x, var int y, var int color) {
    const int zCViewFX__Init_G1                 = 7684128; //0x754020
    const int zCViewFX__Init_G2                 = 6884192; //0x690B60
    const int zCViewObject__SetPixelPosition_G1 = 7689040; //0x755350
    const int zCViewObject__SetPixelPosition_G2 = 6889120; //0x691EA0
    const int zCViewDraw__SetTextureColor_G1    = 7681456; //0x7535B0
    const int zCViewDraw__SetTextureColor_G2    = 6881408; //0x690080
    const int oCViewDocument__oCViewDocument_G1 = 7491936; //0x725160
    const int oCViewDocument__oCViewDocument_G2 = 6866464; //0x68C620
    const int oCViewDocument__SetTexture_G1     = 7493872; //0x7258F0
    const int oCViewDocument__SetTexture_G2     = 6868272; //0x68CD30

    var int viewPtr; viewPtr = MEM_Alloc(252); // oCViewDocument

    const int call = 0;
    if (CALL_Begin(call)) {
        CALL__thiscall(_@(viewPtr), MEMINT_SwitchG1G2(oCViewDocument__oCViewDocument_G1,
                                                      oCViewDocument__oCViewDocument_G2));
        call = CALL_End();
    };

    var int texNamePtr; texNamePtr = _@s("NINJA_ITEMMAP_MARKER.TGA");
    var int open; open = !Ninja_ItemMap_State;

    const int effect = 1; // Zoom
    const int duration = 1133903872; // 300.0f
    const int call2 = 0;
    if (CALL_Begin(call2)) {
        CALL_PtrParam(_@(texNamePtr));
        CALL_IntParam(_@(duration));
        CALL_IntParam(_@(duration));
        CALL_IntParam(_@(effect));
        CALL_IntParam(_@(effect));
        CALL_IntParam(_@(open));
        CALL__fastcall(_@(viewPtr), _@(parentPtr), MEMINT_SwitchG1G2(zCViewFX__Init_G1, zCViewFX__Init_G2));
        call2 = CALL_End();
    };

    var int zero;
    const int call3 = 0;
    if (CALL_Begin(call3)) {
        CALL_IntParam(_@(zero));
        CALL__fastcall(_@(viewPtr), _@(texNamePtr), MEMINT_SwitchG1G2(oCViewDocument__SetTexture_G1,
                                                                      oCViewDocument__SetTexture_G2));
        call3 = CALL_End();
    };

    var int colorPtr; colorPtr = _@(color);
    const int call4 = 0;
    if (CALL_Begin(call4)) {
        CALL__fastcall(_@(viewPtr), _@(colorPtr), MEMINT_SwitchG1G2(zCViewDraw__SetTextureColor_G1,
                                                                    zCViewDraw__SetTextureColor_G2));
        call4 = CALL_End();
    };

    const int size[2] = {8, 8};
    var int pos[2];
    pos[0] = x - size[0] / 2;
    pos[1] = y - size[1] / 2;
    var int posPtr; posPtr = _@(pos);
    const int call5 = 0;
    if (CALL_Begin(call5)) {
        CALL__fastcall(_@(viewPtr), _@(posPtr), MEMINT_SwitchG1G2(zCViewObject__SetPixelPosition_G1,
                                                                  zCViewObject__SetPixelPosition_G2));
        call5 = CALL_End();
    };
};

/*
 * Find items and draw them onto the map
 */
func void Ninja_ItemMap_AddItems() {
    // Obtain map document
    var int docPtr; docPtr = EDI;

    // Obtain world coordinates
    var int wldPos[4]; MEM_Clear(_@(wldPos), 16); // Clear pseudo-locals
    if (GOTHIC_BASE_VERSION == 2) {
        // Gothic 2 has these saved (only sometimes!)
        var int levelPos; levelPos = docPtr+528;
        wldPos[0] = MEM_ReadIntArray(levelPos, 0);
        wldPos[1] = MEM_ReadIntArray(levelPos, 3);
        wldPos[2] = MEM_ReadIntArray(levelPos, 2);
        wldPos[3] = MEM_ReadIntArray(levelPos, 1);
    };

    // Or obtain world coordinates from world mesh
    if ((wldPos[0] == FLOATNULL) && (wldPos[1] == FLOATNULL) && (wldPos[2] == FLOATNULL) && (wldPos[3] == FLOATNULL)) {
        var int bbox; bbox = MEM_World.bspTree_bspRoot+4;
        wldPos[0] = MEM_ReadIntArray(bbox, 0);
        wldPos[1] = MEM_ReadIntArray(bbox, 2);
        wldPos[2] = MEM_ReadIntArray(bbox, 3);
        wldPos[3] = MEM_ReadIntArray(bbox, 5);
    };

    // Obtain map view dimensions
    var int mapViewPtr; mapViewPtr = MEM_ReadInt(docPtr+504);
    var int docDim[4]; MEM_CopyWords(mapViewPtr+56, _@(docDim), 4);  // zCViewObject.posPixel and zCViewObject.sizepixel

    // Create coordinate translations
    var int wld2map[2]; var int wldDim[2];
    wldDim[0] = subf(wldPos[2], wldPos[0]);
    wldDim[1] = subf(wldPos[3], wldPos[1]);
    wld2map[0] = divf(mkf(docDim[2]), wldDim[0]);
    wld2map[1] = divf(mkf(docDim[3]), wldDim[1]);

    // Obtain items
    var int arrPtr; arrPtr = Ninja_ItemMap_GetItems();
    var zCArray arr; arr = _^(arrPtr);

    // Get hero to obtain current map item later
    var oCNpc her; her = Hlp_GetNpc(hero);

    // Iterate over items and add them to the map
    repeat(i, arr.numInArray); var int i;
        var int itmPtr; itmPtr = MEM_ArrayRead(arrPtr, i);
        if (Hlp_Is_oCItem(itmPtr)) {
            // Skip the map item that is currently in use
            if (itmPtr == her.interactItem) {
                continue;
            };

            var oCItem itm; itm = _^(itmPtr);

            // Skip items of low value
            if (itm.value < Ninja_ItemMap_MinValue) {
                continue;
            };

            // Determine color (or exclude)
            var int color; color = Ninja_ItemMap_GetColor(itm.mainflag);
            if ((color & zCOLOR_ALPHA) == (123<<zCOLOR_SHIFT_ALPHA)) {
                continue;
            };

            // Get item world position
            var int itmPos[2];
            itmPos[0] = itm._zCVob_trafoObjToWorld[ 3];
            itmPos[1] = itm._zCVob_trafoObjToWorld[11];

            // Calculate map position
            var int x; x =             roundf(mulf(wld2map[0], subf(itmPos[0], wldPos[0]))) + docDim[0];
            var int y; y = docDim[3] - roundf(mulf(wld2map[1], subf(itmPos[1], wldPos[1]))) + docDim[1];

            // Create new view and place it on the map
            Ninja_ItemMap_DrawItem(mapViewPtr, x, y, color);
        };
    end;

    MEM_ArrayFree(arrPtr);
};
