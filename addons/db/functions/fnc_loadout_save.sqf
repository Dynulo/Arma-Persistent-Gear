#include "script_component.hpp"

params ["_uid", "_loadout", ["_override", false]];

private _player = _uid call EFUNC(common,findFromSteam);

if !(_override) then {
	if !(_player getVariable [QGVAR(loadoutReady), false]) exitWith {};
	if (_player getVariable [QEGVAR(arsenal,inArsenal), false]) exitWith {};
};

EXT callExtension ["save_loadout", [_uid, str ([_loadout] call EFUNC(common,cleanLoadout))]];
