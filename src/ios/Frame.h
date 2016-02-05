//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
@interface Frame : UIView

+ (UINavigationController*)getNavigationController;
+ (void)goForward:(UIView*)view;
+ (void)GoBack;
+ (void)ShowNavigationBar;
+ (void)HideNavigationBar;

@end
