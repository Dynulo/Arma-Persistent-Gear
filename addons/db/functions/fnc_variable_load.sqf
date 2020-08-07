#include "script_component.hpp"

params ["_steam", "_key", "_val"];

private _player = _steam call EFUNC(common,findFromSteam);

if !(_key isEqualTo "pmc_arsenal_locker") then {
	private _num = _val call BIS_fnc_parseNumber;
	if (typeName _num isEqualTo "BOOL") then {
		_val = _num;
	} else {
		if (_num > -1) then {
			_val = _num;
		};
	};
};

[QGVAR(set_variable), [_key, _val], _player] call CBA_fnc_targetEvent;
