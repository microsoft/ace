//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
enum MessageTypes {
    MSG_CREATE = 0,
    MSG_SET = 1,
    MSG_INVOKE = 2,
    MSG_EVENTADD = 3,
    MSG_EVENTREMOVE = 4,
    MSG_STATICINVOKE = 5,
    MSG_FIELDGET = 6,
    MSG_STATICFIELDGET = 7,
    MSG_GETINSTANCE = 8,
    MSG_NAVIGATE = 9,
    MSG_FIELDSET = 10
};

@interface IncomingMessages : NSObject

+ (NSObject*)create:(NSArray*)message;
+ (void)set:(NSArray*)message;
+ (NSObject*)invoke:(NSArray*)message;
+ (NSObject*)staticInvoke:(NSArray*)message;
+ (NSObject*)getInstance:(NSArray*)message webView:(UIWebView*)webView viewController:(UIViewController*)viewController;
+ (void)eventAdd:(NSArray*)message;
+ (void)navigate:(UIView*)view;

@end
