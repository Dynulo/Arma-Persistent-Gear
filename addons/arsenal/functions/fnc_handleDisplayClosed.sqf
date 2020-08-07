#include "script_component.hpp"

[GVAR(balanceHandle)] call CBA_fnc_removePerFrameHandler;
[GVAR(rightPanelColor)] call CBA_fnc_removePerFrameHandler;

private _items = (getUnitLoadout player) call FUNC(items_list);
private _cost = [_items] call FUNC(items_cost);

// Player did not pay for their items
if !(_cost == 0) then {
	// Take carried items
	player setUnitLoadout [GVAR(preLoadout), false];
	[_items] call CBA_fnc_deleteNamespace;
	_items = (getUnitLoadout player) call FUNC(items_list);
};

[_items] call FUNC(locker_take);
[_items] call CBA_fnc_deleteNamespace;

player setVariable [QGVAR(inArsenal), false, true];

if !(EGVAR(main,readOnly)) then {
	[player, getUnitLoadout player] call EFUNC(db,loadout_onChange);
};

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

// TODO
// [player, getPlayerUID player] call FUNC(db_savePlayer);
// [player, getPlayerUID player] call FUNC(db_push);
