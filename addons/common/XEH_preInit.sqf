#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"

["core_common_features", FUNC(handleFeatures)] call CBA_fnc_addEventHandler;

[
    QGVAR(enabled),
    "CHECKBOX",
    ["Enabled", "Enable Persistent Gear"],
    "Commander - Persistent Gear",
    false,
    true,
    {},
    true
] call CBA_fnc_addSetting;

[
    QGVAR(readOnly),
    "CHECKBOX",
    ["Read Only", "Load gear when the mission starts, but do not save changes"],
    "Commander - Persistent Gear",
    false,
    true,
    {},
    true
] call CBA_fnc_addSetting;

ADDON = true;
