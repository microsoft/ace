//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "OutgoingMessages.h"
#import <Cordova/CDVCommandDelegate.h>
#import <objc/message.h>

@implementation OutgoingMessages

NSObject* _callback;
SEL _selector;

+ (void) setCallbackContext:(NSObject*)callback selector:(SEL)selector {
    _callback = callback;
    _selector = selector;
}

+ (void) raiseEvent:(NSString*)eventName instance:(NSObject*)instance eventData:(NSObject*) eventData {
    NSArray* array = [NSArray arrayWithObjects:
        instance == nil ? nil : [[AceHandle fromObject:instance] toJSON],
        eventName, eventData, nil];
    [self send:array];
}

+ (void) raiseEvent:(NSString*)eventName instance:(NSObject*)instance eventData:(NSObject*) eventData eventData2:(NSObject*) eventData2 {
    NSArray* array = [NSArray arrayWithObjects:
        instance == nil ? nil : [[AceHandle fromObject:instance] toJSON],
        eventName, eventData, eventData2, nil];
    [self send:array];
}

// TODO: Remove this. Every instance will have Ace.Handle layer property.
+ (void) raiseEvent:(NSString*)eventName handle:(AceHandle*)handle eventData:(NSObject*) eventData {
    NSArray* array;
    if (handle == nil) {
        array = [NSArray arrayWithObjects:
            [NSNumber numberWithInt:-1] /*Because otherwise array is terminated!*/,
            eventName, eventData, nil];
    }
    else {
        array = [NSArray arrayWithObjects:
            [handle toJSON],
            eventName, eventData, nil];
    }
    [self send:array];
}

+ (void) send:(NSArray*)data {
    objc_msgSend(_callback, _selector, data);
}

@end
