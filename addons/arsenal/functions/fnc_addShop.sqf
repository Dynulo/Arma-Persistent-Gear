#include "script_component.hpp"

params ["_object"];

[EXT, ["get_balance", [getplayerUID player]]] remoteExec ["callExtension", REMOTE_SERVER];

[{
	params ["_args", "_handle"];
	_args params ["_object"];

	// Checks
	if (player getVariable [QGVAR(balance), 0] == 0) exitWith {};

	// Open Shop
	[_handle] call CBA_fnc_removePerFrameHandler;
	[_object, GVAR(arsenalItems), false] call ace_arsenal_fnc_initBox;
	[_object, player] call ace_arsenal_fnc_openBox;
	[_object, false] call ace_arsenal_fnc_removeBox;
}, 0.1, [_object]] call CBA_fnc_addPerFrameHandler;
