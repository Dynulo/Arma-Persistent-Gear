#include "script_component.hpp"

REQUIRE_PMC;
NO_HC;

[{
	// Server side only
	if (isServer) then {
		[QEGVAR(arsenal,balance)] call FUNC(variable_track);
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

		INFO("setup complete");
	};

	systemChat "PMC Persistent System Loading";
	player enableSimulation false;
	player setVariable [QGVAR(loadoutReady), false, true];

	[{
		// Save the loadout every time it changes
		["loadout", FUNC(loadout_onChange)] call CBA_fnc_addPlayerEventHandler;

		// Track Variables
		[{
			{
				private _new = player getVariable [_x, objNull];
				private _old = GVAR(oldVars) getVariable [_x, objNull];
				if !(_new isEqualTo _old) then {
					[getPlayerUID player, _x, _new] remoteExec [QFUNC(variable_save), REMOTE_SERVER];
					call EFUNC(arsenal,populateItems);
				};
				GVAR(oldVars) setVariable [_x, _new];
			} forEach GVAR(tracked);
		}, 1] call CBA_fnc_addPerFrameHandler;

		// Init locker
		private _locker = player getVariable [QEGVAR(arsenal,locker), ""];
		EGVAR(arsenal,locker) = call CBA_fnc_createNamespace;
		{
			private _data = _x splitString ":";
			EGVAR(arsenal,locker) setVariable [_data select 0, parseNumber (_data select 1)];
		} forEach (_locker splitString "|");

		player setVariable [QGVAR(loadoutReady), true, true];
		player enableSimulation true;
		systemChat "PMC Persistent System Ready";
	}, [], 6] call CBA_fnc_waitAndExecute;
	
	[EXT, ["get_loadout", [getplayerUID player]]] remoteExec ["callExtension", REMOTE_SERVER];
	[EXT, ["get_variables", [getplayerUID player]]] remoteExec ["callExtension", REMOTE_SERVER];
	[EXT, ["set_nickname", [getplayerUID player, name player]]] remoteExec ["callExtension", REMOTE_SERVER];
}, {}, 1] call CBA_fnc_waitAndExecute;
