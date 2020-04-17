/*
 * Toggle the markers
 */
func void Ninja_ItemMap_Toggle(var int docPtr) {
    const int zCViewFX__OpenSafe_G1  = 7684304; //0x7540D0
    const int zCViewFX__OpenSafe_G2  = 6884368; //0x690C10
    const int zCViewFX__CloseSafe_G1 = 7684528; //0x7541B0
    const int zCViewFX__CloseSafe_G2 = 6884608; //0x690D00

    // Toggle visibility
    Ninja_ItemMap_State = !Ninja_ItemMap_State;

    // Iterate over view children and show/hide them
    var int arrViewPtr; arrViewPtr = docPtr+252; // oCViewDocumentMap.arrowView
    var int mapViewPtr; mapViewPtr = MEM_ReadInt(docPtr+504); // oCViewDocumentMap.mapView
    var int list; list = MEM_ReadInt(mapViewPtr+88); // zCViewObject.childList
    while(list);
        var zCListSort l; l = _^(list);
        if (l.data) {
            var int viewPtr; viewPtr = l.data; // zCViewObject*
            if (viewPtr != arrViewPtr) {
                var int zero;
                if (!Ninja_ItemMap_State) {
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
    if (Ninja_ItemMap_KeyBindingIsToggled(/*zOPT_GAMEKEY_WEAPON*/8, ESI)) {
        // Iterate over the list of documents
        var int docList; docList = MEM_ReadInt(MEM_ReadInt(ECX+4)+8); // oCDocumentManager.docList.next
        while(docList);
            var zCListSort l; l = _^(docList);
            Ninja_ItemMap_Toggle(l.data);
            docList = l.next;
        end;
    };
};
