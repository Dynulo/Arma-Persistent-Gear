#include "script_component.hpp"

REQUIRE_PMC;

addMissionEventHandler ["ExtensionCallback", {
	params ["_name", "_function", "_data"];
	if !(_name == "dynulo_pmc") exitWith {};
	// if !(_function == "item") then {
	// 	systemChat format ["%1(): %2 | %3", _function, _data];
	// 	private _parsed = parseSimpleArray _data;
	// 	systemchat format ["p: %1", _parsed];
	// };
	switch (_function) do {
		case "variable": {
			(parseSimpleArray _data) call EFUNC(db,variable_load);
		};
		case "loadout": {
			private _data = parseSimpleArray _data;;
			private _player = (_data select 0) call FUNC(findFromSteam);
			_player setUnitLoadout [parseSimpleArray (_data select 1), false];
		};
		case "traits": {
			(parseSimpleArray _data) call EFUNC(db,traits_load);
		};
		case "clear_items": {
			EGVAR(db,items) = [];
		};
		case "item": {
			(parseSimpleArray _data) call EFUNC(db,item_load);
		};
		case "publish_items": {
			[QEGVAR(db,publish)] call CBA_fnc_serverEvent;
		};
	};
}];

EXT callExtension "get_items";
