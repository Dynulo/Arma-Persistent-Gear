#include "script_component.hpp"

params ["_items"];

private _invalid = [];

{
	private _need = (_items getOrDefault [_x, 0]) - ([_x] call FUNC(locker_quantity));
	if (_need > 0) then {
		if (([_x] call FUNC(item_price)) == -1) exitWith {
			_invalid pushBack _x;
		};
	};
} forEach keys _items;

_invalid
