/*
    ITR_OP_fn_zeusPingDialogOpen

    Runs on client; opens the Objective Ping dialog
*/

params [["_pos", [0,0,0], [[]]]];
disableSerialization;
if (!hasInterface) exitWith {};

// Only open if the client is Zeus
if (isNull getAssignedCuratorLogic player) exitWith {};

// Only proceed if the Zeus interface is currently open
if (isNull findDisplay 312) exitWith {};

// Prevent stacking multiple dialogs on the Zeus client
if (uiNamespace getVariable ["ITR_OP_ZeusPingDialogOpen", false]) exitWith {};

uiNamespace setVariable ["ITR_OP_ZeusPingDialogOpen", true];

// Store ping position where your dialog “Send” logic can read it
missionNamespace setVariable ["ITR_OP_ZeusPingPos", _pos];

// If one is already open for any reason, close it first
if (dialog) then { closeDialog 0; };

private _ok = createDialog "ITR_OP_RscObjectivePingDialog";
if (!_ok) exitWith {
    uiNamespace setVariable ["ITR_OP_ZeusPingDialogOpen", false];
};

// Clear the guard when the dialog closes
[] spawn {
    waitUntil { !dialog };
    uiNamespace setVariable ["ITR_OP_ZeusPingDialogOpen", false];
};