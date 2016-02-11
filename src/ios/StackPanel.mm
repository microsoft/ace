//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "StackPanel.h"
#import "UIViewHelper.h"
#import "Thickness.h"

@implementation StackPanel

- (id) init {
    self = [super init];

    self.padding = UIEdgeInsetsMake(0, 0, 0, 0);

    // Default property values
    _isVertical = true;

    return self;
}

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
        else if ([propertyName compare:@"StackPanel.Orientation"] == 0) {
            if ([[(NSString*)propertyValue lowercaseString] compare:@"horizontal"] == 0) {
                _isVertical = false;
            }
            else {
                _isVertical = true;
            }
        }
        else if ([propertyName hasSuffix:@".Padding"]) {
            Thickness* padding = [Thickness fromObject:propertyValue];
            self.padding = UIEdgeInsetsMake(padding.top, padding.left, padding.bottom, padding.right);
            [self layoutSubviews];
        }
        else {
            throw [NSString stringWithFormat:@"Unhandled property for %s: %@", object_getClassName(self), propertyName];
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
    double maxChildWidth = 0;
    double maxChildHeight = 0;
    double totalWidth = 0;
    double totalHeight = 0;
    unsigned long count = _children.Count;
    for (unsigned long i = 0; i < count; i++) {
        UIView* child = _children[i];
        if (child != nil) {
            // Start out with each child as its natural size
            [UIViewHelper resize:child];
            
            // Apply any margin
            double width = child.bounds.size.width;
            double height = child.bounds.size.height;
            Thickness* margin = [child.layer valueForKey:@"Ace.Margin"];
            if (margin != nil) {
                width = width + margin.left + margin.right;
                height = height + margin.top + margin.bottom;
            }

            // Keep track of total width and height (for the direction of stacking)
            // and max child width and height (for the perpendicular direction)
            totalWidth += width;
            totalHeight += height;
            if (width > maxChildWidth)
                maxChildWidth = width;
            if (height > maxChildHeight)
                maxChildHeight = height;
        }
    }

    // Size to content if auto width or height.
    // Explicit width/height is taken care of externally.
    NSNumber* explicitWidth = [self.layer valueForKey:@"Ace.Width"];
    NSNumber* explicitHeight = [self.layer valueForKey:@"Ace.Height"];    
    if (explicitWidth == nil || explicitHeight == nil) {
        // Apply the calculated width/height based on the orientation
        double w;
        double h;
        if (_isVertical) {
            w = (explicitWidth == nil)  ? maxChildWidth : [explicitWidth intValue];
            h = (explicitHeight == nil) ? totalHeight   : [explicitHeight intValue];
        }
        else {
            w = (explicitWidth == nil)  ? totalWidth     : [explicitWidth intValue];
            h = (explicitHeight == nil) ? maxChildHeight : [explicitHeight intValue];
        }
        
        // Apply any padding
        CGFloat finalWidth = w + self.padding.left + self.padding.right;
        CGFloat finalHeight = h + self.padding.top + self.padding.bottom;
        desiredSize = CGSizeMake(finalWidth, finalHeight);
    }

    // Now we've got the entire size
    return desiredSize;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    unsigned long count = _children.Count;

    double top = self.padding.top;
    double left = self.padding.left;
    for (unsigned long i = 0; i < count; i++) {
        UIView* child = _children[i];
        if (child != nil) {
            double width = child.bounds.size.width;
            double height = child.bounds.size.height;
            double halignAdjustment = 0;

            Thickness* margin = [child.layer valueForKey:@"Ace.Margin"];

            if (_isVertical) {
                width = self.bounds.size.width - self.padding.left - self.padding.right;

                // TODO: Only handling this one case for now
                NSString* halign = [child.layer valueForKey:@"Ace.HorizontalAlignment"];
                if (halign != nil) {
                    if ([halign compare:@"center"] == 0) {
                        double parentWidth = width;
                        width = child.bounds.size.width;
                        if (margin != nil) {
                            halignAdjustment = (parentWidth - width - margin.left - margin.right) / 2;
                            // Add margins to the width, simply because they're going to be subtracted below
                            width += margin.left + margin.right;
                        }
                        else {
                            halignAdjustment = (parentWidth - width) / 2;
                        }
                    }
                }
            }
            else {
                height = self.bounds.size.height - self.padding.top - self.padding.bottom;
            }

            if (margin != nil) {
                if (_isVertical)
                    child.frame = CGRectMake(left + halignAdjustment + margin.left, top + margin.top, width - margin.right - margin.left, height);
                else
                    child.frame = CGRectMake(left + margin.left, top + margin.top, width, height - margin.bottom - margin.top);
            }
            else {
                child.frame = CGRectMake(left + halignAdjustment, top, width, height);
            }

            // Move the top/left pointers
            if (_isVertical) {
                top += height;
                if (margin != nil) {
                    top = top + margin.top + margin.bottom;
                }
            }
            else {
                left += width;
                if (margin != nil) {
                    left = left + margin.left + margin.right;
                }
            }
        }
    }
}

@end
