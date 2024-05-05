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
 * Toggle the markers
 */
func void Patch_ItemMap_Toggle(var int docPtr, var int turnOn) {
    const int zCViewFX__OpenSafe[4]                = {/*G1*/7684304, /*G1A*/7955872, /*G2*/7999072, /*G2A*/6884368};
    const int zCViewFX__CloseSafe[4]               = {/*G1*/7684528, /*G1A*/7956096, /*G2*/7999312, /*G2A*/6884608};
    const int zCViewFX__OpenImmediately[4]         = {/*G1*/7684432, /*G1A*/7956000, /*G2*/7999200, /*G2A*/6884496};
    const int zCViewFX__CloseImmediately[4]        = {/*G1*/7684656, /*G1A*/7956208, /*G2*/7999456, /*G2A*/6884752};
    const int oCViewDocumentMap__UpdatePosition[4] = {/*G1*/7495728, /*G1A*/7746960, /*G2*/7808896, /*G2A*/6870960};

    const int zCViewObject_sizepixel_offset      =  64; // zCPosition
    const int zCViewObject_childList_offset      =  80; // zCListSort
    const int oCViewDocumentMap_arrowView_offset = 252; // oCViewDocument
    const int oCViewDocumentMap_mapView_offset   = 504; // oCViewDocument*

    // Iterate over view children and show/hide them
    var int arrViewPtr; arrViewPtr = docPtr + oCViewDocumentMap_arrowView_offset;            // oCViewDocument*
    var int mapViewPtr; mapViewPtr = MEM_ReadInt(docPtr + oCViewDocumentMap_mapView_offset); // oCViewDocument*
    var zCListSort l; l = _^(mapViewPtr + zCViewObject_childList_offset);                    // zCListSort<zCViewObject*>
    var int list; list = l.next;
    var int any; any = FALSE;
    if (!call) {
        // Assembly for performance (check scripts of previous versions to find analogous Daedalus code)
        const int call  = 0;
        const int open  = zCViewFX__OpenSafe[IDX_EXE]; // Shorthands
        const int close = zCViewFX__CloseSafe[IDX_EXE];
        const int ofast = zCViewFX__OpenImmediately[IDX_EXE];
        const int cfast = zCViewFX__CloseImmediately[IDX_EXE];
        ASM_Open(80);
        ASM_1(96);                               // pusha
        ASM_2(15755); ASM_4(_@(list));           // mov   edi, [list]                ; zCListSort*
        ASM_2(13707); ASM_4(_@(turnOn));         // mov   esi, [turnOn]
        ASM_2(56113);                            // xor   ebx, ebx                   ; counter = 0
        // .start:
        ASM_2(65413);                            // test  edi, edi                   ; while (list) {
        ASM_1(116);   ASM_1(43);                 // jz    .end
        ASM_2(20363); ASM_1(4);                  // mov   ecx, [edi+0x4]             ;  viewPtr = list->data
        ASM_2(32651); ASM_1(8);                  // mov   edi, [edi+0x8]             ;  list = list->next
        ASM_2(3387);  ASM_4(_@(arrViewPtr));     // cmp   ecx, [arrViewPtr]          ;  if (viewPtr == arrViewPtr)
        ASM_1(116);   ASM_1(238);                // jz    .start                     ;    continue
        ASM_1(67);                               // inc   ebx                        ;  increase counter
        ASM_2(63109);                            // test  esi, esi                   ;  if (turnOn)
        ASM_1(116);   ASM_1(12);                 // jz    .close
        ASM_1(232);   ASM_4(cfast-ASM_Here()-4); // call  zCViewFX::CloseImmediately ;    reset viewPtr to closed
        ASM_1(232);   ASM_4(open-ASM_Here()-4);  // call  zCViewFX::OpenSafe         ;    open viewPtr
        ASM_1(235);   ASM_1(221);                // jmp   .start                     ;  else
        // .close:
        ASM_1(232);   ASM_4(ofast-ASM_Here()-4); // call  zCViewFX::OpenImmediately  ;    reset viewPtr to opened
        ASM_1(232);   ASM_4(close-ASM_Here()-4); // call  zCViewFX::CloseSafe        ;    close viewPtr
        ASM_1(235);   ASM_1(209);                // jmp   .start                     ; }
        // .end:
        ASM_2(7561);  ASM_4(_@(any));            // mov   [any], ebx                 ; Write counter into 'any'
        ASM_1(97);                               // popa
        call = ASM_Close();
    };
    ASM_Run(call);

    // If the items/containers were not added yet
    if (!any) && (turnOn) {
        // Account for incorrect player position marker shift (set to zero again)
        const int X = 0;
        const int Y = 1;
        MEM_WriteIntArray(arrViewPtr + zCViewObject_sizepixel_offset, X, 0);
        MEM_WriteIntArray(arrViewPtr + zCViewObject_sizepixel_offset, Y, 0);

        // Update/place the document markers
        if (CALL_Begin(call2)) {
            const int call2 = 0;
            CALL__fastcall(_@(docPtr), _@(FALSE), oCViewDocumentMap__UpdatePosition[IDX_EXE]);
            call2 = CALL_End();
        };
    };
};

