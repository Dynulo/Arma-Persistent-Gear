#include "script_component.hpp"

private _add = [];

{
	if ([player, _x select 1 select 1] call FUNC(item_canUse)) then {
		_add pushBack (_x select 0);
	};
} forEach EGVAR(db,items);

// Refresh Arsenals
{
	[_x, true, false] call ace_arsenal_fnc_removeVirtualItems;
	[_x, _add] call ace_arsenal_fnc_initBox;
} forEach GVAR(boxes);
