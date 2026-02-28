/*
    ITR_fnc_transmissionModuleZeus

    Called when the Zeus module is placed.
    Opens the dialog on all machines because I'm lazy, zeusDialogOpen will then limit it to the Zeus
*/

params ["_logic", "_units", "_activated"];

// Send out client-side helper to all machines
[] remoteExec ["ITR_fnc_zeusDialogOpen", 0, false];

// Delete module afterwards to keep things clean
deleteVehicle _logic;