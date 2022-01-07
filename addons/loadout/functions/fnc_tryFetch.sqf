#include "script_component.hpp"

if (GVAR(loadingWait) > 0) exitWith {};

private _me = [getPlayerUID player] call core_discord_fnc_findMemberFromSteam;

[QGVAR(fetch), [_me#1, _me#4]] call CBA_fnc_serverEvent;
