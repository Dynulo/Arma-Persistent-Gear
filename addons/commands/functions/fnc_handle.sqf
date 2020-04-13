#include "script_component.hpp"

params ["_args", "_player"];

if !(isServer) exitWith {};
if !((_args select 0) isEqualTo "pmc") exitWith {};

switch (_args select 1) do {
	case "version": {
		MSG("0.1.0");
	};
	case "register": {
		USAGE(1, "register [code]");
	};
	case "status": {
		MSG("Unimplemented");
	};
	case "help": {
		MSG("version | register | status");
	};
};
