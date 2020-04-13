#include "script_component.hpp"

// player, newLoadout, oldLoadout

private _loadout = param [1, getUnitLoadout player];

if !(player getVariable [QGVAR(inArsenal), false]) then {
	 call FUNC(loadout_save);
	[getPlayerUID player, _loadout] remoteExec [QFUNC(loadout_save), REMOTE_SERVER];
};
