#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"

if (isServer) then {
	[QGVAR(fetch), {
		params ["_discord", "_steam"];
		EXTCALL("features:persistent-gear:player:loadout:fetch",[ARR_2(_discord,_steam)]);
	}] call CBA_fnc_addEventHandler;

	[QGVAR(store), {
		params ["_discord", "_steam", "_loadout"];
		if (EGVAR(common,readonly)) exitWith {
			[QGVAR(stored), [], [_steam] call EFUNC(common,findFromSteam)] call CBA_fnc_targetEvent;
		};
		EXTCALL("features:persistent-gear:player:loadout:store",[ARR_3(_discord,_steam,str ([_loadout] call FUNC(clean)))]);
	}] call CBA_fnc_addEventHandler;

	addMissionEventHandler ["ExtensionCallback", {
		params ["_name", "_function", "_data"];
		if ((tolower _name) isNotEqualTo "dynulo_core") exitWith {};

		switch (_function) do {
			case "features:persistent-gear:player:loadout:fetch": {
				(parseSimpleArray _data) params ["_cmd", "_steam", "_loadout"];
				switch (_cmd) do {
					case "loaded": {
						[QGVAR(loaded), [parseSimpleArray _loadout, _steam]] call CBA_fnc_globalEvent;
					};
					case "empty": {
						[QGVAR(loaded), [BLANK_LOADOUT, _steam]] call CBA_fnc_globalEvent;
					};
					case "error": {
						[QGVAR(loadError), [_steam]] call CBA_fnc_globalEvent;
					};
				};
			};
			case "features:persistent-gear:player:loadout:store": {
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
		};
	}];
};

if (hasInterface) then {
	GVAR(loadingWait) = 2;
	GVAR(tracking) = false;

	[QEGVAR(common,load), FUNC(handleLoadClient)] call CBA_fnc_addEventHandler;

	["core_common_component_ready", {
		params ["_component"];
		if (_component isEqualTo "core_discord_members") then {
			GVAR(loadingWait) = GVAR(loadingWait) - 1;
			call FUNC(tryFetch);
		};
	}] call CBA_fnc_addEventHandler;

	[QGVAR(loaded), {
		params ["_loadout", "_steam"];
		if ((_steam isNotEqualTo (getPlayerUID player))) exitWith {};
		if (player getVariable [QEGVAR(shop_arsenal,inArsenal), false]) exitWith {};
		player setUnitLoadout [_loadout, false];
		[{
			player addGoggles (_loadout select 7);
			player setVariable [QGVAR(loaded), true, true];
			GVAR(tracking) = true;
		}] call CBA_fnc_execNextFrame;
	}] call CBA_fnc_addEventHandler;

	[QGVAR(loadError), {
		params ["_steam"];
		if (_steam isNotEqualTo (getPlayerUID player)) then {
			systemChat "Error loading loadout, abort and retry, or contact your server admin.";
		};
	}] call CBA_fnc_addEventHandler;

	[QGVAR(stored), {
		[QEGVAR(shop_arsenal,loaderReady), QUOTE(ADDON)] call CBA_fnc_localEvent;
	}] call CBA_fnc_addEventHandler;

	[QGVAR(storeError), {
		[QEGVAR(shop_arsenal,loaderError), QUOTE(ADDON)] call CBA_fnc_localEvent;
	}] call CBA_fnc_addEventHandler;

	[QEGVAR(shop_arsenal,opening), FUNC(handleShopOpening)] call CBA_fnc_addEventHandler;
	[QEGVAR(shop_arsenal,closing), FUNC(handleShopClosing)] call CBA_fnc_addEventHandler;
	[QEGVAR(shop_arsenal,reverting), FUNC(handleShopReverting)] call CBA_fnc_addEventHandler;
};

ADDON = true;
