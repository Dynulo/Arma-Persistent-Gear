#include "script_component.hpp"

params ["_items"];

private _ret = [];

{
	// (desired) - (already owned)
	private _need = (_items getOrDefault [_x, 0]) - ([_x] call FUNC(locker_quantity));
	if (_need > 0) then {
		private _price = [_x] call FUNC(item_price);
		private _global = [_x] call FUNC(item_global);
		_ret pushBack [_x, _price, _need, _price * _need, _global]
	};
} forEach keys _items;

_ret
