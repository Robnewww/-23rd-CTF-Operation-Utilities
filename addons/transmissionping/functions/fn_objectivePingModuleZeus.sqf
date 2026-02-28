/*
    ITR_OP_fn_objectivePingModuleZeus

    Called when the Zeus module is placed.
*/

params ["_logic", "_units", "_activated"];
if (!_activated) exitWith {};
if (!local _logic) exitWith {};

private _pos = getPosATL _logic;
[_pos] remoteExec ["ITR_OP_fnc_zeusPingDialogOpen", 0, false];

deleteVehicle _logic;