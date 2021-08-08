#include "script_component.hpp"

if (EGVAR(main,readOnly)) exitWith {};
if !(GVAR(inShop)) exitWith {};

[GVAR(balanceHandle)] call CBA_fnc_removePerFrameHandler;
[GVAR(rightPanelColor)] call CBA_fnc_removePerFrameHandler;

private _items = (getUnitLoadout player) call FUNC(items_list);
private _cost = [_items] call FUNC(items_cost);

// Player did not pay for their items
if !(_cost == 0) then {
	// Take carried items
	player setUnitLoadout [GVAR(preLoadout), false];
	_items = (getUnitLoadout player) call FUNC(items_list);
};

[_items] call FUNC(locker_take);

GVAR(pendingLockerTakeSuccessHandle) = [QGVAR(locker_take_success), {
	[QGVAR(locker_store_success), GVAR(pendingLockerTakeSuccessHandle)] call CBA_fnc_removeEventHandler;
	[QGVAR(locker_store_failed), GVAR(pendingLockerTakeFailedHandle)] call CBA_fnc_removeEventHandler;
	if !(EGVAR(main,readOnly)) then {
		[player, getUnitLoadout player] call EFUNC(db,loadout_onChange);
	};
}] call CBA_fnc_addEventHandlerArgs;
GVAR(pendingLockerTakeFailedHandle) = [QGVAR(locker_take_failed), {
	[QGVAR(locker_store_success), GVAR(pendingLockerTakeSuccessHandle)] call CBA_fnc_removeEventHandler;
	[QGVAR(locker_store_failed),GVAR(pendingLockerTakeFailedHandle)] call CBA_fnc_removeEventHandler;
	systemChat "Failed to take items from the locker";
	player setUnitLoadout BLANK_LOADOUT;
	if !(EGVAR(main,readOnly)) then {
		[player, getUnitLoadout player] call EFUNC(db,loadout_onChange);
	};
}] call CBA_fnc_addEventHandler;

player setVariable [QGVAR(inArsenal), false, true];
player setVariable [QGVAR(balance), -1];
player setVariable [QGVAR(locker), createHashMap];

GVAR(inShop = false);
