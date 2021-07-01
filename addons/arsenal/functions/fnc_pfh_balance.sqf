#include "script_component.hpp"

params ["_args"];
_args params ["_display"];

private _btnHide = _display displayCtrl IDC_buttonHide;
private _btnClose = _display displayCtrl IDC_menuBarClose;

private _items = (getUnitLoadout player) call FUNC(items_list);

private _invalid = [_items] call FUNC(items_canBuy);
if (_invalid isNotEqualTo []) exitWith {
	_btnHide ctrlEnable false;
	_btnHide ctrlSetText "Invalid Items";
	private _names = [];
	{
		private _config = (_x call CBA_fnc_getItemConfig);
		private _name = getText (_config >> "displayName");
		_names pushBack _name;
	} forEach _invalid;
	_btnHide ctrlSetTooltip (_names joinString "\n");
	_btnClose ctrlSetText "Cancel";
};

private _cost = [_items] call FUNC(items_cost);

private _balance = player getVariable [QGVAR(balance), 0];
if (_cost == 0) then {
	_btnHide ctrlEnable false;
	_btnHide ctrlSetText format ["0 / %1", _balance];
	_btnHide ctrlSetTooltip "Current PMC Balance";
	_btnClose ctrlSetText "Apply";
} else {
	if !(GVAR(pendingPurchase)) then {
		// if (_cost > _balance) then {
		// 	_btnHide ctrlEnable false;
		// } else {
		_btnHide ctrlEnable true;
		// };
		private _cost = [_items, 0] call FUNC(items_cost);
		_btnHide ctrlSetText format ["%1 / %2", _cost, _balance];
		_btnHide ctrlSetTooltip "Buy Current Gear";
		_btnClose ctrlSetText "Cancel";
	} else {
		_btnHide ctrlEnable false;
		_btnHide ctrlSetText "Processing";
	};
};
