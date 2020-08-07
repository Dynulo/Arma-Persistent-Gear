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

#include "RscAttributes.hpp"
#include "CfgEventHandlers.hpp"
#include "ui\RscDisplayCheckout.hpp"
