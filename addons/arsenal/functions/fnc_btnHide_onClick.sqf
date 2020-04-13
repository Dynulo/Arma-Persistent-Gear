#include "script_component.hpp"

params ["_display"];

if (getMissionConfigValue ["pmcEnabled", ""] isEqualTo "") exitWith {
	[_display] call ace_arsenal_fnc_buttonHide;
};

private _items = (getUnitLoadout player) call FUNC(listItems);

[_display, _items] spawn {
	params ["_display", "_items"];
	private _text = "";
	{
		_x params ["_item", "_price", "_need", "_total"];
		if (_price != 0) then {
			private _name = getText ((_item call CBA_fnc_getItemConfig) >> "displayName");
			_text = format ["%1%2 x %3 @ %4 = %5<br/>", _text, _name, _need, _price, _total];
		};
	} forEach ([_items] call FUNC(difference));
	_text = parseText format ["%1Total: %2", _text, [_items] call FUNC(itemsCost)];
	_result = [_text, "Confirm Purchase", true, true, _display, false, false] call BIS_fnc_guiMessage;
	if (_result) then {
		private _cost = [_items] call FUNC(buyItems);
		[_items] call CBA_fnc_deleteNamespace;
		// Trigger events manually to color owned items
		["ace_arsenal_leftPanelFilled", [_display]] call CBA_fnc_localEvent;
		["ace_arsenal_rightPanelFilled", [_display]] call CBA_fnc_localEvent;
	};
};
