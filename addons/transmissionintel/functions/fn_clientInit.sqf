/*
    ITR_INT_fnc_clientInit

    Client-side initializer.

    Purpose:
      - Make intel actions reliable in MP + JIP without relying on remoteExec delivery.
      - The Eden module publishes a replicated list of intel-source object netIds.
      - Each client watches that list and adds the addAction locally when the object exists.

*/

if (!hasInterface) exitWith {};

if (isNil "ITR_INT_seenSources") then { ITR_INT_seenSources = createHashMap; };
if (isNil "ITR_INT_pendingSources") then { ITR_INT_pendingSources = createHashMap; };

ITR_INT_fnc_queueSourceNetIds = {
    params [["_netIds", [], [[]]]];

    {
        private _nid = _x;
        if (_nid isEqualTo "") then { continue; };

        // If already processed, skip
        if (ITR_INT_seenSources getOrDefault [_nid, false]) then { continue; };

        // Queue pending
        ITR_INT_pendingSources set [_nid, true];
    } forEach _netIds;
};

// PV updates
"ITR_INT_sourceNetIds" addPublicVariableEventHandler {
    params ["_varName", "_value"];
    [_value] call ITR_INT_fnc_queueSourceNetIds;
};

// JIP: queue whatever exists already
private _existing = missionNamespace getVariable ["ITR_INT_sourceNetIds", []];
[_existing] call ITR_INT_fnc_queueSourceNetIds;

// One scanner only
if (isNil "ITR_INT_pendingEH") then {
    ITR_INT_pendingEH = addMissionEventHandler ["EachFrame", {
        // throttle to ~2/sec
        private _next = missionNamespace getVariable ["ITR_INT_nextScan", 0];
        if (diag_tickTime < _next) exitWith {};
        missionNamespace setVariable ["ITR_INT_nextScan", diag_tickTime + 0.5];

        // Nothing pending
        if (isNil "ITR_INT_pendingSources") exitWith {};
        if ((count ITR_INT_pendingSources) == 0) exitWith {};

        // Copy keys to iterate safely
        private _keys = keys ITR_INT_pendingSources;

        {
            private _nid = _x;

            // If collected globally somehow, you could optionally stop tracking here
            // (we don't have a netId->collected map, so we just resolve when it exists)

            private _obj = objectFromNetId _nid;
            if (isNull _obj) then { continue; };

            // Mark as seen + unqueue
            ITR_INT_seenSources set [_nid, true];
            ITR_INT_pendingSources deleteAt _nid;

            // Add action (or re-add if needed)
            [_obj] call ITR_INT_fnc_addIntelAction;

        } forEach _keys;
    }];
};
