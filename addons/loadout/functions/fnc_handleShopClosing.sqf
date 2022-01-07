#include "script_component.hpp"

GVAR(tracking) = true;

[player, getUnitLoadout player] call FUNC(onChange);
