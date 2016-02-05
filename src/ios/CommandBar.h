//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "IHaveProperties.h"
#import "CommandBarElementCollection.h"

@interface CommandBar : NSObject <IHaveProperties>
{
    CommandBarElementCollection* _primaryCommands;
    CommandBarElementCollection* _secondaryCommands;
}

- (CommandBarElementCollection*) getPrimaryCommands;
- (CommandBarElementCollection*) getSecondaryCommands;

+ (void)showNavigationBar:(CommandBar*)bar on:(UIViewController*)viewController animated:(BOOL)animated;
+ (void)showTabBar:(NSObject*)bar on:(UIViewController*)viewController animated:(BOOL)animated;

@end
