//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
@interface Utils : NSObject

+ (UIImage*) getImage:(NSString*)source;
+ (NSObject*) invokeInstanceMethod:(NSObject*)instance methodName:(NSString*)methodName args:(NSArray*)args;
+ (NSObject*) invokeStaticMethod:(NSString*)typeName methodName:(NSString*)methodName args:(NSArray*)args;
+ (NSObject*) deserializeObjectOrStruct:(NSDictionary*)obj;

+ (UINavigationController*) getParentNavigationController:(UIViewController*)viewController;

+ (int) parseInt:(NSString*)s;
+ (void) alert:(NSString*)s;

@end
