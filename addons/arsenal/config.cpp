#include "script_component.hpp"

class CfgPatches {
  class ADDON {
    name = QUOTE(COMPONENT);
    units[] = {};
    weapons[] = {};
    requiredVersion = REQUIRED_VERSION;
    requiredAddons[] = {"synixe_main", "ace_arsenal"};
    author = "SynixeBrett";
    VERSION_CONFIG;
  };
};

#include "RscAttributes.hpp"
#include "\dynulo\pmc\addons\common\CfgEventHandlers.hpp"
