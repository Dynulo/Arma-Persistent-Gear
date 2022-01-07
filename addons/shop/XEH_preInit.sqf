#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"

if (isServer) then {
	GVAR(items) = createHashMap;

	["core_common_serverReady", {
		["core_common_component_register", QUOTE(ADDON)] call CBA_fnc_serverEvent;
	}] call CBA_fnc_addEventHandler;

	[QEGVAR(common,load), FUNC(handleLoadServer)] call CBA_fnc_addEventHandler;
	[QEGVAR(common,unload), FUNC(handleUnload)] call CBA_fnc_addEventHandler;

	addMissionEventHandler ["ExtensionCallback", {
		params ["_name", "_function", "_data"];
		if ((tolower _name) isNotEqualTo "dynulo_core") exitWith {};

		switch (_function) do {
			case "features:persistent-gear:shop:items:fetch": {
				private _data = parseSimpleArray _data;
				private _cmd = _data select 0;
				switch (_cmd) do {
					case "clear": {
						GVAR(itemsImporting) = createHashMap;
					};
					case "entry": {
						private _entry = _data select 1;
						private _class = _entry deleteAt 0;
						GVAR(itemsImporting) set [_class, _entry];
					};
					case "done": {
						GVAR(items) = +GVAR(itemsImporting);
						publicVariable QGVAR(items);
						INFO_1("Loaded %1 items", count GVAR(items));
						["core_common_component_ready", QUOTE(ADDON)] call CBA_fnc_serverEvent;
					};
				};
			};
		};
	}];
};

if (hasInterface) then {
	[QEGVAR(common,load), FUNC(handleLoadClient)] call CBA_fnc_addEventHandler;
};

ADDON = true;
