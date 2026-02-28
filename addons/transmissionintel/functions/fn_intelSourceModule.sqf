/*
    ITR_INT_fnc_intelSourceModule

    Eden module: sync to one or more objects.

    MP/JIP reliability strategy:
      - Store intel data on the synced object (public).
      - Publish the object's netId into missionNamespace variable ITR_INT_sourceNetIds.
      - Clients (via ITR_INT_fnc_clientInit) watch that list and add the addAction locally.
*/

params ["_logic", "_units", "_activated"];
if (!_activated) exitWith {};
if (!isServer) exitWith {};
if (!local _logic) exitWith {};

// Get variables
private _cardTitle    = _logic getVariable ["CardTitle", ""];
private _cardSummary  = _logic getVariable ["CardSummary", ""];
private _priority     = _logic getVariable ["IntelPriority", 0];
private _colorIndex   = _logic getVariable ["ColorType", 0];
private _duration     = _logic getVariable ["Duration", 10];
private _actionLabel  = _logic getVariable ["ActionLabel", ""];
private _removeObject = _logic getVariable ["RemoveObject", true];
private _showGlobal   = _logic getVariable ["ShowGlobal", true];
private _soundClass   = _logic getVariable ["SoundClass", ""];
private _diarySubject = _logic getVariable ["DiarySubject", ""];
private _diaryTitle   = _logic getVariable ["DiaryTitle", ""];
private _diaryText    = _logic getVariable ["DiaryText", ""];

// Sensible fallbacks
if (_actionLabel isEqualTo "") then { _actionLabel = "Collect Intel"; };
if (_diarySubject isEqualTo "") then { _diarySubject = "Intel"; };
if (_diaryTitle isEqualTo "") then { _diaryTitle = _cardTitle; };

private _targets = synchronizedObjects _logic;
if (_targets isEqualTo []) exitWith {
    diag_log "[ITR_INT] IntelSourceModule has no synced objects.";
    deleteVehicle _logic;
};

private _list = missionNamespace getVariable ["ITR_INT_sourceNetIds", []];

{
    private _obj = _x;
    if (isNull _obj) then { continue };

    private _data = [
        _cardTitle,
        _cardSummary,
        _priority,
        _duration,
        _removeObject,
        _showGlobal,
        _soundClass,
        _colorIndex,
        _diarySubject,
        _diaryTitle,
        _diaryText
    ];

    _obj setVariable ["ITR_INT_data", _data, true];
    _obj setVariable ["ITR_INT_actionLabel", _actionLabel, true];

    private _nid = netId _obj;
    if !(_nid isEqualTo "") then { _list pushBackUnique _nid; };

} forEach _targets;

// Publish for MP + JIP
missionNamespace setVariable ["ITR_INT_sourceNetIds", _list, true];
publicVariable "ITR_INT_sourceNetIds";

deleteVehicle _logic;