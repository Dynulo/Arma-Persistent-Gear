#include "script_component.hpp"

class CfgPatches {
    class ADDON {
        name = QUOTE(COMPONENT);
        units[] = {};
        weapons[] = {};
        requiredVersion = REQUIRED_VERSION;
        requiredAddons[] = {"persistent_gear_main", "ace_arsenal"};
        author = "AUTHOR";
        VERSION_CONFIG;
    };
};

#include "AceArsenalSorts.hpp"
#include "Cfg3DEN.hpp"
#include "CfgEventHandlers.hpp"
#include "RscAttributes.hpp"
#include "ui\RscDisplayCheckout.hpp"
