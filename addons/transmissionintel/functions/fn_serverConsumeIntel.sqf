/*
    ITR_INT_fnc_serverConsumeIntel
    Runs on server only. Immediately hides and deletes the intel object.
*/
params ["_obj"];
if (!isServer) exitWith {};
if (isNull _obj) exitWith {};

_obj hideObjectGlobal true;
_obj enableSimulationGlobal false;

// Small delay helps avoid edge cases where the object is still referenced this frame
[_obj] spawn {
    params ["_obj"];
    uiSleep 0.1;
    if (!isNull _obj) then { deleteVehicle _obj; };
};
