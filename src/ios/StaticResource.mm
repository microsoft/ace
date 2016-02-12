//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "StaticResource.h"

@implementation StaticResource

// IHaveProperties.setProperty
- (void) setProperty:(NSString*)propertyName value:(NSObject*)propertyValue {
    if ([propertyName compare:@"StaticResource.ResourceKey"] == 0) {
        // Ignore. This is handled on the managed side.
    }
    else {
        throw [NSString stringWithFormat:@"Unhandled property for %@: %@", [self class], propertyName];
    }
}

@end
