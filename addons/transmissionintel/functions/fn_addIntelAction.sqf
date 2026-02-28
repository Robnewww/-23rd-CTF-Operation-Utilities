/*
    ITR_INT_fnc_addIntelAction

    Adds the mod interaction to a given intel object.
*/

params ["_obj"];
if (!hasInterface) exitWith {};
if (isNull _obj) exitWith {};

[_obj] spawn {
    params ["_obj"];

    // If already collected globally, don't add an action
    if (_obj getVariable ["ITR_INT_collected", false]) exitWith {};

    // If we've already added our action on this client, bail
    if ((_obj getVariable ["ITR_INT_actionId", -1]) != -1) exitWith {};

    // Persistent stripping of BI intel actions until collected
    [_obj] spawn {
        params ["_obj"];

        while { !isNull _obj && { !(_obj getVariable ["ITR_INT_collected", false]) } } do {
            private _ourId = _obj getVariable ["ITR_INT_actionId", -1];

            {
                private _id = _x;
                if (_id == _ourId) then { continue };

                private _p = _obj actionParams _id;
                private _title = toLower (_p param [0, ""]);
                private _stmtS = toLower (str (_p param [1, ""]));

                private _looksLikeBIIntel =
                    (_title find "take intel" >= 0) ||
                    (_title find "intel" >= 0 && { _title find "collect intel" < 0 }) ||
                    (_stmtS find "initintelobject" >= 0) ||
                    (_stmtS find "curatoraddintel" >= 0);

                if (_looksLikeBIIntel) then {
                    _obj removeAction _id;
                };
            } forEach (actionIDs _obj);

            uiSleep 0.5;
        };
    };

    // Read custom action label
    private _label = _obj getVariable ["ITR_INT_actionLabel", "Collect Intel"];
    if (_label isEqualTo "") then { _label = "Collect Intel"; };
    private _actionText = format ["<t color='#FFCC66'>%1</t>", _label];

    private _actionId = _obj addAction [
        _actionText,
        {
            params ["_target", "_caller", "_actionId", "_args"];

            private _data = _target getVariable ["ITR_INT_data", []];
            if (_data isEqualTo []) exitWith {};

            _data params [
                "_cardTitle",
                "_cardSummary",
                "_priority",
                "_duration",
                "_removeObject",
                "_showGlobal",
                "_soundClass",
                "_colorIndex",
                "_diarySubject",
                "_diaryTitle",
                "_diaryText"
            ];

            // Mark collected globally so everyone’s condition hides it
            _target setVariable ["ITR_INT_collected", true, true];

            // Remove action locally for the caller immediately
            _target removeAction _actionId;
            _target setVariable ["ITR_INT_actionId", -1];

            // Remove the action on all clients
            if (isMultiplayer) then {
                [_target] remoteExec ["ITR_INT_fnc_removeIntelAction", -2, false];
            };

            // Instant local feedback + server authoritative delete
            if (_removeObject) then {
                if (isMultiplayer) then {
                    _target hideObject true;
                    _target enableSimulation false;
                    [_target] remoteExecCall ["ITR_INT_fnc_serverConsumeIntel", 2];
                } else {
                    deleteVehicle _target;
                };
            };

            // Show intel card
            if (_showGlobal) then {
                if (isMultiplayer) then {
                    [_cardTitle, _cardSummary, _priority, _duration, _soundClass, _colorIndex]
                        remoteExec ["ITR_INT_fnc_showIntelCard", -2, false];
                } else {
                    [_cardTitle, _cardSummary, _priority, _duration, _soundClass, _colorIndex]
                        spawn ITR_INT_fnc_showIntelCard;
                };
            } else {
                if (isMultiplayer) then {
                    [_cardTitle, _cardSummary, _priority, _duration, _soundClass, _colorIndex]
                        remoteExec ["ITR_INT_fnc_showIntelCard", _caller, false];
                } else {
                    [_cardTitle, _cardSummary, _priority, _duration, _soundClass, _colorIndex]
                        spawn ITR_INT_fnc_showIntelCard;
                };
            };

            // Diary record
            if !(_diaryText isEqualTo "") then {
                [_diarySubject, _diaryTitle, _diaryText] call ITR_INT_fnc_addDiaryRecord;

                if (_showGlobal && { isMultiplayer }) then {
                    private _others = allPlayers select { _x != _caller };
                    [_diarySubject, _diaryTitle, _diaryText]
                        remoteExec ["ITR_INT_fnc_addDiaryRecord", _others, false];
                };
            };
        },
        [],
        10,     // priority
        true,   // showWindow
        true,   // hideOnUse
        "",     // shortcut
        "!(_target getVariable ['ITR_INT_collected', false])",
        5,      // radius
        false,  // unconscious
        ""      // selection
    ];

    _obj setVariable ["ITR_INT_actionId", _actionId]; // local only
};