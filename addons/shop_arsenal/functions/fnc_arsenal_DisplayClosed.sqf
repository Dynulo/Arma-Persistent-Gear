#include "script_component.hpp"

params ["_display"];

if (ace_player isNotEqualTo player) exitWith {};
if !(player getVariable [QGVAR(inShop), false]) exitWith {};

player setVariable [QGVAR(inShop), false];
player setVariable [QGVAR(inArsenal), false, true];

[GVAR(balanceHandle)] call CBA_fnc_removePerFrameHandler;

private _items = [getUnitLoadout player] call EFUNC(locker,loadout_items);
private _items = [_items] call EFUNC(locker,loadout_remove_owned);
private _cost = [_items] call EFUNC(shop,items_cost);

if (_cost == 0) then {
	[QGVAR(closing)] call CBA_fnc_localEvent;
} else {
	systemChat "You do not own all items, reverting changes.";
	[QGVAR(reverting)] call CBA_fnc_localEvent;
};
