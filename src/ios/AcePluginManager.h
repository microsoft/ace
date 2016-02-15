//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

// Acts like the PluginManager for Cordova's Android implementation
@interface AcePluginManager : NSObject
{
    UIViewController* _viewController;
}

- (id)initWithViewController:(UIViewController*)viewController;

@end
