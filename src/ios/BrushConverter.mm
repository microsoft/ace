//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "BrushConverter.h"
#import "Parsers.h"

@implementation BrushConverter

+ (Brush*)parse:(NSString*)text {
    return [Parsers ParseBrush:text];
}

@end
