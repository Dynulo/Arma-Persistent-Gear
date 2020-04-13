class RscControlsGroupNoScrollbars;
class ctrlButton;

class ace_arsenal_display {
	class controls {
		class menuBar: RscControlsGroupNoScrollbars {
			class controls {
				class buttonHide: ctrlButton {
					onButtonClick = QUOTE([ctrlParent (_this select 0)] call FUNC(btnHide_onClick));
				};
			};
		};
	};
};
