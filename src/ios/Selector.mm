//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "Selector.h"

@implementation Selector

- (id)init {
    self = [super init];

    // Default values:
    _selectionChangedHandlers = 0;
    _SelectedIndex = -1;

    return self;
}

// IFireEvents.addEventHandler
- (void) addEventHandler:(NSString*) eventName handle:(AceHandle*)handle {
    if ([eventName compare:@"selectionchanged"] == 0) {
        _selectionChangedHandlers++;
    }
}

// IFireEvents.removeEventHandler
- (void) removeEventHandler:(NSString*) eventName {
    if ([eventName compare:@"selectionchanged"] == 0) {
        _selectionChangedHandlers--;
    }
}

- (id)getSelectedItem {
    return _SelectedItem;
}
- (void)setSelectedItem:(id)SelectedItem {
    _SelectedItem = SelectedItem;
    for (int i = 0; i < [_Items Count]; i++) {
        if (_Items[i] == _SelectedItem) {
            self.SelectedIndex = i;
        }
    }
}

- (int)getSelectedIndex {
    return _SelectedIndex;
}
- (void)setSelectedIndex:(int)SelectedIndex {
    _SelectedIndex = SelectedIndex;
}
@end
