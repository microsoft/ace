//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "HyperlinkButton.h"
#import "OutgoingMessages.h"

@implementation HyperlinkButton

- (id)init {
    // Required for getting the right visual behavior:
    self = [HyperlinkButton buttonWithType:UIButtonTypeSystem];

    [self addTarget:self action:@selector(navigate:) forControlEvents:UIControlEventTouchUpInside];
    return self;
}

- (void)navigate:(id)sender {
    if (_uri != nil) {
        [OutgoingMessages raiseEvent:@"ace.navigate" handle:nil eventData:_uri];
    }
}

// IHaveProperties.setProperty
- (void) setProperty:(NSString*)propertyName value:(NSObject*)propertyValue {
    if ([propertyName compare:@"HyperlinkButton.NavigateUri"] == 0) {
        _uri = (NSString*)propertyValue;
    }
    else {
        [super setProperty:propertyName value:propertyValue];
    }
}

@end
