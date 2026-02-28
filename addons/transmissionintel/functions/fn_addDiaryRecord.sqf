/*
    ITR_INT_fnc_addDiaryRecord

    Local client helper: creates a diary subject (tab) if missing, then writes a record.

    Params:
    0: STRING - Diary entry subject
    1: STRING - Diary entry title
    2: STRING - Diary entry text body
*/

params [
    ["_subject", "", [""]],
    ["_title", "", [""]],
    ["_docText", "", [""]]
];

if (!hasInterface) exitWith {};
if (isNull player) exitWith {};
if (_docText isEqualTo "") exitWith {};

if (_subject isEqualTo "") then { _subject = "Intel"; };
if (_title isEqualTo "") then { _title = "Recovered Document"; };

// Ensure subject exists
if !(_subject in (allDiarySubjects player)) then {
    player createDiarySubject [_subject, _subject];
};

player createDiaryRecord [_subject, [_title, _docText]];
