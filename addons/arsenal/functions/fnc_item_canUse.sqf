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
		// TODO custom traits
	};
} forEach _traits;

_ret
