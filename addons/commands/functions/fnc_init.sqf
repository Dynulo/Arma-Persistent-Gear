#include "script_component.hpp"

INFO("Creating dynulo command");
["dynulo", {
	[_this, player] remoteExec [QFUNC(handle), REMOTE_SERVER];
}, "all"] call CBA_fnc_registerChatCommand;
