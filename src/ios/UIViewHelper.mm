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
            // TODO: Just remove "Ace.Width" and relayout
            CGRect r = instance.frame;
            instance.frame = CGRectMake(r.origin.x, r.origin.y, instance.superview.frame.size.width, r.size.height);
        }
        else {
            //TODO: What about double?
            int value = [(NSNumber*)propertyValue intValue];

            //TODO: Uniform for all views:
            if ([instance isKindOfClass:[UIButton class]]) {
                [instance.layer setValue:[NSNumber numberWithInt:value] forKey:@"Ace.Width"];
            }
            else {
                CGRect r = instance.frame;
                instance.frame = CGRectMake(r.origin.x, r.origin.y, value, r.size.height);
            }
        }
        handled = true;
    }
    else if ([propertyName hasSuffix:@".Height"]) {
        if (propertyValue == nil) {
            // Restoring to default value
            // TODO: Just remove "Ace.Width" and relayout
            CGRect r = instance.frame;
            instance.frame = CGRectMake(r.origin.x, r.origin.y, r.size.width, instance.superview.frame.size.height);
        }
        else {
            //TODO: What about double?
            int value = [(NSNumber*)propertyValue intValue];

            //TODO: Uniform for all views:
            if ([instance isKindOfClass:[UIButton class]]) {
                [instance.layer setValue:[NSNumber numberWithInt:value] forKey:@"Ace.Height"];
            }
            else {
                CGRect r = instance.frame;
                instance.frame = CGRectMake(r.origin.x, r.origin.y, r.size.width, value);
            }
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

    // TODO: Do for all views, but would still need to detect setting of frame
    if ([instance isKindOfClass:[UIButton class]]) {
        NSNumber* w = [instance.layer valueForKey:@"Ace.Width"];
        NSNumber* h = [instance.layer valueForKey:@"Ace.Height"];
        int buttonPadding = 20;
        int buttonMinWidth = 90;

        [instance sizeToFit];
        if (w != nil || h != nil) {
            CGRect r = instance.frame;
            instance.frame = CGRectMake(r.origin.x, r.origin.y,
                w == nil ? r.size.width + buttonPadding : [w intValue],
                h == nil ? r.size.height + buttonPadding : [h intValue]);
        }
        else {
            // Specific to UIButtons: add some default padding and give a min width,
            //                        so don't use the default size
            CGRect r = instance.frame;
            instance.frame = CGRectMake(r.origin.x, r.origin.y,
                MAX(r.size.width + buttonPadding, buttonMinWidth),
                r.size.height + buttonPadding);
        }
    }

    return handled;
}

@end
