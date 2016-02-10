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

    // Default property values
    _isVertical = true;
    // TODO: Set these to false when Width/Height are set:
    _autoWidth = true;
    _autoHeight = true;

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
        else {
            throw [NSString stringWithFormat:@"Unhandled property for %s: %@", object_getClassName(self), propertyName];
        }
    }
}

// IRecieveCollectionChanges.add
- (void) add:(NSObject*)collection item:(NSObject*)item {
    //assert collection == _children;
    [self addSubview:(UIView*)item];
}

// IRecieveCollectionChanges.removeAt
- (void) removeAt:(NSObject*)collection index:(int)index {
    //assert collection == _children;
    UIView* view = [self subviews][index];
    [view removeFromSuperview];
}

- (void)layoutSubviews {
    [super layoutSubviews];

    unsigned long count = _children.Count;

    // Size to content if auto width or height
    if (_autoWidth || _autoHeight) {
        double maxChildWidth = 0;
        double maxChildHeight = 0;
        double totalWidth = 0;
        double totalHeight = 0;
        for (unsigned long i = 0; i < count; i++) {
            UIView* child = _children[i];
            if (child != nil) {
                double width = child.bounds.size.width;
                double height = child.bounds.size.height;

                Thickness* t = [child.layer valueForKey:@"Ace.Margin"];
                if (t != nil) {
                    width = width + t.left + t.right;
                    height = height + t.top + t.bottom;
                }

                totalWidth += width;
                totalHeight += height;
                if (width > maxChildWidth)
                    maxChildWidth = width;
                if (height > maxChildHeight)
                    maxChildHeight = height;
            }
        }
        double x = self.frame.origin.x;
        double y = self.frame.origin.y;
        double w = self.frame.size.width;
        double h = self.frame.size.height;
        if (_isVertical) {
            if (_autoWidth && w == 0) {
                // Only update width if the current width was 0
                w = maxChildWidth;
            }
            if (_autoHeight) {
                h = totalHeight;
            }
        }
        else {
            if (_autoWidth) {
                w = totalWidth;
            }
            if (_autoHeight && h == 0) {
                // Only update height if the current height was 0
                h = maxChildHeight;
            }
        }
        self.frame = CGRectMake(x, y, w, h);
    }

    // Now size the children
    double top = 0;
    double left = 0;
    for (unsigned long i = 0; i < count; i++) {
        UIView* child = _children[i];
        if (child != nil) {
            double width = child.bounds.size.width;
            double height = child.bounds.size.height;
            double halignAdjustment = 0;

            Thickness* t = [child.layer valueForKey:@"Ace.Margin"];

            if (_isVertical) {
                width = self.bounds.size.width;

                // TODO: Only handling this one case for now
                NSString* halign = [child.layer valueForKey:@"Ace.HorizontalAlignment"];
                if (halign != nil) {
                    if ([halign compare:@"center"] == 0) {
                        width = child.bounds.size.width;
                        if (t != nil) {
                            halignAdjustment = (self.bounds.size.width - child.bounds.size.width - t.left - t.right) / 2;
                        }
                        else {
                            halignAdjustment = (self.bounds.size.width - child.bounds.size.width) / 2;
                        }
                    }
                }
            }
            else {
                height = self.bounds.size.height;
            }

            if (t != nil) {
                if (_isVertical)
                    child.frame = CGRectMake(left + t.left + halignAdjustment, top + t.top, width - t.right - t.left, height);
                else
                    child.frame = CGRectMake(left + t.left, top + t.top, width, height - t.bottom - t.top);
            }
            else {
                child.frame = CGRectMake(left + halignAdjustment, top, width, height);
            }

            if (_isVertical) {
                top += height;
                if (t != nil) {
                    top = top + t.top + t.bottom;
                }
            }
            else {
                left += width;
                if (t != nil) {
                    left = left + t.left + t.right;
                }
            }
        }
    }
}

@end
