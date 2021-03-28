#include "script_component.hpp"
/*
 * Author: Brett
 * Statement to sort items by the quantity owned
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

[_class] call FUNC(locker_quantity)