#include "script_component.hpp"

private _items = [];

{
	private _class = configName _x;
	
	// TODO traits
	// if ([player, _x] call FUNC(canUse)) then {
		_items pushBack _class;
	// };
} forEach configProperties [configFile >> "DynuloPMCShop", "true", true];

_items
