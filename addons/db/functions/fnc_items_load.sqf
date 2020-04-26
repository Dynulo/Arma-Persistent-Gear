#include "script_component.hpp"

params ["_items"];

private _add = [];

GVAR(items) = [];

{
	GVAR(items) pushBack [_x select 0, [_x select 1, _x select 2]];
} forEach (parseSimpleArray _items);

publicVariable QGVAR(items);

[QEGVAR(arsenal,populateItems)] call CBA_fnc_globalEvent;
