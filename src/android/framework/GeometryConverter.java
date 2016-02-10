//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

public class GeometryConverter {
  // The string may start with a "F(0|1)" (with whitespace allowed)
  // to indicate the winding mode: F0 for EvenOdd, F1 for NonZero
  public static Geometry parse(String text) {
    FillRule fillRule = FillRule.EvenOdd;

    PathGeometry geometry = new PathGeometry();
    GeometryContext context = new GeometryContext(geometry);

    try {
      // Ensure there's something to parse
      if (text != null) {
        int index = 0;

        // Skip whitespace
        while (index < text.length() && Character.isWhitespace(text.charAt(index))) {
            index++;
        }

          // Is there more?
          if (index < text.length()) {
              // If so, we only care if the first non-whitespace character encountered is 'F'
              if (text.charAt(index) == 'F') {
                  index++;

                  // We found 'F', so the next non-whitespace character must be 0 or 1

                  // Skip whitespace
                  while (index < text.length() && Character.isWhitespace(text.charAt(index))) {
                      index++;
                  }

                  // Check for 0 or 1
                  if (index == text.length() ||
                      (text.charAt(index) != '0' &&
                       text.charAt(index) != '1')) {
                      throw new RuntimeException("Illegal token: F must be followed by 0 or 1");
                  }

                  fillRule = text.charAt(index) == '0' ? FillRule.EvenOdd : FillRule.Nonzero;
                  index++;
              }
          }

          GeometryParser parser = new GeometryParser();
          // This fills out the geometry object wrapped in the context:
          parser.parseToContext(context, text, index);
      }
    }
    finally {
      context.close();
    }

    geometry.fillRule = fillRule;

    return geometry;
  }
}
