#include "script_component.hpp"

params ["_variable"];

if !(isServer) exitWith {};

private _tracked = missionNamespace getVariable [QGVAR(tracked), []];
_tracked pushBackUnique _variable;
missionNamespace setVariable [QGVAR(tracked), _tracked, true];
