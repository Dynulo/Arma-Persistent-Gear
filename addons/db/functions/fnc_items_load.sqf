#include "script_component.hpp"

params ["_items"];

private _add = [];

GVAR(items) = [];

{
	GVAR(items) pushBack [_x select 0, [_x select 1, _x select 2]];
	_add pushBack (_x select 0);
} forEach (parseSimpleArray _items);

publicVariable QGVAR(items);

// Refresh Arsenals
{
	[_x, true, false] call ace_arsenal_fnc_removeVirtualItems;
	[_x, _add] call ace_arsenal_fnc_initBox;
} forEach EGVAR(arsenal,boxes);
