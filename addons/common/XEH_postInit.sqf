#include "script_component.hpp"

REQUIRE_PMC;
NO_HC;

// Don't save information about Zeus
if (typeOf player isEqualto "VirtualCurator_F") exitWith {
	player setVariable [QEGVAR(common,ignore), true, true];
};

if (isServer) then {
	addMissionEventHandler ["ExtensionCallback", {
		params ["_name", "_function", "_data"];
		if !(_name == "dynulo_pmc") exitWith {};
		switch (_function) do {
			case "variables": {
				private _data = parseSimpleArray ((parseSimpleArray _data) select 0);
				_data call EFUNC(db,variables_load);
			};
			case "loadout": {
				private _data = parseSimpleArray ((parseSimpleArray _data) select 0);
				private _player = (_data select 0) call FUNC(findFromSteam);
				private _loadout = parseSimpleArray (_data select 1);
				_player setUnitLoadout [_loadout, false];
			};
			case "traits": {
				(parseSimpleArray _data) call EFUNC(db,traits_load);
			};
			case "items": {
				(parseSimpleArray _data) call EFUNC(db,items_load);
			};
		};
	}];

	EXT callExtension "get_items";
};