/*
 * Check if a key binding is toggled (== pressed once)
 * This approach is more safe than using Ikarus' MEM_KeyState as it does not interfere with any other scripts
 */
func int Patch_ItemMap_KeyBindingIsToggled(var int keyBinding, var int keyStroke) {
    const int zCInput__IsBinded_G1         = 4993104; //0x4C3050
    const int zCInput_Win32__GetToggled_G1 = 5015088; //0x4C8630
    const int zCInput__IsBindedToggled[4]  = {0, /*G1A*/5057200, /*G2*/5021440, /*G2A*/5031024};

    if (CALL_Begin(call)) {
        const int call = 0;
        const int ret  = 0;
        const int ret2 = 1;
        if (GOTHIC_BASE_VERSION == 1) {
            // Emulating zCInput::IsBindedToggled
            CALL_IntParam(_@(keyStroke));
            CALL_IntParam(_@(keyBinding));
            CALL_PutRetValTo(_@(ret));
            CALL__thiscall(zCInput_zinput, zCInput__IsBinded_G1);

            CALL_IntParam(_@(keyBinding));
            CALL_PutRetValTo(_@(ret2));
            CALL__thiscall(zCInput_zinput, zCInput_Win32__GetToggled_G1);
        } else {
            CALL_IntParam(_@(keyStroke));
            CALL_IntParam(_@(keyBinding));
            CALL_PutRetValTo(_@(ret));
            CALL__thiscall(zCInput_zinput, zCInput__IsBindedToggled[IDX_EXE]);
        };
        call = CALL_End();
    };
    return (ret && ret2);
};

/*
 * Handle key additional presses
 */
func void Patch_ItemMap_HandleEvent() {
    const int oCViewDocumentMap__vtbl[4] = {/*G1*/8254556, /*G1A*/8528896, /*G2*/8584556, /*G2A*/8633036};
    const int oCDocumentManager_docList_offset = 4; // oCListSort
    const int zOPT_GAMEKEY_WEAPON = 8;

    if (Patch_ItemMap_KeyBindingIsToggled(zOPT_GAMEKEY_WEAPON, ESI)) {
        // Toggle visibility
        Patch_ItemMap_State = !Patch_ItemMap_State;

        // Iterate over the list of documents
        var zCListSort l; l = _^(MEM_ReadInt(ECX + oCDocumentManager_docList_offset));
        var int docList; docList = l.next;
        while(docList);
            l = _^(docList);
            // Only for map documents
            if (MEM_ReadInt(l.data) == oCViewDocumentMap__vtbl[IDX_EXE]) {
                Patch_ItemMap_Toggle(l.data, !Patch_ItemMap_State);
            };
            docList = l.next;
        end;
    };
};
