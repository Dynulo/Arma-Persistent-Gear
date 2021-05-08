#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"
ADDON = true;

GVAR(pendingPurchase) = false;
GVAR(pendingOpenShop) = false;

// Objects with access to the PMC arsenal
GVAR(boxes) = [];
GVAR(arsenalItems) = [];
