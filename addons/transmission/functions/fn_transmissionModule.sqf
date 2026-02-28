/*
    ITR_fnc_transmissionModule
*/

// Parameters for 3DEN module
private _logic = _this param [0, objNull, [objNull]];
private _units = _this param [1, [], [[]]];
private _activated = _this param [2, true, [true]];

// _activated may not be passed at all; treated as true by default for Zeus module
if (!_activated) exitWith {};

private _portrait = _logic getVariable ["portrait", ""];
private _speaker = _logic getVariable ["speaker", ""];
private _text = _logic getVariable ["text", ""];
private _sound = _logic getVariable ["sound", ""];
private _duration = _logic getVariable ["duration", 6];
private _styleIndex = _logic getVariable ["style", 0];
private _speakerSize = _logic getVariable ["speakerSize", 1.1];
private _textSize = _logic getVariable ["textSize", 1];
private _delayBefore = _logic getVariable ["delay", 0];

// Convert the style dropdown box back into a numerical value
private _style = switch (_styleIndex) do {
    case 1: { "command" };
    case 2: { "warning" };
    case 3: { "enemy" };
    case 4: { "system" };
    default { "default" };
};

// Require some text at a minimum, otherwise the failsafes kick in
if (_text isEqualTo "") exitWith {};

[
    _portrait,
    _speaker,
    _text,
    _sound,
    _duration,
    _style,
    _speakerSize,
    _textSize,
    _delayBefore
] remoteExec ["ITR_fnc_transmission", 0, false];