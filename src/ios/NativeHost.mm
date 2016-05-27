//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "NativeHost.h"
#import "Handle.h"
#import "IncomingMessages.h"
#import "OutgoingMessages.h"
#import "Frame.h"
#import "Popup.h"

NSString* _callbackId;
BOOL _setting_PopupsCloseOnHtmlNavigation;
BOOL _initialized;
//TODO: NSData* _startupMarkup;

@implementation NativeHost

/* TODO: No point unless XBF parsing is also done in native host
            and instances can be retrieved on managed side without
            caching of property values
- (void)pluginInitialize {
    [super pluginInitialize];

    try {
        _startupMarkup = [self readXbf:@"www/xbf/startup.xbf"];
        // Since a startup markup file exists, detach the WebView
        [self.webView removeFromSuperview];
    }
    catch (NSString* s) {
        // A startup markup file doesn't exist
    }
    catch (NSException* ex) {
        // A startup markup file doesn't exist
    }
}
*/

// Called when the URL of the webview changes
- (BOOL)shouldOverrideLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    if ([[request.URL absoluteString] hasPrefix:@"native://"] || [[request.URL absoluteString] hasPrefix:@"ios://"]) {
        [OutgoingMessages raiseEvent:@"ace.navigate" handle:nil eventData:[request.URL absoluteString]];
        return true;
    }
    else if (_setting_PopupsCloseOnHtmlNavigation) {
        // This is an HTML navigation.
        // Close all popups since this has been requested.
        [Popup CloseAll];
    }
    
    // Before Cordova 4.0, we must return false in order for HTML navigation to work.
    // Starting with Cordova 4.0, we must return true.
    // The __CORDOVA_4_0_0 constant isn't used so this still compiles with older versions
    // that don't have it defined.
    return CORDOVA_VERSION_MIN_REQUIRED >= 40000 /*__CORDOVA_4_0_0*/;
}

- (void)initialize:(CDVInvokedUrlCommand*)command {
    _callbackId = command.callbackId;
    [OutgoingMessages setCallbackContext:self selector:@selector(sendOutgoingMessage:)];

    // Make the background white instead of black for the sake of the status bar
    self.webView.backgroundColor = [UIColor whiteColor];

    if (!_initialized) {
        // Force wrapping in nav controller now for consistent status bar appearance
        UINavigationController* navigationController = [Frame getNavigationController];
        navigationController.navigationBarHidden = true;

        /* TODO
        if (_startupMarkup != nil) {
            // Send the bytes back to the managed side.
            // Do it directly instead of using OutgoingMessages.raiseEvent
            // Because otherwise it gets marshaled as an array instead of an ArrayBuffer
            CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArrayBuffer:_startupMarkup];
            [pluginResult setKeepCallbackAsBool:YES];
            [self.commandDelegate sendPluginResult:pluginResult callbackId:_callbackId];
            _startupMarkup = nil;
        }
        */

        _initialized = true;
    }
}

