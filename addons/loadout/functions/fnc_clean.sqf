#include "script_component.hpp"

params ["_loadout"];

_loadout = [_loadout] call acre_api_fnc_filterUnitLoadout;

_loadout
