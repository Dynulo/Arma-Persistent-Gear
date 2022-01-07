#define COMPONENT shop_arsenal
#include "\{{project.mainprefix}}\{{project.prefix}}\addons\main\script_mod.hpp"
#include "defines.hpp"
#include "\z\ace\addons\arsenal\defines.hpp"

// #define DEBUG_MODE_FULL
// #define DISABLE_COMPILE_CACHE

#ifdef DEBUG_ENABLED_SHOP_ARSENAL
    #define DEBUG_MODE_FULL
#endif
    #ifdef DEBUG_SETTINGS_OTHER
    #define DEBUG_SETTINGS DEBUG_SETTINGS_SHOP_ARSENAL
#endif

#include "\{{project.mainprefix}}\{{project.prefix}}\addons\main\script_macros.hpp"
