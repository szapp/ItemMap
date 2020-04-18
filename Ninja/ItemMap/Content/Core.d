/*
 * Find all items in the current world
 */
func int Ninja_ItemMap_GetItems(var int classDef, var int arrPtr) {
    const int zCWorld__SearchVobListByBaseClass_G1 = 6250016; //0x5F5E20
    const int zCWorld__SearchVobListByBaseClass_G2 = 6439712; //0x624320

    var int vobTreePtr; vobTreePtr = _@(MEM_Vobtree);
    var int worldPtr;   worldPtr   = _@(MEM_World);
    if (!arrPtr) {
        arrPtr = MEM_ArrayCreate();
    };

    const int call = 0;
    if (CALL_Begin(call)) {
        CALL_PtrParam(_@(vobTreePtr));
        CALL_PtrParam(_@(arrPtr));
        CALL_PtrParam(_@(classDef));
        CALL__thiscall(_@(worldPtr), MEMINT_SwitchG1G2(zCWorld__SearchVobListByBaseClass_G1,
                                                       zCWorld__SearchVobListByBaseClass_G2));
        call = CALL_End();
    };

    return arrPtr;
};

/*
 * Draw an item into the parent document
 */
func void Ninja_ItemMap_DrawObject(var int parentPtr, var int x, var int y, var int color) {
    const int zCViewFX__Init_G1                 = 7684128; //0x754020
    const int zCViewFX__Init_G2                 = 6884192; //0x690B60
    const int zCViewObject__SetPixelPosition_G1 = 7689040; //0x755350
    const int zCViewObject__SetPixelPosition_G2 = 6889120; //0x691EA0
    const int zCViewDraw__SetTextureColor_G1    = 7681456; //0x7535B0
    const int zCViewDraw__SetTextureColor_G2    = 6881408; //0x690080
    const int oCViewDocument__oCViewDocument_G1 = 7491936; //0x725160
    const int oCViewDocument__oCViewDocument_G2 = 6866464; //0x68C620
    const int oCViewDocument__scal_del_destr_G1 = 7491888; //0x725130
    const int oCViewDocument__scal_del_destr_G2 = 6866416; //0x68C5F0
    const int oCViewDocument__SetTexture_G1     = 7493872; //0x7258F0
    const int oCViewDocument__SetTexture_G2     = 6868272; //0x68CD30

    // Arguments for the following function calls
    var int zero;
    var int open; open = !Ninja_ItemMap_State;
    const int effect = 1; // Zoom
    const int duration = 1133903872; // 300.0f
    var int colorPtr; colorPtr = _@(color);

    // Create new oCViewDocument object
    var int viewPtr; viewPtr = MEM_Alloc(252);

    const int call = 0;
    if (CALL_Begin(call)) {
        CALL__thiscall(_@(viewPtr), MEMINT_SwitchG1G2(oCViewDocument__oCViewDocument_G1,
                                                      oCViewDocument__oCViewDocument_G2));

        CALL_PtrParam(_@(Ninja_ItemMap_TexNamePtr));
        CALL_IntParam(_@(duration));
        CALL_IntParam(_@(duration));
        CALL_IntParam(_@(effect));
        CALL_IntParam(_@(effect));
        CALL_IntParam(_@(open));
        CALL__fastcall(_@(viewPtr), _@(parentPtr), MEMINT_SwitchG1G2(zCViewFX__Init_G1, zCViewFX__Init_G2));

        CALL_IntParam(_@(zero));
        CALL__fastcall(_@(viewPtr), _@(Ninja_ItemMap_TexNamePtr), MEMINT_SwitchG1G2(oCViewDocument__SetTexture_G1,
                                                                                    oCViewDocument__SetTexture_G2));

        CALL__fastcall(_@(viewPtr), _@(colorPtr), MEMINT_SwitchG1G2(zCViewDraw__SetTextureColor_G1,
                                                                    zCViewDraw__SetTextureColor_G2));
        call = CALL_End();
    };

    // Center the texture
    var int size[2]; MEM_CopyWords(viewPtr+64, _@(size), 2); // zCViewObject.sizepixel
    var int pos[2];
    pos[0] = x - size[0]/2;
    pos[1] = y - size[1]/2;
    var int posPtr; posPtr = _@(pos);
    const int call2 = 0;
    if (CALL_Begin(call2)) {
        CALL__fastcall(_@(viewPtr), _@(posPtr), MEMINT_SwitchG1G2(zCViewObject__SetPixelPosition_G1,
                                                                  zCViewObject__SetPixelPosition_G2));
        call2 = CALL_End();
    };

    // I no longer refer to the object (it's in its parent's hands now)
    var int refCtr; refCtr = MEM_ReadInt(viewPtr+4); // zCObject.refCtr
    refCtr -= 1;
    MEM_WriteInt(viewPtr+4, refCtr);
    if (!refCtr) {
        // Let's do this properly (although this should never be reached)
        const int one = 1;
        const int call3 = 0;
        if (CALL_Begin(call3)) {
            CALL_IntParam(_@(one));
            CALL__thiscall(_@(viewPtr), MEMINT_SwitchG1G2(oCViewDocument__scal_del_destr_G1,
                                                          oCViewDocument__scal_del_destr_G2));
            call3 = CALL_End();
        };
    };
};

