//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

class GridLengthConverter {

    public static GridLength parse(String text) {
        // Normalize
        text = text.toLowerCase().trim();

        GridLength gl = new GridLength();

        if (text.equals("auto")) {
            gl.type = GridUnitType.Auto;
            gl.gridValue = 1;
            return gl;
        }
        else if (text.endsWith("*")) {
            gl.type = GridUnitType.Star;
            text = text.substring(0, text.length() - 1);
            if (text.length() == 0) {
                // Treat * as 1*, which is needed for the number parsing below
                text = "1";
            }
        }
        else {
            gl.type = GridUnitType.Pixel;
        }

        gl.gridValue = Double.parseDouble(text);

        return gl;
    }
}
