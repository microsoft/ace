//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "IHaveProperties.h"
#import "IFireEvents.h"
#import "Handle.h"

@interface ToggleSwitch : UIView <IHaveProperties, IFireEvents>
{
    UILabel* _header;
    UISwitch* _switch;

    int _isOnChangedHandlers;
    AceHandle* _handle;
}

@property UIEdgeInsets padding;

@end
