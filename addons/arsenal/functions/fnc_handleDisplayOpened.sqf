#include "script_component.hpp"

params ["_display"];
player setVariable [QGVAR(inArsenal), true, true];
GVAR(preLoadout) = getUnitLoadout player;
// Send an empty loadout to the database
[0, {
	params ["_unit"];
	EXT callExtension ["save_loadout", [getPlayerUID _unit, str ([[],[],[],[],[],[],"","",[],["","","","","",""]])]];
}, player] call CBA_fnc_globalExecute;
// Store carried items
private _items = (getUnitLoadout player) call FUNC(listItems);
private _cost = [_items] call FUNC(addOwned);
[player, getPlayerUID player] call FUNC(db_sync);
[_items] call CBA_fnc_deleteNamespace;
GVAR(balanceHandle) = [{
	params ["_args"];
	_args params ["_display"];
	private _btnHide = _display displayCtrl IDC_buttonHide;
	private _btnClose = _display displayCtrl IDC_menuBarClose;
	private _items = (getUnitLoadout player) call FUNC(listItems);
	private _cost = [_items] call FUNC(itemsCost);
	[_items] call CBA_fnc_deleteNamespace;
	private _balance = player getVariable [QGVAR(balance), 2000];
	if (_cost == 0) then {
		_btnHide ctrlEnable false;
		_btnHide ctrlSetText format ["Balance: %1", _balance];
		_btnHide ctrlSetTooltip "Current PMC Balance";
		_btnClose ctrlSetText "Apply";
	} else {
		if (_cost > _balance) then {
			_btnHide ctrlEnable false;
		} else {
			_btnHide ctrlEnable true;
		};
		_btnHide ctrlSetText format ["Purchase: %1 / %2", _cost, _balance];
		_btnHide ctrlSetTooltip "Buy Current Gear";
		_btnClose ctrlSetText "Cancel";
	};
}, 0.2, [_display]] call CBA_fnc_addPerFrameHandler;
GVAR(rightPanelColor) = [{
	params ["_args"];
	_args params ["_display"];
	private _ctrlPanel = _display displayCtrl IDC_rightTabContentListnBox;
	(lnbSize _ctrlPanel) params ["_rows", "_columns"];
	for "_lbIndex" from 0 to (_rows - 1) do {
		private _class = _ctrlPanel lnbData [_lbIndex, 0];
		private _price = [_class] call FUNC(getPrice);
		private _owned = [_class] call FUNC(getOwned);
		if (_owned > 0 && {_price > 0}) then {
			_ctrlPanel lnbSetColor [[_lbIndex, 1], [0, 1, 0, 1]];
		};
		private _tooltip = format ["%1\nOwned: %2\nPrice: %3", _class, _owned, _price];
		_ctrlPanel lnbSetTooltip [[_lbIndex, 0], _tooltip];
	};
}, 0, [_display]] call CBA_fnc_addPerFrameHandler;
