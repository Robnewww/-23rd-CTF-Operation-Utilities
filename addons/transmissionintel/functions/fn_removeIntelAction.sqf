/*
    ITR_INT_fnc_removeIntelAction
*/

params ["_obj"];
if (!hasInterface) exitWith {};
if (isNull _obj) exitWith {};

private _id = _obj getVariable ["ITR_INT_actionId", -1];
if (_id != -1) then {
    _obj removeAction _id;
    _obj setVariable ["ITR_INT_actionId", -1];
};