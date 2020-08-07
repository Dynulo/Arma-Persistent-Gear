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
		private _balance = player getVariable [QGVAR(balance), 3000];
		_balance = _balance - (_price * _need);
		if !(EGVAR(main,readOnly)) then {
			[EXT, ["purchase", [getPlayerUID player, _x, _price, _need]]] remoteExec ["callExtension", REMOTE_SERVER];
		};
		player setVariable [QGVAR(balance), _balance, true];
	};
} forEach allVariables _items;

_cost
