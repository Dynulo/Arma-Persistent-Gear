#include "script_component.hpp"

if (EGVAR(common,readonly)) exitWith {};

[QEGVAR(shop_arsenal,loaderRegister), QUOTE(ADDON)] call CBA_fnc_localEvent;

GVAR(tracking) = false;

private _me = [getPlayerUID player] call core_discord_fnc_findMemberFromSteam;

GVAR(preLoadout) = getUnitLoadout player;

[QGVAR(store), [_me#1, _me#4, BLANK_LOADOUT]] call CBA_fnc_serverEvent;
