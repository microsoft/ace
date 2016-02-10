//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "Thickness.h"
#import "Utils.h"

@implementation Thickness

+ (NSObject*) deserialize:(NSDictionary*)obj {
    Thickness* t = [[Thickness alloc] init];
    t.left = [obj[@"left"] doubleValue];
    t.top = [obj[@"top"] doubleValue];
    t.right = [obj[@"right"] doubleValue];
    t.bottom = [obj[@"bottom"] doubleValue];
    return t;
}

+ (Thickness*) fromNumber:(NSNumber*)number {
    int p = [number intValue];
    Thickness* t = [[Thickness alloc] init];
    t.left = p;
    t.top = p;
    t.right = p;
    t.bottom = p;
    return t;
}

+ (Thickness*) parse:(NSString*)text {
    NSArray* parts = [text componentsSeparatedByCharactersInSet:
          [NSCharacterSet characterSetWithCharactersInString:@","]];

    Thickness* t = [[Thickness alloc] init];

    if (parts.count == 1) {
        int p = [Utils parseInt:text];
        t.left = p;
        t.top = p;
        t.right = p;
        t.bottom = p;
        return t;
    }
    else if (parts.count == 2) {
        int h = [Utils parseInt:parts[0]];
        int v = [Utils parseInt:parts[1]];
        t.left = h;
        t.top = v;
        t.right = h;
        t.bottom = v;
        return t;
    }
    else if (parts.count == 4) {
        t.left = [Utils parseInt:parts[0]];
        t.top = [Utils parseInt:parts[1]];
        t.right = [Utils parseInt:parts[2]];
        t.bottom = [Utils parseInt:parts[3]];
        return t;
    }

    throw [NSString stringWithFormat:@"Invalid thickness string: %@", text];
}

// Return a Thickness, whether the input is a number, string, or Thickness
+ (Thickness*) fromObject:(NSObject*)obj {
  if ([obj isKindOfClass:[NSNumber class]]) {
    return [Thickness fromNumber:(NSNumber*)obj];
  }
  else if ([obj isKindOfClass:[NSString class]]) {
    return [Thickness parse:(NSString*)obj];
  }
  else {
    return (Thickness*)obj;
  }
}

@end
