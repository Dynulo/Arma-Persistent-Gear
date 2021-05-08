#include "script_component.hpp"

/*
 * Takes the items from the remote locker
 */

if (EGVAR(main,readOnly)) exitWith {};

params ["_items"];

[EXT, ["locker_take", [getPlayerUID player, str _items]]] remoteExec ["callExtension", REMOTE_SERVER];
