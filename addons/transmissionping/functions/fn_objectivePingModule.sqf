/*
    ITR_OP_fn_objectivePingModule
*/

// 3DEN parameters
params ["_logic", "_units", "_activated"];
if (!_activated) exitWith {};

// Run only once fix
if (!local _logic) exitWith {};

// Set module variables
private _pos = getPosATL _logic;
private _title = _logic getVariable ["Title", ""];
private _subtitle = _logic getVariable ["Subtitle", ""];
private _label = _logic getVariable ["Label", ""];
private _bannerDuration = parseNumber str (_logic getVariable ["BannerDuration", 6]);
private _pingDuration = parseNumber str (_logic getVariable ["PingDuration", 10]);
private _iconIndex = (parseNumber str (_logic getVariable ["IconType", 0]));
private _colorIndex = (parsenumber str (_logic getVariable ["ColorType", 0]));
private _playRadio = _logic getVariable ["PlayRadio", false];

// If world ping is unlabeled/left empty, use banner title for ping
if (_label isEqualTo "" && !(_title isEqualTo "")) then {
    _label = _title;
};

// Vanilla icon paths
private _iconPaths = [
    "\A3\ui_f\data\map\markers\military\objective_CA.paa",
    "\A3\ui_f\data\map\markers\military\flag_CA.paa",
    "\A3\ui_f\data\map\markers\military\destroy_CA.paa",
    "\A3\ui_f\data\map\markers\military\pickup_CA.paa",
    "\A3\ui_f\data\map\markers\military\unknown_CA.paa",
    "\A3\ui_f\data\map\markers\military\warning_CA.paa",
    "\A3\ui_f\data\map\markers\military\support_CA.paa",
    "\A3\ui_f\data\map\markers\military\join_CA.paa"
];

// Set colors
private _colors = [
    [1, 0.7, 0, 1],
    [1, 1, 1, 1],
    [0, 1, 0, 1],
    [1, 0, 0, 1],
    [0, 0.6, 1, 1],
    [1, 1, 0, 1],
    [0, 1, 1, 1],
    [0.7, 0, 1, 1]
];

private _icon = _iconPaths param [_iconIndex, _iconPaths select 0];
private _color = _colors param [_colorIndex, _colors select 0];

// Set and send ping
if !(_title isEqualTo "" && _subtitle isEqualTo "") then {
    [_title, _subtitle, _bannerDuration, _color] remoteExec ["ITR_OP_fnc_overlayPingShow", 0, false];
};
[_pos, _label, _pingDuration, _icon, _color] remoteExecCall ["ITR_OP_fnc_worldPingShow", 0, false];

// If radio chatter ticked, play radio sounds
if (_playRadio) then {
    ["RadioAmbient2"] remoteExec ["playSound", 0, false];
};

deleteVehicle _logic;
