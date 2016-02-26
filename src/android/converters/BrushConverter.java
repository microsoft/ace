//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

import android.graphics.Color;

public class BrushConverter {

	static final int ZERO_CHAR = (int)'0';
	static final int LOWER_A_CHAR = (int)'a';
	static final int UPPER_A_CHAR = (int)'A';

	public static SolidColorBrush parse(String brush) {
		return new SolidColorBrush(parseColor(brush));
	}

	static int parseColor(String color) {
			color = color.trim();
			if (color.charAt(0) == '#' &&
					 (color.length() == 4 || color.length() == 5 ||
					  color.length() == 7 || color.length() == 9)) {
				// This is a numberic color
				return parseHexColor(color);
			}
			else if (color.startsWith("sc#")) {
				throw new RuntimeException("ScRgb colors are not supported");
			}
			else {
				// This must be a named color
				color = NamedColor.toNumericColorString(color);
				return parseHexColor(color);
			}
	}

	static int parseHexColor(String color) {
			int a,r,g,b;
			a = 255;

			if (color.length() > 7) {
					a = parseHexChar(color.charAt(1)) * 16 + parseHexChar(color.charAt(2));
					r = parseHexChar(color.charAt(3)) * 16 + parseHexChar(color.charAt(4));
					g = parseHexChar(color.charAt(5)) * 16 + parseHexChar(color.charAt(6));
					b = parseHexChar(color.charAt(7)) * 16 + parseHexChar(color.charAt(8));
			}
			else if (color.length() > 5) {
					r = parseHexChar(color.charAt(1)) * 16 + parseHexChar(color.charAt(2));
					g = parseHexChar(color.charAt(3)) * 16 + parseHexChar(color.charAt(4));
					b = parseHexChar(color.charAt(5)) * 16 + parseHexChar(color.charAt(6));
			}
			else if (color.length() > 4) {
					a = parseHexChar(color.charAt(1));
					a = a + a*16;
					r = parseHexChar(color.charAt(2));
					r = r + r*16;
					g = parseHexChar(color.charAt(3));
					g = g + g*16;
					b = parseHexChar(color.charAt(4));
					b = b + b*16;
			}
			else {
					r = parseHexChar(color.charAt(1));
					r = r + r*16;
					g = parseHexChar(color.charAt(2));
					g = g + g*16;
					b = parseHexChar(color.charAt(3));
					b = b + b*16;
			}

			return Color.argb(a, r, g, b);
	}

	static int parseHexChar(char c) {
		int intChar = (int)c;
		if (intChar >= ZERO_CHAR && intChar <= ZERO_CHAR+9) {
			// It's a number
			return (intChar-ZERO_CHAR);
		}
		else if (intChar >= LOWER_A_CHAR && intChar <= LOWER_A_CHAR+5) {
			// It's a letter from a-f
			return (intChar-LOWER_A_CHAR+10);
		}
		else if (intChar >= UPPER_A_CHAR && intChar <= UPPER_A_CHAR+5) {
			// It's a letter from A-F
			return (intChar-UPPER_A_CHAR+10);
		}
		throw new RuntimeException("Illegal hex character");
	}
}
