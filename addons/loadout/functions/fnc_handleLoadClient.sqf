#include "script_component.hpp"

GVAR(loadingWait) = GVAR(loadingWait) - 1;
call FUNC(tryFetch);

["loadout", FUNC(onChange)] call CBA_fnc_addPlayerEventHandler;
