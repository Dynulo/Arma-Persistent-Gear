#include "script_component.hpp"

class CfgPatches {
  class ADDON {
    name = QUOTE(COMPONENT);
    units[] = {};
    weapons[] = {};
    requiredVersion = REQUIRED_VERSION;
    requiredAddons[] = {"pmc_main", "ace_arsenal"};
    author = "SynixeBrett";
    VERSION_CONFIG;
  };
};

#include "AceArsenalSorts.hpp"
#include "CfgEventHandlers.hpp"
#include "RscAttributes.hpp"
#include "ui\RscDisplayCheckout.hpp"
