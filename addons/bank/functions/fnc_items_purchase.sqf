#include "script_component.hpp"

params ["_items"];

if (GVAR(pending)) exitWith {};

GVAR(pending) = true;

private _me = [getPlayerUID player] call core_discord_fnc_findMemberFromSteam;

[QGVAR(purchase), [_me#1, _me#4, _items]] call CBA_fnc_serverEvent;
