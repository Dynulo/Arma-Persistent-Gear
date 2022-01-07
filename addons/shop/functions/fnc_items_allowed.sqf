#include "script_component.hpp"

params ["_items"];

private _ret = [];

private _me = ([getPlayerUID player] call core_discord_fnc_findMemberFromSteam) select 3;

{
	private _roles = [_x] call FUNC(item_roles);
	if (_roles isEqualTo [] || {count (_my_roles arrayIntersect _roles) > 0}) then {
		_ret pushBack _x;
	};
} forEach _items;

_ret
