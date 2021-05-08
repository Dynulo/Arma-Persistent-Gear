#include "script_component.hpp"

REQUIRE_PMC;
NO_HC;

if (isServer) then {
	publicVariable QGVAR(boxes);
};
if (isDedicated) exitWith {};

[QGVAR(locker_publish), {
	params ["_map"];
	player setVariable [QGVAR(locker), _map];
}] call CBA_fnc_addEventHandler;

// Init Arsenal Option
private _action = [QGVAR(shop), "Shop", "", {
	[_target] call FUNC(addShop);
}, {
	GVAR(arsenalItems) isNotEqualTo []
}] call ace_interact_menu_fnc_createAction;
{
	[_x, 0, ["ACE_MainActions"], _action] call ace_interact_menu_fnc_addActionToObject;
} forEach GVAR(boxes);

player setVariable [QGVAR(inArsenal), false, true];

// Handle ACE Arsenal Events
["ace_arsenal_displayOpened", FUNC(handleDisplayOpened)] call CBA_fnc_addEventHandler;
["ace_arsenal_displayClosed", FUNC(handleDisplayClosed)] call CBA_fnc_addEventHandler;
["ace_arsenal_leftPanelFilled", FUNC(handleLeftPanelFilled)] call CBA_fnc_addEventHandler;
["ace_arsenal_rightPanelFilled", FUNC(handleRightPanelFilled)] call CBA_fnc_addEventHandler;

// Init ACE Stats

// Price stat
[[[0,1,2,3,4,5,6,7,8,9,10,11], [0,1,2,3,4,5,6,7]], QGVAR(price), [], "Price", [false, true], [{}, {
	params ["_statsArray", "_itemCfg"];
	private _path = (str _itemCfg) splitString "/";
	[_path select ((count _path) - 1)] call FUNC(item_price)
}, {true}]] call ACE_arsenal_fnc_addStat;

// Owned stat
[[[0,1,2,3,4,5,6,7,8,9,10,11], [0,1,2,3,4,5,6,7]], QGVAR(locker), [], "Owned", [false, true], [{}, {
	params ["_statsArray", "_itemCfg"];
	private _path = (str _itemCfg) splitString "/";
	[_path select ((count _path) - 1)] call FUNC(locker_quantity)
}, {true}]] call ACE_arsenal_fnc_addStat;

[QGVAR(populateItems), FUNC(populateItems)] call CBA_fnc_addEventHandler;
