//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "Parsers.h"
#import "KnownColors.h"
#import "SolidColorBrush.h"

@implementation Parsers

const int s_zeroChar = (int) '0';
const int s_aLower   = (int) 'a';
const int s_aUpper   = (int) 'A';

+ (int) ParseHexChar:(char) c {
    int intChar = (int) c;

    if ((intChar >= s_zeroChar) && (intChar <= (s_zeroChar+9))) {
        return (intChar-s_zeroChar);
    }

    if ((intChar >= s_aLower) && (intChar <= (s_aLower+5))) {
        return (intChar-s_aLower + 10);
    }

    if ((intChar >= s_aUpper) && (intChar <= (s_aUpper+5))) {
        return (intChar-s_aUpper + 10);
    }

    throw @"Illegal token";
}

+ (UIColor*) ParseHexColor:(NSString*) trimmedColor {
    float a,r,g,b;
    a = 255;

    if ([trimmedColor length] > 7) {
        a = [Parsers ParseHexChar:[trimmedColor characterAtIndex:1]] * 16 + [Parsers ParseHexChar:[trimmedColor characterAtIndex:2]];
        r = [Parsers ParseHexChar:[trimmedColor characterAtIndex:3]] * 16 + [Parsers ParseHexChar:[trimmedColor characterAtIndex:4]];
        g = [Parsers ParseHexChar:[trimmedColor characterAtIndex:5]] * 16 + [Parsers ParseHexChar:[trimmedColor characterAtIndex:6]];
        b = [Parsers ParseHexChar:[trimmedColor characterAtIndex:7]] * 16 + [Parsers ParseHexChar:[trimmedColor characterAtIndex:8]];
    }
    else if ([trimmedColor length] > 5) {
        r = [Parsers ParseHexChar:[trimmedColor characterAtIndex:1]] * 16 + [Parsers ParseHexChar:[trimmedColor characterAtIndex:2]];
        g = [Parsers ParseHexChar:[trimmedColor characterAtIndex:3]] * 16 + [Parsers ParseHexChar:[trimmedColor characterAtIndex:4]];
        b = [Parsers ParseHexChar:[trimmedColor characterAtIndex:5]] * 16 + [Parsers ParseHexChar:[trimmedColor characterAtIndex:6]];
    }
    else if ([trimmedColor length] > 4) {
        a = [Parsers ParseHexChar:[trimmedColor characterAtIndex:1]];
        a = a + a*16;
        r = [Parsers ParseHexChar:[trimmedColor characterAtIndex:2]];
        r = r + r*16;
        g = [Parsers ParseHexChar:[trimmedColor characterAtIndex:3]];
        g = g + g*16;
        b = [Parsers ParseHexChar:[trimmedColor characterAtIndex:4]];
        b = b + b*16;
    }
    else {
        r = [Parsers ParseHexChar:[trimmedColor characterAtIndex:1]];
        r = r + r*16;
        g = [Parsers ParseHexChar:[trimmedColor characterAtIndex:2]];
        g = g + g*16;
        b = [Parsers ParseHexChar:[trimmedColor characterAtIndex:3]];
        b = b + b*16;
    }

    return [UIColor colorWithRed:r/255 green:g/255 blue:b/255 alpha:a/255];
}

+ (UIColor*) ParseColor:(NSString*) color {
    bool isPossibleKnownColor;
    bool isNumericColor;
    bool isScRgbColor;
    bool isContextColor;
    NSString* trimmedColor = [KnownColors MatchColor:color isKnownColor:&isPossibleKnownColor isNumericColor:&isNumericColor isContextColor:&isContextColor isScRgbColor:&isScRgbColor];

    if (!isPossibleKnownColor &&
        !isNumericColor &&
        !isScRgbColor &&
        !isContextColor) {
        throw @"Illegal token";
    }

    if (isNumericColor) {
        return [Parsers ParseHexColor: trimmedColor];
    }
    else if (isContextColor) {
        throw @"NYI: Context colors";
    }
    else if (isScRgbColor) {
        throw @"NYI: ScRgb colors";
    }
    else {
        // TODO: iOS-specific color customizations (not all):
        if ([trimmedColor compare:@"darkGray" options:NSCaseInsensitiveSearch] == 0)
            return [UIColor darkGrayColor];
        else if ([trimmedColor compare:@"lightGray" options:NSCaseInsensitiveSearch] == 0)
            return [UIColor lightGrayColor];
//                else if ([trimmedColor compare:@"green" options:NSCaseInsensitiveSearch] == 0)
//                    return [UIColor greenColor];
        else if ([trimmedColor compare:@"blue" options:NSCaseInsensitiveSearch] == 0)
            return [UIColor blueColor];
        else if ([trimmedColor compare:@"orange" options:NSCaseInsensitiveSearch] == 0)
            return [UIColor orangeColor];
        else if ([trimmedColor compare:@"purple" options:NSCaseInsensitiveSearch] == 0)
            return [UIColor purpleColor];
        else if ([trimmedColor compare:@"brown" options:NSCaseInsensitiveSearch] == 0)
            return [UIColor brownColor];
        else if ([trimmedColor compare:@"darkGray" options:NSCaseInsensitiveSearch] == 0)
            return [UIColor darkGrayColor];

        // SEL colorName = NSSelectorFromString([NSString stringWithFormat:@"%@Color", [text lowercaseString]]);
        //return [UIColor performSelector:colorName];

        trimmedColor = [KnownColors ColorStringToKnownColor:trimmedColor];
        return [Parsers ParseHexColor: trimmedColor];
    }
}

+ (Brush*) ParseBrush:(NSString*) brush {
    return [[SolidColorBrush alloc] initWithColor:[Parsers ParseColor:brush]];
}

@end
