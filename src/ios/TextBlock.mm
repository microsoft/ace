//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "TextBlock.h"
#import "UILabelHelper.h"
#import "Thickness.h"

@implementation TextBlock

- (id)init {
  self = [super init];
  self.padding = UIEdgeInsetsMake(0, 0, 0, 0);
  return self;
}

// IHaveProperties.setProperty
- (void) setProperty:(NSString*)propertyName value:(NSObject*)propertyValue {
  if (![UILabelHelper setProperty:self propertyName:propertyName propertyValue:propertyValue]) {
    if ([propertyName hasSuffix:@".Padding"]) {
      Thickness* padding = [Thickness fromObject:propertyValue];
      self.padding = UIEdgeInsetsMake(padding.top, padding.left, padding.bottom, padding.right);
      [self setNeedsDisplay];
    }
    else {
      throw [NSString stringWithFormat:@"Unhandled property for %@: %@", [self class], propertyName];
    }
  }
}

// Override to apply any padding
- (void)drawTextInRect:(CGRect)rect {
  return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.padding)];
}

@end
