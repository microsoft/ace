//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

import android.graphics.PointF;

enum SweepDirection { Counterclockwise, Clockwise };

public class ArcSegment extends PathSegment {
    PointF _point;
    PointF _size;
    Boolean _isLargeArc;
    SweepDirection _sweepDirection;
    double _rotationAngle;

    public PointF getPoint() {
        return _point;
    }
    public void setPoint(PointF point) {
        _point = point;
    }

    public PointF getSize() {
        return _size;
    }
    public void setSize(PointF size) {
        _size = size;
    }

    public Boolean getIsLargeArc() {
        return _isLargeArc;
    }
    public void setIsLargeArc(Boolean isLargeArc) {
        _isLargeArc = isLargeArc;
    }

    public SweepDirection getSweepDirection() {
        return _sweepDirection;
    }
    public void setSweepDirection(SweepDirection sweepDirection) {
        _sweepDirection = sweepDirection;
    }

    public double getRotationAngle() {
        return _rotationAngle;
    }
    public void setRotationAngle(double rotationAngle) {
        _rotationAngle = rotationAngle;
    }
}
