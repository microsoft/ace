//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml;

public class Setter implements Windows.UI.Xaml.Controls.IHaveProperties {
	public Setter(android.content.Context context) {
	}

	// IHaveProperties.setProperty
	public void setProperty(String propertyName, Object propertyValue)
	{
        if (propertyName.endsWith(".Property") || propertyName.endsWith(".Value")) {
            // Ignore. These are handled on the managed side.
        }
        else {
            throw new RuntimeException("Unhandled property for " + this.getClass().getSimpleName() + ": " + propertyName);
        }
	}
}
