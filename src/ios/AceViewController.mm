//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "AceViewController.h"
#import "AceNavigationController.h"
#import "Page.h"
#import "CommandBar.h"
#import "Frame.h"

@implementation AceViewController

- (id)initWithContent:(UIView*)view navigationController:(UINavigationController*)navigationController {
    self = [super init];
    self.content = view;

    // Make the default page color white instead of black
    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:view];

    if ([view isKindOfClass:[Page class]] && ((Page*)view).frameTitle != nil) {
        self.title = ((Page*)view).frameTitle;
        navigationController.navigationBarHidden = false;
    }
    else {
        navigationController.navigationBarHidden = true;
    }

    // instead of .bounds to account for status bar (TODO need to handle navigation bar):
    view.frame = [UIScreen mainScreen].applicationFrame;

    return self;
}

// Only works when navigation bar is hidden. The navigation controller handles the other case.
-(UIStatusBarStyle)preferredStatusBarStyle{
/*TODO
    if (theme == Default || theme == Dark)
*/
        return UIStatusBarStyleDefault;
/*  else
        return UIStatusBarStyleLightContent;
*/
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillDisappear:(BOOL)animated {
    if ([self.navigationController.viewControllers indexOfObject:self]==NSNotFound) {

        // We just hooked a back navigation

        [self.navigationController setToolbarHidden:true animated:animated];

        if (((AceNavigationController*)self.navigationController).NavigationMode == NavigationModeNone)
        {
            // This happened via the native navigation bar button, so we need
            // to trigger the managed navigation to keep things in sync!
            ((AceNavigationController*)self.navigationController).InsideNativeInitiatedBackNavigation = true;

            // TODO: Send navigation events
        }
    }

    [super viewWillDisappear:animated];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (((AceNavigationController*)self.navigationController).InsideNativeInitiatedBackNavigation)
    {
        ((AceNavigationController*)self.navigationController).InsideNativeInitiatedBackNavigation = false;
        // TODO: Send navigation events
    }

    if ([self.view.subviews count] > 0 && [self.view.subviews[0] isKindOfClass:[Page class]]) {
        Page* p = (Page*)self.view.subviews[0];

        // Show or hide the toolbar based on the presence of a Page's BottomAppBar
        [CommandBar showTabBar:[p getBottomAppBar] on:self animated:animated];

        // Show or hide the navigation bar based on the presence of a Page's TopAppBar
        // (TODO still need to force show if there's a title)
        if ([p getTopAppBar] != nil)
            [CommandBar showNavigationBar:[p getTopAppBar] on:self animated:animated];

        // Hide the navigation bar if there's no title or top app bar
        if ([p getTopAppBar] == nil && p.frameTitle == nil) {
            [Frame HideNavigationBar];
        }
    }
}

@end
