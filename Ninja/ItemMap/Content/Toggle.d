/*
 * Toggle the markers
 */
func void Ninja_ItemMap_Toggle(var int docPtr, var int turnOn) {
    const int zCViewFX__OpenSafe_G1                = 7684304; //0x7540D0
    const int zCViewFX__OpenSafe_G2                = 6884368; //0x690C10
    const int zCViewFX__CloseSafe_G1               = 7684528; //0x7541B0
    const int zCViewFX__CloseSafe_G2               = 6884608; //0x690D00
    const int oCViewDocumentMap__UpdatePosition_G1 = 7495728; //0x726030
    const int oCViewDocumentMap__UpdatePosition_G2 = 6870960; //0x68D7B0

    // Iterate over view children and show/hide them
    var int arrViewPtr; arrViewPtr = docPtr+252; // oCViewDocumentMap.arrowView
    var int mapViewPtr; mapViewPtr = MEM_ReadInt(docPtr+504); // oCViewDocumentMap.mapView
    var int list; list = MEM_ReadInt(mapViewPtr+88); // zCViewObject.childList
    var int zero;
    var int any; any = FALSE;
    while(list);
        var zCListSort l; l = _^(list);
        if (l.data) {
            var int viewPtr; viewPtr = l.data; // zCViewObject*
            if (viewPtr != arrViewPtr) {
                any = TRUE;

                if (turnOn) {
                    const int call = 0;
                    if (CALL_Begin(call)) {
                        CALL__fastcall(_@(viewPtr), _@(zero), MEMINT_SwitchG1G2(zCViewFX__OpenSafe_G1,
                                                                                zCViewFX__OpenSafe_G2));
                        call = CALL_End();
                    };
                } else {
                    const int call2 = 0;
                    if (CALL_Begin(call2)) {
                        CALL__fastcall(_@(viewPtr), _@(zero), MEMINT_SwitchG1G2(zCViewFX__CloseSafe_G1,
                                                                                zCViewFX__CloseSafe_G2));
                        call2 = CALL_End();
                    };
                };
            };
        };
        list = l.next;
    end;

    // If the items/containers were not added yet
    if ((!any) && (turnOn)) {
        // Account for incorrect player position marker shift (set to zero again)
        MEM_WriteInt(arrViewPtr+64, 0); // zCViewObject.sizepixel[0]
        MEM_WriteInt(arrViewPtr+68, 0); // zCViewObject.sizepixel[1]

        // Update/place the document markers
        const int call3 = 0;
        if (CALL_Begin(call3)) {
            CALL__fastcall(_@(docPtr), _@(zero), MEMINT_SwitchG1G2(oCViewDocumentMap__UpdatePosition_G1,
                                                                   oCViewDocumentMap__UpdatePosition_G2));
            call3 = CALL_End();
        };
    };
};

/*
 * Check if a key binding is toggled (== pressed once)
 * This approach is more safe than using Ikarus' MEM_KeyState as it does not interfere with any other scripts
 */
func int Ninja_ItemMap_KeyBindingIsToggled(var int keyBinding, var int keyStroke) {
    const int zCInput__IsBinded_G1         = 4993104; //0x4C3050
    const int zCInput_Win32__GetToggled_G1 = 5015088; //0x4C8630
    const int zCInput__IsBindedToggled_G2  = 5031024; //0x4CC470

    var int zptr; zptr = MEM_ReadInt(zCInput_zinput);
    const int call = 0;
    if (CALL_Begin(call)) {
        if (GOTHIC_BASE_VERSION == 1) {
            // Emulating Gothic 2's zCInput::IsBindedToggled
            CALL_IntParam(_@(keyStroke));
            CALL_IntParam(_@(keyBinding));
            CALL_PutRetValTo(_@(ret));
            CALL__thiscall(_@(zptr), zCInput__IsBinded_G1);

            CALL_IntParam(_@(keyBinding));
            CALL_PutRetValTo(_@(ret2));
            CALL__thiscall(_@(zptr), zCInput_Win32__GetToggled_G1);
        } else {
            CALL_IntParam(_@(keyStroke));
            CALL_IntParam(_@(keyBinding));
            CALL_PutRetValTo(_@(ret));
            CALL__thiscall(_@(zptr), zCInput__IsBindedToggled_G2);
        };
        call = CALL_End();
    };

    var int ret;
    var int ret2;
    return +MEMINT_SwitchG1G2(ret && ret2, ret);
};

/*
 * Handle key additional presses
 */
func void Ninja_ItemMap_HandleEvent() {
    const int oCViewDocumentMap__vtbl_G1 = 8254556; //0x7DF45C
    const int oCViewDocumentMap__vtbl_G2 = 8633036; //0x83BACC

    if (Ninja_ItemMap_KeyBindingIsToggled(/*zOPT_GAMEKEY_WEAPON*/8, ESI)) {
        // Toggle visibility
        Ninja_ItemMap_State = !Ninja_ItemMap_State;

        // Iterate over the list of documents
        var int docList; docList = MEM_ReadInt(MEM_ReadInt(ECX+4)+8); // oCDocumentManager.docList.next
        while(docList);
            var zCListSort l; l = _^(docList);
            // Only for map documents
            if (MEM_ReadInt(l.data) == MEMINT_SwitchG1G2(oCViewDocumentMap__vtbl_G1, oCViewDocumentMap__vtbl_G2)) {
                Ninja_ItemMap_Toggle(l.data, !Ninja_ItemMap_State);
            };
            docList = l.next;
        end;
    };
};
