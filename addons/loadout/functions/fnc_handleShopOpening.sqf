#include "script_component.hpp"

[QEGVAR(shop_arsenal,loaderRegister), QUOTE(ADDON)] call CBA_fnc_localEvent;

if (EGVAR(common,readonly)) exitWith {};

GVAR(tracking) = false;

private _me = [getPlayerUID player] call core_discord_fnc_findMemberFromSteam;

GVAR(preLoadout) = getUnitLoadout player;

[QGVAR(store), [_me#1, _me#4, BLANK_LOADOUT]] call CBA_fnc_serverEvent;
