#include "script_component.hpp"

params ["_class"];

private _price = 0;

// Check for shop listing
private _shopClass = configFile >> "DynuloPMCShop" >> ([_class] call FUNC(item_listing));
if (isClass _shopClass) exitWith {
	getNumber (_shopClass >> "price")
};

_price
