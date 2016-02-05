//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "SolidColorBrush.h"

@implementation SolidColorBrush

- (id)initWithColor:(UIColor*) color {
    self = [super init];
    if (self) {
        self.Color = color;
    }
    return self;
}

- (UIColor*)Color {
    return _Color;
}
- (void)setColor:(UIColor*)newValue {
    _Color = newValue;
}

@end
