#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"

[
    QEGVAR(main,enabled),
    "CHECKBOX",
    ["Enabled", "Use the PMC feautres"],
    "Dynulo - PMC",
    false,
    true,
    {},
    true
] call CBA_fnc_addSetting;

ADDON = true;
