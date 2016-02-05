//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import run.ace.*;

public class AppBarButton extends Button {
    public String label;
    public Object icon;

	public AppBarButton(Context context) {
		super(context);
	}

	@Override
	public void setProperty(String propertyName, Object propertyValue)
	{
        if (propertyName.endsWith(".Label")) {
           this.label = (String)propertyValue;
        }
        else if (propertyName.endsWith(".Icon")) {
           this.icon = propertyValue;
        }
        else {
            super.setProperty(propertyName, propertyValue);
        }
	}
}