/*
 * Find items and draw them onto the map
 */
func void Ninja_ItemMap_AddItems() {
    const int oCItem__classDef_G1         =  9284224; //0x8DAA80
    const int oCItem__classDef_G2         = 11211112; //0xAB1168
    const int oCMobContainer__classDef_G1 =  9285504; //0x8DAF80
    const int oCMobContainer__classDef_G2 = 11212976; //0xAB18B0

    // If state is hidden, do not draw them yet
    if (Ninja_ItemMap_State) {
        return;
    };

    // Obtain map document
    var int docPtr; docPtr = EDI;

    // Obtain world coordinates
    var int coordShift;
    var int wldPos[4]; MEM_Clear(_@(wldPos), 16); // Clear pseudo-locals
    if (GOTHIC_BASE_VERSION == 2) {
        // Gothic 2 allows to provide the coordinates from script with Doc_SetLevelCoords
        var int levelPos; levelPos = docPtr+528;
        wldPos[0] = MEM_ReadIntArray(levelPos, 0);
        wldPos[1] = MEM_ReadIntArray(levelPos, 3);
        wldPos[2] = MEM_ReadIntArray(levelPos, 2);
        wldPos[3] = MEM_ReadIntArray(levelPos, 1);

        // The coordinates assume a shift of the size of the player marker texture (assumed to be 16x16 here!)
        coordShift = 16/2;
    };

    // Or obtain world coordinates from world mesh
    var int empty[4];
    if (MEM_CompareWords(_@(wldPos), _@(empty), 4)) {
        var int bbox; bbox = MEM_World.bspTree_bspRoot+4;
        wldPos[0] = MEM_ReadIntArray(bbox, 0);
        wldPos[1] = MEM_ReadIntArray(bbox, 2);
        wldPos[2] = MEM_ReadIntArray(bbox, 3);
        wldPos[3] = MEM_ReadIntArray(bbox, 5);

        // The coordinates are exact
        coordShift = 0;
    };

    // Obtain map view dimensions
    var int mapViewPtr; mapViewPtr = MEM_ReadInt(docPtr+504);
    var int docDim[4]; MEM_CopyWords(mapViewPtr+56, _@(docDim), 4);  // zCViewObject.posPixel and zCViewObject.sizepixel
    var int docCntr[2];
    docCntr[0] = fracf(docDim[0]*2 + docDim[2], 2);
    docCntr[1] = fracf(docDim[1]*2 + docDim[3], 2);

    // Create coordinate translations
    var int wld2map[2]; var int wldDim[2];
    wldDim[0] = subf(wldPos[2], wldPos[0]);
    wldDim[1] = subf(wldPos[3], wldPos[1]);
    wld2map[0] = divf(mkf(docDim[2]), wldDim[0]);
    wld2map[1] = divf(mkf(docDim[3]), wldDim[1]);
    if (GOTHIC_BASE_VERSION == 1) {
        wld2map[1] = negf(wld2map[1]);
    };

    // Drawing properties
    var int color;
    var int x; var int y;

    // Get hero to obtain current map item later
    var oCNpc her; her = Hlp_GetNpc(hero);

    // Obtain items
    var int arrPtr; arrPtr = Ninja_ItemMap_GetItems(MEMINT_SwitchG1G2(oCItem__classDef_G1, oCItem__classDef_G2), 0);
    var zCArray arr; arr = _^(arrPtr);

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
            color = Ninja_ItemMap_GetItemColor(itm.mainflag);
            if (color == (255<<24)) {
                continue;
            };

            // Get item world position
            var int itmPos[2];
            itmPos[0] = itm._zCVob_trafoObjToWorld[ 3];
            itmPos[1] = itm._zCVob_trafoObjToWorld[11];

            // Calculate map position
            if (GOTHIC_BASE_VERSION == 1) {
                x = roundf(addf(mulf(wld2map[0], itmPos[0]), docCntr[0]));
                y = roundf(addf(mulf(wld2map[1], itmPos[1]), docCntr[1]));
            } else {
                x =             roundf(mulf(wld2map[0], subf(itmPos[0], wldPos[0]))) + docDim[0];
                y = docDim[3] - roundf(mulf(wld2map[1], subf(itmPos[1], wldPos[1]))) + docDim[1];
            };
            x += coordShift;
            y += coordShift;

            // Create new view and place it on the map
            Ninja_ItemMap_DrawObject(mapViewPtr, x, y, color);
        };
    end;

    // Check if also containers are requested
    if (Ninja_ItemMap_Colors[8] != (255<<24)) {
        // Collect all containers in the world
        MEM_ArrayClear(arrPtr);
        arrPtr = Ninja_ItemMap_GetItems(MEMINT_SwitchG1G2(oCMobContainer__classDef_G1,
                                                          oCMobContainer__classDef_G2), arrPtr);

        // Iterate over containers and add them to the map
        color = Ninja_ItemMap_Colors[8];
        repeat(i, arr.numInArray); var int i;
            var int containerPtr; containerPtr = MEM_ArrayRead(arrPtr, i);
            if (Hlp_Is_oCMobContainer(containerPtr)) {
                var oCMobContainer container; container = _^(containerPtr);

                // Skip if already looted (empty)
                if (!container.containList_next) {
                    continue;
                };

                // Get container world position
                var int containerPos[2];
                containerPos[0] = container._zCVob_trafoObjToWorld[ 3];
                containerPos[1] = container._zCVob_trafoObjToWorld[11];

                // Calculate map position
                if (GOTHIC_BASE_VERSION == 1) {
                    x = roundf(addf(mulf(wld2map[0], containerPos[0]), docCntr[0]));
                    y = roundf(addf(mulf(wld2map[1], containerPos[1]), docCntr[1]));
                } else {
                    x =             roundf(mulf(wld2map[0], subf(containerPos[0], wldPos[0]))) + docDim[0];
                    y = docDim[3] - roundf(mulf(wld2map[1], subf(containerPos[1], wldPos[1]))) + docDim[1];
                };

                // Create new view and place it on the map
                Ninja_ItemMap_DrawObject(mapViewPtr, x, y, color);
            };
        end;
    };

    MEM_ArrayFree(arrPtr);
};

