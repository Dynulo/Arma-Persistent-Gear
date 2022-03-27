#include "script_component.hpp"

addMissionEventHandler ["HandleDisconnect", {
	params ["_unit", "_id", "_uid", "_name"];
	[{
		deleteVehicle _this;
	}, _unit] call CBA_fnc_execNextFrame;
	false
}];
