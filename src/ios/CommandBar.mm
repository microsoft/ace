//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "CommandBar.h"
#import "AppBarButton.h"
#import "SymbolIcon.h"
#import "BitmapIcon.h"
#import "TabBar.h"
#import "Frame.h"
#import "OutgoingMessages.h"
#import "Utils.h"

@implementation CommandBar

- (CommandBarElementCollection*) getPrimaryCommands {
    return _primaryCommands;
}

- (CommandBarElementCollection*) getSecondaryCommands {
    return _secondaryCommands;
}

// IHaveProperties.setProperty
- (void) setProperty:(NSString*)propertyName value:(NSObject*)propertyValue {
    if ([propertyName hasSuffix:@".PrimaryCommands"]) {
        _primaryCommands = (CommandBarElementCollection*)propertyValue;
    }
    else if ([propertyName hasSuffix:@".SecondaryCommands"]) {
        _secondaryCommands = (CommandBarElementCollection*)propertyValue;
    }
    else {
        throw [NSString stringWithFormat:@"Unhandled property for %@: %@", [self class], propertyName];
    }
}

+ (void)showNavigationBar:(CommandBar*)bar on:(UIViewController*)viewController animated:(BOOL)animated {
    [Frame ShowNavigationBar];

    UINavigationItem* navItem = viewController.navigationItem;
    [CommandBar addNavigationItems:bar on:navItem];
}

+ (void)showTabBar:(NSObject*)bar on:(UIViewController*)viewController animated:(BOOL)animated {
    if (bar == nil) {
        // Hide the current toolbar / tabbar
        [viewController.navigationController setToolbarHidden:true animated:animated];
        TabBar* tb = [viewController.view.layer valueForKey:@"Ace.TabBar"];
        if (tb != nil) {
            [tb removeFromSuperview];
        }
        return;
    }

    if ([bar isKindOfClass:[TabBar class]]) {
        [CommandBar showTabBarTabBar:(TabBar*)bar on:viewController animated:animated];
    }
    else {
        [CommandBar showTabBarToolBar:(CommandBar*)bar on:viewController animated:animated];
    }
}

+ (void)addNavigationItems:(CommandBar*)bar on:(UINavigationItem*)navigationItem {
    NSMutableArray* primaryItems = [[NSMutableArray alloc] init];
    NSMutableArray* secondaryItems = [[NSMutableArray alloc] init];

    //
    // PrimaryCommands
    //
    ObservableCollection* primaryCommands = [bar getPrimaryCommands];
    if (primaryCommands != nil) {
        unsigned long primaryItemsCount = primaryCommands.Count;

        for (unsigned long i = 0; i < primaryItemsCount; i++) {
            id command = primaryCommands[i];
            UIBarButtonItem* item = nil;

            if ([command isKindOfClass:[AppBarButton class]]) {
                AppBarButton* abb = (AppBarButton*)command;
                if (true) { //TODO: if visible
                    if ([abb.Icon isKindOfClass:[SymbolIcon class]] || abb.Icon == nil)
                    {
                        if (abb.hasSystemIcon)
                            item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:abb.systemIcon target:abb action:@selector(onClick:)];
                        else
                            item = [[UIBarButtonItem alloc] initWithTitle:abb.Label style:UIBarButtonItemStylePlain target:abb action:@selector(onClick:)];
                    }
                    else if ([abb.Icon isKindOfClass:[BitmapIcon class]]) {
                        NSString* source = ((BitmapIcon*)abb.Icon).UriSource;
                        // TODO: Need util:
                        UIImage* image;
                        if ([source hasPrefix:@"ms-appx:///"]) {
                            image = [UIImage imageNamed:[source substringFromIndex:11]];
                        }
                        else if ([source containsString:@"://"]) {
                            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:source]]];
                        }
                        else {
                            image = [UIImage imageNamed:source];
                        }

                        item = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:abb action:@selector(onClick:)];
                    }
                    else
                        throw @"Unhandled AppBarButton icon type";
                }
            }
            else {
                throw @"Unhandled command bar item type";
            }

            if (item != nil) {
                [primaryItems addObject:item];
            }
        }
    }
    
    navigationItem.rightBarButtonItems = primaryItems;
    
    //
    // SecondaryCommands
    //
    ObservableCollection* secondaryCommands = [bar getSecondaryCommands];
    if (secondaryCommands != nil) {
        unsigned long secondaryItemsCount = secondaryCommands.Count;

        for (unsigned long i = 0; i < secondaryItemsCount; i++) {
            id command = secondaryCommands[i];
            UIBarButtonItem* item = nil;

            if ([command isKindOfClass:[AppBarButton class]]) {
                AppBarButton* abb = (AppBarButton*)command;
                if (true) { //TODO: if visible
                    if ([abb.Icon isKindOfClass:[SymbolIcon class]] || abb.Icon == nil)
                    {
                        if (abb.hasSystemIcon)
                            item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:abb.systemIcon target:abb action:@selector(onClick:)];
                        else
                            item = [[UIBarButtonItem alloc] initWithTitle:abb.Label style:UIBarButtonItemStylePlain target:abb action:@selector(onClick:)];
                    }
                    else if ([abb.Icon isKindOfClass:[BitmapIcon class]]) {
                        NSString* source = ((BitmapIcon*)abb.Icon).UriSource;
                        // TODO: Need util:
                        UIImage* image;
                        if ([source hasPrefix:@"ms-appx:///"]) {
                            image = [UIImage imageNamed:[source substringFromIndex:11]];
                        }
                        else if ([source containsString:@"://"]) {
                            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:source]]];
                        }
                        else {
                            image = [UIImage imageNamed:source];
                        }

                        item = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:abb action:@selector(onClick:)];
                    }
                    else
                        throw @"Unhandled AppBarButton icon type";
                }
            }
            else {
                throw @"Unhandled command bar item type";
            }

            if (item != nil) {
                [secondaryItems addObject:item];
            }
        }
    }
    
    navigationItem.leftBarButtonItems = secondaryItems;
}

