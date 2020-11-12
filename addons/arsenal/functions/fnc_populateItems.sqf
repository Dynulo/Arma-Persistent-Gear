#include "script_component.hpp"

private _add = [];

{
	if ([player, _x select 1 select 1] call FUNC(item_canUse)) then {
		_add pushBack (_x select 0);
	};
} forEach EGVAR(db,items);

GVAR(arsenalItems) = _add;
