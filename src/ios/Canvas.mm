//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "Canvas.h"
#import "UIViewHelper.h"
#import "Thickness.h"

@implementation Canvas

// IHaveProperties.setProperty
- (void) setProperty:(NSString*)propertyName value:(NSObject*)propertyValue {
    if (![UIViewHelper setProperty:self propertyName:propertyName propertyValue:propertyValue]) {
        if ([propertyName compare:@"Panel.Children"] == 0) {
            if (propertyValue == nil) {
                [_children removeListener:self];
                _children = nil;
            }
            else {
                _children = (UIElementCollection*)propertyValue;
                // Listen to collection changes
                [_children addListener:self];
            }
        }
        else {
            throw [NSString stringWithFormat:@"Unhandled property for %@: %@", [self class], propertyName];
        }
    }
}

// IRecieveCollectionChanges.add
- (void) add:(NSObject*)collection item:(NSObject*)item {
    //assert collection == _children;
    [self addSubview:(UIView*)item];
    [UIViewHelper resize:self];
}

// IRecieveCollectionChanges.removeAt
- (void) removeAt:(NSObject*)collection index:(int)index {
    //assert collection == _children;
    UIView* view = [self subviews][index];
    [view removeFromSuperview];
    [UIViewHelper resize:self];
}

- (CGSize) sizeThatFits:(CGSize)size {
    CGSize desiredSize = size;

    // UIViewHelper.resize must be called on each child for correct layout behavior
    double maxWidth = 0;
    double maxHeight = 0;
    unsigned long count = _children.Count;
    for (unsigned long i = 0; i < count; i++) {
        UIView* child = _children[i];
        if (child != nil) {
            // Start out with each child as its natural size
            [UIViewHelper resize:child];

            double width = child.bounds.size.width;
            double height = child.bounds.size.height;
            
            // Retrieve the properties relevant for Canvas layout
            NSNumber*  explicitTop  = [child.layer valueForKey:@"Canvas.Top"];
            NSNumber*  explicitLeft = [child.layer valueForKey:@"Canvas.Left"];
            Thickness* margin       = [child.layer valueForKey:@"Ace.Margin"];
            
            if (explicitTop != nil) {
                height += [(NSNumber*)explicitTop floatValue];
            }
            if (explicitLeft != nil) {
                width += [(NSNumber*)explicitLeft floatValue];
            }
            if (margin != nil) {
                width += margin.left + margin.right;
                height += margin.top + margin.bottom;
            }

            // Keep track of max width and height
            if (width > maxWidth)
                maxWidth = width;
            if (height > maxHeight)
                maxHeight = height;
        }
    }
        
    // Size to content if auto width or height.
    // This is important for input events to travel to children.
    // Explicit width/height is taken care of externally.
    NSNumber* explicitWidth = [self.layer valueForKey:@"Ace.Width"];
    NSNumber* explicitHeight = [self.layer valueForKey:@"Ace.Height"];    
    if (explicitWidth == nil || explicitHeight == nil) {
        // Apply the calculated width/height
        CGFloat finalWidth  = (explicitWidth == nil)  ? maxWidth  : [explicitWidth intValue];
        CGFloat finalHeight = (explicitHeight == nil) ? maxHeight : [explicitHeight intValue];
        desiredSize = CGSizeMake(finalWidth, finalHeight);
    }

    // Now we've got the entire size
    return desiredSize;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    unsigned long count = _children.Count;

    for (unsigned long i = 0; i < count; i++) {
        UIView* child = _children[i];
        if (child != nil) {
            float top = 0;
            float left = 0;
            float width = child.bounds.size.width;
            float height = child.bounds.size.height;

            // Retrieve the properties relevant for Canvas layout
            NSNumber*  explicitTop  = [child.layer valueForKey:@"Canvas.Top"];
            NSNumber*  explicitLeft = [child.layer valueForKey:@"Canvas.Left"];
            Thickness* margin       = [child.layer valueForKey:@"Ace.Margin"];
            
            if (explicitTop != nil) {
                top = [(NSNumber*)explicitTop floatValue];
            }
            if (explicitLeft != nil) {
                left = [(NSNumber*)explicitLeft floatValue];
            }
            if (margin != nil) {
                left += margin.left;
                top += margin.top;
            }
            
            child.frame = CGRectMake(left, top, width, height);
        }
    }
}

@end
