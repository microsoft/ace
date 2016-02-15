//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "IncomingMessages.h"
#import "Dictionary.h"
#import "IHaveProperties.h"
#import "IFireEvents.h"
#import "Handle.h"
#import "Utils.h"
#import "UIViewHelper.h"
#import "UILabelHelper.h"
#import "ItemCollection.h"
#import "Frame.h"
#import "SolidColorBrush.h"
#import "BrushConverter.h"
#import "NativeEventAttacher.h"
#import "AcePluginManager.h"

AcePluginManager* _pluginManager = nil;

@implementation IncomingMessages

// Create an object instance
+ (NSObject*)create:(NSArray*)message {
    NSString* typeName = message[2];

    // Remove any namespace
    if ([typeName containsString:@"."]) {
        NSRange range = [typeName rangeOfString:@"." options:NSBackwardsSearch];
        typeName = [typeName substringFromIndex:range.location + 1];
    }

    // Special construction of button
    if ([typeName compare:@"UIButton"] == 0) {
        // Required for getting the right visual behavior:
        return [UIButton buttonWithType:UIButtonTypeSystem];
    }

    NSObject* instance = nil;
    if ([message count] > 3) {
        // Parameterized constructor
        throw @"NYI: parameterized constructor";
    }
    else {
        // Default constructor
        instance = [[NSClassFromString(typeName) alloc] init];
    }

    if (instance == nil) {
        throw [NSString stringWithFormat:@"Unable to instantiate a class named '%@'", typeName];
    }

    return instance;
}

// Get an existing well-known object instance
+ (NSObject*)getInstance:(NSArray*)message webView:(UIWebView*)webView viewController:(UIViewController*)viewController {
    NSString* typeName = message[2];

    if ([typeName compare:@"HostPage"] == 0) {
        return [Frame getNavigationController].topViewController.view;
    }
    else if ([typeName compare:@"HostWebView"] == 0) {
        return webView;
    }
    else if ([typeName compare:@"UINavigationController"] == 0) {
        return [Frame getNavigationController];
    }
    else if ([typeName compare:@"PluginManager"] == 0) {
        // Create on-demand
        if (_pluginManager == nil) {
            _pluginManager = [[AcePluginManager alloc] initWithViewController:viewController];
        }
        return _pluginManager;
    }
    else if ([typeName compare:@"CurrentModalRoot"] == 0) {
        UIViewController* c = [Frame getNavigationController].presentedViewController;
        if (c == nil) {
            throw @"There is no current modal content. Did you attempt to get it too soon?";
        }
        return c.view;
    }
    else if ([typeName compare:@"CurrentModalContent"] == 0) {
        UIViewController* c = [Frame getNavigationController].presentedViewController;
        if (c == nil) {
            throw @"There is no current modal content. Did you attempt to get it too soon?";
        }
        return c.view.subviews[0];
    }

    throw [NSString stringWithFormat:@"%@ is not a valid choice for getting an existing instance", typeName];
}

+ (BOOL)tryReflection:(NSObject*)instance propertyName:(NSString*)propertyName propertyValue:(NSObject*)propertyValue {
    NSString* setterName = nil;
    try {
        if ([propertyName containsString:@"."]) {
            NSRange range = [propertyName rangeOfString:@"." options:NSBackwardsSearch];
            setterName = [NSString stringWithFormat:@"set%@", [propertyName substringFromIndex:range.location + 1]];
        }
        else {
            setterName = [NSString stringWithFormat:@"set%@", propertyName];
        }

        //TODO: Need to do more permissive parameter matching in this case since everything will be strings
        //      Handle as a loose matching option in util, like Android. But need to discover signature types
        //      instead of doing it like below.
        if ([propertyValue isKindOfClass:[NSString class]]) {
            NSString* p = [(NSString*)propertyValue lowercaseString];
            try {
                int value = [Utils parseInt:p];
                propertyValue = [NSNumber numberWithInt:value];
            }
            catch (NSString* ex) {
                if ([p compare:@"true"] == 0) {
                    propertyValue = [NSNumber numberWithBool:true];
                }
                else if ([p compare:@"false"] == 0) {
                    propertyValue = [NSNumber numberWithBool:false];
                }
                else {
                    try {
                        Brush* brush = [BrushConverter parse:p];
                        if ([brush isKindOfClass:[SolidColorBrush class]]) {
                            propertyValue = [((SolidColorBrush*)brush) Color];
                        }
                    }
                    catch (NSString* ex) {}
                }
            }
        }

        [Utils invokeInstanceMethod:instance methodName:setterName args:[NSArray arrayWithObject:propertyValue]];
    }
    catch (NSException* ex) {
        return false;
    }
    catch (NSString* ex) {
        return false;
    }
    return true;
}

