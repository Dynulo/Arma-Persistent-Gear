class ace_arsenal_sorts {
    class sortBase;

    class GVAR(price): sortBase {
        scope = 2;
        displayName = "Sort by price";
        tabs[] = {{0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17}, {0,1,2,3,4,5,6,7}};
        statement = QUOTE(_this call FUNC(sortStatement_price));
    };

    class GVAR(owned): sortBase {
        scope = 2;
        displayName = "Sort by owned";
        tabs[] = {{0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17}, {0,1,2,3,4,5,6,7}};
        statement = QUOTE(_this call FUNC(sortStatement_owned));
    };
};
