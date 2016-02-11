//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "RectUtils.h"

@implementation RectUtils

+ (CGRect) replace:(CGRect)r x:(CGFloat)x {
    return CGRectMake(x, r.origin.y, r.size.width, r.size.height);
}

+ (CGRect) replace:(CGRect)r y:(CGFloat)y {
    return CGRectMake(r.origin.x, y, r.size.width, r.size.height);
}

+ (CGRect) replace:(CGRect)r width:(CGFloat)width {
    return CGRectMake(r.origin.x, r.origin.y, width, r.size.height);
}

+ (CGRect) replace:(CGRect)r height:(CGFloat)height {
    return CGRectMake(r.origin.x, r.origin.y, r.size.width, height);
}

+ (CGRect) replace:(CGRect)r width:(CGFloat)width height:(CGFloat)height {
    return CGRectMake(r.origin.x, r.origin.y, width, height);
}

+ (CGRect) replace:(CGRect)r size:(CGSize)size {
    return CGRectMake(r.origin.x, r.origin.y, size.width, size.height);
}

+ (CGRect) increaseSize:(CGRect)r withPadding:(UIEdgeInsets)padding {
    return CGRectMake(r.origin.x, r.origin.y,
            r.size.width + padding.left + padding.right,
            r.size.height + padding.top + padding.bottom);
}

@end
