//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "Frame.h"
#import "AceNavigationController.h"
#import "AceViewController.h"
#import "Page.h"

@implementation Frame

UINavigationController* _navigationController;

+ (UINavigationController*)getNavigationController {
    if (_navigationController == nil) {
        // Grab the current root UIViewController and wrap it in our UINavigationController
        UIWindow* window = [UIApplication sharedApplication].keyWindow;
        UIViewController* currentViewController = window.rootViewController;
        window.rootViewController = nil;
        _navigationController = [[AceNavigationController alloc] initWithRootViewController:currentViewController];

        // Make the host view white instead of black
        currentViewController.view.backgroundColor = [UIColor whiteColor];
        // Ensure the status bar looks as expected
        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

        // Make the UINavigationController the new root view controller
        window.rootViewController = _navigationController;
    }
    return _navigationController;
}

+ (void)goForward:(UIView*)view {
    UINavigationController* navigationController = [Frame getNavigationController];

    // Place the content in a new UIViewController
    AceViewController* newPageController =
        [[AceViewController alloc] initWithContent:view
                                        navigationController:navigationController];

    // Navigate to the new content
    [navigationController pushViewController:newPageController animated:true];
}

+ (void)GoBack {
    UINavigationController* navigationController = [Frame getNavigationController];
    [navigationController popViewControllerAnimated:true];

    UIView* rootView = navigationController.topViewController.view;
    UIView* firstChild = nil;
    if ([rootView.subviews count] > 0) {
        firstChild = rootView.subviews[0];
    }

    if (([rootView isKindOfClass:[Page class]] && ((Page*)rootView).frameTitle != nil) ||
        ([firstChild isKindOfClass:[Page class]] && ((Page*)firstChild).frameTitle != nil)) {
        navigationController.navigationBarHidden = false;
    }
    else {
        navigationController.navigationBarHidden = true;
    }
}

+ (void)ShowNavigationBar {
    UINavigationController* navigationController = [Frame getNavigationController];
    navigationController.navigationBarHidden = false;
}

+ (void)HideNavigationBar {
    UINavigationController* navigationController = [Frame getNavigationController];
    navigationController.navigationBarHidden = true;
}

@end
