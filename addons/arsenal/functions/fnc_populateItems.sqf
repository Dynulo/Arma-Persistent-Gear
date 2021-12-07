#include "script_component.hpp"

private _add = [];

{
	if ([player, _x select 1 select 1] call FUNC(item_canUse)) then {
		private _dlc = getAssetDLCInfo [_x select 0, configFile >> "CfgWeapons"];
		if (_dlc#0) then {
			if (_dlc#1 && _dlc#2) then {
				_add pushBack (_x select 0);
			};
		} else {
			_add pushBack (_x select 0);
		};
	};
} forEach EGVAR(db,items);

GVAR(arsenalItems) = _add;
