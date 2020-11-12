#include "script_component.hpp"

// Set locker
{
	private _class = toLower ([_x] call FUNC(item_listing));
	if !(_class isEqualTo _x) then {
		private _existing = GVAR(locker) getVariable [_x, 0];
		GVAR(locker) setVariable [_class, _existing + (GVAR(locker) getVariable [toLower _class, 0])];
		GVAR(locker) setVariable [_x, 0];
	};
} forEach allVariables GVAR(locker);
private _owned = "";
{
	private _quantity = GVAR(locker) getVariable [_x, 0];
	if (_quantity > 0) then {
		_owned = format ["%1|%2:%3", _owned, _x, _quantity];
	};
} forEach allVariables GVAR(locker);
player setVariable [QGVAR(locker), _owned, true];
