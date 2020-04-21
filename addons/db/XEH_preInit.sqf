#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"
ADDON = true;

if (isServer) then {
	GVAR(items) = [];
	publicVariable QGVAR(items);
};

if (hasInterface) then {
	GVAR(oldVars) = call CBA_fnc_createNamespace;
};
