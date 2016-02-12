//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "GridLengthConverter.h"

@implementation GridLengthConverter

+ (GridLength*)parse:(NSString*)text {
    // Normalize
    text = [text lowercaseString];
    text = [text stringByTrimmingCharactersInSet: [NSCharacterSet whitespaceCharacterSet]];

    GridLength* gl = [[GridLength alloc] init];

    if ([text compare:@"auto"] == 0) {
        gl->type = GridUnitTypeAuto;
        gl->gridValue = 1;
        return gl;
    }
    else if ([text hasSuffix:@"*"]) {
        gl->type = GridUnitTypeStar;
        text = [text substringToIndex:text.length - 1];
        if (text.length == 0) {
            // Treat * as 1*, which is needed for the number conversion below
            text = @"1";
        }
    }
    else {
        gl->type = GridUnitTypePixel;
    }

    NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
    numberFormatter.numberStyle = NSNumberFormatterDecimalStyle;
    gl->gridValue = [[numberFormatter numberFromString:text] doubleValue];

    return gl;
}

@end
