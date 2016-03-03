//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "AcePluginManager.h"
#import <Cordova/CDVViewController.h>

@implementation AcePluginManager

- (id)initWithViewController:(UIViewController*)viewController {
    self = [super init];
    _viewController = viewController;
    return self;
}

- (NSObject*)getPlugin:(NSString*)pluginName {
    CDVViewController* cordovaViewController = (CDVViewController*)_viewController;
    return [cordovaViewController getCommandInstance:pluginName];
}

@end
