#include "script_component.hpp"

params ["_display"];
private _ctrlPanel = _display displayCtrl IDC_leftTabContent;
for "_lbIndex" from 0 to (lbSize _ctrlPanel - 1) do {
	private _class = _ctrlPanel lbData _lbIndex;
	private _owned = [_class] call FUNC(getOwned);
	if (_owned > 0) then {
		_ctrlPanel lbSetColor [_lbIndex, [0, 1, 0, 1]];
	};
	private _price = [_class] call FUNC(getPrice);
	_ctrlPanel lbSetTooltip [_lbIndex, format ["%1\nOwned: %2\nPrice: %3", _class, _owned, _price]];
};
