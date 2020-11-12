#include "script_component.hpp"

REQUIRE_PMC;

[QEGVAR(arsenal,locker)] call FUNC(variable_track);
["ace_medical_medicClass"] call FUNC(variable_track);
["ACE_IsEngineer"] call FUNC(variable_track);
["ACE_IsEOD"] call FUNC(variable_track);
["ACE_hasEarPlugsin"] call FUNC(variable_track);

// delete corpse
addMissionEventHandler ["HandleDisconnect", {
	params ["_unit", "_id", "_uid", "_name"];
	deleteVehicle _unit;
}];

[QGVAR(publish), {
	publicVariable QGVAR(items);
	[QEGVAR(arsenal,populateItems)] call CBA_fnc_globalEvent;
}] call CBA_fnc_addEventHandler;

INFO("setup complete");
