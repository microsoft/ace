//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "UIViewHelper.h"
#import "GridLength.h"
#import "Color.h"
#import "Thickness.h"
#import "Utils.h"
#import "Page.h"
#import "Frame.h"
#import "CommandBar.h"
#import "RectUtils.h"

@implementation UIViewHelper

+ (BOOL) setProperty:(UIView*)instance propertyName:(NSString*)propertyName propertyValue:(NSObject*)propertyValue {
    bool handled = false;
    if ([propertyName hasSuffix:@".Content"]) {
        if (propertyValue == nil) {
            // Remove all subviews
            [[instance subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            // Clear button text
            if ([instance isKindOfClass:[UIButton class]])
                [(UIButton*)instance setTitle:@"" forState:UIControlStateNormal];
        }
        else if ([propertyValue isKindOfClass:[NSString class]]) {
            if ([instance isKindOfClass:[UIButton class]])
                [(UIButton*)instance setTitle:(NSString*)propertyValue forState:UIControlStateNormal];
            else
                throw [NSString stringWithFormat:@"NYI string content on non-Button %@", [instance description]];
        }
        else if ([propertyValue isKindOfClass:[UIView class]]) {
            // Remove all subviews
            [[instance subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
            [instance addSubview:(UIView*)propertyValue];

            // When we're setting content on the root view, respect the title/appbar
            // and always make it fill the view controller
            UIViewController* viewController = [Frame getNavigationController].topViewController;
            if (instance == viewController.view) {

                // Fill the view controller (TODO: applicationFrame here and then fix elsewhere?)
                ((UIView*)propertyValue).frame = [UIScreen mainScreen].bounds;

                if ([propertyValue isKindOfClass:[Page class]]) {
                    Page* p = (Page*)propertyValue;
                    if (p.frameTitle != nil) {
                        [Frame ShowNavigationBar];
                        [viewController setTitle:p.frameTitle];
                    }
                    if ([p getTopAppBar] != nil) {
                        [CommandBar showNavigationBar:[p getTopAppBar] on:[Frame getNavigationController].topViewController animated:false];
                    }
                    //TODO: Hide navbar if no title and no topappbar
                    [CommandBar showTabBar:[p getBottomAppBar] on:[Frame getNavigationController].topViewController animated:false];
                }
                else {
                    [Frame HideNavigationBar];
                    //TODO: App bar, too
                }
            }

            handled = true;
        }
        else {
            if ([instance isKindOfClass:[UIButton class]])
                [(UIButton*)instance setTitle:[propertyValue description] forState:UIControlStateNormal];
            else
                throw [NSString stringWithFormat:@"NYI non-string, non-UIView content on non-Button %@", [instance description]];
        }
        handled = true;
    }
    else if ([propertyName hasSuffix:@".Background"]) {
      UIColor* color = [Color fromObject:propertyValue withDefault:nil];
      if (propertyValue == nil) {
          // null background means windowBackground (TODO: need to reset)
      }
      else {
        instance.backgroundColor = color;
      }
      handled = true;
    }
    else if ([propertyName hasSuffix:@".Width"]) {
        if (propertyValue == nil) {
            // Restoring to default value
            [instance.layer setValue:nil forKey:@"Ace.Width"];
            instance.frame = [RectUtils replace:instance.frame width:instance.superview.frame.size.width];
        }
        else {
            //TODO: What about double?
            int value = [(NSNumber*)propertyValue intValue];
            // Record the fact that there's an explicit width
            [instance.layer setValue:[NSNumber numberWithInt:value] forKey:@"Ace.Width"];
            // Update the width
            instance.frame = [RectUtils replace:instance.frame width:value];
        }
        handled = true;
    }
    else if ([propertyName hasSuffix:@".Height"]) {
        if (propertyValue == nil) {
            // Restoring to default value
            [instance.layer setValue:nil forKey:@"Ace.Height"];
            instance.frame = [RectUtils replace:instance.frame height:instance.superview.frame.size.height];
        }
        else {
            //TODO: What about double?
            int value = [(NSNumber*)propertyValue intValue];
            // Record the fact that there's an explicit height
            [instance.layer setValue:[NSNumber numberWithInt:value] forKey:@"Ace.Height"];
            // Update the height
            instance.frame = [RectUtils replace:instance.frame height:value];
        }
        handled = true;
    }
    else if ([propertyName hasSuffix:@".HorizontalAlignment"]) {
        if ([propertyValue isKindOfClass:[NSString class]]) {
            [instance.layer setValue:[(NSString*)propertyValue lowercaseString] forKey:@"Ace.HorizontalAlignment"];
        }
        else {
            throw "NYI: non-string horizontalalignment";
        }
        handled = true;
    }
    else if ([propertyName hasSuffix:@".Margin"]) {
      [instance.layer setValue:[Thickness fromObject:propertyValue] forKey:@"Ace.Margin"];
      handled = true;
    }
    else if ([propertyName hasSuffix:@".Padding"]) {
      Thickness* padding = [Thickness fromObject:propertyValue];
      if ([instance isKindOfClass:[UIButton class]]) {
        ((UIButton*)instance).contentEdgeInsets = UIEdgeInsetsMake(padding.top, padding.left, padding.bottom, padding.right);
        handled = true;
      }
      // Leave Padding unhandled on all other view types
    }
    else if ([propertyName hasSuffix:@".BottomAppBar"]) {
        // This is valid when treating the default root view as a Page
        [CommandBar showTabBar:propertyValue on:[Frame getNavigationController].topViewController animated:false];
        return true; // Don't adjust size based on this
    }
    else if ([propertyName hasSuffix:@".TopAppBar"]) {
        // This is valid when treating the default root view as a Page
        [CommandBar showNavigationBar:(CommandBar*)propertyValue on:[Frame getNavigationController].topViewController animated:false];
        return true; // Don't adjust size based on this
    }
    else if ([propertyName hasSuffix:@".Resources"] || [propertyName hasSuffix:@".Style"]) {
        // Accept this, but don't actually do anything with the object.
        // Resources and styles are handled on the managed side.
        return true; // Don't adjust size based on this
    }
    else if ([propertyName compare:@"Canvas.Left"] == 0) {
        float pos = [(NSNumber*)propertyValue floatValue];
        CGRect newFrame = instance.frame;
        newFrame.origin.x = pos;
        instance.frame = newFrame;
        return true; // Don't adjust size based on this
    }
    else if ([propertyName compare:@"Canvas.Top"] == 0) {
        float pos = [(NSNumber*)propertyValue floatValue];
        CGRect newFrame = instance.frame;
        newFrame.origin.y = pos;
        instance.frame = newFrame;
        return true; // Don't adjust size based on this
    }
    else if ([propertyName compare:@"Grid.Row"] == 0 ||
             [propertyName compare:@"Grid.RowSpan"] == 0 ||
             [propertyName compare:@"Grid.Column"] == 0 ||
             [propertyName compare:@"Grid.ColumnSpan"] == 0) {
        [instance.layer setValue:propertyValue forKey:propertyName];
        return true; // Don't adjust size based on this
    }
    
    //
    // Special sizing of any UIButtons (default padding and height)
    //
    if ([instance isKindOfClass:[UIButton class]]) {
        #define BUTTON_DEFAULT_PADDING 20
        #define BUTTON_MIN_WIDTH 90

        [instance sizeToFit];

        // See if an explicit width/height has been assigned
        NSNumber* w = [instance.layer valueForKey:@"Ace.Width"];
        NSNumber* h = [instance.layer valueForKey:@"Ace.Height"];

        // Add default padding to any dimension without an explicit length,
        // and enforce a min width
        CGFloat width = w == nil ? MAX(instance.frame.size.width + BUTTON_DEFAULT_PADDING, BUTTON_MIN_WIDTH) : [w intValue];
        CGFloat height = h == nil ? instance.frame.size.height + BUTTON_DEFAULT_PADDING : [h intValue];
        instance.frame = [RectUtils replace:instance.frame width:width height:height];
    }

    return handled;
}

@end
