#include "script_component.hpp"

params ["_uid", "_loadout"];

EXT callExtension ["save_loadout", [_uid, str ([_loadout] call EFUNC(common,cleanLoadout))]];
