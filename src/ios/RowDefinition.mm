//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "RowDefinition.h"
#import "GridLengthConverter.h"

@implementation RowDefinition

-(id) init {
    self = [super init];

    // Set default to *
    self->height = [[GridLength alloc] init];
    self->height->gridValue = 1;
    self->height->type = GridUnitTypeStar;

    return self;
}

// IHaveProperties.setProperty
- (void) setProperty:(NSString*)propertyName value:(NSObject*)propertyValue {
    if ([propertyName compare:@"RowDefinition.Height"] == 0) {
        if ([propertyValue isKindOfClass:[GridLength class]])
            self->height = (GridLength*)propertyValue;
        else
            self->height = [GridLengthConverter parse:(NSString*)propertyValue];
    }
    else {
        throw [NSString stringWithFormat:@"Unhandled property for %@: %@", [self class], propertyName];
    }
}

@end
