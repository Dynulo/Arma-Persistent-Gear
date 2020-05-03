#include "script_component.hpp"

params ["_display"];

player setVariable [QGVAR(inArsenal), true, true];

GVAR(preLoadout) = getUnitLoadout player;

// Send an empty loadout to the database
[getPlayerUID player, BLANK_LOADOUT] remoteExec [QEFUNC(db,loadout_save), REMOTE_SERVER];

// Store all items the player had
private _items = (getUnitLoadout player) call FUNC(items_list);
[_items] call FUNC(locker_add);
[_items] call CBA_fnc_deleteNamespace;

GVAR(balanceHandle) = [FUNC(pfh_balance), 0.2, [_display]] call CBA_fnc_addPerFrameHandler;

GVAR(rightPanelColor) = [{
	params ["_args"];
	_args params ["_display"];
	private _ctrlPanel = _display displayCtrl IDC_rightTabContentListnBox;
	(lnbSize _ctrlPanel) params ["_rows", "_columns"];

	private _items = (getUnitLoadout player) call FUNC(items_list);

	for "_lbIndex" from 0 to (_rows - 1) do {
		private _class = _ctrlPanel lnbData [_lbIndex, 0];
		private _price = [_class] call FUNC(item_price);
		private _owned = [_class] call FUNC(locker_quantity);
		private _equipped = _items getVariable [_class, 0];
		if (_owned > 0 && {_price > 0}) then {
			_ctrlPanel lnbSetColor [[_lbIndex, 1], [0, 1, 0, 1]];
		};
		private _tooltip = format ["%1\nOwned: %2\nEquipped: %3\nPrice: %4", _class, _owned, _equipped, _price];
		_ctrlPanel lnbSetTooltip [[_lbIndex, 0], _tooltip];
	};

	[_items] call CBA_fnc_deleteNamespace;
}, 0.2, [_display]] call CBA_fnc_addPerFrameHandler;
