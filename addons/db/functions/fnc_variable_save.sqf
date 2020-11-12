#include "script_component.hpp"

params ["_uid", "_name", "_value"];

if (EGVAR(main,readOnly)) exitWith {};

EXT callExtension ["save_variable", [_uid, _name, _value]];
