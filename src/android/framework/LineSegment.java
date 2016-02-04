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
