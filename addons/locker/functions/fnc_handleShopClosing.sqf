#include "script_component.hpp"

private _me = [getPlayerUID player] call core_discord_fnc_findMemberFromSteam;

[QGVAR(take), [_me#1, _me#4, [getUnitLoadout player] call FUNC(loadout_items)]] call CBA_fnc_serverEvent;
