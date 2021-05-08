#include "script_component.hpp"

params ["_object"];

if (EGVAR(main,readOnly)) exitWith {
	[_object, GVAR(arsenalItems), false] call ace_arsenal_fnc_initBox;
	[_object, player] call ace_arsenal_fnc_openBox;
	[_object, false] call ace_arsenal_fnc_removeBox;
};

if (GVAR(pendingOpenShop)) exitWith {};
GVAR(pendingOpenShop) = true;

// Blur screen
GVAR(shopBlurHandle) = ppEffectCreate ["DynamicBlur", 800];
GVAR(shopBlurHandle) ppEffectEnable true;
GVAR(shopBlurHandle) ppEffectAdjust [8];
GVAR(shopBlurHandle) ppEffectCommit 0.5;

// Store existing items
GVAR(pendingLockerStoreSuccessHandle) = [QGVAR(locker_store_success), {
	[QGVAR(locker_store_success), GVAR(pendingLockerStoreSuccessHandle)] call CBA_fnc_removeEventHandler;
	[QGVAR(locker_store_failed), GVAR(pendingLockerStoreFailedHandle)] call CBA_fnc_removeEventHandler;
	[EXT, ["balance_get", [getplayerUID player]]] remoteExec ["callExtension", REMOTE_SERVER];
	[EXT, ["locker_get", [getplayerUID player]]] remoteExec ["callExtension", REMOTE_SERVER];
}] call CBA_fnc_addEventHandlerArgs;
GVAR(pendingLockerStoreFailedHandle) = [QGVAR(locker_store_failed), {
	[QGVAR(locker_store_success), GVAR(pendingLockerStoreSuccessHandle)] call CBA_fnc_removeEventHandler;
	[QGVAR(locker_store_failed),GVAR(pendingLockerStoreFailedHandle)] call CBA_fnc_removeEventHandler;
	systemChat "Failed to store inventory in the locker";
	GVAR(pendingOpenShop) = false;
	GVAR(shopBlurHandle) ppEffectEnable false;
	ppEffectDestroy GVAR(shopBlurHandle);
}] call CBA_fnc_addEventHandler;

private _items = (getUnitLoadout player) call FUNC(items_list);
[_items] call FUNC(locker_store);

[{
	params ["_args", "_handle"];
	_args params ["_object"];

	// Checks
	if (player getVariable [QGVAR(balance), 0] == 0) exitWith {};
	if (count (player getVariable [QGVAR(locker), createHashMap]) == 0) exitWith {};

	// Open Shop
	[_handle] call CBA_fnc_removePerFrameHandler;
	private _items = +GVAR(arsenalItems);
	_items append (keys (player getVariable [QGVAR(locker), createHashMap]));
	_items = _items - ["ItemRadioAcreFlagged"];
	[_object, _items, false] call ace_arsenal_fnc_initBox;
	[_object, player] call ace_arsenal_fnc_openBox;
	[_object, false] call ace_arsenal_fnc_removeBox;

	GVAR(shopBlurHandle) ppEffectAdjust [0];
	GVAR(shopBlurHandle) ppEffectCommit 0.5;
	[{
		GVAR(shopBlurHandle) ppEffectEnable false;
		ppEffectDestroy GVAR(shopBlurHandle);
	}, [], 1] call CBA_fnc_waitAndExecute;
	GVAR(pendingOpenShop) = false;
}, 0.1, [_object]] call CBA_fnc_addPerFrameHandler;
