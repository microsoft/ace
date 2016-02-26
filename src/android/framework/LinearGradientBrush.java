//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Media;

import android.graphics.PointF;
import Windows.UI.Xaml.Controls.*;

public class LinearGradientBrush extends Brush implements IHaveProperties {
    PointF _startPoint;
    PointF _endPoint;
    GradientStopCollection _gradientStops;

    public LinearGradientBrush(android.content.Context context) {
  		super(context);
  	}

    // IHaveProperties.setProperty
    public void setProperty(String propertyName, Object propertyValue) {
        if (propertyName.endsWith(".StartPoint")) {
            if (propertyValue instanceof PointF)
                setStartPoint((PointF)propertyValue);
            else
                setStartPoint(PointFConverter.parse((String)propertyValue));
        }
        else if (propertyName.endsWith(".EndPoint")) {
            if (propertyValue instanceof PointF)
                setEndPoint((PointF)propertyValue);
            else
                setEndPoint(PointFConverter.parse((String)propertyValue));
        }
        else if (propertyName.endsWith(".GradientStops")) {
            setGradientStops((GradientStopCollection)propertyValue);
        }
        else {
            throw new RuntimeException("Unhandled property for " + this.getClass().getSimpleName() + ": " + propertyName);
        }
    }

    public PointF getStartPoint() {
        return _startPoint;
    }
    public void setStartPoint(PointF startPoint) {
        _startPoint = startPoint;
    }

    public PointF getEndPoint() {
        return _endPoint;
    }
    public void setEndPoint(PointF endPoint) {
        _endPoint = endPoint;
    }

    public GradientStopCollection getGradientStops() {
        return _gradientStops;
    }
    public void setGradientStops(GradientStopCollection gradientStops) {
        _gradientStops = gradientStops;
    }
}
