package Windows.UI.Xaml.Controls;

import android.view.View;
import run.ace.*;

public class Canvas extends android.widget.AbsoluteLayout implements IHaveProperties, IRecieveCollectionChanges {
	UIElementCollection _children;

	public Canvas(android.content.Context context) {
		super(context);
	}

	// IHaveProperties.setProperty
	public void setProperty(String propertyName, Object propertyValue)
	{
		if (!ViewGroupHelper.setProperty(this, propertyName, propertyValue)) {
			if (propertyName.equals("Panel.Children")) {
				if (propertyValue == null) {
					_children.removeListener(this);
					_children = null;
				}
				else {
					_children = (UIElementCollection)propertyValue;
					// Listen to collection changes
					_children.addListener(this);
				}
			}
			else {
				throw new RuntimeException("Unhandled property for " + this.getClass().getSimpleName() + ": " + propertyName);
			}
		}
	}

	// IRecieveCollectionChanges.add
	public void add(Object collection, Object item) {
		assert collection == _children;
		this.addView((View)item);
	}

	// IRecieveCollectionChanges.removeAt
	public void removeAt(Object collection, int index) {
		assert collection == _children;
		this.removeViewAt(index);
	}
}
