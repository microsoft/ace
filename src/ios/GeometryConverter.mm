//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
#import "GeometryConverter.h"
#import "GeometryContext.h"
#import "GeometryParser.h"

@implementation GeometryConverter

// The string may start with a "F(0|1)" (with whitespace allowed)
// to indicate the winding mode: F0 for EvenOdd, F1 for NonZero
+ (Geometry*)parse:(NSString*)text {
    enum FillRule fillRule = EvenOdd;

    PathGeometry* geometry = [[PathGeometry alloc] init];
    GeometryContext* context = [[GeometryContext alloc] initWithGeometry:geometry];

    @try {
      // Ensure there's something to parse
      if (text != nil) {
          int index = 0;

          // Skip whitespace
          while (index < [text length] &&
                [[NSCharacterSet whitespaceAndNewlineCharacterSet]
                characterIsMember:[text characterAtIndex:index]]) {
              index++;
          }

          // Is there more?
          if (index < [text length]) {
              // If so, we only care if the first non-whitespace character encountered is 'F'
              if ([text characterAtIndex:index] == 'F') {
                  index++;

                  // We found 'F', so the next non-whitespace character must be 0 or 1

                  // Skip whitespace
                  while (index < [text length] &&
                        [[NSCharacterSet whitespaceAndNewlineCharacterSet]
                        characterIsMember:[text characterAtIndex:index]]) {
                      index++;
                  }

                  // Check for 0 or 1
                  if (index == [text length] ||
                      ([text characterAtIndex:index] != '0' &&
                       [text characterAtIndex:index] != '1')) {
                      throw @"Illegal token: F must be followed by 0 or 1";
                  }

                  fillRule = [text characterAtIndex:index] == '0' ? EvenOdd : Nonzero;

                  index++;
              }
          }

          GeometryParser* parser = [[GeometryParser alloc] init];
          // This fills out the geometry object wrapped in the context:
          [parser parseToContext:context pathString:text startIndex:index];
      }
    }
    @finally {
      [context Close];
    }

    geometry.FillRule = fillRule;

    return geometry;
}

@end
