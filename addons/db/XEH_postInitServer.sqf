#include "script_component.hpp"

REQUIRE_PMC;

[QEGVAR(arsenal,locker)] call FUNC(variable_track);
["ace_medical_medicClass"] call FUNC(variable_track);
["ACE_IsEngineer"] call FUNC(variable_track);
["ACE_IsEOD"] call FUNC(variable_track);
["ACE_hasEarPlugsin"] call FUNC(variable_track);

// delete corpse
addMissionEventHandler ["HandleDisconnect", {
	params ["_unit", "_id", "_uid", "_name"];
	deleteVehicle _unit;
}];

[QGVAR(publish), {
	publicVariable QGVAR(items);
	[QEGVAR(arsenal,populateItems)] call CBA_fnc_globalEvent;
}] call CBA_fnc_addEventHandler;

addMissionEventHandler ["ExtensionCallback", {
	params ["_name", "_function", "_data"];
	if !(_name == "dynulo_pmc") exitWith {};
	// systemChat format ["%1(): %2 | %3", _function, _data];
	// if !(_function == "item") then {
	// 	private _parsed = parseSimpleArray _data;
	// 	systemchat format ["p: %1", _parsed];
	// };
	switch (_function) do {
		case "balance_success": {
			(parseSimpleArray _data) params ["_steam", "_val"];
			[_steam, QEGVAR(arsenal,balance), _val] call FUNC(variable_load);
		};
		case "purchase_success": {
			private _player = _data call EFUNC(common,findFromSteam);
			[QEGVAR(arsenal,purchase_success), [], _player] call CBA_fnc_targetEvent;
		};
		case "purchase_failed": {
			private _player = _data call EFUNC(common,findFromSteam);
			[QEGVAR(arsenal,purchase_failed), [], _player] call CBA_fnc_targetEvent;
		};
		case "variable": {
			(parseSimpleArray _data) call FUNC(variable_load);
		};
		case "loadout": {
			private _data = parseSimpleArray _data;
			private _player = (_data select 0) call EFUNC(common,findFromSteam);
			_player setUnitLoadout [parseSimpleArray (_data select 1), false];
			_player setVariable [QGVAR(loadoutReady), true, true];
		};
		case "traits": {
			(parseSimpleArray _data) call FUNC(traits_load);
		};
		case "clear_items": {
			GVAR(items) = [];
		};
		case "item": {
			(parseSimpleArray _data) call FUNC(item_load);
		};
		case "publish_items": {
			[QGVAR(publish)] call CBA_fnc_serverEvent;
		};
	};
}];

EXT callExtension "get_items";

missionNamespace setVariable [QGVAR(serverReady), true, true];

INFO("setup complete");
