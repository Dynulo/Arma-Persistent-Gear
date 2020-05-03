#include "script_component.hpp"

params ["_display"];
private _ctrlPanel = _display displayCtrl IDC_leftTabContent;

private _items = (getUnitLoadout player) call FUNC(items_list);

for "_lbIndex" from 0 to (lbSize _ctrlPanel - 1) do {
	private _class = _ctrlPanel lbData _lbIndex;
	private _owned = [_class] call FUNC(locker_quantity);
	if (_owned > 0) then {
		_ctrlPanel lbSetColor [_lbIndex, [0, 1, 0, 1]];
	};
	private _price = [_class] call FUNC(item_price);
	private _equipped = _items getVariable [_class, 0];
	private _tooltip = format ["%1\nOwned: %2\nEquipped: %3\nPrice: %4", _class, _owned, _equipped, _price];
	_ctrlPanel lbSetTooltip [_lbIndex, _tooltip];
};

[_items] call CBA_fnc_deleteNamespace;