- (void)send:(CDVInvokedUrlCommand*)command {
    NSArray* messages = [command arguments];
    try {
        NSObject* returnValue = nil;
        BOOL hasReturnValue = false; // Needed because nil can be a valid return value
        NSUInteger numMessages = [messages count];

        for (int i = 0; i < numMessages; i++)
        {
            NSObject* instance = nil;
            AceHandle* handle;
            NSArray* message = messages[i];
            //NSLog([NSString stringWithFormat:@"TODO: MSG: %@", message]);
            NSNumber* messageType = message[0];

            switch ([messageType intValue]) {
                case MSG_CREATE:
                    instance = [IncomingMessages create:message];
                    handle = [AceHandle fromJSON:message[1]];
                    [handle register:instance];
                    break;
                case MSG_SET:
					[IncomingMessages set:message];
                    break;
                case MSG_INVOKE:
                    returnValue = [IncomingMessages invoke:message];
                    hasReturnValue = true;
                    break;
                case MSG_EVENTADD:
                    [IncomingMessages eventAdd:message];
                    break;
                case MSG_EVENTREMOVE:
                    throw @"EventRemove NYI";
                    //IncomingMessages.eventRemove(message);
                    break;
                case MSG_STATICINVOKE:
                    returnValue = [IncomingMessages staticInvoke:message];
                    hasReturnValue = true;
                    break;
                case MSG_FIELDGET:
                    throw @"You cannot get fields on iOS";
                case MSG_STATICFIELDGET:
                    throw @"You cannot get fields on iOS";
                case MSG_GETINSTANCE:
                    instance = [IncomingMessages getInstance:message webView:self.webView viewController:self.viewController];
                    handle = [AceHandle fromJSON:message[1]];
                    [handle register:instance];
                    break;
                case MSG_NAVIGATE:
                    [IncomingMessages navigate:(UIView*)[AceHandle deserialize:message[1]]];
                    break;
                case MSG_FIELDSET:
                    throw @"You cannot set fields on iOS";
                default:
                    throw [NSString stringWithFormat:@"Unknown message type: %@", messageType];
            }
        }

        if (numMessages == 1 && hasReturnValue) {
            // This is a single (non-batched) invoke with a return value
            // (or a field get).
            // Send it.
            // TODO: Need to handle arrays of primitives/objects as well
            if ([returnValue isKindOfClass:[NSNumber class]]) {
                NSNumber* number = (NSNumber*)returnValue;
                CFNumberType numberType = CFNumberGetType((CFNumberRef)number);
                if (numberType == kCFNumberIntType || numberType == kCFNumberSInt32Type ||
                    numberType == kCFNumberSInt64Type) {
                    CDVPluginResult* r = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsInt:[number intValue]];
                    [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
                }
                else if (numberType == kCFNumberCharType) {
                    CDVPluginResult* r = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:[number boolValue]];
                    [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
                }
                else if (numberType == kCFNumberDoubleType || numberType == kCFNumberFloat32Type ||
                         numberType == kCFNumberFloat64Type) {
                    CDVPluginResult* r = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDouble:[number doubleValue]];
                    [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
                }
                else {
                    throw [NSString stringWithFormat:@"NYI: Unhandled number type: %ld", numberType];
                }
            }
            else if ([returnValue isKindOfClass:[NSString class]]) {
                CDVPluginResult* r = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:(NSString*)returnValue];
                [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
            }
            else if (returnValue == nil) {
                CDVPluginResult* r = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
                [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
            }
            else {
                // Send the object as a handle
                // Use existing handle if this object already has one
                AceHandle* handle = nil; //TODO: Easy to do with "Ace.Handle": = Handle.fromObject(returnValue);
                if (handle == nil) {
                    handle = [[AceHandle alloc] init];
                    [handle register:returnValue];
                }
                CDVPluginResult* r = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:[handle toJSON]];
                [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
            }
        }
        else {
            CDVPluginResult* r = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
            [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
        }
    }
    catch (NSString* s) {
        CDVPluginResult* r = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:s];
        [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
    }
    catch (NSException* ex) {
        NSString* s = [NSString stringWithFormat:@"%@\r\n%@", [ex description], [NSThread callStackSymbols]];
        CDVPluginResult* r = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:s];
        [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
    }
}

- (void)setPopupsCloseOnHtmlNavigation:(CDVInvokedUrlCommand*)command {
        NSNumber* value = [command argumentAtIndex:0];
        _setting_PopupsCloseOnHtmlNavigation = [value boolValue];
        CDVPluginResult* r = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
        [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
}

- (void)loadXbf:(CDVInvokedUrlCommand*)command {
    try {
        NSString* path = [command argumentAtIndex:0];
        NSData* data = [self readXbf:path];

        CDVPluginResult* r = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArrayBuffer:data];
        [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
    }
    catch (NSString* s) {
        CDVPluginResult* r = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:s];
        [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
    }
    catch (NSException* ex) {
        NSString* s = [NSString stringWithFormat:@"%@\r\n%@", [ex description], [NSThread callStackSymbols]];
        CDVPluginResult* r = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:s];
        [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
    }
}

- (NSData*)readXbf:(NSString*)path {
    // Remove the .xbf suffix
    if ([path containsString:@".xbf"]) {
        NSRange range = [path rangeOfString:@".xbf" options:NSBackwardsSearch];
        path = [path substringToIndex:range.location];
    }

    // Get the file contents
    NSString* absolutePath = [[NSBundle mainBundle] pathForResource:path ofType:@"xbf"];
    if (absolutePath == nil) {
        throw [NSString stringWithFormat:@"Compiled markup file %@.xbf does not exist.", path];
    }
    NSData* data = [NSData dataWithContentsOfFile:absolutePath];
    if (data == nil) {
        throw [NSString stringWithFormat:@"Could not read compiled markup file %@.xbf", path];
    }
    return data;
}

// Loads an Interface Builder NIB/XIB file
- (void)loadPlatformSpecificMarkup:(CDVInvokedUrlCommand*)command {
    try {
        NSString* path = [command argumentAtIndex:0];
        UIView* content = nil;

        // A NIB/XIB can contain multiple roots
        NSArray* roots = [[NSBundle mainBundle] loadNibNamed:path owner:nil options:nil];

        // Just find the first one that's a UIView
        for (id root in roots) {
            if ([root isKindOfClass:[UIView class]]) {
                content = (UIView*)root;
                break;
            }
        }

        if (content == nil) {
            throw [NSString stringWithFormat:@"Could not find a root UIView inside '%@'", path];
        }

        // Send the object as a handle
        AceHandle* handle = [[AceHandle alloc] init];
        [handle register:content];

        CDVPluginResult* r = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:[handle toJSON]];
        [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
    }
    catch (NSString* s) {
        CDVPluginResult* r = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:s];
        [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
    }
    catch (NSException* ex) {
        NSString* s = [NSString stringWithFormat:@"%@\r\n%@", [ex description], [NSThread callStackSymbols]];
        CDVPluginResult* r = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:s];
        [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
    }
}

// Returns if there is support for ace plugin
- (void)isSupported:(CDVInvokedUrlCommand*)command {
    BOOL isSupported = SYSTEM_VERSION_GREATER_THAN(@"8.0");
    CDVPluginResult* r = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsBool:isSupported];
    [self.commandDelegate sendPluginResult:r callbackId:command.callbackId];
}

- (void) sendOutgoingMessage:(NSArray*)data {
	CDVPluginResult* pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsArray:data];
	[pluginResult setKeepCallbackAsBool:YES];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:_callbackId];
}

@end
