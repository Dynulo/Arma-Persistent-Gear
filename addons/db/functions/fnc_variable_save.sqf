#include "script_component.hpp"

params ["_uid", "_name", "_value"];

EXT callExtension ["save_variables", [_uid, str [[_name, _value]]]];
