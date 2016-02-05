//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

class FontWeightConverter {
	public static double parse(String s)
	{
		s = s.toLowerCase();
		if (s.equals("thin")) {
			return 100;
		}
		else if (s.equals("extralight")) {
			return 200;
		}
		else if (s.equals("light")) {
			return 300;
		}
		else if (s.equals("semilight")) {
			return 350;
		}
		else if (s.equals("normal")) {
			return 400;
		}
		else if (s.equals("medium")) {
			return 500;
		}
		else if (s.equals("semibold")) {
			return 600;
		}
		else if (s.equals("bold")) {
			return 700;
		}
		else if (s.equals("extrabold")) {
			return 800;
		}
		else if (s.equals("extrablack")) {
			return 900;
		}

		throw new RuntimeException("Invalid FontWeight string: " + s);
	}
}
