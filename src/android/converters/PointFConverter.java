//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

import android.graphics.PointF;

public class PointFConverter {
	public static PointF parse(String text) {
        String[] parts = text.split(",");
        return new PointF(Float.parseFloat(parts[0]), Float.parseFloat(parts[1]));
	}
}
