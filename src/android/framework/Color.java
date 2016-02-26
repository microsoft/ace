//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

public class Color {
	public static int fromObject(Object value) {
		if (value == null) {
			throw new RuntimeException("NYI: Null color value");
    }
		else if (value instanceof Long) {
			// It's a raw color value
			return (int)(long)(Long)value;
		}
		else if (value instanceof Integer) {
			// It's a raw color value
			return (Integer)value;
		}
		else if (value instanceof SolidColorBrush) {
        return ((SolidColorBrush)value).Color;
    }
		else if (value instanceof String) {
			SolidColorBrush brush = BrushConverter.parse((String)value);
			return ((SolidColorBrush)brush).Color;
		}
    else {
        throw new RuntimeException("Cannot get a color from unsupported object type " + value.getClass().getSimpleName());
    }
	}
}
