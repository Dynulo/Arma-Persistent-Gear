#include "script_component.hpp"

params ["_display"];

if !(EGVAR(common,enabled) && {!(EGVAR(common,readOnly))}) exitWith {
	[_display] call ace_arsenal_fnc_buttonHide;
};

createDialog QGVAR(RscCheckout);
