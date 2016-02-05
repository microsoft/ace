//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

import android.graphics.PointF;

public class LineSegment extends PathSegment {
    PointF _point;

    public PointF getPoint() {
        return _point;
    }
    public void setPoint(PointF point) {
        _point = point;
    }
}
