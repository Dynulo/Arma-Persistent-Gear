#include "script_component.hpp"

/*
 * Stores the items in the remote locker
 */

if (EGVAR(main,readOnly)) exitWith {};

params ["_items"];

[EXT, ["locker_store", [getPlayerUID player, str _items]]] remoteExec ["callExtension", REMOTE_SERVER];
