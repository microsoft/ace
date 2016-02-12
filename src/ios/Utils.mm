//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "Utils.h"
#import "Handle.h"
#import "Thickness.h"
#import "GridLength.h"
#import "ObservableCollection.h"

@implementation Utils

+ (NSObject*) deserializeObjectOrStruct:(NSDictionary*)obj {
    NSString* type = obj[@"_t"];
    if ([type compare:@"H"] == 0) {
        return [AceHandle deserialize:obj];
    }
    else if ([type compare:@"Thickness"] == 0) {
        return [Thickness deserialize:obj];
    }
    else if ([type compare:@"GridLength"] == 0) {
        return [GridLength deserialize:obj];
    }
    else {
        throw [NSString stringWithFormat:@"Unhandled struct type: %@", type];
    }
}

+ (UIImage*) getImage:(NSString*)source {
    if ([source rangeOfString:@"{platform}"].location != NSNotFound) {
        source = [source stringByReplacingOccurrencesOfString:@"{platform}" withString:@"ios"];
    }

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
    return image;
}

+ (NSObject*) invokeStaticMethod:(NSString*)typeName methodName:(NSString*)methodName args:(NSArray*)args {
    return [Utils invokeMethod:NSClassFromString(typeName) methodName:methodName args:args];
}

+ (NSObject*) invokeInstanceMethod:(NSObject*)instance methodName:(NSString*)methodName args:(NSArray*)args {
    return [Utils invokeMethod:instance methodName:methodName args:args];
}

