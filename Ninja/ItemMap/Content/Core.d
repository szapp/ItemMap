/*
 * Find all items in the current world
 */
func int Patch_ItemMap_GetItems(var int classDef, var int arrPtr) {
    const int zCWorld__SearchVobListByBaseClass[4] = {/*G1*/6250016, /*G1A*/6385120, /*G2*/6409104, /*G2A*/6439712};

    var int vobTreePtr; vobTreePtr = _@(MEM_Vobtree);
    var int worldPtr;   worldPtr   = _@(MEM_World);
    if (!arrPtr) {
        arrPtr = MEM_ArrayCreate();
    };

    if (CALL_Begin(call)) {
        const int call = 0;
        CALL_PtrParam(_@(vobTreePtr));
        CALL_PtrParam(_@(arrPtr));
        CALL_PtrParam(_@(classDef));
        CALL__thiscall(_@(worldPtr), zCWorld__SearchVobListByBaseClass[IDX_EXE]);
        call = CALL_End();
    };

    return arrPtr;
};

/*
 * Draw a marker into the parent document
 */
func void Patch_ItemMap_DrawObject(var int parentPtr, var int x, var int y, var int color) {
    const int zCViewFX__Init[4]                 = {/*G1*/7684128, /*G1A*/7955680, /*G2*/7998896, /*G2A*/6884192};
    const int zCViewFX__OpenSafe[4]             = {/*G1*/7684304, /*G1A*/7955872, /*G2*/7999072, /*G2A*/6884368};
    const int zCViewObject__SetPixelSize[4]     = {/*G1*/7689744, /*G1A*/7961152, /*G2*/8004528, /*G2A*/6889824};
    const int zCViewObject__SetPixelPosition[4] = {/*G1*/7689040, /*G1A*/7960432, /*G2*/8003824, /*G2A*/6889120};
    const int zCViewDraw__SetTexture[4]         = {/*G1*/7681168, /*G1A*/7952688, /*G2*/7995824, /*G2A*/6881120};
    const int zCViewDraw__SetTextureColor[4]    = {/*G1*/7681456, /*G1A*/7952992, /*G2*/7996112, /*G2A*/6881408};
    const int oCViewDocument__oCViewDocument[4] = {/*G1*/7491936, /*G1A*/7742432, /*G2*/7804400, /*G2A*/6866464};

    // Arguments for the following function calls
    const int sizeof_oCViewDocument = 252;
    const int FX_ZOOM = 1;
    const int FX_FADE = 2;
    const int effect = FX_ZOOM | FX_FADE;
    const int durOpen  = 1133903872; // 300.0f
    const int durClose = 1140457472; // 500.0f
    const int emptyStrPtr = 0;
    const int texStrPtr = 0;
    const int viewPtr = 0;
    const int colorPtr = 0;
    const int sizePtr = 0;
    const int posPtr = 0;
    const int halfSize = 0;
    const int size[2] = {0, 0};
    const int call = 0;

    if (CALL_Begin(call)) {
        // One-time address definitions
        texStrPtr = _@s(Patch_ItemMap_TexName);
        emptyStrPtr = _@s("");
        colorPtr = _@(color);
        sizePtr = _@(size);

        // One-time size calculations
        size[0] = Patch_ItemMap_MarkerSize;
        size[1] = Patch_ItemMap_MarkerSize;
        halfSize = Patch_ItemMap_MarkerSize/2;

        // Position calculations
        ASM_Open(280);
        ASM_1(161);   ASM_4(_@(y));       // mov   eax, [y]
        ASM_1(45);    ASM_4(halfSize);    // sub   eax, halfSize
        ASM_1(80);                        // push  eax              ; pos[1] = y - halfSize
        ASM_1(161);   ASM_4(_@(x));       // mov   eax, [x]
        ASM_1(45);    ASM_4(halfSize);    // sub   eax, halfSize
        ASM_1(80);                        // push  eax              ; pos[0] = x - halfSize
        ASM_2(9609);  ASM_4(_@(posPtr));  // mov   [posPtr], esp

        // Create new oCViewDocument object
        CALL_IntParam(_@(sizeof_oCViewDocument));
        CALL_PutRetValTo(_@(viewPtr));
        CALL__cdecl(malloc_adr);
        CALL__thiscall(_@(viewPtr), oCViewDocument__oCViewDocument[IDX_EXE]);

        // Attach to parent view
        CALL_PtrParam(_@(emptyStrPtr));
        CALL_IntParam(_@(durClose));
        CALL_IntParam(_@(durOpen));
        CALL_IntParam(_@(effect));
        CALL_IntParam(_@(effect));
        CALL_IntParam(_@(FALSE));
        CALL__fastcall(_@(viewPtr), _@(parentPtr), zCViewFX__Init[IDX_EXE]);

        // Adjust size, position, texture, and color
        CALL__fastcall(_@(viewPtr), _@(sizePtr), zCViewObject__SetPixelSize[IDX_EXE]);
        CALL__fastcall(_@(viewPtr), _@(posPtr),  zCViewObject__SetPixelPosition[IDX_EXE]);
        CALL__fastcall(_@(viewPtr), _@(texStrPtr), zCViewDraw__SetTexture[IDX_EXE]);
        CALL__fastcall(_@(viewPtr), _@(colorPtr),  zCViewDraw__SetTextureColor[IDX_EXE]);

        // Open delayed
        CALL__fastcall(_@(viewPtr), _@(FALSE), zCViewFX__OpenSafe[IDX_EXE]);

        // Release; it's in its parent's hands now
        ASM_2(50307); ASM_1(8);           // add   esp, 0x8         ; Pop stack (see above)
        ASM_2(3467);  ASM_4(_@(viewPtr)); // mov   ecx, [viewPtr]
        ASM_2(16779); ASM_1(4);           // mov   eax, [ecx+0x4]
        ASM_1(72);                        // dec   eax              ; viewPtr->refCtr--
        ASM_2(16777); ASM_1(4);           // mov   [ecx+0x4], eax
        ASM_2(49285);                     // test  eax, eax         ; if (viewPtr->refCtr <= 0)
        ASM_1(127);   ASM_1(7);           // jg    .skip
        ASM_2(395);                       // mov   eax, [ecx]
        ASM_1(106);   ASM_1(1);           // push  0x1
        ASM_2(20735); ASM_1(12);          // call  [eax+0xC]        ;   viewPtr->Delete(TRUE)
        call = CALL_End();
    };
};

