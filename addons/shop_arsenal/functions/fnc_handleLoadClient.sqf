#include "script_component.hpp"

["ace_arsenal_displayOpened", FUNC(arsenal_DisplayOpened)] call CBA_fnc_addEventHandler;
["ace_arsenal_displayClosed", FUNC(arsenal_DisplayClosed)] call CBA_fnc_addEventHandler;
["ace_arsenal_leftPanelFilled", FUNC(arsenal_LeftPanelFilled)] call CBA_fnc_addEventHandler;
["ace_arsenal_rightPanelFilled", FUNC(arsenal_RightPanelFilled)] call CBA_fnc_addEventHandler;
["ace_arsenal_loadoutsListFilled", FUNC(arsenal_LoadoutsListFilled)] call CBA_fnc_addEventHandler;

// Price stat
[[[0,1,2,3,4,5,6,7,8,9,10,11], [0,1,2,3,4,5,6,7]], QGVAR(price), [], "Price", [false, true], [{}, {
	params ["_statsArray", "_itemCfg"];
	private _path = (str _itemCfg) splitString "/";
	[_path select ((count _path) - 1)] call EFUNC(shop,item_price)
}, {true}]] call ACE_arsenal_fnc_addStat;

// Owned stat
[[[0,1,2,3,4,5,6,7,8,9,10,11], [0,1,2,3,4,5,6,7]], QGVAR(locker), [], "Owned", [false, true], [{}, {
	params ["_statsArray", "_itemCfg"];
	private _path = (str _itemCfg) splitString "/";
	[_path select ((count _path) - 1)] call EFUNC(locker,owned)
}, {true}]] call ACE_arsenal_fnc_addStat;

[{
	call FUNC(create_actions);
}] call CBA_fnc_execNextFrame;
