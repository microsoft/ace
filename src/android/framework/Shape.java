package Windows.UI.Xaml.Controls;

import android.content.Context;

public class Shape extends android.view.View {
    Brush _stroke;
    double _strokeThickness;
    String _strokeStartLineCap;
    String _strokeEndLineCap;
    Brush _fill;
    String _strokeLineJoin;
    double _strokeMiterLimit;
    String _stretch;

    public Shape(Context context) {
        super(context);

        // Default property values
        _strokeMiterLimit = 10d;
        _strokeThickness = 1d;
    }

    public Brush getStroke() {
        return _stroke;
    }
    public void setStroke(Brush stroke) {
        _stroke = stroke;
    }

    public double getStrokeThickness() {
        return _strokeThickness;
    }
    public void setStrokeThickness(double strokeThickness) {
        _strokeThickness = strokeThickness;
    }

    public String getStrokeStartLineCap() {
        return _strokeStartLineCap;
    }
    public void setStrokeStartLineCap(String strokeStartLineCap) {
        _strokeStartLineCap = strokeStartLineCap;
    }

    public String getStrokeEndLineCap() {
        return _strokeEndLineCap;
    }
    public void setStrokeEndLineCap(String strokeEndLineCap) {
        _strokeEndLineCap = strokeEndLineCap;
    }

    public Brush getFill() {
        return _fill;
    }
    public void setFill(Brush fill) {
        _fill = fill;
    }

    public String getStrokeLineJoin() {
        return _strokeLineJoin;
    }
    public void setStrokeLineJoin(String strokeLineJoin) {
        _strokeLineJoin = strokeLineJoin;
    }

    public double getStrokeMiterLimit() {
        return _strokeMiterLimit;
    }
    public void setStrokeMiterLimit(double strokeMiterLimit) {
        _strokeMiterLimit = strokeMiterLimit;
    }

    public String getStretch() {
        return _stretch;
    }
    public void setStretch(String stretch) {
        _stretch = stretch;
    }
}
