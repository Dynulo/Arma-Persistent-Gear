#include "script_component.hpp"

REQUIRE_PMC;
NO_HC;

[{
	// Server side only
	if (isServer) then {
		[QGVAR(balance)] call FUNC(variable_track);
		[QGVAR(locker)] call FUNC(variable_track);
		["ace_medical_medicClass"] call FUNC(variable_track);

		// delete corpse
		addMissionEventHandler ["HandleDisconnect", {
			params ["_unit", "_id", "_uid", "_name"];
			[_unit, _uid, _name] call FUNC(db_savePlayer);
			_unit spawn {
				sleep 3;
				deleteVehicle _this;
			};
		}];

		INFO("setup complete");
	};

	systemChat "Enabling PMC Persistent System";

	// [{time > 60 && !(isNull player)}, {
	// 	[{
	// 		[0, {
	// 			if !(_this getVariable [QGVAR(ignore), false]) then {
	// 				if !(_this getVariable [QGVAR(inArsenal), false]) then {
	// 					[_this, getPlayerUID _this] call FUNC(db_savePlayer);
	// 				};
	// 			};
	// 		}, player] call CBA_fnc_globalExecute;
	// 	}, 30] call CBA_fnc_addPerFrameHandler;
	// }] call CBA_fnc_waitUntilAndExecute;

	// Save the loadout every time it changes
	["loadout", FUNC(loadout_onChange)] call CBA_fnc_addPlayerEventHandler;
}, {}, 1] call CBA_fnc_waitAndExecute;
