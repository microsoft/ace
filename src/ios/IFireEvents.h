//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "Handle.h"

@protocol IFireEvents <NSObject>

@required
- (void) addEventHandler:(NSString*) eventName handle:(AceHandle*)handle;
- (void) removeEventHandler:(NSString*) eventName;

@end
