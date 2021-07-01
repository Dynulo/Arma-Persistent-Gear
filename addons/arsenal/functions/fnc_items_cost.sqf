#include "script_component.hpp"

/// Global Mode
/// 0 - Include only non global
/// 1 - Include only global
/// 2 - Include all items
params ["_items", ["_globalMode", 2]];

private _cost = 0;

{
	// (desired) - (already owned)
	private _need = (_items getOrDefault [_x, 0]) - ([_x] call FUNC(locker_quantity));
	if (_need > 0) then {
		if (
			_globalMode == 2 || { _globalMode == (parseNumber ([_x] call FUNC(item_global))) }
		) then {
			private _price = [_x] call FUNC(item_price);
			_cost = _cost + (_price * _need);
		};
	};
} forEach keys _items;

_cost
