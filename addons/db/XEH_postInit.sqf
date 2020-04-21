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
		["ACE_hasEarPlugsin"] call FUNC(variable_track);

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
	player enableSimulation false;
	player setVariable [QGVAR(loadoutReady), false, true];

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
	}, [], 8] call CBA_fnc_waitAndExecute;
	[EXT, ["get_loadout", [getplayerUID player]]] remoteExec ["callExtension", REMOTE_SERVER];
	[EXT, ["get_variables", [getplayerUID player]]] remoteExec ["callExtension", REMOTE_SERVER];
}, {}, 1] call CBA_fnc_waitAndExecute;
