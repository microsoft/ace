//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "IHaveProperties.h"
#import "IRecieveCollectionChanges.h"
#import "UIElementCollection.h"

@interface Canvas : UIView <IHaveProperties, IRecieveCollectionChanges>
{
	UIElementCollection* _children;
}
@end
