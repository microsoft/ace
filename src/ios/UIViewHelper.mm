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
            [UIViewHelper replaceContentIn:instance with:(UIView*)propertyValue];
        }
        else {
            if ([instance isKindOfClass:[UIButton class]])
                [(UIButton*)instance setTitle:[propertyValue description] forState:UIControlStateNormal];
            else
                throw [NSString stringWithFormat:@"NYI non-string, non-UIView content on non-Button %@", [instance description]];
        }
        return true;
    }
    else if ([propertyName hasSuffix:@".Background"]) {
      UIColor* color = [Color fromObject:propertyValue withDefault:nil];
      if (propertyValue == nil) {
          // null background means windowBackground (TODO: need to reset)
      }
      else {
        instance.backgroundColor = color;
      }
      return true;
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
        return true;
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
        return true;
    }
    else if ([propertyName hasSuffix:@".HorizontalAlignment"]) {
        if ([propertyValue isKindOfClass:[NSString class]]) {
            [instance.layer setValue:[(NSString*)propertyValue lowercaseString] forKey:@"Ace.HorizontalAlignment"];
        }
        else {
            throw "NYI: non-string HorizontalAlignment";
        }
        return true;
    }
    else if ([propertyName hasSuffix:@".VerticalAlignment"]) {
        if ([propertyValue isKindOfClass:[NSString class]]) {
            [instance.layer setValue:[(NSString*)propertyValue lowercaseString] forKey:@"Ace.VerticalAlignment"];
        }
        else {
            throw "NYI: non-string VerticalAlignment";
        }
        return true;
    }
    else if ([propertyName hasSuffix:@".Margin"]) {
      [instance.layer setValue:[Thickness fromObject:propertyValue] forKey:@"Ace.Margin"];
      return true;
    }
    else if ([propertyName hasSuffix:@".Padding"]) {
      Thickness* padding = [Thickness fromObject:propertyValue];
      if ([instance isKindOfClass:[UIButton class]]) {
        ((UIButton*)instance).contentEdgeInsets = UIEdgeInsetsMake(padding.top, padding.left, padding.bottom, padding.right);
        return true;
      }
      // Leave Padding unhandled on all other view types
    }
    else if ([propertyName hasSuffix:@".BottomAppBar"]) {
        // This is valid when treating the default root view as a Page
        [CommandBar showTabBar:propertyValue on:[Frame getNavigationController].topViewController animated:false];
        return true;
    }
    else if ([propertyName hasSuffix:@".TopAppBar"]) {
        // This is valid when treating the default root view as a Page
        [CommandBar showNavigationBar:(CommandBar*)propertyValue on:[Frame getNavigationController].topViewController animated:false];
        return true;
    }
    else if ([propertyName hasSuffix:@".Resources"] || [propertyName hasSuffix:@".Style"]) {
        // Accept this, but don't actually do anything with the object.
        // Resources and styles are handled on the managed side.
        return true;
    }
    // Attached layout properties
    else if ([propertyName compare:@"Canvas.Left"] == 0 ||
             [propertyName compare:@"Canvas.Top"] == 0 ||
             [propertyName compare:@"Grid.Row"] == 0 ||
             [propertyName compare:@"Grid.RowSpan"] == 0 ||
             [propertyName compare:@"Grid.Column"] == 0 ||
             [propertyName compare:@"Grid.ColumnSpan"] == 0) {
        [instance.layer setValue:propertyValue forKey:propertyName];
        // TODO: Invalidate relevant layout
        return true;
    }
    else if ([propertyName hasSuffix:@".Uid"]) {
        instance.accessibilityIdentifier = (NSString*)propertyValue;
        return true;
    }
    
    return false;
}

// Takes care of applying explict width/height to override natural size
+ (void) resize:(UIView*)view {
    // First resize to natural size
    [view sizeToFit];
    // Then set explicit width and/or height if applicable
    NSNumber* explicitWidth = [view.layer valueForKey:@"Ace.Width"];
    NSNumber* explicitHeight = [view.layer valueForKey:@"Ace.Height"];    
    if (explicitWidth != nil) {
        view.frame = [RectUtils replace:view.frame width:[explicitWidth intValue]];
    }
    if (explicitHeight != nil) {
        view.frame = [RectUtils replace:view.frame height:[explicitHeight intValue]];
    }
}

+ (void) replaceContentIn:(UIView*)view with:(UIView*)content {

    // Remove all subviews
    [[view subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // Add the new content
    [view addSubview:(UIView*)content];

    // When we're setting content on a root view, respect the title/appbar
    // and always make it fill the view controller

    // Must do this instead of superview, which gives internal classes like UIViewControllerWrapperView
    UIResponder* parent = [view nextResponder];
    if ([parent isKindOfClass:[UIViewController class]]) {
        UIViewController* viewController = (UIViewController*)parent;
        UINavigationController* navigationController = [Utils getParentNavigationController:viewController];

        // Fill the view controller (TODO: applicationFrame here and then fix elsewhere?)
        content.frame = [UIScreen mainScreen].bounds;
        
        // More needs to happen to support doing this on external NavigationControllers,
        // so limit to the main one:
        if (navigationController == [Frame getNavigationController]) {
            if ([content isKindOfClass:[Page class]]) {
                Page* p = (Page*)content;
                if (p.frameTitle != nil) {
                    navigationController.navigationBarHidden = false;
                    [viewController setTitle:p.frameTitle];
                }
                if ([p getTopAppBar] != nil) {
                    [CommandBar showNavigationBar:[p getTopAppBar] on:viewController animated:false];
                }
                //TODO: Hide navbar if no title and no topappbar
                [CommandBar showTabBar:[p getBottomAppBar] on:viewController animated:false];
            }
            else {
                navigationController.navigationBarHidden = true;
                //TODO: App bar, too
            }
        }
    }
}

@end
