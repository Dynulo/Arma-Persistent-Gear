#include "script_component.hpp"

params ["_items"];

{
	GVAR(locker) setVariable [_x,
		// owned - (# to take)
		([_x] call FUNC(locker_quantity)) - (_items getVariable [_x, 0])
	];
} forEach allVariables _items;
