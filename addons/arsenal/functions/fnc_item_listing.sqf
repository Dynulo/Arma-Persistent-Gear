#include "script_component.hpp"

params ["_class"];

private _ret = _class;

// Check for shop listing
private _shopClass = _class call FUNC(item_get);
if !(_shopClass isEqualTo []) exitWith {
	_class
};

// Handles CBA disposable rockets
private _launcherCheck = (tolower _class) splitString "_";
if (count _launcherCheck > 0) then {
	if ((_launcherCheck select (count _launcherCheck - 1)) isEqualTo "loaded") then {
		_launcherCheck deleteAt (count _launcherCheck - 1);
		_launcherCheck = _launcherCheck joinString "_";
		private _shopClass = _launcherCheck call FUNC(item_get);
		if !(_shopClass isEqualTo []) then {
			_ret = _launcherCheck;
		};
	};
};

// Check for non-pip
private _parents = [configFile >> "CfgWeapons" >> _class, true] call BIS_fnc_returnParents;
if (count _parents > 2) then {
	private _shopClass = (_parents select 1) call FUNC(item_get);
	if !(_shopClass isEqualTo []) then {
		_ret = (_parents select 1);
	};
};

// Check for MRT next scope
private _nextClass = configFile >> "CfgWeapons" >> _class >> "MRT_SwitchItemNextClass";
if (isText (_nextClass)) then {
	private _next = getText _nextClass;
	private _shopClass = _next call FUNC(item_get);
	if !(_shopClass isEqualTo []) then {
		_ret = _next;
	};
};

_ret
