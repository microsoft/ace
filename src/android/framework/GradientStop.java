//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

public class GradientStop implements IHaveProperties {
    int _color;
    double _offset;

    // IHaveProperties.setProperty
    public void setProperty(String propertyName, Object propertyValue) {
        if (propertyName.endsWith(".Color")) {
          _color = Color.fromObject(propertyValue);
        }
        else if (propertyName.endsWith(".Offset")) {
          _offset = run.ace.Utils.getDouble(propertyValue);
        }
        else {
          throw new RuntimeException("Unhandled property for " + this.getClass().getSimpleName() + ": " + propertyName);
        }
    }
}
