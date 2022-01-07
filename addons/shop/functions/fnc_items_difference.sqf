#include "script_component.hpp"

params ["_items"];

private _ret = [];

{
	// (desired) - (already owned)
	private _need = _y - ([_x] call EFUNC(locker,owned));
	if (_need > 0) then {
		private _class = [_x] call EFUNC(shop,item_listing);
		private _price = [_class, false] call FUNC(item_price);
		private _global = [_class, false] call FUNC(item_global);
		_ret pushBack [_x, _price, _need, _price * _need, _global]
	};
} forEach _items;

_ret
