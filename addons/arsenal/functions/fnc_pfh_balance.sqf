params ["_args"];
_args params ["_display"];

private _btnHide = _display displayCtrl IDC_buttonHide;
private _btnClose = _display displayCtrl IDC_menuBarClose;

private _items = (getUnitLoadout player) call FUNC(items_list);
private _cost = [_items] call FUNC(items_cost);
[_items] call CBA_fnc_deleteNamespace;

// Default 2000 balance
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
