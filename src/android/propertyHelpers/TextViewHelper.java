package Windows.UI.Xaml.Controls;

import android.graphics.Typeface;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsoluteLayout;
import android.widget.TextView;
import run.ace.*;
import Windows.UI.Xaml.Documents.*;

public class TextViewHelper {
	public static boolean setProperty(TextView instance, String propertyName, Object propertyValue) {
		// First look at TextView-specific properties
        
        // The .endsWith checks are important for supporting standard properties on custom
        // TextViews. What would have been Control.FontSize would appear as XXXTextView.FontSize.
        if (propertyName.endsWith(".Content") ||
            propertyName.endsWith(".Text") ||
            propertyName.endsWith(".Header")) {
			if (propertyValue instanceof String || propertyValue == null) {
				instance.setText((String)propertyValue);
			}
			else {
				instance.setText(propertyValue.toString());
			}
			return true;
		}
        else if (propertyName.endsWith(".Inlines")) {
            InlineCollection inlines = (InlineCollection)propertyValue;
            // TODO: Handling of multiple Runs and with separate formatting
            instance.setText(inlines.get(0).toString());
			return true;
		}
        else if (propertyName.endsWith(".FontSize")) {
			if (propertyValue instanceof Double)
				instance.setTextSize((float)(double)(Double)propertyValue);
			else if (propertyValue instanceof Integer)
				instance.setTextSize((float)(int)(Integer)propertyValue);
			else
				instance.setTextSize((float)Integer.parseInt(propertyValue.toString()));
			return true;
		}
        else if (propertyName.endsWith(".FontWeight")) {
			double weight;
			if (propertyValue instanceof Double)
				weight = (Double)propertyValue;
			else if (propertyValue instanceof String)
				weight = FontWeightConverter.parse((String)propertyValue);
			else
				weight = (double)(int)(Integer)propertyValue;

            // TODO: Preserve italicness
			if (weight >= 600 /* SemiBold or greater */)
				instance.setTypeface(null, Typeface.BOLD);
			else
				instance.setTypeface(null, Typeface.NORMAL);
			return true;
		}
        else if (propertyName.endsWith(".FontStyle")) {
            String s = ((String)propertyValue).toLowerCase();
            if (s.equals("italic") || s.equals("oblique")) {
                // TODO: Preserve boldness
				instance.setTypeface(null, Typeface.ITALIC);
            }
            else if (s.equals("normal")) {
                // TODO: Preserve boldness
				instance.setTypeface(null, Typeface.NORMAL);
            }
            else {
                throw new RuntimeException("Unknown " + propertyName + ": " + propertyValue);
            }
			return true;
		}
        else if (propertyName.endsWith(".Foreground")) {
			if (propertyValue instanceof Long) {
				// It's a raw color value
				instance.setTextColor((int)(long)(Long)propertyValue);
			}
			else if (propertyValue instanceof Integer) {
				// It's a raw color value
				instance.setTextColor((Integer)propertyValue);
			}
			else {
				Brush brush = BrushConverter.parse((String)propertyValue);
				if (brush instanceof SolidColorBrush)
					instance.setTextColor(((SolidColorBrush)brush).Color);
				else
					throw new RuntimeException("Brushes other than SolidColorBrush are NYI");
			}
			return true;
		}
        else if (propertyName.endsWith(".HorizontalAlignment")) {
            String alignment = ((String)propertyValue).toLowerCase();

            // TODO: Do differently to preserve any vertical alignment            
            if (alignment.equals("center") || alignment.equals("stretch")) {
                instance.setGravity(Gravity.CENTER_HORIZONTAL);
            }
            else if (alignment.equals("left")) {
                instance.setGravity(Gravity.LEFT);
            }
            else if (alignment.equals("right")) {
                instance.setGravity(Gravity.RIGHT);
            }
            else {
                throw new RuntimeException("Unknown " + propertyName + ": " + propertyValue);
            }
			return true;
		}

		// Now look at properties applicable to all Views
		return ViewHelper.setProperty(instance, propertyName, propertyValue, true);
	}
}
