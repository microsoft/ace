package Windows.UI.Xaml.Controls;

public class PathSegment {
    boolean _isSmoothJoin;
    boolean _isStroked;

    boolean getIsSmoothJoin() {
        return _isSmoothJoin;
    }
    public void setIsSmoothJoin(boolean isSmoothJoin) {
        _isSmoothJoin = isSmoothJoin;
    }

    boolean getIsStroked() {
        return _isStroked;
    }
    public void setIsStroked(boolean isStroked) {
        _isStroked = isStroked;
    }
}
