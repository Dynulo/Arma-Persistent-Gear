#include "script_component.hpp"

REQUIRE_PMC;
NO_HC;

// Don't save information about Zeus
if (typeOf player isEqualto "VirtualCurator_F") exitWith {
	player setVariable [QEGVAR(common,ignore), true, true];
};

if (isServer) then {
	EXT callExtension "setup";

	addMissionEventHandler ["ExtensionCallback", {
		params ["_name", "_function", "_data"];
		if !(_name == "dynulo_pmc") exitWith {};
		switch (_function) do {
			case "playerVariables": {
				_data call EFUNC(db,variables_load);
			};
			case "playerLoadout": {
				player setUnitLoadout [_data, false];
			};
		}
	}];
};
