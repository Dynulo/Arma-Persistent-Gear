class Cfg3DEN {
	class Object {
		class AttributeCategories {
			class ADDON {
				displayName = "Commander - Persistent Gear";
				class Attributes {
					class Shop {
						//--- Mandatory properties
						displayName = "Shop";
						tooltip = "Add a shop via ACE Interact";
						property = QGVAR(attribute_shop);
						control = "Checkbox";

						//--- Optional
						expression = QUOTE(if(_value)then{GVAR(shops) pushBack _this});
						defaultValue = QUOTE(false);
					};
				};
			};
		};
	};
};
