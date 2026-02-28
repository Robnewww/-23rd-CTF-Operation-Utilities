/*
    ITR_INT_fnc_showIntelCard

    Params:
    0: STRING - Card title
    1: STRING - Card summary OR "" for none
    2: NUMBER - Intel priority - 0 = primary, 2 = secondary, 3 = optional
    3: NUMBER - Duration in seconds (default 10)
    4: STRING - Sound class name (CfgSounds) OR "" for none
    5: NUMBER - Color index for accent. Use 0 through 7

    A test script call should look something like:
    ["NEW INTEL ACQUIRED", "Enemy recon team documents added", 0, 10, "", 0] call ITR_INT_fnc_showIntelCard;
*/

params [
    ["_title", "", [""]],
    ["_summary", "", [""]],
    ["_priority", 0, [0]],
    ["_duration", 10, [0]],
    ["_soundClass", "", [""]],
    ["_colorIndex", -1, [0]]
];

// Duration sanity clamp
if (_duration <= 0) then { _duration = 10 };

"ITR_IntelCard" cutRsc ["ITR_IntelCard", "PLAIN"];

private _display = uiNamespace getVariable ["ITR_IntelCard_Display", displayNull];
if (isNull _display) exitWith {};

private _bg = _display displayCtrl 9100;
private _accent = _display displayCtrl 9101;
private _titleC = _display displayCtrl 9102;
private _tagC = _display displayCtrl 9103;
private _textC = _display displayCtrl 9105;

// Set text
_titleC ctrlSetText _title;
_textC ctrlSetStructuredText parseText _summary;

// Priority tag text
private _tagText = "PRIMARY";
if (_priority == 1) then { _tagText = "SECONDARY" };
if (_priority == 2) then { _tagText = "OPTIONAL" };
_tagC ctrlSetText _tagText;

// Accent/title color array
private _colors = [
    [1, 0.7, 0, 1], // 0 - Orange / Gold
    [1, 1, 1, 1], // 1 - White
    [0, 1, 0, 1], // 2 - Green
    [1, 0, 0, 1], // 3 - Red
    [0, 0.6, 1, 1], // 4 - Blue
    [1, 1, 0, 1], // 5 - Yellow
    [0, 1, 1, 1], // 6 - Cyan
    [0.7, 0, 1, 1] // 7 - Purple
];

// Color sanity clamps, so many sanity clamps
if (_colorIndex < 0) then {
    _colorIndex = if (_priority > 0) then {4} else {0};
};

// Set color
private _accentColor = _colors param [_colorIndex, _colors select 0];

_accent ctrlSetBackgroundColor _accentColor;
_titleC ctrlSetTextColor _accentColor;

// Resize card
private _hasSummary = !(_summary isEqualTo "");

// Read positions
private _bgPos     = ctrlPosition _bg;
private _accentPos = ctrlPosition _accent;
private _textPos   = ctrlPosition _textC;

private _baseHeight    = safeZoneH * 0.08;
private _extraPadding  = safeZoneH * 0.02;
private _totalHeight   = _baseHeight;

if (_hasSummary) then {
    _textC ctrlShow true;

    private _txtHeight = ctrlTextHeight _textC;
    _textPos set [3, _txtHeight];
    _textC ctrlSetPosition _textPos;
    _textC ctrlCommit 0;

    _totalHeight = _baseHeight + _txtHeight + _extraPadding;
} else {
    _textC ctrlShow false;
};

// Update background and accent heights
_bgPos set [3, _totalHeight];
_bg ctrlSetPosition _bgPos;
_bg ctrlCommit 0;

_accentPos set [3, _totalHeight];
_accent ctrlSetPosition _accentPos;
_accent ctrlCommit 0;

// Fade in
{
    _x ctrlSetFade 1;
    _x ctrlCommit 0;
} forEach [_bg, _accent, _titleC, _tagC, _textC];

{
    _x ctrlSetFade 0;
    _x ctrlCommit 0.3;
} forEach [_bg, _accent, _titleC, _tagC, _textC];

// Play sound
if (_soundClass != "") then {
    playSound _soundClass;
} else {
    playSound "defaultNotification";
};

uiSleep _duration;

// Fade out
{
    _x ctrlSetFade 1;
    _x ctrlCommit 0.5;
} forEach [_bg, _accent, _titleC, _tagC, _textC];

uiSleep 0.6;

"ITR_IntelCard" cutText ["", "PLAIN"];