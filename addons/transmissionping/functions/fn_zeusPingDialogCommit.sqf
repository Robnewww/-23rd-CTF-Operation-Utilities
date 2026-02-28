/*
    ITR_OP_fn_zeusPingDialogCommit

    Executes the Zeus dialog once send ping is clicked
*/

disableSerialization;

private _disp = uiNamespace getVariable ["ITR_OP_RscObjectivePingDialog", displayNull];
if (isNull _disp) exitWith {};

private _title = ctrlText (_disp displayCtrl 9101);
private _subtitle = ctrlText (_disp displayCtrl 9102);
private _label = ctrlText (_disp displayCtrl 9103);
private _bannerDuration = parseNumber (trim (ctrlText (_disp displayCtrl 9104)));
private _pingDuration   = parseNumber (trim (ctrlText (_disp displayCtrl 9105)));
private _iconIndex = lbCurSel (_disp displayCtrl 9110);
private _colorIndex = lbCurSel (_disp displayCtrl 9111);
private _playRadio = cbChecked (_disp displayCtrl 9120);

//Sanity clamps
if (_bannerDuration <= 0) then {_bannerDuration = 6};
if (_pingDuration <= 0) then {_pingDuration = 10};
if (_label isEqualTo "" && !(_title isEqualTo "")) then {_label = _title};

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

// If ping position doesn't save, default to player location to prevent breaking shit
private _pos = if (isNil "ITR_OP_ZeusPingPos") then {getPosATL player} else {ITR_OP_ZeusPingPos};

// Set and send ping
if !(_title isEqualTo "" && _subtitle isEqualTo "") then {
    [_title, _subtitle, _bannerDuration, _color] remoteExec ["ITR_OP_fnc_overlayPingShow", 0, false];
};
[_pos, _label, _pingDuration, _icon, _color] remoteExec ["ITR_OP_fnc_worldPingShow", 0, false];

// If radio chatter ticked, play radio sounds 
if (_playRadio) then {
    ["RadioAmbient2"] remoteExec ["playSound", 0, false];
};

closeDialog 0;