//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------

// Utilities for manipulating CGRect structs
@interface RectUtils : NSObject

+ (CGRect) replace:(CGRect)r x:(CGFloat)x;
+ (CGRect) replace:(CGRect)r y:(CGFloat)y;
+ (CGRect) replace:(CGRect)r width:(CGFloat)width;
+ (CGRect) replace:(CGRect)r height:(CGFloat)height;
+ (CGRect) replace:(CGRect)r width:(CGFloat)width height:(CGFloat)height;
+ (CGRect) replace:(CGRect)r size:(CGSize)size;

+ (CGRect) increaseSize:(CGRect)r withPadding:(UIEdgeInsets)padding;

@end
