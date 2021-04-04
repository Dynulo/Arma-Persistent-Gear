#include "script_component.hpp"

params ["_display"];

if !(EGVAR(main,enabled) && {!(EGVAR(main,readOnly))}) exitWith {
	[_display] call ace_arsenal_fnc_buttonHide;
};

uiNamespace setVariable [QGVAR(arsenalDisplay), _display];
createDialog QGVAR(RscCheckout);
