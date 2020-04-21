#include "script_component.hpp"

params ["_class"];

private _ret = _class;

private _index = EGVAR(db,items) findIf { (toLower (_x select 0)) isEqualTo _class};

if (_index != -1) then {
	_ret = EGVAR(db,items) select _index select 0;
};

_ret
