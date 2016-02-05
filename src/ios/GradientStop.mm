//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "GradientStop.h"
#import "Color.h"

@implementation GradientStop

// IHaveProperties.setProperty
- (void) setProperty:(NSString*)propertyName value:(NSObject*)propertyValue {
  if ([propertyName hasSuffix:@".Color"]) {
    self.color = [Color fromObject:propertyValue withDefault:nil];
  }
  else if ([propertyName hasSuffix:@".Offset"]) {
    self.offset = [(NSNumber*)propertyValue doubleValue];
  }
  else {
    throw [NSString stringWithFormat:@"Unhandled property for %@: %@", [self class], propertyName];
  }
}

@end
