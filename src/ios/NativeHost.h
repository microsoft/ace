//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <Cordova/CDVPlugin.h>

// Bring in any custom code included by the app
#define SYSTEM_VERSION_GREATER_THAN(v) ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedDescending)
#if defined(__has_include)
#if __has_include("../../../../../native/ios/CustomCode.h")
#include "../../../../../native/ios/CustomCode.h"
#endif
#endif

@interface NativeHost : CDVPlugin

- (void)initialize:(CDVInvokedUrlCommand*)command;
- (void)send:(CDVInvokedUrlCommand*)command;
- (void)setPopupsCloseOnHtmlNavigation:(CDVInvokedUrlCommand*)command;
- (void)loadXbf:(CDVInvokedUrlCommand*)command;

@end
