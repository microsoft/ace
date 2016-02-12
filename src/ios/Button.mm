//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "Button.h"
#import "UIViewHelper.h"
#import "UILabelHelper.h"
#import "Utils.h"
#import "Color.h"
#import "FontWeightConverter.h"
#import "OutgoingMessages.h"

@implementation Button

- (id)init {
    // Required for getting the right visual behavior:
    self = [Button buttonWithType:UIButtonTypeSystem];
    return self;
}

// IHaveProperties.setProperty
- (void) setProperty:(NSString*)propertyName value:(NSObject*)propertyValue {
    if (![UIViewHelper setProperty:self propertyName:propertyName propertyValue:propertyValue]) {
        // Must check UIViewHelper first so relevent properties are set on this instance rather than the label.
        // Also check these properties first, so things like Foreground does the right thing.
        // TODO: Or can setTitle be replaced with the other way of setting foreground on titleLabel?
        if ([propertyName hasSuffix:@".Foreground"]) {
            UIColor* color = [Color fromObject:propertyValue withDefault:nil];
            if (color == nil) {
                throw @"Null foreground NYI";
            }
            [self setTitleColor:color forState:UIControlStateNormal];
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
            UIFont* f = [self.titleLabel.font fontWithSize:size];
            [self.titleLabel setFont:f];
        }
        else if ([propertyName hasSuffix:@".FontWeight"]) {
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
            UIFont* f = [UIFont systemFontOfSize:self.titleLabel.font.pointSize weight:weight];
            [self.titleLabel setFont:f];
        }
        // If there was no match, check for UILabel matches on the titleLabel:
        // TODO: Because of this, we should be able to remove the stuff above:
        else if (![UILabelHelper setProperty:self.titleLabel propertyName:propertyName propertyValue:propertyValue]) {
            throw [NSString stringWithFormat:@"Unhandled property for %@: %@", [self class], propertyName];
        }
    }
}

// IFireEvents.addEventHandler
- (void) addEventHandler:(NSString*) eventName handle:(AceHandle*)handle {
    if ([eventName compare:@"click"] == 0) {
        if (_clickHandlers == 0) {
            // Set up the message sending, which goes to all handlers
            _handle = handle;
            [self addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        }
        _clickHandlers++;
    }
}

// IFireEvents.removeEventHandler
- (void) removeEventHandler:(NSString*) eventName {
    if ([eventName compare:@"click"] == 0) {
        _clickHandlers--;
        if (_clickHandlers == 0) {
            // Stop sending messages because nobody is listening
            [self removeTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}

- (CGSize) sizeThatFits:(CGSize)size {
    CGSize desiredSize = [super sizeThatFits:size];

    #define BUTTON_DEFAULT_PADDING 20
    #define BUTTON_MIN_WIDTH 90

    // Add default padding and enforce a min width
    CGFloat width = MAX(desiredSize.width + BUTTON_DEFAULT_PADDING, BUTTON_MIN_WIDTH);
    CGFloat height = desiredSize.height + BUTTON_DEFAULT_PADDING;
    
    return CGSizeMake(width, height);
}

// Note: This is sometimes invoked externally, like by the consumption of AppBarButtons in the view controller:
- (void)onClick:(id)sender {
    [OutgoingMessages raiseEvent:@"click" handle:_handle eventData:nil];
}

@end
