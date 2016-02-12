//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "ItemsControl.h"
#import "UIViewHelper.h"

@implementation ItemsControl

// IHaveProperties.setProperty
- (void) setProperty:(NSString*)propertyName value:(NSObject*)propertyValue {
    if (![UIViewHelper setProperty:self propertyName:propertyName propertyValue:propertyValue]) {
        if ([propertyName compare:@"ItemsControl.Items"] == 0) {
            [self setItems:(ItemCollection*)propertyValue];
        }
        else {
            throw [NSString stringWithFormat:@"Unhandled property for %@: %@", [self class], propertyName];
        }
    }
}

- (ItemCollection*)Items {
    return _Items;
}

-(void) setItems:(ItemCollection*)newValue {
    _Items = newValue;
}

@end
