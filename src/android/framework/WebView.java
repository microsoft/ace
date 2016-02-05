//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

import android.view.ViewGroup;
import android.widget.AbsoluteLayout;

public class WebView extends android.webkit.WebView implements IHaveProperties {

	public WebView(android.content.Context context) {
		super(context);
	}

	// IHaveProperties.setProperty
	public void setProperty(String propertyName, Object propertyValue) {
        if (propertyName.equals("WebView.Source")) {
            this.loadUrl((String)propertyValue);
        }
		else if (!ViewGroupHelper.setProperty(this, propertyName, propertyValue)) {
			throw new RuntimeException("Unhandled property for " + this.getClass().getSimpleName() + ": " + propertyName);
		}
	}
}
