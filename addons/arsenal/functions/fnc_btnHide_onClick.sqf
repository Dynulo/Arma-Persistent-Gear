#include "script_component.hpp"

params ["_display"];

if !(EGVAR(main,enabled)) exitWith {
	[_display] call ace_arsenal_fnc_buttonHide;
};

uiNamespace setVariable [QGVAR(arsenalDisplay), _display];
createDialog QGVAR(RscCheckout);

// _display ctrlCreate [QGVAR(RscCheckout), IDC_RSCDISPLAYCHECKOUT_CHECKOUT];

// TODO is there a better way to use guiMessage
// [_display] spawn {
// 	params ["_display"];

	
	// private _items = (getUnitLoadout player) call FUNC(items_list);
	// private _text = "";
	// {
	// 	_x params ["_item", "_price", "_need", "_total"];
	// 	if (_price != 0) then {
	// 		private _name = getText ((_item call CBA_fnc_getItemConfig) >> "displayName");
	// 		_text = format ["%1%2 x %3 @ %4 = %5<br/>", _text, _name, _need, _price, _total];
	// 	};
	// } forEach ([_items] call FUNC(items_difference));
	// _text = parseText format ["%1Total: %2", _text, [_items] call FUNC(items_cost)];
	// private _result = [_text, "Confirm Purchase", true, true, _display, false, false] call BIS_fnc_guiMessage;
	// if (_result) then {
	// 	private _cost = [_items] call FUNC(items_buy);
	// 	[_items] call CBA_fnc_deleteNamespace;
	// 	// Trigger events manually to color owned items
	// 	["ace_arsenal_leftPanelFilled", [_display]] call CBA_fnc_localEvent;
	// 	["ace_arsenal_rightPanelFilled", [_display]] call CBA_fnc_localEvent;
	// };
// };
