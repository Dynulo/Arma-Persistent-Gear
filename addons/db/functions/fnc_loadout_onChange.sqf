#include "script_component.hpp"

// player, newLoadout, oldLoadout

params ["_unit", "_new"];

if (_unit isNotEqualTo player) exitWith {};

if (player getVariable [QEGVAR(arsenal,inArsenal), false]) exitWith {};

[getPlayerUID player, _new] remoteExec [QFUNC(loadout_save), REMOTE_SERVER];
