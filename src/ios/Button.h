//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "IHaveProperties.h"
#import "IFireEvents.h"
#import "Handle.h"

@interface Button : UIButton <IHaveProperties, IFireEvents>
{
    int _clickHandlers;
    AceHandle* _handle;
}
@end
