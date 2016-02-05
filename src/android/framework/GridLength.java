//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

import org.json.JSONException;
import org.json.JSONObject;

public class GridLength {

	public int type;
	public double gridValue;

	public GridLength() {
    }

	public GridLength(int type, double gridValue) {
        this.type = type;
        this.gridValue = gridValue;
	}

	public static GridLength deserialize(JSONObject obj) {
		try {
			int type = obj.getInt("type");
			double gridValue = obj.getDouble("gridValue");
			return new GridLength(type, gridValue);
		}
		catch (JSONException ex) {
			throw new RuntimeException(ex);
		}
	}
}
