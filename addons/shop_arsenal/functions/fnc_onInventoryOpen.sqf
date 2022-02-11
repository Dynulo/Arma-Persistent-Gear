#include "script_component.hpp"

/*
 * Author: diwako, Brett
 * Prevent opening the backpack of a unit in the shop
 *
 * Arguments:
 * 0: Unit <OBJECT>
 * 1: Backpack <OBJECT>
 *
 * Return Value:
 * boolean if inventory should be closed
 *
 * Example:
 * [bob, unitBackpack bob] call pmc_arsenal_fnc_onOpenInventory
 *
 * Public: No
 */

params ["_unit", "_backpack"];

private _target = objectParent _backpack;

if (isNull _target) exitWith {false};

if (alive _target && {_target getVariable [QGVAR(inArsenal),false]}) exitWith {
	[{
		!isNull (findDisplay 602)
	},
	{
		(findDisplay 602) closeDisplay 0;
		(format ["%1 is in the Shop", ([getPlayerUID _target] call core_discord_fnc_findMemberFromSteam)#0]) call CBA_fnc_notify;
	},
	[]] call CBA_fnc_waitUntilAndExecute;
};

// return false to open inventory as usual
false
