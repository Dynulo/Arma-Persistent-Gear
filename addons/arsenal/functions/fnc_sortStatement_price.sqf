#include "script_component.hpp"
/*
 * Author: Brett
 * Statement to sort items by their price
 *
 * Arguments:
 * 0: Item Config <CONFIG>
 *
 * Return Value:
 * Sorting Value <NUMBER>
 *
 * Public: No
*/

params ["_itemCfg"];

private _class = configName _itemCfg;

[_class] call FUNC(item_price)