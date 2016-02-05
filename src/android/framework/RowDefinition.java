//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

public class RowDefinition implements IHaveProperties {
    public GridLength Height;
    public double CalculatedHeight;
    public double CalculatedTop;

	// IHaveProperties.setProperty
	public void setProperty(String propertyName, Object propertyValue) {
        if (propertyName.equals("RowDefinition.Height")) {
            if (propertyValue instanceof GridLength)
                this.Height = (GridLength)propertyValue;
            else
                this.Height = GridLengthConverter.parse((String)propertyValue);
        }
        else {
            throw new RuntimeException("Unhandled property for " + this.getClass().getSimpleName() + ": " + propertyName);
        }
	}
}
