#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"
ADDON = true;

GVAR(pendingPurchase) = false;

// Objects with access to the PMC arsenal
GVAR(boxes) = [];
GVAR(arsenalItems) = [];

// Track owned items
GVAR(locker) = call CBA_fnc_createNamespace;
