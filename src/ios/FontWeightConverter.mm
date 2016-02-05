//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "FontWeightConverter.h"

@implementation FontWeightConverter

+ (double)parse:(NSString*)text {
    text = [text lowercaseString];
    // NOTE: iOS has reversed meanings of ExtraLight and Thin!
    if ([text compare:@"thin"] == 0)
        return -0.6;
    if ([text compare:@"extralight"] == 0)
        return -0.8;
    if ([text compare:@"light"] == 0)
        return -0.4;
    if ([text compare:@"semilight"] == 0) // No such setting. Map to Light.
        return -0.4;
    if ([text compare:@"normal"] == 0)
        return 0;
    if ([text compare:@"medium"] == 0)
        return 0.23;
    if ([text compare:@"semibold"] == 0)
        return 0.3;
    if ([text compare:@"bold"] == 0)
        return 0.4;
    if ([text compare:@"extrabold"] == 0)
        return 0.56;
    if ([text compare:@"black"] == 0)
        return 0.62;
    if ([text compare:@"extrablack"] == 0) // No such setting. Map to Black.
        return 0.62;

    throw [NSString stringWithFormat:@"Invalid FontWeight: %@", text];
}

@end
