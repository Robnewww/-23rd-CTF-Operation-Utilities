/*
    ITR_fnc_zeusDialogOpen

    Runs on client; opens the Incoming Transmission dialog
*/

disableSerialization;

// Only open if the client is Zeus
if (isNull getAssignedCuratorLogic player) exitWith {};

// Only proceed if the Zeus interface is currently open
if (isNull findDisplay 312) exitWith {};

createDialog "ITR_RscTransmissionDialog";