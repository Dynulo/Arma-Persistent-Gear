#include "script_component.hpp"

if (EGVAR(common,readonly)) exitWith {};

GVAR(tracking) = true;

[player, getUnitLoadout player] call FUNC(onChange);
