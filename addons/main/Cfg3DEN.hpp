class Cfg3DEN {
	class Object {
		class AttributeCategories {
			class DynuloPMC {
				displayName = "Dynulo PMC";
				class Attributes {
					class Shop {
						//--- Mandatory properties
						displayName = "Shop";
						tooltip = "Add a PMC shop via ACE";
						property = QGVAR(attribute_shop);
						control = "Checkbox";

						//--- Optional
						expression = QUOTE(if(_value)then{EGVAR(arsenal,boxes) pushBack _this});
						defaultValue = false;
					};
				};
			};
		};
	};
};
