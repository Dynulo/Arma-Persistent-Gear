#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"

EGVAR(main,enabled) = false;

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

[
    QEGVAR(main,readOnly),
    "CHECKBOX",
    ["Read Only", "Load values from the database, but do not make changes"],
    "Dynulo - PMC",
    false,
    true,
    {},
    true
] call CBA_fnc_addSetting;

if (isServer) then {
    private _token = profileNamespace getVariable [QEGVAR(main,token), ""];
	if (_token isEqualTo "") exitWith {
		INFO("token empty, not running setup");
	};
	private _result = EXT callExtension ["setup", [_token]];
	INFO_1("token submitted with result %1", _result);
};

ADDON = true;
