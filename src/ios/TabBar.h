//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "Color.h"
#import "IHaveProperties.h"
#import "IRecieveCollectionChanges.h"
#import "CommandBarElementCollection.h"

@interface TabBar : UITabBar <UITabBarDelegate, IHaveProperties, IRecieveCollectionChanges>
{
    @public
	CommandBarElementCollection* items;
}
@end
