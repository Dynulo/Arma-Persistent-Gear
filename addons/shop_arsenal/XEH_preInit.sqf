#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"
ADDON = true;

GVAR(shops) = [];

if (hasInterface) then {
	[QEGVAR(common,load), FUNC(handleLoadClient)] call CBA_fnc_addEventHandler;

	[QGVAR(loaderRegister), FUNC(handleLoaderRegister)] call CBA_fnc_addEventHandler;
	[QGVAR(loaderReady), FUNC(handleLoaderReady)] call CBA_fnc_addEventHandler;
	[QGVAR(loaderError), FUNC(handleLoaderError)] call CBA_fnc_addEventHandler;
};
