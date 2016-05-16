//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "Color.h"
#import "BrushConverter.h"
#import "SolidColorBrush.h"

#define UIColorFromARGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:((float)((rgbValue & 0xFF000000) >> 24))/255.0];

@implementation Color

+ (UIColor*)fromObject:(NSObject*)value withDefault:(UIColor*)defaultValue {
    if (value == nil) {
        return defaultValue;
    }
    else if ([value isKindOfClass:[NSNumber class]]) {
        // It's a raw color value
        return UIColorFromARGB([(NSNumber*)value intValue]);
    }
    else if ([value isKindOfClass:[NSString class]]) {
        NSString* stringValue = (NSString *)value;
        if ([stringValue hasPrefix:@"#"]) {
            unsigned rgbValue = 0;
            NSScanner *scanner = [NSScanner scannerWithString:stringValue];
            [scanner setScanLocation:1]; // bypass '#' character
            [scanner scanHexInt:&rgbValue];
            return [UIColor colorWithRed:((rgbValue & 0xFF0000) >> 16)/255.0 green:((rgbValue & 0xFF00) >> 8)/255.0 blue:(rgbValue & 0xFF)/255.0 alpha:1.0];
        }
        else {
            Brush* brush = [BrushConverter parse:stringValue];
            return ((SolidColorBrush*)brush).Color;
        }
    }
    else if ([value isKindOfClass:[SolidColorBrush class]]) {
        return ((SolidColorBrush*)value).Color;
    }
    else {
        throw [NSString stringWithFormat:@"Cannot get a color from unsupported object type %@", object_getClassName(value)];
    }
}

@end
