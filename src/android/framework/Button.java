//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import run.ace.*;

public class Button extends android.widget.Button implements IHaveProperties, IFireEvents {
	int _clickHandlers = 0;

	public Button(Context context) {
		super(context);
	}

	// IHaveProperties.setProperty
	public void setProperty(String propertyName, Object propertyValue)
	{
		if (!TextViewHelper.setProperty(this, propertyName, propertyValue)) {
			throw new RuntimeException("Unhandled property for " + this.getClass().getSimpleName() + ": " + propertyName);
		}
	}

	// IFireEvents.addEventHandler
	public void addEventHandler(final String eventName, final Handle handle) {
		if (eventName.equals("click")) {
			if (_clickHandlers == 0) {
				// Set up the message sending, which goes to all handlers
				this.setOnClickListener(new View.OnClickListener() {
					public void onClick(View v) {
						OutgoingMessages.raiseEvent(eventName, handle, null);
					}
				});
			}
			_clickHandlers++;
		}
	}

	// IFireEvents.removeEventHandler
	public void removeEventHandler(String eventName) {
		if (eventName.equals("click")) {
			_clickHandlers--;
			if (_clickHandlers == 0) {
				// Stop sending messages because nobody is listening
				this.setOnClickListener(null);
			}
		}
	}
}
