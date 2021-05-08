#include "script_component.hpp"

REQUIRE_PMC;

[QEGVAR(arsenal,lockerMigration)] call FUNC(variable_track);
["ace_medical_medicClass"] call FUNC(variable_track);
["ACE_IsEngineer"] call FUNC(variable_track);
["ACE_IsEOD"] call FUNC(variable_track);
["ACE_hasEarPlugsin"] call FUNC(variable_track);

// delete corpse
addMissionEventHandler ["HandleDisconnect", {
	params ["_unit", "_id", "_uid", "_name"];
	deleteVehicle _unit;
}];

GVAR(items) = [];
publicVariable QGVAR(items);

[QGVAR(items_publish), {
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

		// Items

		case "items_clear": {
			GVAR(items) = [];
		};
		case "item": {
			(parseSimpleArray _data) call FUNC(item_load);
		};
		case "items_publish": {
			[QGVAR(items_publish)] call CBA_fnc_serverEvent;
		};

		// Locker

		case "locker_new": {
			missionNamespace setVariable [format [QGVAR(locker_%1), _data], createHashMap];
		};
		case "locker_item": {
			private _data = parseSimpleArray _data;
			_data params ["_player", "_class", "_quantity"];
			private _map = missionNamespace getVariable [format [QGVAR(locker_%1), _player], createHashMap];
			_map set [_class, _quantity];
		};
		case "locker_publish": {
			private _player = _data call EFUNC(common,findFromSteam);
			private _map = missionNamespace getVariable [format [QGVAR(locker_%1), _data], createHashMap];
			[QEGVAR(arsenal,locker_publish), [_map], _player] call CBA_fnc_targetEvent;
		};

		case "locker_take_success": {
			private _player = _data call EFUNC(common,findFromSteam);
			[QEGVAR(arsenal,locker_take_success), [], _player] call CBA_fnc_targetEvent;
		};
		case "locker_take_failed": {
			private _player = _data call EFUNC(common,findFromSteam);
			[QEGVAR(arsenal,locker_take_failed), [], _player] call CBA_fnc_targetEvent;
		};
		case "locker_store_success": {
			private _player = _data call EFUNC(common,findFromSteam);
			[QEGVAR(arsenal,locker_store_success), [], _player] call CBA_fnc_targetEvent;
		};
		case "locker_store_failed": {
			private _player = _data call EFUNC(common,findFromSteam);
			[QEGVAR(arsenal,locker_store_failed), [], _player] call CBA_fnc_targetEvent;
		};
	};
}];

EXT callExtension "get_items";

[{
	missionNamespace setVariable [QGVAR(serverReady), true, true];
}, [], 3] call CBA_fnc_waitAndExecute;

INFO("setup complete");
