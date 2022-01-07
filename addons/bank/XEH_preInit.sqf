#include "script_component.hpp"
ADDON = false;
#include "XEH_PREP.hpp"

if (isServer) then {
	[QGVAR(fetch), {
		params ["_discord", "_steam"];
		EXTCALL("features:persistent-gear:bank:balance:fetch",[ARR_2(_discord,_steam)]);
	}] call CBA_fnc_addEventHandler;

	[QGVAR(purchase), {
		params ["_discord", "_steam", "_items"];
		EXTCALL("features:persistent-gear:bank:purchases:create",[ARR_3(_discord,_steam,str _items)]);
	}] call CBA_fnc_addEventHandler;

	addMissionEventHandler ["ExtensionCallback", {
		params ["_name", "_function", "_data"];
		if ((tolower _name) isNotEqualTo "dynulo_core") exitWith {};

		switch (_function) do {
			case "features:persistent-gear:bank:balance:fetch": {
				private _data = parseSimpleArray _data;
				private _cmd = _data select 0;
				private _player = [_data select 1] call EFUNC(common,findFromSteam);
				switch (_cmd) do {
					case "loaded": {
						[QGVAR(loaded), [_data select 2], _player] call CBA_fnc_targetEvent;
					};
					case "error": {
						[QGVAR(loadError), [], _player] call CBA_fnc_targetEvent;
					};
				};
			};
			case "features:persistent-gear:bank:purchases:create": {
				private _data = parseSimpleArray _data;
				private _cmd = _data select 0;
				private _player = [_data select 1] call EFUNC(common,findFromSteam);
				switch (_cmd) do {
					case "created": {
						[QGVAR(purchaseCreated), [], _player] call CBA_fnc_targetEvent;
					};
					case "error": {
						[QGVAR(purchaseError), [], _player] call CBA_fnc_targetEvent;
					};
				};
			};
		};
	}];
};

if (hasInterface) then {
	GVAR(balance) = 0;
	GVAR(processing) = false;

	[QGVAR(loaded), {
		params ["_balance"];
		GVAR(balance) = _balance;
		[QEGVAR(shop_arsenal,loaderReady), QUOTE(ADDON)] call CBA_fnc_localEvent;
	}] call CBA_fnc_addEventHandler;

	[QGVAR(loadError), {
		[QEGVAR(shop_arsenal,loaderError), QUOTE(ADDON)] call CBA_fnc_localEvent;
	}] call CBA_fnc_addEventHandler;

	[QGVAR(purchaseCreated), {
		systemChat "Purchase Successful";
		[QEGVAR(shop_arsenal,purchaseCreated), QUOTE(ADDON)] call CBA_fnc_localEvent;
		private _me = [getPlayerUID player] call core_discord_fnc_findMemberFromSteam;
		[QGVAR(fetch), [_me#1, _me#4]] call CBA_fnc_serverEvent;
		GVAR(pending) = false;
	}] call CBA_fnc_addEventHandler;

	[QGVAR(purchaseError), {
		systemChat "Purchase Failed";
		GVAR(pending) = false;
	}] call CBA_fnc_addEventHandler;

	[QEGVAR(shop_arsenal,opening), FUNC(handleShopOpening)] call CBA_fnc_addEventHandler;
};

ADDON = true;
