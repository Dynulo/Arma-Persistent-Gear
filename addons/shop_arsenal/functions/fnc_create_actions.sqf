#include "script_component.hpp"

private _action = [QGVAR(shop), "Shop", "", {
	[_target] call FUNC(open);
}, {
	EGVAR(shop,items) isNotEqualTo []
}] call ace_interact_menu_fnc_createAction;

{
	[_x, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
} forEach GVAR(shops);
