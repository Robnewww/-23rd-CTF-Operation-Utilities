/*
    ITR_OP_fn_worldPingShow

    Example call:
    [[x,y,z], "LABEL", duration, iconPath, colorRGBA] call ITR_OP_fnc_worldPingShow;
*/

//Exit if interface 
if (!hasInterface) exitWith {};

// Default parameters
params [
    ["_pos", [0,0,0], [[]]],
    ["_text", "OBJECTIVE", [""]],
    ["_duration", 8, [0,""]],
    ["_icon", "\A3\ui_f\data\map\markers\military\objective_CA.paa", [""]],
    ["_color", [1,0.7,0,1], [[]]]
];

//Parse duration
_duration = if (_duration isEqualType 0) then {_duration} else { parseNumber _duration };
if (_duration <= 0) exitWith {};   // or: _duration = 8;

// Snap to terrain using AGL/ATL, then add 0.5m height
private _x = _pos select 0;
private _y = _pos select 1;
private _posAGL = [_x, _y, 0.5];

if (isNil "ITR_OP_worldPings") then {
    ITR_OP_worldPings = [];
};

if (isNil "ITR_OP_worldPingEH") then {
    ITR_OP_worldPingEH = addMissionEventHandler ["Draw3D", {
        for "_i" from (count ITR_OP_worldPings - 1) to 0 step -1 do {
            private _ping = ITR_OP_worldPings select _i;
            // Ping parameters
            _ping params ["_posAGL", "_text", "_startTime", "_duration", "_icon", "_baseColor"];

            private _elapsed = time - _startTime;
            if (_elapsed >= _duration) then {
                ITR_OP_worldPings deleteAt _i;
            } else {
                private _t = _elapsed / _duration;
                if (_t < 0) then {_t = 0};
                if (_t > 1) then {_t = 1};

                // Set up fade
                private _fadeFrac = 0.05;  // 5% fade in and out
                private _alphaBase = if (count _baseColor > 3) then {_baseColor select 3} else {1};
                private _alpha = _alphaBase;

                if (_t < _fadeFrac) then {
                    _alpha = _alphaBase * (_t / _fadeFrac); // fade in
                } else {
                    if (_t > (1 - _fadeFrac)) then {
                        _alpha = _alphaBase * ((1 - _t) / _fadeFrac); // fade out
                    };
                };

                private _drawColor = +_baseColor;
                if (count _drawColor < 4) then {_drawColor set [3,1]};
                _drawColor set [3, _alpha];

                // Draw ping icon
                drawIcon3D [
                    _icon,
                    _drawColor,
                    _posAGL,
                    1.5,
                    1.5,
                    0,
                    _text,
                    2,
                    0.035,
                    "PuristaMedium",
                    "center",
                    false
                ];
            };
        };

        if (ITR_OP_worldPings isEqualTo []) then {
            removeMissionEventHandler ["Draw3D", ITR_OP_worldPingEH];
            ITR_OP_worldPingEH = nil;
        };
    }];
};

ITR_OP_worldPings pushBack [_posAGL, _text, time, _duration, _icon, _color];