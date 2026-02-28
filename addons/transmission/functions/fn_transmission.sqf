/*
    ITR_fnc_transmission

    Params:
    0: STRING - Portrait image path (mission-relative) OR "" for none
    1: STRING - Speaker name OR "" for none
    2: STRING - Transmission text OR "" (will abort if everything is empty)
    3: STRING - Sound class name (CfgSounds) OR "" for none
    4: NUMBER - Duration in seconds (default 6)
    5: STRING - Style ("default","command","warning","enemy","system")
    6: NUMBER - Speaker font size (default 1.1)
    7: NUMBER - Text font size (default 1)
    8: NUMBER - Delay before showing (seconds, default 0)

    A test script call should look something like:
    ["", "", "Debug: Incoming Transmission works!", "", 5, "default", 1.1, 1, 0] spawn ITR_fnc_transmission;
*/

params [
    ["_portrait", "", [""]],
    ["_speaker", "", [""]],
    ["_text", "", [""]],
    ["_sound", "", [""]],
    ["_duration", 6, [0]],
    ["_style", "default", [""]],
    ["_speakerSize", 1.1, [0]],
    ["_textSize", 1, [0]],
    ["_delayBefore", 0, [0]]
];

// Sanity clamp (patent pending)
if (_speakerSize <= 0) then { _speakerSize = 1.1; };
if (_textSize <= 0) then { _textSize = 1; };
if (_delayBefore < 0) then { _delayBefore = 0; };

// Exit if there is nothing in portrait, speaker name AND text to prevent the module breaking
if (
    _portrait isEqualTo "" &&
    _speaker isEqualTo "" &&
    _text isEqualTo ""
) exitWith {};

// Delay before showing (Optional)
if (_delayBefore > 0) then {
    uiSleep _delayBefore;
};

private _display = findDisplay 46;
if (isNull _display) exitWith {};

// Style control, "default" uses these initial values
private _bgColor       = [0.06, 0, 0, 1];
private _speakerColor  = "#FFCC00";
private _textColor     = "#DBFFFF";

switch (toLower _style) do {
    case "command": {
        _bgColor      = [0, 0.08, 0.02, 1];
        _speakerColor = "#00FF88";
        _textColor    = "#CFEFD0";
    };
    case "system": {
        _bgColor      = [0, 0.02, 0.06, 1];
        _speakerColor = "#00E5FF";
        _textColor    = "#B3F3FF";
    };
    case "enemy": {
        _bgColor      = [0.04, 0, 0.06, 1];
        _speakerColor = "#FF3377";
        _textColor    = "#FFCCE6";
    };
    case "warning": {
        _bgColor      = [0.12, 0.01, 0, 1];
        _speakerColor = "#FF6600";
        _textColor    = "#FFD6B3";
    };
};

// Build the transmission based on what has been added
private _ITR = "";

// Portrait (Optional)
if !(_portrait isEqualTo "") then {
    _ITR = _ITR + format [
        "<img image='%1' size='4' color='#FFFFFF' shadow='0'></img>",
        _portrait
    ];
};

// Speaker name (Optional)
if (!(_speaker isEqualTo "") || !(_portrait isEqualTo "")) then {
    private _speakerPlaceholder = _speaker;
    if (_speakerPlaceholder isEqualTo "") then {
        _speakerPlaceholder = " "; // Keeps text out of speaker field
    };    

    _ITR = _ITR + format [
        "<t color='%1' size='%2' shadow='1'>  %3</t><br/><br/>",
        _speakerColor,
        _speakerSize,
        _speaker
    ];
};

// Text
if !(_text isEqualTo "") then {
    _ITR = _ITR + format [
        "<t color='%1' size='%2'>%3</t>",
        _textColor,
        _textSize,
        _text
    ];
};

// Failsafe if it gets this far without inputs/bad inputs to prevent breakage
if (_ITR isEqualTo "") exitWith { ctrlDelete _ctrl; };

// UI controls
disableSerialization;

private _baseX = safeZoneX + 0.012;
private _baseY = safeZoneY + 0.025;
private _width = 0.8;

// Inner padding between box edge and portrait/text
private _padX = 0.01;
private _padY = 0.02;

// Background box
private _bg = _display ctrlCreate ["RscText", -1];
_bg ctrlSetFade 1;
_bg ctrlSetBackgroundColor _bgColor;
_bg ctrlSetPosition [_baseX, _baseY, _width, 0.01]; // Temp height value
_bg ctrlCommit 0;

// Structured text
private _ctrl = _display ctrlCreate ["RscStructuredText", -1];
_ctrl ctrlSetFade 1;
_ctrl ctrlSetPosition [
    _baseX + _padX,
    _baseY + _padY,
    _width - (2 * _padX),
    0.01
];

// Build transmission
private _structured = parseText _ITR;
_ctrl ctrlSetStructuredText _structured;
_ctrl ctrlSetFont "EtelkaMonospacePro";
_ctrl ctrlCommit 0;

// Size the dialogue box to the text amount
private _textHeight   = ctrlTextHeight _ctrl;
private _neededHeight = _textHeight;

// Apply final position
_ctrl ctrlSetPosition [
    _baseX + _padX,
    _baseY + _padY,
    _width - (2 * _padX),
    _neededHeight
];
_ctrl ctrlCommit 0;

private _bgHeight = _neededHeight + (2 * _padY);
_bg ctrlSetPosition [_baseX, _baseY, _width, _bgHeight];
_bg ctrlCommit 0;

// Fade in effect
_bg ctrlSetFade 0;
_ctrl ctrlSetFade 0;
_bg ctrlCommit 0.5;
_ctrl ctrlCommit 0.5;

// Sound and duration
if !(_sound isEqualTo "") then {
    playSound _sound;
};

uiSleep _duration;

_bg ctrlSetFade 1;
_ctrl ctrlSetFade 1;
_bg ctrlCommit 0.7;
_ctrl ctrlCommit 0.7;
uiSleep 1;

ctrlDelete _ctrl;
ctrlDelete _bg;