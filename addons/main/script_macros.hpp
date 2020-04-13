#include "\x\cba\addons\main\script_macros_common.hpp"

#define DFUNC(var1) TRIPLES(ADDON,fnc,var1)

#ifdef DISABLE_COMPILE_CACHE
  #undef PREP
  #define PREP(fncName) DFUNC(fncName) = compile preprocessFileLineNumbers QPATHTOF(functions\DOUBLES(fnc,fncName).sqf)
#else
  #undef PREP
  #define PREP(fncName) [QPATHTOF(functions\DOUBLES(fnc,fncName).sqf), QFUNC(fncName)] call CBA_fnc_compileFunction
#endif

#define BLANK_LOADOUT [[],[],[],[],[],[],"","",[],["","","","","",""]]

// remoteExec
#define REMOTE_GLOBAL   0
#define REMOTE_SERVER   2
#define REMOTE_CLIENTS  -2

// functions
#define REQUIRE_PMC if (getMissionConfigValue ["pmcEnabled", ""] isEqualTo "") exitWith {};
#define NO_HC if !(hasInterface) exitWith { player setVariable [QEGVAR(main,ignore), true, true]; };
