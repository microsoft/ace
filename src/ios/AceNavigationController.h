//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "IHaveProperties.h"

enum NavigationMode { NavigationModeNew, NavigationModeBack, NavigationModeForward, NavigationModeRefresh, NavigationModeNone };

@interface AceNavigationController : UINavigationController <IHaveProperties>

    @property enum NavigationMode NavigationMode;
    @property bool InsideNativeInitiatedBackNavigation;

@end
