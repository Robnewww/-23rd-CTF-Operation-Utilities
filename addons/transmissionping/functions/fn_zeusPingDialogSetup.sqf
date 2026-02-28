/*
    ITR_OP_fn_zeusPingDialogSetup

    Runs when the Objective Ping dialog opens, sets defaults and fills icon/color lists
*/

disableSerialization;
params ["_display"];

uiNamespace setVariable ["ITR_OP_RscObjectivePingDialog", _display];

// Default values
(_display displayCtrl 9101) ctrlSetText "OBJECTIVE UPDATE"; // Banner title
(_display displayCtrl 9102) ctrlSetText "Advance and secure the objective."; // Banner text
(_display displayCtrl 9103) ctrlSetText "NEW OBJECTIVE"; // World ping title
(_display displayCtrl 9104) ctrlSetText "6";   // Banner duration
(_display displayCtrl 9105) ctrlSetText "10";  // Ping duration

// Icons
private _iconCombo = _display displayCtrl 9110;
lbClear _iconCombo;
{
    _iconCombo lbAdd _x;
} forEach [
    "Objective", // 0
    "Flag",      // 1
    "Destroy",   // 2
    "Pickup",    // 3
    "Unknown",   // 4
    "Warning",   // 5
    "Support",   // 6
    "Join"       // 7
];
_iconCombo lbSetCurSel 0;

// Colors
private _colorCombo = _display displayCtrl 9111;
lbClear _colorCombo;
{
    _colorCombo lbAdd _x;
} forEach [
    "Orange / Gold", // 0
    "White",         // 1
    "Green",         // 2
    "Red",           // 3
    "Blue",          // 4
    "Yellow",        // 5
    "Cyan",          // 6
    "Purple"         // 7
];
_colorCombo lbSetCurSel 0;

// Radio sounds checkbox
(_display displayCtrl 9120) cbSetChecked false;