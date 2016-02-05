//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

import android.graphics.PointF;

public class LinearGradientBrush extends Brush {
    PointF _startPoint;
    PointF _endPoint;
    GradientStopCollection _gradientStops;

    public LinearGradientBrush(android.content.Context context) {
  		super(context);
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
