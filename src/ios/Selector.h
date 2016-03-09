//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "ItemsControl.h"
#import "IFireEvents.h"

@interface Selector : ItemsControl <IFireEvents>
{
    int _selectionChangedHandlers;
}

@property int SelectedIndex;
@property id SelectedItem;

@end