+ (void)showTabBarToolBar:(CommandBar*)bar on:(UIViewController*)viewController animated:(BOOL)animated {
    [viewController.navigationController setToolbarHidden:false animated:animated];

    if (viewController.toolbarItems != nil) {
        return;
    }

    NSMutableArray* items = [[NSMutableArray alloc] init];

    //
    // SecondaryCommands
    //
    if ([bar getSecondaryCommands] != nil) {
        // TODO
    }

    //
    // Then space
    //
    UIBarButtonItem* flexBar = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [items addObject:flexBar];

    //
    // Then PrimaryCommands
    //
    ObservableCollection* primaryCommands = [bar getPrimaryCommands];
    if (primaryCommands != nil) {
        unsigned long primaryItemsCount = primaryCommands.Count;

        for (unsigned long i = 0; i < primaryItemsCount; i++) {
            id command = primaryCommands[i];
            UIBarButtonItem* item = nil;

            if ([command isKindOfClass:[AppBarButton class]]) {
                AppBarButton* abb = (AppBarButton*)command;
                if (true) { //TODO: if visible
                    if ([abb.Icon isKindOfClass:[SymbolIcon class]] || abb.Icon == nil)
                    {
                        if (abb.hasSystemIcon)
                            item = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:abb.systemIcon target:abb action:@selector(onClick:)];
                        else
                            item = [[UIBarButtonItem alloc] initWithTitle:abb.Label style:UIBarButtonItemStylePlain target:abb action:@selector(onClick:)];
                    }
                    else if ([abb.Icon isKindOfClass:[BitmapIcon class]]) {
                        NSString* source = ((BitmapIcon*)abb.Icon).UriSource;
                        // TODO: Need util:
                        UIImage* image;
                        if ([source hasPrefix:@"ms-appx:///"]) {
                            image = [UIImage imageNamed:[source substringFromIndex:11]];
                        }
                        else if ([source containsString:@"://"]) {
                            image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:source]]];
                        }
                        else {
                            image = [UIImage imageNamed:source];
                        }

                        item = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStylePlain target:abb action:@selector(onClick:)];
                    }
                    else
                        throw @"Unhandled AppBarButton icon type";
                }
            }
            else {
                throw @"Unhandled command bar item type";
            }

            if (item != nil) {
                [items addObject:item];

                // Add space after all but the last item
                if (i < primaryItemsCount-1) {
                    // For centering and stretching
                    UIBarButtonItem* flexBarTemp = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
                    [items addObject:flexBarTemp];
                }
            }
        }
    }

    // For centering and stretching
    UIBarButtonItem* flexBar2 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    [items addObject:flexBar2];

    viewController.toolbarItems = items;
}

+ (void)showTabBarTabBar:(TabBar*)bar on:(UIViewController*)viewController animated:(BOOL)animated {
    [viewController.view addSubview:(TabBar*)bar];

    // Remember the tab bar
    [viewController.view.layer setValue:bar forKey:@"Ace.TabBar"];

    NSMutableArray* tabs = [[NSMutableArray alloc] init];

    ObservableCollection* items = bar->items;
    if (items != nil) {
        unsigned long itemsCount = items.Count;

        for (unsigned long i = 0; i < itemsCount; i++) {
            id command = items[i];
            UITabBarItem* tab = nil;

            if ([command isKindOfClass:[AppBarButton class]]) {
                AppBarButton* abb = (AppBarButton*)command;
                if (true) { //TODO: if visible
                    if ([abb.Icon isKindOfClass:[SymbolIcon class]] || abb.Icon == nil) {
                        if (abb.hasSystemIcon)
                            tab = [[UITabBarItem alloc] initWithTabBarSystemItem:abb.systemIcon tag:i];
                        else
                            tab = [[UITabBarItem alloc] initWithTitle:abb.Label image:nil tag:i];
                    }
                    else if ([abb.Icon isKindOfClass:[BitmapIcon class]]) {
                        NSString* source = ((BitmapIcon*)abb.Icon).UriSource;
                        NSString* sourceOn = [source stringByReplacingOccurrencesOfString:@"{platform}" withString:@"ios-on"];
                        NSString* sourceOff = [source stringByReplacingOccurrencesOfString:@"{platform}" withString:@"ios-off"];
                        UIImage* onImage = [Utils getImage:sourceOn];
                        UIImage* offImage = [Utils getImage:sourceOff];
                        if (offImage == nil) {
                            offImage = [Utils getImage:source];
                        }
                        tab = [[UITabBarItem alloc] initWithTitle:abb.Label image:offImage tag:i];
                        tab.selectedImage = onImage;
                    }
                    else if (abb.Icon == nil) {
                        tab = [[UITabBarItem alloc] initWithTitle:abb.Label image:nil tag:i];
                    }
                    else
                        throw @"Unhandled AppBarButton icon type";
                }
            }
            else {
                throw @"Unhandled command bar item type";
            }

            if (tab != nil) {
                [tabs addObject:tab];
            }
        }
        [bar setItems:tabs animated:animated];

        if (tabs.count > 0) {
            // Automatically select the first tab, which happens automatically on Android
            bar.selectedItem = (UITabBarItem*)tabs[0];
            [OutgoingMessages raiseEvent:@"click" instance:items[0] eventData:nil];
        }
    }

    // Refresh layout
    [viewController.navigationController viewWillLayoutSubviews];
}

@end
