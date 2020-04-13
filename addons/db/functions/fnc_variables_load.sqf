#include "script_component.hpp"

params ["_steam", "_vars"];



{
	_player setVariable [_x select 0, _x select 1, true];
} forEach parseSimpleArray (_vars);
[QEGVAR(common,syncedVars), [], _player] call CBA_fnc_targetEvent;