+ (void)set:(NSArray*)message {
    NSObject* instance = [AceHandle deserialize:message[1]];
    NSString* propertyName = message[2];
    NSObject* propertyValue = message[3];

    // Convert non-primitives (TODO arrays)
    if ([propertyValue isKindOfClass:[NSDictionary class]]) {
        propertyValue = [Utils deserializeObjectOrStruct:(NSDictionary*)propertyValue];
    }
    else if ([propertyValue isKindOfClass:[NSNull class]]) {
        propertyValue = nil;
    }

    if ([instance conformsToProtocol:@protocol(IHaveProperties)]) {
        NSObject<IHaveProperties>* ihp = (NSObject<IHaveProperties>*)instance;
        [ihp setProperty:propertyName value:propertyValue];
    }
    else {
        // Try reflection. So XXX.YYY maps to a setYYY method.
        if (![IncomingMessages tryReflection:instance propertyName:propertyName propertyValue:propertyValue]) {
            //
            // Translate standard cross-platform (XAML) properties for well-known base types
            //
            if ([instance isKindOfClass:[UILabel class]]) {
                if ([propertyName hasSuffix:@".Children"] && [propertyValue isKindOfClass:[ItemCollection class]]) {
                    // This is from XAML compilation of a custom content property, which always gives an ItemCollection.
                    propertyName = @"ContentControl.Content";
                    if ([(ItemCollection*)propertyValue Count] == 1) {
                        propertyValue = ((ItemCollection*)propertyValue)[0];
                    }
                }
                if (![UILabelHelper setProperty:(UILabel*)instance propertyName:propertyName propertyValue:propertyValue]) {
                    throw [NSString stringWithFormat:@"Unhandled property for a custom UILabel: %@. Implement IHaveProperties to support this.", propertyName];
                }
            }
            else if ([instance isKindOfClass:[UIView class]]) {
                if ([propertyName hasSuffix:@".Children"] && [propertyValue isKindOfClass:[ItemCollection class]]) {
                    // This is from XAML compilation of a custom content property, which always gives an ItemCollection.
                    propertyName = @"ContentControl.Content";
                    if ([(ItemCollection*)propertyValue Count] == 1) {
                        propertyValue = ((ItemCollection*)propertyValue)[0];
                    }
                }
                if (![UIViewHelper setProperty:(UIView*)instance propertyName:propertyName propertyValue:propertyValue]) {
                    throw [NSString stringWithFormat:@"Unhandled property for a custom UIView: %@. Implement IHaveProperties to support this.", propertyName];
                }
            }
            else {
                throw [NSString stringWithFormat:@"Either there must be a set%@ method, or IHaveProperties must be implemented.", propertyName];
            }
        }
    }
}

+ (NSObject*)invoke:(NSArray*)message {
    NSObject* instance = [AceHandle deserialize:message[1]];
    NSString* methodName = message[2];
    NSArray* array = message[3];
    return [Utils invokeInstanceMethod:instance methodName:methodName args:array];
}

+ (NSObject*)staticInvoke:(NSArray*)message {
    NSString* typeName = message[1];
    NSString* methodName = message[2];
    NSArray* array = message[3];

    // Remove any namespace
    if ([typeName containsString:@"."]) {
        NSRange range = [typeName rangeOfString:@"." options:NSBackwardsSearch];
        typeName = [typeName substringFromIndex:range.location + 1];
    }

    return [Utils invokeStaticMethod:typeName methodName:methodName args:array];
}

+ (void)eventAdd:(NSArray*)message {
    AceHandle* handle = [AceHandle fromJSON:message[1]];
    NSObject* instance = [handle toObject];
    NSString* eventName = message[2];

    //TODO: We don't need to send the handle to anyone because every instance will have the
    //      Ace.Handle layer property set
    if ([instance conformsToProtocol:@protocol(IFireEvents)]) {
        NSObject<IFireEvents>* ife = (NSObject<IFireEvents>*)instance;
        [ife addEventHandler:eventName handle:handle];
    }
    else if ([instance isKindOfClass:[UIControl class]]) {
        NativeEventAttacher* attacher = [[NativeEventAttacher alloc] initWithInstance:instance event:eventName];
    }
    else {
        throw [NSString stringWithFormat:@"Attaching handler for %@, but it's not recognized and %@ doesn't support IFireEvents.", eventName, [instance description]];
    }
}

+ (void)navigate:(UIView*)view {
    [Frame goForward:view];
}

@end
