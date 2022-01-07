#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"

if (isServer) then {
	[QGVAR(fetch), {
		params ["_discord", "_steam"];
		EXTCALL("features:persistent-gear:player:locker:fetch",[ARR_2(_discord,_steam)]);
	}] call CBA_fnc_addEventHandler;

	[QGVAR(store), {
		params ["_discord", "_steam", "_items"];
		if (EGVAR(common,readonly)) exitWith {
			[QGVAR(stored), [], [_steam] call EFUNC(common,findFromSteam)] call CBA_fnc_targetEvent;
		};
		EXTCALL("features:persistent-gear:player:locker:store",[ARR_3(_discord,_steam,str _items)]);
	}] call CBA_fnc_addEventHandler;

	[QGVAR(take), {
		params ["_discord", "_steam", "_items"];
		if (EGVAR(common,readonly)) exitWith {
			[QGVAR(stored), [], [_steam] call EFUNC(common,findFromSteam)] call CBA_fnc_targetEvent;
		};
		EXTCALL("features:persistent-gear:player:locker:take",[ARR_3(_discord,_steam,str _items)]);
	}] call CBA_fnc_addEventHandler;

	GVAR(pending) = createHashMap;

	addMissionEventHandler ["ExtensionCallback", {
		params ["_name", "_function", "_data"];
		if ((tolower _name) isNotEqualTo "dynulo_core") exitWith {};

		switch (_function) do {
			case "features:persistent-gear:player:locker:fetch": {
				private _data = parseSimpleArray _data;
				private _cmd = _data select 0;
				switch (_cmd) do {
					case "clear": {
						GVAR(pending) set [_data select 1, createHashMap];
					};
					case "entry": {
						// Will silently fail if clear is not called first
						(GVAR(pending) getOrDefault [_data select 1, createHashMap]) set [_data#2#0, _data#2#1];
					};
					case "done": {
						private _player = [_data select 1] call EFUNC(common,findFromSteam);
						[QGVAR(loaded), [GVAR(pending) getOrDefault [_data select 1, createHashMap]], _player] call CBA_fnc_targetEvent;
					};
					case "error": {
						private _player = [_data select 1] call EFUNC(common,findFromSteam);
						[QGVAR(loadError), [], _player] call CBA_fnc_targetEvent;
					};
				};
			};
			case "features:persistent-gear:player:locker:store": {
				private _data = parseSimpleArray _data;
				private _cmd = _data select 0;
				private _player = [_data select 1] call EFUNC(common,findFromSteam);
				switch (_cmd) do {
					case "stored": {
						[QGVAR(stored), [], _player] call CBA_fnc_targetEvent;
					};
					case "error": {
						[QGVAR(storeError), [], _player] call CBA_fnc_targetEvent;
					};
				};
			};
			case "features:persistent-gear:player:locker:take": {
				private _data = parseSimpleArray _data;
				private _cmd = _data select 0;
				private _player = [_data select 1] call EFUNC(common,findFromSteam);
				switch (_cmd) do {
					case "taken": {
						[QGVAR(taken), [], _player] call CBA_fnc_targetEvent;
					};
					case "error": {
						[QGVAR(takeError), [], _player] call CBA_fnc_targetEvent;
					};
				};
			};
		};
	}];
};

if (hasInterface) then {
	[QEGVAR(common,load), FUNC(handleLoadClient)] call CBA_fnc_addEventHandler;

	[QGVAR(loaded), {
		params ["_locker"];
		GVAR(items) = _locker;
		[QEGVAR(shop_arsenal,loaderReady), QUOTE(ADDON)] call CBA_fnc_localEvent;

		["ace_arsenal_leftPanelFilled", [findDisplay 1127001]] call CBA_fnc_localEvent;
		["ace_arsenal_rightPanelFilled", [findDisplay 1127001]] call CBA_fnc_localEvent;
	}] call CBA_fnc_addEventHandler;

	[QGVAR(loadError), {
		[QEGVAR(shop_arsenal,loaderError), QUOTE(ADDON)] call CBA_fnc_localEvent;
	}] call CBA_fnc_addEventHandler;

	[QGVAR(stored), {
		private _me = [getPlayerUID player] call core_discord_fnc_findMemberFromSteam;
		[QGVAR(fetch), [_me#1, _me#4]] call CBA_fnc_serverEvent;
		GVAR(ignoreRevert) = false;
	}] call CBA_fnc_addEventHandler;

	[QGVAR(storeError), {
		systemChat "Failed to store gear in your locker.";
		GVAR(ignoreRevert) = true;
		[QEGVAR(shop_arsenal,loaderError), QUOTE(ADDON)] call CBA_fnc_localEvent;
	}] call CBA_fnc_addEventHandler;

	[QGVAR(taken), {
		// Do nothing
	}] call CBA_fnc_addEventHandler;

	[QGVAR(takeError), {
		player setUnitLoadout [BLANK_LOADOUT, false];
		systemChat "Failed to take gear from locker.";
	}] call CBA_fnc_addEventHandler;

	[QEGVAR(bank,purchaseCreated), {
		private _me = [getPlayerUID player] call core_discord_fnc_findMemberFromSteam;
		[QGVAR(fetch), [_me#1, _me#4]] call CBA_fnc_serverEvent;
	}] call CBA_fnc_addEventHandler;

	[QEGVAR(shop_arsenal,opening), FUNC(handleShopOpening)] call CBA_fnc_addEventHandler;
	[QEGVAR(shop_arsenal,closing), FUNC(handleShopClosing)] call CBA_fnc_addEventHandler;
	[QEGVAR(shop_arsenal,reverting), FUNC(handleShopReverting)] call CBA_fnc_addEventHandler;
};

ADDON = true;
