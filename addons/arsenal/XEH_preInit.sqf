#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"
ADDON = true;

// Objects with access to the PMC arsenal
GVAR(boxes) = [];

// Track owned items
GVAR(locker) = call CBA_fnc_createNamespace;
