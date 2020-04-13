#include "script_component.hpp"

LOG("Creating command globally");
[] remoteExec [QFUNC(init), REMOTE_CLIENTS, true];
