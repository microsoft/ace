//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsoluteLayout;
import android.widget.FrameLayout;
import android.widget.LinearLayout;
import run.ace.*;

import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.IOException;

public class ViewHelper {
	public static boolean setProperty(View instance, String propertyName, Object propertyValue, boolean useTintListForBackground) {
		if (propertyName.endsWith(".Background")) {
			if (propertyValue == null) {
				// null background means windowBackground (doesn't work with TintList)
				int[] attrs = { android.R.attr.windowBackground };
				android.content.res.TypedArray ta = instance.getContext().getTheme().obtainStyledAttributes(attrs);
				instance.setBackground(ta.getDrawable(0));
				ta.recycle();
			}
			else if (propertyValue instanceof String && ((String)propertyValue).startsWith("www/")) {
				// ImageBrush
				Bitmap bitmap = Utils.getBitmap(instance.getContext(), (String)propertyValue);
				instance.setBackground(new android.graphics.drawable.BitmapDrawable(bitmap));
			}
			else {
				int color = Color.fromObject(propertyValue);
				if (useTintListForBackground)
					instance.setBackgroundTintList(android.content.res.ColorStateList.valueOf(color));
				else
					instance.setBackgroundColor(color);
			}
			return true;
		}
		else if (propertyName.endsWith(".Width")) {
			setLength(instance, true, propertyValue);
			return true;
        }
		else if (propertyName.endsWith(".Height")) {
			setLength(instance, false, propertyValue);
			return true;
        }
        // TODO: Treating margin like padding
		else if (propertyName.endsWith(".Padding") || propertyName.endsWith(".Margin")) {
			if (propertyValue instanceof Long) {
                int p = (int)(long)(Long)propertyValue;
                // Get the scale of screen content
                p *= Utils.getScaleFactor(instance.getContext());

                instance.setPadding(p, p, p, p);
            }
            else if (propertyValue instanceof Integer) {
                int p = (Integer)propertyValue;
                // Get the scale of screen content
                p *= Utils.getScaleFactor(instance.getContext());

                instance.setPadding(p, p, p, p);
            }
            //TODO: Can be a string like x,y or x,y,a,b when set on a custom control. Need to have parsers on native side.
            // Move all of this code (Long/Integer/String/Thickness) to a converter.ConvertThickness.
            // Then same with brushes, etc., too.
            else {
                Thickness thickness = (Thickness)propertyValue;
                // Get the scale of screen content
                float scale = Utils.getScaleFactor(instance.getContext());
                instance.setPadding((int)(thickness.left * scale), (int)(thickness.top * scale), (int)(thickness.right * scale), (int)(thickness.bottom * scale));
            }
            return true;
		}
        else if (propertyName.endsWith(".BottomAppBar")) {
            // This is valid when treating the default root view as a Page
            // TODO: Top, too, and non-TabBars?
            ((TabBar)propertyValue).show(NativeHost.getMainActivity());
            return true;
        }
        else if (propertyName.endsWith(".Resources") || propertyName.endsWith(".Style")) {
			// Accept this, but don't actually do anything with the object.
            // Resources and styles are handled on the managed side.
			return true;
		}
		else if (propertyName.equals("Canvas.Left")) {
			setCoordinate(instance, true, propertyValue);
			return true;
		}
		else if (propertyName.equals("Canvas.Top")) {
			setCoordinate(instance, false, propertyValue);
			return true;
		}
		else if (propertyName.equals("Grid.Row")) {
            int id = run.ace.NativeHost.getResourceId("grid_rowproperty", "integer", instance.getContext());
            instance.setTag(id, propertyValue);
			return true;
        }
		else if (propertyName.equals("Grid.RowSpan")) {
            int id = run.ace.NativeHost.getResourceId("grid_rowspanproperty", "integer", instance.getContext());
            instance.setTag(id, propertyValue);
			return true;
        }
		else if (propertyName.equals("Grid.Column")) {
            int id = run.ace.NativeHost.getResourceId("grid_columnproperty", "integer", instance.getContext());
            instance.setTag(id, propertyValue);
			return true;
        }
		else if (propertyName.equals("Grid.ColumnSpan")) {
            int id = run.ace.NativeHost.getResourceId("grid_columnspanproperty", "integer", instance.getContext());
            instance.setTag(id, propertyValue);
			return true;
        }

		return false;
	}

	static void setCoordinate(View instance, boolean isX, Object position) {
		int value;
		if (position instanceof Double)
			value = (int)(double)(Double)position;
		else
			value = (Integer)position;

        // Get the scale of screen content
        value *= Utils.getScaleFactor(instance.getContext());

		ViewGroup.LayoutParams params = instance.getLayoutParams();
		if (params != null && params instanceof AbsoluteLayout.LayoutParams)
		{
			// Keep the other coordinate intact while setting the new one
			AbsoluteLayout.LayoutParams params2 = (AbsoluteLayout.LayoutParams)params;
			params = new AbsoluteLayout.LayoutParams(params2.width, params2.height,
				isX ? value : params2.x,
				isX ? params2.y : value);
		}
		else
		{
			// Set the new coordinate to the passed-in value,
			// making the other coordinate zero
			params = new AbsoluteLayout.LayoutParams(
				ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT,
				isX ? value : 0,
				isX ? 0 : value);
		}
		instance.setLayoutParams(params);
	}

	static void setLength(View instance, boolean isWidth, Object length) {
		int value;

        if (length == null)
            value = ViewGroup.LayoutParams.MATCH_PARENT; // TODO: Should be WRAP_CONTENT
		else if (length instanceof Double)
			value = (int)(double)(Double)length;
        else if (length instanceof String)
            value = (int)(double)Double.parseDouble((String)length);
		else
			value = (Integer)length;

        // Get the scale of screen content
        value *= Utils.getScaleFactor(instance.getContext());

		ViewGroup.LayoutParams params = instance.getLayoutParams();
		if (params != null) {
            // Keep the other coordinate intact while setting the new one
            if (params instanceof AbsoluteLayout.LayoutParams) {
                AbsoluteLayout.LayoutParams params2 = (AbsoluteLayout.LayoutParams)params;
                params = new AbsoluteLayout.LayoutParams(
                    isWidth ? value : params2.width,
                    isWidth ? params2.height : value,
                    params2.x, params2.y);
            }
            else if (params instanceof FrameLayout.LayoutParams) {
                FrameLayout.LayoutParams params2 = (FrameLayout.LayoutParams)params;
                params = new FrameLayout.LayoutParams(
                    isWidth ? value : params2.width,
                    isWidth ? params2.height : value,
                    params2.gravity);
            }
            else if (params instanceof LinearLayout.LayoutParams) {
                LinearLayout.LayoutParams params2 = (LinearLayout.LayoutParams)params;
                params = new LinearLayout.LayoutParams(
                    isWidth ? value : params2.width,
                    isWidth ? params2.height : value,
                    params2.weight);
            }
            else {
                throw new RuntimeException("Unable to resize element with layoutParams " + params);
            }
		}
		else
		{
            // Set the new coordinate to the passed-in value,
            // making the other coordinate WRAP_CONTENT
            params = new AbsoluteLayout.LayoutParams(
                isWidth ? value : ViewGroup.LayoutParams.WRAP_CONTENT,
                isWidth ? ViewGroup.LayoutParams.WRAP_CONTENT : value,
                0, 0);
		}
		instance.setLayoutParams(params);
	}
}
