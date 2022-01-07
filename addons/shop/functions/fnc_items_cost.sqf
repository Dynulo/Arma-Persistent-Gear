#include "script_component.hpp"

/// Global Mode
/// 0 - Include only non global
/// 1 - Include only global
/// 2 - Include all items
params ["_items", ["_globalMode", 2]];

private _cost = 0;

{
	// (desired) - (already owned)
	private _need = _y - ([_x] call EFUNC(locker,owned));
	if (_need > 0) then {
		private _class = [_x] call EFUNC(shop,item_listing);
		if (
			_globalMode == 2 || { _globalMode == (parseNumber ([_class, false] call FUNC(item_global))) }
		) then {
			private _price = [_class, false] call FUNC(item_price);
			_cost = _cost + (_price * _need);
		};
	};
} forEach _items;

_cost
