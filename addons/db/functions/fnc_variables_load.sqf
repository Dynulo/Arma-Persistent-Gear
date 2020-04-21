#include "script_component.hpp"

params ["_steam", "_vars"];

private _player = _steam call EFUNC(common,findFromSteam);

{
	_player setVariable [_x select 0, _x select 1, true];
} forEach _vars;
