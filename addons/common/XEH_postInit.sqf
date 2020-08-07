#include "script_component.hpp"

addMissionEventHandler ["ExtensionCallback", {
    params ["_name", "_function", "_data"];

    if !((tolower _name) isEqualTo "dynulo_pmc_log") exitWith {};
	LOG_SYS(_function,_data);
}];