/*
 * Find items/containers and draw them onto the map
 */
func void Patch_ItemMap_AddItems() {
    const int oCItem__classDef[4]         = {/*G1*/9284224, /*G1A*/9574736, /*G2*/9968832, /*G2A*/11211112};
    const int oCMobContainer__classDef[4] = {/*G1*/9285504, /*G1A*/9576984, /*G2*/9970696, /*G2A*/11212976};

    const int zCViewObject_posPixel_offset      = 56;  // zCPosition
    const int oCViewDocumentMap_mapView_offset  = 504; // oCViewDocument*
    const int oCViewDocumentMap_levelPos_offset = 528; // zVEC4

    const int ITEM_NFOCUS = 1<<23;
    const int COL_CHEST   = Patch_ItemMap_NumColors-1;
    const int COL_INVALID = 255<<24;

    // If state is hidden, do not draw them yet
    if (Patch_ItemMap_State) {
        return;
    };

    // Obtain map document
    var int docPtr; docPtr = EDI; // oCViewDocumentMap*

    // Obtain world coordinates
    var int wldPos[4]; MEM_Clear(_@(wldPos), 4*4); // Clear pseudo-locals
    if (GOTHIC_BASE_VERSION == 130) || (GOTHIC_BASE_VERSION == 2) {
        // Gothic 2 allows to provide the coordinates from script with Doc_SetLevelCoords
        var int levelPos; levelPos = docPtr+oCViewDocumentMap_levelPos_offset;
        wldPos[0] = MEM_ReadIntArray(levelPos, 0);
        wldPos[1] = MEM_ReadIntArray(levelPos, 3);
        wldPos[2] = MEM_ReadIntArray(levelPos, 2);
        wldPos[3] = MEM_ReadIntArray(levelPos, 1);
    };

    // Or obtain world coordinates from world mesh
    var int empty[4];
    if (MEM_CompareWords(_@(wldPos), _@(empty), 4)) {
        var int bbox; bbox = MEM_World.bspTree_bspRoot+4;
        wldPos[0] = MEM_ReadIntArray(bbox, 0);
        wldPos[1] = MEM_ReadIntArray(bbox, 2);
        wldPos[2] = MEM_ReadIntArray(bbox, 3);
        wldPos[3] = MEM_ReadIntArray(bbox, 5);
    };

    // Obtain map view dimensions
    var int mapViewPtr; mapViewPtr = MEM_ReadInt(docPtr+oCViewDocumentMap_mapView_offset); // oCViewDocument*
    var int docDim[4]; MEM_CopyWords(mapViewPtr+zCViewObject_posPixel_offset, _@(docDim), 4);  // posPixel to sizepixel
    var int docCntr[2];
    docCntr[0] = fracf(docDim[0]*2 + docDim[2], 2);
    docCntr[1] = fracf(docDim[1]*2 + docDim[3], 2);

    // Create coordinate translations
    var int wld2map[2]; var int wldDim[2];
    wldDim[0] = subf(wldPos[2], wldPos[0]);
    wldDim[1] = subf(wldPos[3], wldPos[1]);
    wld2map[0] = divf(mkf(docDim[2]), wldDim[0]);
    wld2map[1] = divf(mkf(docDim[3]), wldDim[1]);
    if (GOTHIC_BASE_VERSION == 1) || (GOTHIC_BASE_VERSION == 112) {
        wld2map[1] = negf(wld2map[1]);
    };

    // Drawing properties
    var int color;
    var int x; var int y;

    // Get hero to obtain current map item later
    var oCNpc her; her = Hlp_GetNpc(hero);
    var int herPos[2]; var int diff[2];
    herPos[0] = truncf(her._zCVob_trafoObjToWorld[ 3]) / 100;
    herPos[1] = truncf(her._zCVob_trafoObjToWorld[11]) / 100;

    // Obtain items
    var int arrPtr; arrPtr = Patch_ItemMap_GetItems(oCItem__classDef[IDX_EXE], 0);

    // Iterate over items and add them to the map
    repeat(i, MEM_ArraySize(arrPtr)); var int i;
        var int itmPtr; itmPtr = MEM_ArrayRead(arrPtr, i);
        if (Hlp_Is_oCItem(itmPtr)) {
            // Skip the map item that is currently in use
            if (itmPtr == her.interactItem) {
                continue;
            };

            var oCItem itm; itm = _^(itmPtr);

            // Skip items of low value
            if (itm.value < Patch_ItemMap_MinValue) {
                continue;
            };

            // Skip non-focusable items (items in use by NPC)
            if ((itm.flags & ITEM_NFOCUS) == ITEM_NFOCUS) {
                continue;
            };

            // Skip invalid items
            if (itm.instanz < 0) {
                continue;
            };

            // Determine color (or exclude)
            color = Patch_ItemMap_GetItemColor(itm.mainflag);
            if (color == COL_INVALID) {
                continue;
            };

            // Get item world position
            var int itmPos[2];
            itmPos[0] = itm._zCVob_trafoObjToWorld[ 3];
            itmPos[1] = itm._zCVob_trafoObjToWorld[11];

            // Exclude by distance
            if (Patch_ItemMap_Radius > 0) {
                diff[0] = truncf(itmPos[0])/100 - herPos[0];
                diff[1] = truncf(itmPos[1])/100 - herPos[1];
                diff = diff[0] * diff[0] + diff[1] * diff[1];
                if (diff > Patch_ItemMap_Radius) {
                    continue;
                };
            };

            // Calculate map position
            if (GOTHIC_BASE_VERSION == 1) || (GOTHIC_BASE_VERSION == 112) {
                x = roundf(addf(mulf(wld2map[0], itmPos[0]), docCntr[0]));
                y = roundf(addf(mulf(wld2map[1], itmPos[1]), docCntr[1]));
            } else {
                x =             roundf(mulf(wld2map[0], subf(itmPos[0], wldPos[0]))) + docDim[0];
                y = docDim[3] - roundf(mulf(wld2map[1], subf(itmPos[1], wldPos[1]))) + docDim[1];
            };

            // Account for displacement in the coordinates
            x += Patch_ItemMap_CoordShift;
            y += Patch_ItemMap_CoordShift;

            // Create new view and place it on the map
            Patch_ItemMap_DrawObject(mapViewPtr, x, y, color);
        };
    end;

    // Check if also containers are requested
    if (Patch_ItemMap_Colors[COL_CHEST] != COL_INVALID) {
        // Collect all containers in the world
        MEM_ArrayClear(arrPtr);
        arrPtr = Patch_ItemMap_GetItems(oCMobContainer__classDef[IDX_EXE], arrPtr);

        // Iterate over containers and add them to the map
        color = Patch_ItemMap_Colors[COL_CHEST];
        repeat(i, MEM_ArraySize(arrPtr));
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

                // Exclude by distance
                if (Patch_ItemMap_Radius > 0) {
                    diff[0] = truncf(containerPos[0])/100 - herPos[0];
                    diff[1] = truncf(containerPos[1])/100 - herPos[1];
                    diff = diff[0] * diff[0] + diff[1] * diff[1];
                    if (diff > Patch_ItemMap_Radius) {
                        continue;
                    };
                };

                // Calculate map position
                if (GOTHIC_BASE_VERSION == 1) || (GOTHIC_BASE_VERSION == 112) {
                    x = roundf(addf(mulf(wld2map[0], containerPos[0]), docCntr[0]));
                    y = roundf(addf(mulf(wld2map[1], containerPos[1]), docCntr[1]));
                } else {
                    x =             roundf(mulf(wld2map[0], subf(containerPos[0], wldPos[0]))) + docDim[0];
                    y = docDim[3] - roundf(mulf(wld2map[1], subf(containerPos[1], wldPos[1]))) + docDim[1];
                };

                // Account for displacement in the coordinates
                x += Patch_ItemMap_CoordShift;
                y += Patch_ItemMap_CoordShift;

                // Create new view and place it on the map
                Patch_ItemMap_DrawObject(mapViewPtr, x, y, color);
            };
        end;
    };

    MEM_ArrayFree(arrPtr);
};

