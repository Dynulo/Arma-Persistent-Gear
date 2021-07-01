#include "script_component.hpp"

params ["_class", "_price", "_traits", "_global"];

GVAR(items) pushBack [_class, [_price, _traits, _global]];

{
	if (_x isEqualTo "") exitWith {};
	if !(_x in ["medic", "eod", "engineer"]) then {
		[format ["pmc_traits_%1", _x]] call FUNC(variable_track);
	};
} forEach (_traits);
