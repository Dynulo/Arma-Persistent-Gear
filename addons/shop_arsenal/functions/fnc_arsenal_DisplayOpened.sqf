#include "script_component.hpp"

params ["_display"];

if (ace_player isNotEqualTo player) exitWith {};
if !(player getVariable [QGVAR(inShop), false]) exitWith {};

player setVariable [QGVAR(inArsenal), true, true];

GVAR(balanceHandle) = [FUNC(pfh_balance), 0.2, [_display]] call CBA_fnc_addPerFrameHandler;

GVAR(rightPanelColor) = [{
	params ["_args"];
	_args params ["_display"];
	private _ctrlPanel = _display displayCtrl IDC_rightTabContentListnBox;
	(lnbSize _ctrlPanel) params ["_rows", "_columns"];

	private _items = (getUnitLoadout player) call FUNC(items_list);

	for "_lbIndex" from 0 to (_rows - 1) do {
		private _raw_class = _ctrlPanel lnbData [_lbIndex, 0];
		private _class = [_raw_class] call EFUNC(shop,item_listing);
		private _price = [_class, false] call EFUNC(shop,item_price);
		private _owned = [_raw_class] call EFUNC(locker,owned);
		private _equipped = _items getOrDefault [_class, 0];
		if (_owned > 0 && {_price > 0}) then {
			_ctrlPanel lnbSetColor [[_lbIndex, 1], [0, 1, 0, 1]];
		};
		private _tooltip = format ["%1\nOwned: %2\nEquipped: %3\nPrice: %4", _class, _owned, _equipped, _price];
		_ctrlPanel lnbSetTooltip [[_lbIndex, 0], _tooltip];
	};
}, 0.2, [_display]] call CBA_fnc_addPerFrameHandler;
