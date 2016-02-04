package Windows.UI.Xaml.Controls;

import android.content.Context;
import android.view.View;
import run.ace.*;

public class Image extends android.widget.ImageView implements IHaveProperties {
	public Image(Context context) {
		super(context);
	}

	// IHaveProperties.setProperty
	public void setProperty(String propertyName, Object propertyValue)
	{
		if (!ViewHelper.setProperty(this, propertyName, propertyValue, true)) {
			if (propertyName.endsWith(".Source")) {
				if (propertyValue instanceof String) {
					this.setImageBitmap(Utils.getBitmap(getContext(), (String)propertyValue));
				}
				else if (propertyValue instanceof ImageSource) {
					this.setImageBitmap(Utils.getBitmap(getContext(), ((ImageSource)propertyValue).getUriSource()));
				}
				else if (propertyValue == null) {
					this.setImageBitmap(null);
				}
				else {
					throw new RuntimeException("Invalid type for Image.Source: " + propertyValue.getClass().getSimpleName());
				}
			}
			else {
				throw new RuntimeException("Unhandled property for " + this.getClass().getSimpleName() + ": " + propertyName);
			}
		}
	}
}
