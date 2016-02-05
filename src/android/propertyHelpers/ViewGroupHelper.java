//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsoluteLayout;
import android.widget.TextView;
import run.ace.*;

public class ViewGroupHelper {
	public static boolean setProperty(ViewGroup instance, String propertyName, Object propertyValue) {
		// First look at ViewGroup-specific properties

        // The .endsWith checks are important for supporting standard properties on custom
        // ViewGroups. What would have been ContentControl.Content would appear as XXXViewGroup.Content.
		if (propertyName.endsWith(".Content")) {

            // Clear any existing content first
            instance.removeAllViews();

            // When we're setting content on the root view, clear the existing title/appbars
            if (instance == NativeHost.getRootView()) {
                TabBar.remove(NativeHost.getMainActivity());
                CommandBar.remove(NativeHost.getMainActivity(), NativeHost.getRootMenu());
            }

			if (propertyValue == null) {
                return true;
			}

			if (propertyValue instanceof View) {
				View content = (View)propertyValue;

                // Automatically reparent, since Android is a bit pickier about this compared to iOS
                Object parent = content.getParent();
                if (parent instanceof ViewGroup) {
                    ((ViewGroup)parent).removeView(content);
                }

				// Stretch to fill
				content.setLayoutParams(new android.widget.FrameLayout.LayoutParams(
					ViewGroup.LayoutParams.MATCH_PARENT,
					ViewGroup.LayoutParams.MATCH_PARENT));

                // When we're setting content on the root view, respect the title/appbars
                if (instance == NativeHost.getRootView()) {
                    if (propertyValue instanceof Page) {
                        ((Page)propertyValue).processBars(NativeHost.getMainActivity(), NativeHost.getRootMenu());
                    }
                }


				instance.addView(content);
			}
			else {
				TextView content = new TextView(instance.getContext());
				// Stretch to fill horizontally
				content.setLayoutParams(new android.widget.FrameLayout.LayoutParams(
					ViewGroup.LayoutParams.MATCH_PARENT,
					ViewGroup.LayoutParams.WRAP_CONTENT));
				content.setText(propertyValue.toString());
				instance.addView(content);
			}
			return true;
		}

		// Now look at properties applicable to all Views
		return ViewHelper.setProperty(instance, propertyName, propertyValue, false);
	}
}
