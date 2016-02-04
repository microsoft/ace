package Windows.UI.Xaml.Controls;

public class PolyBezierSegment extends PathSegment {
    PointCollection _points;

    public PointCollection getPoints() {
        return _points;
    }
    public void setPoints(PointCollection points) {
        _points = points;
    }
}
