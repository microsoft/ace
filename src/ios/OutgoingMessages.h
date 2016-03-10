//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "Handle.h"

// Used for sending data back (raising events)
@interface OutgoingMessages : NSObject

+ (void) setCallbackContext:(NSObject*)callback selector:(SEL)selector;
+ (void) raiseEvent:(NSString*)eventName instance:(NSObject*)instance eventData:(NSObject*) eventData;
+ (void) raiseEvent:(NSString*)eventName instance:(NSObject*)instance eventData:(NSObject*) eventData eventData2:(NSObject*) eventData2;
+ (void) raiseEvent:(NSString*)eventName handle:(AceHandle*)handle eventData:(NSObject*) eventData;

@end
