//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

import org.json.JSONException;
import org.json.JSONObject;

public class Thickness {

	public double left;
	public double top;
	public double right;
	public double bottom;

    public Thickness() {
    }
    
	public Thickness(double left, double top, double right, double bottom) {
        this.left = left;
        this.top = top;
        this.right = right;
        this.bottom = bottom;
	}

	public static Thickness deserialize(JSONObject obj) {
		try {
			double left = obj.getDouble("left");
			double top = obj.getDouble("top");
			double right = obj.getDouble("right");
			double bottom = obj.getDouble("bottom");
			return new Thickness(left, top, right, bottom);
		}
		catch (JSONException ex) {
			throw new RuntimeException(ex);
		}
	}
    
    public static Thickness parse(String text) {
        String[] parts = text.split(",");

        Thickness t = new Thickness();

        if (parts.length == 1) {
            int p = Integer.parseInt(text);
            t.left = p;
            t.top = p;
            t.right = p;
            t.bottom = p;
            return t;
        }
        else if (parts.length == 2) {
            int h = Integer.parseInt(parts[0]);
            int v = Integer.parseInt(parts[1]);
            t.left = h;
            t.top = v;
            t.right = h;
            t.bottom = v;
            return t;
        }
        else if (parts.length == 4) {
            t.left = Integer.parseInt(parts[0]);
            t.top = Integer.parseInt(parts[1]);
            t.right = Integer.parseInt(parts[2]);
            t.bottom = Integer.parseInt(parts[3]);
            return t;
        }

        throw new RuntimeException("Invalid thickness string: " + text);
    }

    // Return a Thickness, whether the input is a number, string, or Thickness
    public static Thickness fromObject(Object obj) {
        if (obj instanceof Long) {
            int v = (int)(long)(Long)obj;
            return new Thickness(v, v, v, v);
        }
        else if (obj instanceof Integer) {
            int v = (Integer)obj;
            return new Thickness(v, v, v, v);
        }
        else if (obj instanceof String) {
            return Thickness.parse((String)obj);
        }
        else {
            return (Thickness)obj;
        }
    }
}
