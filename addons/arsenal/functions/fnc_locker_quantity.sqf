#include "script_component.hpp"

/*
 * Return the count of an item stored in the locker
 */

params ["_class"];
(player getVariable [QGVAR(locker), createHashMap]) getOrDefault [_class, 0]
