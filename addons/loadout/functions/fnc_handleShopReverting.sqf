#include "script_component.hpp"

if (EGVAR(common,readonly)) exitWith {};

private _me = [getPlayerUID player] call core_discord_fnc_findMemberFromSteam;

player setUnitLoadout [GVAR(preLoadout), false];

[QGVAR(store), [_me#1, _me#4, GVAR(preLoadout)]] call CBA_fnc_serverEvent;

[{
	GVAR(tracking) = true;
}] call CBA_fnc_execNextFrame;
