//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "NativeEventAttacher.h"
#import "OutgoingMessages.h"

@implementation NativeEventAttacher

- (id)initWithInstance:(UIControl*)instance event:(NSString*)eventName {
    self = [super init];
    _instance = instance;
    _event = eventName;

    if ([eventName compare:@"UIControlEventValueChanged"] == 0) { //TODO ignore case
        [instance addTarget:self action:@selector(onEvent) forControlEvents:UIControlEventValueChanged];
    }
    else {
        throw @"Unhandled event type";
    }

    // Keep this alive
    [instance.layer setValue:self forKey:@"Ace.NativeEventAttacher"];

    return self;
}

//TODO: detach

- (void)onEvent {
    [OutgoingMessages raiseEvent:_event instance:_instance eventData:nil];
}

@end
