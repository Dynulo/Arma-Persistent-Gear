#include "script_component.hpp"

params ["_features"];

if ((3 in _features) && {GVAR(enabled)}) then {
	[QGVAR(load)] call CBA_fnc_globalEventJIP;
} else {
	[QGVAR(unload)] call CBA_fnc_serverEvent;
};
