#include "script_component.hpp"

params ["_display"];

if (ace_player isNotEqualTo player) exitWith {};
if !(player getVariable [QGVAR(inShop), false]) exitWith {};

player setVariable [QGVAR(inArsenal), true, true];

GVAR(balanceHandle) = [FUNC(pfh_balance), 0.2, [_display]] call CBA_fnc_addPerFrameHandler;
