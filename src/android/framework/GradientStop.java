//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Media;

import Windows.UI.Xaml.Controls.*;

public class GradientStop implements IHaveProperties {
    public int color;
    public double offset;

    // IHaveProperties.setProperty
    public void setProperty(String propertyName, Object propertyValue) {
        if (propertyName.endsWith(".Color")) {
          this.color = Color.fromObject(propertyValue);
        }
        else if (propertyName.endsWith(".Offset")) {
          this.offset = run.ace.Utils.getDouble(propertyValue);
        }
        else {
          throw new RuntimeException("Unhandled property for " + this.getClass().getSimpleName() + ": " + propertyName);
        }
    }
}
