//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

import android.graphics.PointF;

public class PathFigure {
    boolean _isClosed;
    PointF _startPoint;
    boolean _isFilled;
    PathSegmentCollection _segments;

    public boolean getIsClosed() {
        return _isClosed;
    }
    public void setIsClosed(boolean isClosed) {
        _isClosed = isClosed;
    }

    public PointF getStartPoint() {
        return _startPoint;
    }
    public void setStartPoint(PointF startPoint) {
        _startPoint = startPoint;
    }

    public boolean getIsFilled() {
        return _isFilled;
    }
    public void setIsFilled(boolean isFilled) {
        _isFilled = isFilled;
    }

    public PathSegmentCollection getSegments() {
        return _segments;
    }
    public void setSegments(PathSegmentCollection segments) {
        _segments = segments;
    }
}
