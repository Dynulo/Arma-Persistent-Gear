#include "script_component.hpp"

params ["_items"];

private _cost = 0;

{
	private _owned = [_x] call FUNC(locker_quantity);
	// (desired) - (already owned)
	private _need = (_items getVariable [_x, 0]) - _owned;
	if (_need > 0) then {
		private _price = [_x] call FUNC(item_price);
		_cost = _cost + (_price * _need);
		GVAR(locker) setVariable [_x, _owned + _need];
		private _balance = player getVariable [QGVAR(balance), 2000];
		_balance = _balance - (_price * _need);
		player setVariable [QGVAR(balance), _balance, true];
	};
} forEach allVariables _items;

// TODO
[player, getPlayerUID player] call FUNC(db_push);

_cost
