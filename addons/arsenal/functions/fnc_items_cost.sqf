#include "script_component.hpp"

params ["_items"];

private _cost = 0;

{
	// (desired) - (already owned)
	private _need = (_items getVariable [_x, 0]) - ([_x] call FUNC(locker_quantity));
	if (_need > 0) then {
		private _price = [_x] call FUNC(item_price);
		_cost = _cost + (_price * _need);
	};
} forEach allVariables _items;

_cost
