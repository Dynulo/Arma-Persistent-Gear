#include "script_component.hpp"

// player, newLoadout, oldLoadout

if (player getVariable [QEGVAR(arsenal,inArsenal), false]) exitWith {};

[getPlayerUID player, _this select 1] remoteExec [QFUNC(loadout_save), REMOTE_SERVER];
