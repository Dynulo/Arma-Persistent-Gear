
// Handle ACE Arsenal Events
["ace_arsenal_displayOpened", FUNC(handleDisplayOpened)] call CBA_fnc_addEventHandler;
["ace_arsenal_displayClosed", FUNC(handleDisplayClosed)] call CBA_fnc_addEventHandler;
["ace_arsenal_leftPanelFilled", FUNC(handleLeftPanelFilled)] call CBA_fnc_addEventHandler;
["ace_arsenal_rightPanelFilled", FUNC(handleRightPanelFilled)] call CBA_fnc_addEventHandler;