+ (NSObject*) invokeMethod:(NSObject*)target methodName:(NSString*)methodName args:(NSArray*)args {
    // Automatically add the : to the end of the methodName if there's one arg and it's not there
    // This is helpful for cross-platform method invocation
    if ([args count] == 1 && ![methodName hasSuffix:@":"]) {
        methodName = [NSString stringWithFormat:@"%@:", methodName];
    }

    SEL selector = NSSelectorFromString(methodName);

    NSMethodSignature* sig = [target methodSignatureForSelector:selector];

    if (sig == nil) {
        throw [NSString stringWithFormat:@"%@ does not have selector with the name '%@'", [target description], methodName];
    }

    NSInvocation* invocation = [NSInvocation invocationWithMethodSignature:sig];

    [invocation setTarget:target];
    [invocation setSelector:selector];

    // With NSInvocation, argument 0 is the instance, and argument 1 is the selector
    #define SKIP 2

    if (args.count != [sig numberOfArguments] - SKIP)
        throw [NSString stringWithFormat:@"You invoked %@ with %d arguments, but it needs %d", methodName, args.count, [sig numberOfArguments] - SKIP];

    // Process the supplied arguments
    for (int i = 0; i < args.count; i++) {
        id arg = args[i];

        // Primitives have to be unwrapped...
        if ([arg isKindOfClass:[NSNumber class]]) {
            // ...unless the target method wants an id/NSObject/NSNumber.
            //    Then we can just pass the NSNumber.
            const char* declaredType = [sig getArgumentTypeAtIndex:i + SKIP];
            if (strcmp(declaredType, @encode(id)) == 0 ||
                strcmp(declaredType, @encode(NSObject)) == 0 ||
                strcmp(declaredType, @encode(NSNumber)) == 0) {
                [invocation setArgument:&arg atIndex:i + SKIP];
                continue;
            }

            NSNumber* n = (NSNumber*)arg;
            void* buffer;
            const char* type = [n objCType];

            if (strcmp(type, @encode(int)) == 0) {
                buffer = malloc(sizeof(int));
                int value = [n intValue];
                memcpy(buffer, &value, sizeof(int));
            }
            else if (strcmp(type, @encode(BOOL)) == 0) {
                buffer = malloc(sizeof(BOOL));
                BOOL value = [n boolValue];
                memcpy(buffer, &value, sizeof(int));
            }
            else if (strcmp(type, @encode(float)) == 0) {
                buffer = malloc(sizeof(float));
                float value = [n floatValue];
                memcpy(buffer, &value, sizeof(float));
            }
            else if (strcmp(type, @encode(double)) == 0) {
                buffer = malloc(sizeof(double));
                double value = [n doubleValue];
                memcpy(buffer, &value, sizeof(double));
            }
            else if (strcmp(type, @encode(char)) == 0) {
                buffer = malloc(sizeof(char));
                char value = [n charValue];
                memcpy(buffer, &value, sizeof(char));
            }
            else if (strcmp(type, @encode(long)) == 0) {
                buffer = malloc(sizeof(long));
                long value = [n longValue];
                memcpy(buffer, &value, sizeof(long));
            }
            else if (strcmp(type, @encode(long long)) == 0) {
                buffer = malloc(sizeof(long long));
                long long value = [n longLongValue];
                memcpy(buffer, &value, sizeof(long long));
            }
            else if (strcmp(type, @encode(short)) == 0) {
                buffer = malloc(sizeof(short));
                short value = [n shortValue];
                memcpy(buffer, &value, sizeof(short));
            }
            else if (strcmp(type, @encode(unsigned int)) == 0) {
                buffer = malloc(sizeof(unsigned int));
                unsigned int value = [n unsignedIntValue];
                memcpy(buffer, &value, sizeof(unsigned int));
            }
            else if (strcmp(type, @encode(unsigned char)) == 0) {
                buffer = malloc(sizeof(unsigned char));
                unsigned char value = [n unsignedCharValue];
                memcpy(buffer, &value, sizeof(unsigned char));
            }
            else if (strcmp(type, @encode(unsigned long)) == 0) {
                buffer = malloc(sizeof(unsigned long));
                unsigned long value = [n unsignedLongValue];
                memcpy(buffer, &value, sizeof(unsigned long));
            }
            else if (strcmp(type, @encode(unsigned long long)) == 0) {
                buffer = malloc(sizeof(unsigned long long));
                unsigned long long value = [n unsignedLongLongValue];
                memcpy(buffer, &value, sizeof(unsigned long long));
            }
            else if (strcmp(type, @encode(unsigned short)) == 0) {
                buffer = malloc(sizeof(unsigned short));
                unsigned short value = [n unsignedShortValue];
                memcpy(buffer, &value, sizeof(unsigned short));
            }
            else {
                throw [NSString stringWithFormat:@"The type of parameter #%d for %@ is an unknown type: %s", i+1, methodName, type];
            }

            // NSInvocation copies the value from the buffer
            [invocation setArgument:buffer atIndex:i + SKIP];

            free(buffer);
        }
        else if ([arg isKindOfClass:[NSDictionary class]]) {
            // This is a handle, or a well-known struct
            id value = [Utils deserializeObjectOrStruct:args[i]];
            [invocation setArgument:&value atIndex:i + 2];
        }
        else {
            // For a non-number non-handle (e.g. a string), we can just pass it
            [invocation setArgument:&arg atIndex:i + SKIP];
        }
    }

    // Do the invocation
    [invocation invoke];

    // Now process the return value
    const char* returnType = [sig methodReturnType];
    if (strcmp(returnType, @encode(void)) == 0) {
        // The method returns void.
        return nil;
    }
    else if (strcmp(returnType, @encode(int)) == 0) {
        int returnValue;
        [invocation getReturnValue:&returnValue];
        return [NSNumber numberWithInt:returnValue];
    }
    else if (strcmp(returnType, @encode(BOOL)) == 0) {
        BOOL returnValue;
        [invocation getReturnValue:&returnValue];
        return [NSNumber numberWithBool:returnValue];
    }
    else if (strcmp(returnType, @encode(float)) == 0) {
        float returnValue;
        [invocation getReturnValue:&returnValue];
        return [NSNumber numberWithFloat:returnValue];
    }
    else if (strcmp(returnType, @encode(double)) == 0) {
        double returnValue;
        [invocation getReturnValue:&returnValue];
        return [NSNumber numberWithDouble:returnValue];
    }
    else if (strcmp(returnType, @encode(char)) == 0) {
        char returnValue;
        [invocation getReturnValue:&returnValue];
        return [NSNumber numberWithChar:returnValue];
    }
    else if (strcmp(returnType, @encode(long)) == 0) {
        long returnValue;
        [invocation getReturnValue:&returnValue];
        return [NSNumber numberWithLong:returnValue];
    }
    else if (strcmp(returnType, @encode(long long)) == 0) {
        long long returnValue;
        [invocation getReturnValue:&returnValue];
        return [NSNumber numberWithLongLong:returnValue];
    }
    else if (strcmp(returnType, @encode(short)) == 0) {
        short returnValue;
        [invocation getReturnValue:&returnValue];
        return [NSNumber numberWithShort:returnValue];
    }
    else if (strcmp(returnType, @encode(unsigned int)) == 0) {
        unsigned int returnValue;
        [invocation getReturnValue:&returnValue];
        return [NSNumber numberWithUnsignedInt:returnValue];
    }
    else if (strcmp(returnType, @encode(unsigned char)) == 0) {
        unsigned char returnValue;
        [invocation getReturnValue:&returnValue];
        return [NSNumber numberWithUnsignedChar:returnValue];
    }
    else if (strcmp(returnType, @encode(unsigned long)) == 0) {
        unsigned long returnValue;
        [invocation getReturnValue:&returnValue];
        return [NSNumber numberWithUnsignedLong:returnValue];
    }
    else if (strcmp(returnType, @encode(unsigned long long)) == 0) {
        unsigned long long returnValue;
        [invocation getReturnValue:&returnValue];
        return [NSNumber numberWithUnsignedLongLong:returnValue];
    }
    else if (strcmp(returnType, @encode(unsigned short)) == 0) {
        unsigned short returnValue;
        [invocation getReturnValue:&returnValue];
        return [NSNumber numberWithUnsignedShort:returnValue];
    }

    // If we got here, the return type is an object
    CFTypeRef returnValue;
    [invocation getReturnValue:&returnValue];
    if (returnValue) {
        CFRetain(returnValue);
        return (__bridge_transfer NSObject*)returnValue;
    }
    
    // The returned object is nil
    return nil;
}

+ (int) parseInt:(NSString*)s {
    NSScanner *scanner = [[NSScanner alloc] initWithString:s];
    NSInteger integer;
    if ([scanner scanInteger:&integer]) {
        return integer;
    }
    else {
        throw [NSString stringWithFormat:@"Could not parse an integer from '%@'", s];
    }
}

+ (void) alert:(NSString*)s {
    UIAlertView* a = [[UIAlertView alloc] initWithTitle:@"Alert"
                                                message:s
                                               delegate:self
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
    [a show];
}

@end
