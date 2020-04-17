/*
 * Toggle the markers
 */
func void Ninja_ItemMap_Toggle(var int docPtr) {
    const int zCViewFX__Open_G1  = 7684256; //0x7540A0
    const int zCViewFX__Open_G2  = 6884320; //0x690BE0
    const int zCViewFX__Close_G1 = 7684464; //0x754170
    const int zCViewFX__Close_G2 = 6884528; //0x690CB0

    // Toggle visibility
    Ninja_ItemMap_State = !Ninja_ItemMap_State;

    // Iterate over view children and show/hide them
    var int arrViewPtr; arrViewPtr = docPtr+252; // oCViewDocumentMap.arrowView
    var int mapViewPtr; mapViewPtr = MEM_ReadInt(docPtr+504); // oCViewDocumentMap.mapView
    var int list; list = MEM_ReadInt(mapViewPtr+MEMINT_SwitchG1G2(22, 88)); // zCViewObject.childList
    while(list);
        var zCListSort l; l = _^(list);
        if (l.data) {
            var int viewPtr; viewPtr = l.data; // zCViewObject*
            if (viewPtr != arrViewPtr) {
                var int zero;
                if (!Ninja_ItemMap_State) {
                    const int call = 0;
                    if (CALL_Begin(call)) {
                        CALL__fastcall(_@(viewPtr), _@(zero), MEMINT_SwitchG1G2(zCViewFX__Open_G1, zCViewFX__Open_G2));
                        call = CALL_End();
                    };
                } else {
                    const int call2 = 0;
                    if (CALL_Begin(call2)) {
                        CALL__fastcall(_@(viewPtr), _@(zero), MEMINT_SwitchG1G2(zCViewFX__Close_G1,
                                                                                zCViewFX__Close_G2));
                        call2 = CALL_End();
                    };
                };
            };
        };
        list = l.next;
    end;
};

/*
 * Check if a key binding is pressed
 */
func int Ninja_ItemMap_KeyBinding(var int keyBinding, var int keyStroke) {
    const int zCInput__IsBinded_G1 = 4993104; //0x4C3050
    const int zCInput__IsBinded_G2 = 5030768; //0x4CC370

    var int zptr; zptr = MEM_ReadInt(zCInput_zinput);
    const int call = 0;
    if (CALL_Begin(call)) {
        CALL_IntParam(_@(keyStroke));
        CALL_IntParam(_@(keyBinding));
        CALL_PutRetValTo(_@(ret));
        CALL__thiscall(_@(zptr), MEMINT_SwitchG1G2(zCInput__IsBinded_G1, zCInput__IsBinded_G2));
        call = CALL_End();
    };

    var int ret;
    return +ret;
};

/*
 * Handle key additional presses
 */
func void Ninja_ItemMap_HandleEvent() {
    if (Ninja_ItemMap_KeyBinding(/*zOPT_GAMEKEY_WEAPON*/8, ESI)) {
        // Iterate over the list of documents
        var int docList; docList = MEM_ReadInt(MEM_ReadInt(ECX+4)+8); // oCDocumentManager.docList.next
        while(docList);
            var zCListSort l; l = _^(docList);
            Ninja_ItemMap_Toggle(l.data);
            docList = l.next;
        end;
    };
};
