#include "script_component.hpp"

params ["_display", "_leftIDC"]; // , "_rightIDC"];
if (_leftIDC in [IDC_buttonPrimaryWeapon, IDC_buttonSecondaryWeapon, IDC_buttonHandgun]) then {
	private _ctrlPanel = _display displayCtrl IDC_rightTabContent;
	private _items = [getUnitLoadout player] call EFUNC(locker,loadout_items);
	for "_lbIndex" from 0 to (lbSize _ctrlPanel - 1) do {
		private _raw_class = configName ((_ctrlPanel lbData _lbIndex) call CBA_fnc_getItemConfig);
		if (_raw_class isNotEqualTo "") then {
			private _class = [_raw_class] call EFUNC(shop,item_listing);
			private _price = [_class, false] call EFUNC(shop,item_price);
			private _global = [_class, false] call EFUNC(shop,item_global);
			private _tooltip = if (EGVAR(common,readOnly)) then {
				format ["%1\nPrice: %2\nGlobal: %3", _raw_class, _price, _global]
			} else {
				private _owned = [_raw_class] call EFUNC(locker,owned);
				if (_owned > 0) then {
					_ctrlPanel lbSetColor [_lbIndex, [0, 1, 0, 1]];
				};
				private _equipped = _items getOrDefault [_raw_class, 0];
				format ["%1\nOwned: %2\nEquipped: %3\nPrice: %4\nGlobal: %5", _raw_class, _owned, _equipped, _price, _global]
			};
			_ctrlPanel lbSetTooltip [_lbIndex, _tooltip];
		};
	};
};
if (_leftIDC in [IDC_buttonUniform, IDC_buttonVest, IDC_buttonBackpack]) then {
	private _ctrlPanel = _display displayCtrl IDC_rightTabContentListnBox;
	private _items = [getUnitLoadout player] call EFUNC(locker,loadout_items);
	(lnbSize _ctrlPanel) params ["_rows", "_columns"];

	for "_lbIndex" from 0 to (_rows - 1) do {
		private _raw_class = _ctrlPanel lnbData [_lbIndex, 0];
		private _class = [_raw_class] call EFUNC(shop,item_listing);
		private _price = [_class, false] call EFUNC(shop,item_price);
		private _global = [_class, false] call EFUNC(shop,item_global);
		private _owned = [_raw_class] call EFUNC(locker,owned);
		private _equipped = _items getOrDefault [_class, 0];
		if (_owned > 0 && {_price > 0}) then {
			_ctrlPanel lnbSetColor [[_lbIndex, 1], [0, 1, 0, 1]];
		};
		private _tooltip = format ["%1\nOwned: %2\nEquipped: %3\nPrice: %4\nGlobal: %5", _raw_class, _owned, _equipped, _price, _global];
		_ctrlPanel lnbSetTooltip [[_lbIndex, 0], _tooltip];
	};
};
