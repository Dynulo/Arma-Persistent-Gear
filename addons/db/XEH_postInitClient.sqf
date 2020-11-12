#include "script_component.hpp"

REQUIRE_PMC;
NO_HC;

[{!isNull player}, {
	[QGVAR(publish)] call CBA_fnc_serverEvent;

	systemChat "PMC Persistent System Loading";
	player enableSimulation false;
	player setVariable [QGVAR(loadoutReady), false, true];

	if !(EGVAR(main,readOnly)) then {
		[{
			// Save the loadout every time it changes
			["loadout", FUNC(loadout_onChange)] call CBA_fnc_addPlayerEventHandler;
			// Track Variables
			[{
				{
					private _new = player getVariable [_x, objNull];
					private _old = GVAR(oldVars) getVariable [_x, objNull];
					if !(_new isEqualTo _old) then {
						if !(EGVAR(main,readOnly)) then {
							[getPlayerUID player, _x, _new] remoteExec [QFUNC(variable_save), REMOTE_SERVER];
						};
						call EFUNC(arsenal,populateItems);
					};
					GVAR(oldVars) setVariable [_x, _new];
				} forEach GVAR(tracked);
			}, 1] call CBA_fnc_addPerFrameHandler;
			systemChat "PMC Persistent System Tracking";
		}, [], 6] call CBA_fnc_waitAndExecute;
	} else {
		systemChat "PMC Persistent System Read-Only Mode";
	};

	player enableSimulation true;
	
	[EXT, ["get_loadout", [getplayerUID player]]] remoteExec ["callExtension", REMOTE_SERVER];
	[EXT, ["get_variables", [getplayerUID player]]] remoteExec ["callExtension", REMOTE_SERVER];
	if !(EGVAR(main,readOnly)) then {
		[EXT, ["set_nickname", [getplayerUID player, name player]]] remoteExec ["callExtension", REMOTE_SERVER];
	};
}] call CBA_fnc_waitUntilAndExecute;

[QGVAR(set_variable), {
	params ["_key", "_val"];
	GVAR(oldVars) setVariable [_key, _val];
	player setVariable [_key, _val, true];

	if (_key isEqualTo "ACE_hasEarPlugsin") then {
		[[true]] call ace_hearing_fnc_updateVolume;
		[] call ace_hearing_fnc_updateHearingProtection;
	};
	if (_key isEqualTo QEGVAR(arsenal,locker)) then {
		EGVAR(arsenal,locker) = call CBA_fnc_createNamespace;
		{
			_x splitString ":" params ["_class", "_quantity"];
			if !(_class isEqualTo "itemradioacreflagged") then {
				EGVAR(arsenal,locker) setVariable [_class, parseNumber (_quantity)];
			};
		} forEach (_val splitString "|");
	};

	call EFUNC(arsenal,populateItems);
}] call CBA_fnc_addEventHandler;
