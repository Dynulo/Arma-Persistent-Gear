#include "script_component.hpp"

[GVAR(balanceHandle)] call CBA_fnc_removePerFrameHandler;
private _items = (getUnitLoadout player) call FUNC(listItems);
private _cost = [_items] call FUNC(itemsCost);
[_items] call CBA_fnc_deleteNamespace;
if !(_cost == 0) then {
	// Take carried items
	player setUnitLoadout [GVAR(preLoadout), false];
};
private _items = (getUnitLoadout player) call FUNC(listItems);
[_items] call FUNC(takeOwned);
[_items] call CBA_fnc_deleteNamespace;
player setVariable [QGVAR(inArsenal), false, true];
[player, getPlayerUID player] call FUNC(db_savePlayer);
[player, getPlayerUID player] call FUNC(db_push);
