#include "script_component.hpp"

REQUIRE_PMC;
NO_HC;

// TODO why was this made a network variable?
player setVariable [QGVAR(inArsenal), false, true];

// Handle arsenal synced variables
[QGVAR(syncedVars), {
	[GVAR(locker)] call CBA_fnc_deleteNamespace;
	GVAR(locker) = call CBA_fnc_createNamespace;
	{
		GVAR(locker) setVariable [_x select 0, _x select 1];
	} forEach (player getVariable [QGVAR(locker), []]);

	// Refresh Arsenals
	private _items = call FUNC(items_populate);
	{
		[_x, true, false] call ace_arsenal_fnc_removeVirtualItems;
		[_x, _items] call ace_arsenal_fnc_initBox;
	} forEach GVAR(boxes);
}] call CBA_fnc_addEventHandler;


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
