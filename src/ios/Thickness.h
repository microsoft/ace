//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
@interface Thickness : NSObject

@property double left;
@property double top;
@property double right;
@property double bottom;

+ (NSObject*) deserialize:(NSDictionary*)obj;
+ (Thickness*) parse:(NSString*)text;
+ (Thickness*) fromNumber:(NSNumber*)number;
+ (Thickness*) fromObject:(NSObject*)obj;

@end
