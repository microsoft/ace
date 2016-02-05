//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "Handle.h"

@interface NativeEventAttacher : NSObject
{
    UIControl* _instance;
    NSString* _event;
}

- (id)initWithInstance:(UIControl*)instance event:(NSString*)eventName;

@end
