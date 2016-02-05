//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

public class PolyLineSegment extends PathSegment {
    PointCollection _points;

    public PointCollection getPoints() {
        return _points;
    }
    public void setPoints(PointCollection points) {
        _points = points;
    }
}
