//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

import android.content.Context;
import android.view.ViewGroup;
import android.widget.RelativeLayout;
import run.ace.Utils;

// A container for an item in a ListBox.
public class ListBoxItem extends RelativeLayout implements IHaveProperties, IFireEvents {

	public ListBoxItem(Context context) {
		super(context);

		// Stretch horizontally by default
		this.setGravity(android.view.Gravity.FILL_HORIZONTAL);
	}

  public void setContent(Object content) {
		setProperty("ContentControl.Content", content);
	}

	// IHaveProperties.setProperty
	public void setProperty(String propertyName, Object propertyValue)
	{
		// Handle the Content property specially if it's a primitive
		// so it is formatted as expected inside a list.
		// Otherwise, defer to the generic handlng for all ViewGroups.
		if (propertyName.equals("ContentControl.Content") &&
				Utils.isBoxedNumberOrString(propertyValue)) {
			android.widget.TextView content = (android.widget.TextView)android.view.LayoutInflater.from(getContext())
				.inflate(android.R.layout.simple_list_item_activated_1, this, false);
			content.setText(propertyValue.toString());
			this.addView(content);
		}
		else if (!ViewGroupHelper.setProperty(this, propertyName, propertyValue)) {
			throw new RuntimeException("Unhandled property for " + this.getClass().getSimpleName() + ": " + propertyName);
		}
	}

	// IFireEvents.addEventHandler
	public void addEventHandler(final String eventName, final Handle handle) {
        // TODO
	}

	// IFireEvents.removeEventHandler
	public void removeEventHandler(String eventName) {
        // TODO
	}
}
