//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "UILabelHelper.h"
#import "UIViewHelper.h"
#import "InlineCollection.h"
#import "Utils.h"
#import "Color.h"
#import "FontWeightConverter.h"

@implementation UILabelHelper

+ (BOOL) setProperty:(UILabel*)instance propertyName:(NSString*)propertyName propertyValue:(NSObject*)propertyValue {
    // First look at UILabel-specific properties

    // The .endsWith checks are important for supporting standard properties on custom
    // UILabels. What would have been Control.FontSize would appear as XXXTextView.FontSize.
    if ([propertyName hasSuffix:@".Content"] ||
        [propertyName hasSuffix:@".Text"] ||
        [propertyName hasSuffix:@".Header"]) {
        if ([propertyValue isKindOfClass:[NSString class]] || propertyValue == nil) {
            instance.text = (NSString*)propertyValue;
        }
        else {
            instance.text = [propertyValue description];
        }
        [UIViewHelper resize:instance];
        return true;
    }
    else if ([propertyName hasSuffix:@".Inlines"]) {
        InlineCollection* inlines = (InlineCollection*)propertyValue;
        // TODO: Handling of multiple Runs and with separate formatting
        instance.text = (NSString*)inlines[0];
        [UIViewHelper resize:instance];
        return true;
    }
    else if ([propertyName hasSuffix:@".FontSize"]) {
        double size;
        if ([propertyValue isKindOfClass:[NSNumber class]]) {
            size = [(NSNumber*)propertyValue doubleValue];
        }
        else {
            // TODO: parseDouble instead:
            size = [Utils parseInt:(NSString*)propertyValue];
        }
        UIFont* f = [instance.font fontWithSize:size];
        [instance setFont:f];
        [UIViewHelper resize:instance];
        return true;
    }
    else if ([propertyName hasSuffix:@".FontWeight"]) {
        //TODO: Helper shared with button, etc.
        double weight;
        if ([propertyValue isKindOfClass:[NSNumber class]]) {
            int w = [(NSNumber*)propertyValue intValue];
            switch (w) {
                // NOTE: iOS has reversed meanings of ExtraLight and Thin!
                case 100 /*Thin*/:
                    weight = -0.6;
                    break;
                case 200 /*ExtraLight*/:
                    weight = -0.8;
                    break;
                case 300 /*Light*/:
                    weight = -0.4;
                    break;
                case 350 /*SemiLight*/:
                    // No such setting. Map to Light.
                    weight = -0.4;
                    break;
                case 400 /*Normal*/:
                    weight = 0;
                    break;
                case 500 /*Medium*/:
                    weight = 0.23;
                    break;
                case 600 /*SemiBold*/:
                    weight = 0.3;
                    break;
                case 700 /*Bold*/:
                    weight = 0.4;
                    break;
                case 800 /*ExtraBold*/:
                    weight = 0.56;
                    break;
                case 900 /*Black*/:
                    weight = 0.62;
                    break;
                case 950 /*ExtraBlack*/:
                    // No such setting. Map to Black.
                    weight = 0.62;
                    break;
                default:
                    // Just map to Normal
                    weight = 0;
                    break;
            }
        }
        else {
            // TODO: parseDouble if a number?
            weight = [FontWeightConverter parse:(NSString*)propertyValue];
        }
        UIFont* f = [UIFont systemFontOfSize:instance.font.pointSize weight:weight];
        [instance setFont:f];
        [UIViewHelper resize:instance];
        return true;
    }
    else if ([propertyName hasSuffix:@".FontStyle"]) {
        throw @"NYI: FontStyle";
    }
    else if ([propertyName hasSuffix:@".Foreground"]) {
      UIColor* color = [Color fromObject:propertyValue withDefault:nil];
      if (propertyValue == nil) {
        throw @"Null Foreground NYI";
      }
      instance.textColor = color;
      return true;
    }
    else if ([propertyName hasSuffix:@".HorizontalContentAlignment"]) {
        NSString* alignment = [(NSString*)propertyValue lowercaseString];

        if ([alignment compare:@"center"] == 0) {
            instance.textAlignment = NSTextAlignmentCenter;
        }
        else if ([alignment compare:@"left"] == 0) {
            instance.textAlignment = NSTextAlignmentLeft;
        }
        else if ([alignment compare:@"right"] == 0) {
            instance.textAlignment = NSTextAlignmentRight;
        }
        else if ([alignment compare:@"stretch"] == 0) {
            instance.textAlignment = NSTextAlignmentJustified;
        }
        else {
            throw [NSString stringWithFormat:@"Unknown %@: %@", propertyName, propertyValue];
        }
        return true;
    }
    else if ([propertyName hasSuffix:@".VerticalContentAlignment"]) {
        // TODO: Need to reposition the UILabel, or consider using UITextView
        return true;
    }
    else if ([propertyName hasSuffix:@".TextWrapping"]) {
        NSString* value = [(NSString*)propertyValue lowercaseString];

        if ([value compare:@"wrap"] == 0) {
            instance.numberOfLines = 0;
        }
        else if ([value compare:@"wrapwithoverflow"] == 0) {
            instance.numberOfLines = 0;
        }
        else if ([value compare:@"nowrap"] == 0) {
            instance.numberOfLines = 1;
        }
        else {
            throw [NSString stringWithFormat:@"Unknown %@: %@", propertyName, propertyValue];
        }
        [UIViewHelper resize:instance];
        return true;
    }

    // Now look at properties applicable to all Views
    return [UIViewHelper setProperty:instance propertyName:propertyName propertyValue:propertyValue];
}

@end
