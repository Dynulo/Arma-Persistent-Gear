#include "script_component.hpp"

params ["_class"];

GVAR(locker) getVariable [[_class] call FUNC(item_listing), 0]
