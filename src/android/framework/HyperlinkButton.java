//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import run.ace.*;

public class HyperlinkButton extends Button {
    String _uri;

	public HyperlinkButton(Context context) {
		super(context);
        final HyperlinkButton hb = this;
        this.setOnClickListener(new View.OnClickListener() {
            public void onClick(View v) {
                hb.navigate();
            }
        });
	}

    void navigate() {
        if (_uri != null) {
            OutgoingMessages.raiseEvent("ace.navigate", null, _uri);
        }
    }

    @Override
	public void setProperty(String propertyName, Object propertyValue)
	{
        if (propertyName.equals("HyperlinkButton.NavigateUri")) {
            _uri = (String)propertyValue;
        }
        else {
            super.setProperty(propertyName, propertyValue);
        }
	}
}
