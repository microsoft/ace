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
				Bitmap bitmap = Utils.getBitmapAsset(instance.getContext(), (String)propertyValue);
				instance.setBackground(new android.graphics.drawable.BitmapDrawable(bitmap));
			}
			else {
                int color = Color.fromObject(propertyValue);
                // setBackgroundTintList is only suported in Lollipop (5.0)+, and it doesn't work
                // unless running on 5.1 (API 22, aka LOLLIPOP_MR1).
                if (useTintListForBackground && android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.LOLLIPOP_MR1)
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
		else if (propertyName.endsWith(".Margin")) {
            Utils.setTag(instance, "ace_margin", Thickness.fromObject(propertyValue));
            return true;
		}
		else if (propertyName.endsWith(".Padding")) {
            if (propertyValue == null) {
                instance.setPadding(0,0,0,0);
            }
            else {
                Thickness t = Thickness.fromObject(propertyValue);
                // Get the scale of screen content
                float scale = Utils.getScaleFactor(instance.getContext());
                instance.setPadding(
                    (int)(t.left * scale),  (int)(t.top * scale),
                    (int)(t.right * scale), (int)(t.bottom * scale));
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
            Utils.setTag(instance, "canvas_left", Utils.getInt(propertyValue));
			return true;
		}
		else if (propertyName.equals("Canvas.Top")) {
            Utils.setTag(instance, "canvas_top", Utils.getInt(propertyValue));
			return true;
		}
		else if (propertyName.equals("Grid.Row")) {
            Utils.setTag(instance, "grid_rowproperty", propertyValue);
			return true;
        }
		else if (propertyName.equals("Grid.RowSpan")) {
            Utils.setTag(instance, "grid_rowspanproperty", propertyValue);
			return true;
        }
		else if (propertyName.equals("Grid.Column")) {
            Utils.setTag(instance, "grid_columnproperty", propertyValue);
			return true;
        }
		else if (propertyName.equals("Grid.ColumnSpan")) {
            Utils.setTag(instance, "grid_columnspanproperty", propertyValue);
			return true;
        }
        else if (propertyName.endsWith(".HorizontalAlignment")) {
            Utils.setTag(instance, "ace_horizontalalignment", ((String)propertyValue).toLowerCase());
            return true;
        }
        else if (propertyName.endsWith(".VerticalAlignment")) {
            Utils.setTag(instance, "ace_verticalalignment", ((String)propertyValue).toLowerCase());
            return true;
        }
        else if (propertyName.endsWith(".Uid")) {
            instance.setContentDescription((String)propertyValue);
            return true;
        }

		return false;
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

        if (isWidth) {
            Utils.setTag(instance, "ace_width", value);
        }
        else {
            Utils.setTag(instance, "ace_height", value);
        }

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
