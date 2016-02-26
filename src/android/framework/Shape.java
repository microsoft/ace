//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Shapes;

import android.content.Context;
import Windows.UI.Xaml.Controls.*;

public class Shape extends android.view.View implements IHaveProperties {
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

    // IHaveProperties.setProperty
    public void setProperty(String propertyName, Object propertyValue) {
      if (!ViewHelper.setProperty(this, propertyName, propertyValue, false)) {
        if (propertyName.endsWith(".Stroke")) {
            if (propertyValue instanceof Brush)
                setStroke((Brush)propertyValue);
            else
                setStroke(BrushConverter.parse((String)propertyValue));
        }
        else if (propertyName.endsWith(".StrokeThickness")) {
          setStrokeThickness(run.ace.Utils.getDouble(propertyValue));
        }
        else if (propertyName.endsWith(".StrokeStartLineCap")) {
          setStrokeStartLineCap((String)propertyValue);
        }
        else if (propertyName.endsWith(".StrokeEndLineCap")) {
          setStrokeEndLineCap((String)propertyValue);
        }
        else if (propertyName.endsWith(".Fill")) {
            if (propertyValue instanceof Brush)
                setFill((Brush)propertyValue);
            else
                setFill(BrushConverter.parse((String)propertyValue));
        }
        else if (propertyName.endsWith(".StrokeLineJoin")) {
          setStrokeLineJoin((String)propertyValue);
        }
        else if (propertyName.endsWith(".StrokeMiterLimit")) {
          setStrokeMiterLimit(run.ace.Utils.getDouble(propertyValue));
        }
        else if (propertyName.endsWith(".Stretch")) {
          setStretch((String)propertyValue);
        }
        else {
          throw new RuntimeException("Unhandled property for " + this.getClass().getSimpleName() + ": " + propertyName);
        }
      }
    }

    public Brush getStroke() {
        return _stroke;
    }
    public void setStroke(Brush stroke) {
        _stroke = stroke;
        // Redraw
        invalidate();
    }

    public double getStrokeThickness() {
        return _strokeThickness;
    }
    public void setStrokeThickness(double strokeThickness) {
        _strokeThickness = strokeThickness;
        // Redraw
        invalidate();
    }

    public String getStrokeStartLineCap() {
        return _strokeStartLineCap;
    }
    public void setStrokeStartLineCap(String strokeStartLineCap) {
        _strokeStartLineCap = strokeStartLineCap;
        // Redraw
        invalidate();
    }

    public String getStrokeEndLineCap() {
        return _strokeEndLineCap;
    }
    public void setStrokeEndLineCap(String strokeEndLineCap) {
        _strokeEndLineCap = strokeEndLineCap;
        // Redraw
        invalidate();
    }

    public Brush getFill() {
        return _fill;
    }
    public void setFill(Brush fill) {
        _fill = fill;
        // Redraw
        invalidate();
    }

    public String getStrokeLineJoin() {
        return _strokeLineJoin;
    }
    public void setStrokeLineJoin(String strokeLineJoin) {
        _strokeLineJoin = strokeLineJoin;
        // Redraw
        invalidate();
    }

    public double getStrokeMiterLimit() {
        return _strokeMiterLimit;
    }
    public void setStrokeMiterLimit(double strokeMiterLimit) {
        _strokeMiterLimit = strokeMiterLimit;
        // Redraw
        invalidate();
    }

    public String getStretch() {
        return _stretch;
    }
    public void setStretch(String stretch) {
        _stretch = stretch;
        // Redraw
        invalidate();
    }
}