/*
 * Fix player position marker (arrow) on the map
 * Gothic does not subtract the texture dimensions from its position properly. Instead of fixing it here, it is fixed
 * but shifted to its old position to maintain integrity of the map document coordinates (Gothic 2).
 */
func void Ninja_ItemMap_FixPlayerMarker() {
    var int arrViewPtr; arrViewPtr = ESI;
    var int posPtr; posPtr = MEMINT_SwitchG1G2(ESP+88, ESP+80);
    var int dim[4]; MEM_CopyWords(arrViewPtr+56, _@(dim), 4);  // zCViewObject.posPixel and zCViewObject.sizepixel
    var int pos[2]; MEM_CopyWords(posPtr, _@(pos), 2); // New position the view is going to be placed at

    // If the view has not be placed yet (no coordinates yet), center the new position
    if ((dim[0] == 0) && (dim[1] == 0)) {
        pos[0] -= dim[2]/2;
        pos[1] -= dim[3]/2;
    };

    // Special case for Gothic 2 if level coordinates have been provided from script with Doc_SetLevelCoords
    if (GOTHIC_BASE_VERSION == 2) {
        // Obtain the oCViewDocumentMap
        var int mapViewPtr; mapViewPtr = MEM_ReadInt(arrViewPtr+76); // zCViewObject.parent
        var int docPtr; docPtr = MEM_ReadInt(mapViewPtr+76); // zCViewObject.parent

        // Check if the document coordinates where set by script with Doc_SetLevelCoords
        var int empty[4];
        if (!MEM_CompareWords(docPtr+528, _@(empty), 4)) { // oCViewDocumentMap.levelPos[4]
            // Revert the fix (even if not performed here, it was done in oCViewDocumentMap::UpdatePosition)
            // Because the manually set level coordinates assume this shift and are aligned to it
            pos[0] += dim[2]/2;
            pos[1] += dim[3]/2;
        };
    };

    // Update position
    MEM_CopyWords(_@(pos), posPtr, 2);
};