/*
 * Obtain the size of the player position marker (only called once, therefore no recyclable calls)
 * This functions helps to deal with the incorrectly centered player position marker
 */
func int Patch_ItemMap_GetTexSize(var string texture) {
    const int zCTexture__Load[4]           = {/*G1*/6064880, /*G1A*/6190000, /*G2*/6211824, /*G2A*/6239904};
    const int zCTexture__GetPixelSize[4]   = {/*G1*/6081488, /*G1A*/6207296, /*G2*/6229536, /*G2A*/6257680};
    const int zCTexture__scal_del_destr[4] = {/*G1*/6064272, /*G1A*/6189408, /*G2*/6211216, /*G2A*/6239296};

    // Retrieve (or load) one of the marker textures
    var int texPtr;
    CALL_IntParam(1); // Loading flag
    CALL_zStringPtrParam(texture);
    CALL_PutRetValTo(_@(texPtr));
    CALL__cdecl(zCTexture__Load[IDX_EXE]);

    // Retrieve its dimensions
    CALL_PtrParam(_@(ret));
    CALL_PtrParam(_@(ret));
    CALL__thiscall(texPtr, zCTexture__GetPixelSize[IDX_EXE]);

    // Dereference (and possibly delete) the texture again
    var zCObject obj; obj = _^(texPtr);
    obj.refCtr -= 1;
    if (obj.refCtr <= 0) {
        CALL_IntParam(1);
        CALL__thiscall(texPtr, zCTexture__scal_del_destr[IDX_EXE]);
    };

    var int ret;
    return +ret;
};
func int Patch_ItemMap_GetPositionMarkerSize() {
    return Patch_ItemMap_GetTexSize("L.TGA");
};
func int Patch_ItemMap_GetItemMarkerSize() {
    return Patch_ItemMap_GetTexSize(Patch_ItemMap_TexName);
};
