enum NavigationMode { NavigationModeNew, NavigationModeBack, NavigationModeForward, NavigationModeRefresh, NavigationModeNone };

@interface AceNavigationController : UINavigationController

    @property enum NavigationMode NavigationMode;
    @property bool InsideNativeInitiatedBackNavigation;

@end
