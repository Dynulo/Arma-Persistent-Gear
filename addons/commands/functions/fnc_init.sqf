#include "script_component.hpp"

LOG("Creating command");
["dynulo", {
	[_this, player] remoteExec [QFUNC(handle), REMOTE_SERVER];
}, "adminLogged"] call CBA_fnc_registerChatCommand;
