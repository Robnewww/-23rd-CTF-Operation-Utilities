/*
    ITR_fnc_zeusDialogCommit

    Reads UI fields from ITR_RscTransmissionDialog and broadcasts information to all clients.
*/

private _display = uiNamespace getVariable ["ITR_RscTransmissionDialog", displayNull];
if (isNull _display) exitWith {};

// Set private variables
private _ctrlPortrait = _display displayCtrl 9001;
private _ctrlSpeaker  = _display displayCtrl 9002;
private _ctrlText  = _display displayCtrl 9003;
private _ctrlSound = _display displayCtrl 9004;
private _ctrlDuration = _display displayCtrl 9005;
private _ctrlStyle = _display displayCtrl 9006;
private _ctrlSpeakerSize = _display displayCtrl 9007;
private _ctrlTextSize = _display displayCtrl 9008;
private _ctrlDelay = _display displayCtrl 9009;

private _portrait = ctrlText _ctrlPortrait;
private _speaker = ctrlText _ctrlSpeaker;
private _text = ctrlText _ctrlText;
private _sound = ctrlText _ctrlSound;
private _duration = parseNumber (ctrlText _ctrlDuration);
private _speakerSize = parseNumber (ctrlText _ctrlSpeakerSize);
private _textSize = parseNumber (ctrlText _ctrlTextSize);
private _delay = parseNumber (ctrlText _ctrlDelay);

// Style mapping
private _styleIndex = lbCurSel _ctrlStyle;
if (_styleIndex < 0) then { _styleIndex = 0; };

private _style = switch (_styleIndex) do {
    case 1: { "command" };
    case 2: { "warning" };
    case 3: { "enemy"   };
    case 4: { "system"  };
    default { "default" };
};

// Defaults for my sanity
if (_duration <= 0) then { _duration = 6; };
if (_speakerSize <= 0) then { _speakerSize = 1.1; };
if (_textSize <= 0) then { _textSize = 1.0; };
if (_delay <  0) then { _delay = 0; };

// Require some text or else exit
if (_text isEqualTo "") exitWith {
    hint "Incoming Transmission: No text provided";
};

// Broadcast to all clients
[
    _portrait,
    _speaker,
    _text,
    _sound,
    _duration,
    _style,
    _speakerSize,
    _textSize,
    _delay
] remoteExec ["ITR_fnc_transmission", 0, false];

closeDialog 0;