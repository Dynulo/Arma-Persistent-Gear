#include "script_component.hpp"

params ["_unit", "_traits"];

if (_traits isEqualTo [""]) exitWith { true };

private _ret = false;

{
	if (_ret) exitWith { true };
	switch (_x) do {
		case "medic": {
			_ret = [_unit] call ace_common_fnc_isMedic;
		};
		case "engineer": {
			_ret = [_unit] call ace_common_fnc_isEngineer;
		};
		case "eod": {
			_ret = [_unit] call ace_common_fnc_isEOD;
		};
		default {
			_ret = _unit getVariable [format ["pmc_traits_%1", _x], false];
		};
		// TODO custom traits
	};
} forEach _traits;

_ret
