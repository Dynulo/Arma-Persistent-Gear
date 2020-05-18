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

if (isServer) then {
    private _token = profileNamespace getVariable [QEGVAR(main,token), ""];
	if (_token isEqualTo "") exitWith {
		INFO("token empty, not running setup");
	};
	private _result = EXT callExtension ["setup", [_token]];
	INFO_1("token submitted with result %1", _result);
};

ADDON = true;
