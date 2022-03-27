#include "script_component.hpp"

params ["_unit", "_new"];

if (EGVAR(common,readonly)) exitWith {};

if !(GVAR(tracking)) exitWith {};
if (_unit isNotEqualTo player) exitWith {};
if !(player getVariable [QGVAR(loaded), false]) exitWith {};
if (player getVariable [QEGVAR(shop_arsenal,inArsenal), false]) exitWith {};

private _me = [getPlayerUID player] call core_discord_fnc_findMemberFromSteam;

[QGVAR(store), [_me#1, _me#4, getUnitLoadout player]] call CBA_fnc_serverEvent;
