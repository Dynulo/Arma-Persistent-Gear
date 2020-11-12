#include "script_component.hpp"

params ["_items"];

if (GVAR(pendingPurchase)) exitWith {};
if (EGVAR(main,readOnly)) exitWith {};

private _cost = 0;

private _purchase = [];

{
	private _owned = [_x] call FUNC(locker_quantity);
	// (desired) - (already owned)
	private _need = (_items getVariable [_x, 0]) - _owned;
	if (_need > 0) then {
		private _price = [_x] call FUNC(item_price);
		_cost = _cost + (_price * _need);
		_purchase pushBack [_x, _price, _need];
	};
} forEach allVariables _items;

GVAR(pendingPurchase) = true;
GVAR(pendingPurchaseSuccessHandle) = [QGVAR(purchase_success), {
	[QGVAR(purchase_success), GVAR(pendingPurchaseSuccessHandle)] call CBA_fnc_removeEventHandler;
	[QGVAR(purchase_failed), GVAR(pendingPurchaseFailedHandle)] call CBA_fnc_removeEventHandler;
	[EXT, ["get_balance", [getplayerUID player]]] remoteExec ["callExtension", REMOTE_SERVER];
	_thisArgs params ["_purchase"];
	{
		_x params ["_class", "", "_need"];
		private _owned = [_class] call FUNC(locker_quantity);
		GVAR(locker) setVariable [_class, _owned + _need];
	} forEach _purchase;
	["ace_arsenal_leftPanelFilled", [findDisplay 1127001]] call CBA_fnc_localEvent;
	["ace_arsenal_rightPanelFilled", [findDisplay 1127001]] call CBA_fnc_localEvent;
	GVAR(pendingPurchase) = false;
	call FUNC(locker_save);
	systemChat "Purchase Complete!";
}, [_purchase]] call CBA_fnc_addEventHandlerArgs;
GVAR(pendingPurchaseFailedHandle) = [QGVAR(purchase_failed), {
	[QGVAR(purchase_success), GVAR(pendingPurchaseSuccessHandle)] call CBA_fnc_removeEventHandler;
	[QGVAR(purchase_failed),GVAR(pendingPurchaseFailedHandle)] call CBA_fnc_removeEventHandler;
	GVAR(pendingPurchase) = false;
	systemChat "Purchase Failed";
}] call CBA_fnc_addEventHandler;

[EXT, ["purchase", [getPlayerUID player, str _purchase]]] remoteExec ["callExtension", REMOTE_SERVER];
systemChat str _purchase;
