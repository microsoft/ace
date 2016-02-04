package Windows.UI.Xaml.Controls;

import android.graphics.Rect;

enum FillRule { EvenOdd, Nonzero };

public class Geometry {
    Rect _bounds;

    public Rect getBounds() {
        throw new RuntimeException("Bounds NYI");
    }
    public void setBounds(Rect bounds) {
        throw new RuntimeException("Bounds NYI");
    }
}
