//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "GridLength.h"

@implementation GridLength

+ (NSObject*) deserialize:(NSDictionary*)obj {
    GridLength* gl = [[GridLength alloc] init];
    gl->type = [obj[@"type"] intValue];
    gl->gridValue = [obj[@"gridValue"] doubleValue];
    return gl;
}

@end
