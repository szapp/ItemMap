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
