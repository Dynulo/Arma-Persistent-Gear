#include "script_component.hpp"

// TODO might be able to remove

params ["_display", "_leftIDC", "_rightIDC"];
if (_leftIDC in [IDC_buttonPrimaryWeapon, IDC_buttonSecondaryWeapon, IDC_buttonHandgun]) then {
	private _ctrlPanel = _display displayCtrl IDC_rightTabContent;
	for "_lbIndex" from 0 to (lbSize _ctrlPanel - 1) do {
		private _class = _ctrlPanel lbData _lbIndex;
		private _owned = [_class] call FUNC(locker_quantity);
		if (_owned > 0) then {
			_ctrlPanel lbSetColor [_lbIndex, [0, 1, 0, 1]];
		};
		private _price = [_class] call FUNC(item_price);
		private _tooltip = format ["%1\nOwned: %2\nPrice: %3", _class, _owned, _price];
		_ctrlPanel lbSetTooltip [_lbIndex, _tooltip];
	};
};
