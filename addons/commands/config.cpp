#include "script_component.hpp"

class CfgPatches {
  class ADDON {
    name = QUOTE(COMPONENT);
    units[] = {};
    weapons[] = {};
    requiredVersion = REQUIRED_VERSION;
    requiredAddons[] = {"pmc_main"};
    author = "SynixeBrett";
    VERSION_CONFIG;
  };
};

#include "CfgEventHandlers.hpp"
