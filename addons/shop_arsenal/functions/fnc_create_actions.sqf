#include "script_component.hpp"

private _action = [QGVAR(shop), "Shop", "", {
	[_target] call FUNC(open);
}, {
	EGVAR(shop,items) isNotEqualTo []
}] call ace_interact_menu_fnc_createAction;

{
	if !(_x getVariable [QGVAR(has_action), false]) then {
		[_x, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
		_x setVariable [QGVAR(has_action), true];
	};
} forEach GVAR(shops);
