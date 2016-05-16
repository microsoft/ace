//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "AceNavigationController.h"
#import "Page.h"
#import "UIViewHelper.h"
#import "Frame.h"

@implementation Page

- (CommandBar*)getTopAppBar {
    return _topAppBar;
}

- (NSObject*)getBottomAppBar {
    return _bottomAppBar;
}

// IHaveProperties.setProperty
- (void) setProperty:(NSString*)propertyName value:(NSObject*)propertyValue {
    if ([propertyName hasSuffix:@".BottomAppBar"]) {
        // TODO: Need to handle invalidations inside buttons, etc.
        _bottomAppBar = propertyValue;
        // TODO: Only do this if the page is already attached
        // [CommandBar showTabBar:_bottomAppBar on:[Frame getNavigationController].topViewController animated:false];
    }
    else if ([propertyName hasSuffix:@".TopAppBar"]) {
        // TODO: Need to handle invalidations inside buttons, etc.
        _topAppBar = (CommandBar*)propertyValue;
        // TODO: Only do this if the page is already attached
        // [CommandBar showNavigationBar:[p getTopAppBar] on:[Frame getNavigationController].topViewController animated:false];
    }
    else if ([propertyName hasSuffix:@".Title"]) {
        _frameTitle = (NSString*)propertyValue;
        // If this is the currently-visible page, update the title now:
        if ([self superview] == [Frame getNavigationController].topViewController.view) {
            [[Frame getNavigationController].topViewController setTitle:_frameTitle];
        }
    }
    else if ([propertyName hasSuffix:@".TintColor"]) {
        UINavigationController* nc = [Frame getNavigationController];
        AceNavigationController* anc = (AceNavigationController *) nc;
        [anc setProperty:propertyName value:propertyValue];
    }
    else if ([propertyName hasSuffix:@".BarTintColor"]) {
        UINavigationController* nc = [Frame getNavigationController];
        AceNavigationController* anc = (AceNavigationController *) nc;
        [anc setProperty:propertyName value:propertyValue];
    }
    else if ([propertyName hasSuffix:@".Content"]) {
        if (_content != nil) {
            [_content removeFromSuperview];
        }
        if (propertyValue != nil) {
            [self addSubview:(UIView*)propertyValue];
        }
        _content = (UIView*)propertyValue;
    }
    else if (![UIViewHelper setProperty:self propertyName:propertyName propertyValue:propertyValue]) {
        throw [NSString stringWithFormat:@"Unhandled property for %@: %@", [self class], propertyName];
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];

    // Make the content fill the page
    if (_content != nil) {
        _content.frame = [UIScreen mainScreen].bounds;
    }
}

@end
