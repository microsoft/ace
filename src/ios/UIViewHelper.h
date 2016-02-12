//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
@interface UIViewHelper : NSObject

+ (BOOL) setProperty:(UIView*)instance propertyName:(NSString*)propertyName propertyValue:(NSObject*)propertyValue;
+ (void) resize:(UIView*)view;
+ (void) replaceContentIn:(UIView*)view with:(UIView*)content;

@end
