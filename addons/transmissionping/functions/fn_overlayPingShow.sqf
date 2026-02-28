/*
    ITR_OP_fn_overlayPingShow

    Example call:
    [_title, _subtitle, _duration, _color] call ITR_OP_fnc_overlayPingShow;
*/

//Exit if interface 
if (!hasInterface) exitWith {};
if (!canSuspend) exitWith { _this spawn ITR_OP_fnc_overlayPingShow; };

//Default parameters
params [
    ["_title", "", [""]],
    ["_subtitle", "", [""]],
    ["_duration", 4, [0,""]],
    ["_accentColor", [1,0.7,0,1], [[]]]
];

//Parse duration
_duration = if (_duration isEqualType 0) then {_duration} else { parseNumber _duration };
if (_duration < 0) then { _duration = 0; };

// If title and text are empty, exit
if (_title isEqualTo "" && _subtitle isEqualTo "") exitWith {};

private _token = (uiNamespace getVariable ["ITR_OP_OverlayToken", 0]) + 1;
uiNamespace setVariable ["ITR_OP_OverlayToken", _token];

// Show RscTitle
"ITR_OverlayPing" cutRsc ["ITR_OverlayPing", "PLAIN"];

private _display = uiNamespace getVariable ["ITR_OverlayPing_Display", displayNull];
if (isNull _display) exitWith {};

private _bg = _display displayCtrl 9000;
private _accent = _display displayCtrl 9001;
private _titleC = _display displayCtrl 9002;
private _subC = _display displayCtrl 9003;

// Accent and heading color
_accent ctrlSetBackgroundColor _accentColor;
_titleC ctrlSetTextColor _accentColor;

// Set text
_titleC ctrlSetText _title;
_subC ctrlSetStructuredText (parseText _subtitle);

// Dimensions
private _safeX = safeZoneX;
private _safeW = safeZoneW;
private _safeY = safeZoneY;
private _safeH = safeZoneH;

private _centerX = _safeX + _safeW * 0.5;
private _bgY = _safeY + _safeH * 0.10;
private _accentWidth = _safeW * 0.005;
private _padding = _safeW * 0.01;

private _titleWidth = ctrlTextWidth _titleC;
private _subWidth   = if (_subtitle isEqualTo "") then {0} else {ctrlTextWidth _subC};
private _contentWidth = _titleWidth max _subWidth;

// Clamp max width
private _minWidth = _safeW * 0.20;
private _maxWidth = _safeW * 0.60;
private _bannerWidth = _contentWidth + (2 * _padding);
if (_bannerWidth < _minWidth) then {_bannerWidth = _minWidth};
if (_bannerWidth > _maxWidth) then {_bannerWidth = _maxWidth};

private _bgX = _centerX - (_bannerWidth / 2);
private _accentX = _bgX;
private _textX = _bgX + _accentWidth + (_safeW * 0.005);
private _textW = _bannerWidth - _accentWidth - (_safeW * 0.01);

// Default layout (Title and text)
private _bgHeight  = _safeH * 0.08;
private _titleY = _bgY + _safeH * 0.002;
private _titleH = _safeH * 0.03;
private _subY = _bgY + _safeH * 0.035;
private _subH = _safeH * 0.035;

// One-line mode (Title only)
if (_subtitle isEqualTo "") then {
    _bgHeight = _safeH * 0.05;
    _titleY   = _bgY + _safeH * 0.01;
    _titleH   = _safeH * 0.03;
    _subH = 0;
    _subC ctrlShow false;
} else {
    _subC ctrlShow true;
};

// Apply positions
_bg ctrlSetPosition [_bgX, _bgY, _bannerWidth, _bgHeight];
_accent ctrlSetPosition [_accentX, _bgY, _accentWidth, _bgHeight];
_titleC ctrlSetPosition [_textX, _titleY, _textW, _titleH];
_subC ctrlSetPosition [_textX, _subY, _textW, _subH];

{
    _x ctrlCommit 0;
} forEach [_bg, _accent, _titleC, _subC];

// Fade banner in, hold on screen for duration then fade out
{
    _x ctrlSetFade 1;
    _x ctrlCommit 0;
} forEach [_bg, _accent, _titleC, _subC];

{
    _x ctrlSetFade 0;
    _x ctrlCommit 0.5;
} forEach [_bg, _accent, _titleC, _subC];

uiSleep (_duration max 0);

{
    _x ctrlSetFade 1;
    _x ctrlCommit 1.5;
} forEach [_bg, _accent, _titleC, _subC];

uiSleep 1.6;

if ((uiNamespace getVariable ["ITR_OP_OverlayToken", 0]) == _token) then {
    "ITR_OverlayPing" cutText ["", "PLAIN"];
};