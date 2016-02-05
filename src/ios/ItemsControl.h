//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "ItemCollection.h"
#import "IHaveProperties.h"

@interface ItemsControl : UIView<IHaveProperties, UIPickerViewDelegate>
{
    ItemCollection* _Items;
}

@property ItemCollection* Items;

@end
