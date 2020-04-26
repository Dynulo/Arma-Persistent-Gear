#include "script_component.hpp"

["Dynulo PMC", "Payment", {
    params ["","_object"];
	if (_object isEqualTo objNull || {!(isPlayer _object)}) exitWith {};
    [
        format ["Payment - %1", name _object],
        [["SLIDER","Payment Amount",[1,5000,1000,0],0],["EDIT","Reason"]],
        {
            params ["_values", "_args"];
            _values params ["_amount", "_reason"];
            _args params ["_object"];
            private _current = _object getVariable [QEGVAR(arsenal,balance), 3000];
            _object setVariable [QEGVAR(arsenal,balance), _current + _amount, true];
			[EXT, ["transaction", [getPlayerUID player, _reason, _amount]]] remoteExec ["callExtension", REMOTE_SERVER];
        },{},[_object]
    ] call zen_dialog_fnc_create;
}] call zen_custom_modules_fnc_register;

["Dynulo PMC", "Fine", {
    params ["","_object"];
	if (_object isEqualTo objNull || {!(isPlayer _object)}) exitWith {};
    [
        format ["Fine - %1", name _object],
        [["SLIDER","Fine Amount",[1,5000,200,0],0],["EDIT","Reason"]],
        {
            params ["_values", "_args"];
            _values params ["_amount", "_reason"];
            _args params ["_object"];
            private _current = _object getVariable [QEGVAR(arsenal,balance), 3000];
            _object setVariable [QEGVAR(arsenal,balance), _current - _amount, true];
			[EXT, ["transaction", [getPlayerUID player, _reason, 0 - _amount]]] remoteExec ["callExtension", REMOTE_SERVER];
        },{},[_object]
    ] call zen_dialog_fnc_create;
}] call zen_custom_modules_fnc_register;

["Dynulo PMC", "Refresh Items", {
	[EXT, "get_items"] remoteExec ["callExtension", REMOTE_SERVER];
}] call zen_custom_modules_fnc_register;
