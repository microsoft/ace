//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsoluteLayout;
import run.ace.*;

public class Canvas extends AbsoluteLayout implements IHaveProperties, IRecieveCollectionChanges {
	UIElementCollection _children;

	public Canvas(android.content.Context context) {
		super(context);
	}

	// IHaveProperties.setProperty
	public void setProperty(String propertyName, Object propertyValue) {
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

    @Override
    protected void onLayout(boolean changed, int left, int top, int right, int bottom) {
        if (_children != null) {
            for (int i = 0; i < _children.size(); i++) {
                positionChild((View)_children.get(i));
            }
        }
        super.onLayout(changed, left, top, right, bottom);
    }
    
    void positionChild(View view) {
        Thickness margin = (Thickness)Utils.getTag(view, "ace_margin", null);
        int x = (Integer)Utils.getTag(view, "canvas_left", 0);
        int y = (Integer)Utils.getTag(view, "canvas_top", 0);

        // Get the scale of screen content
        float scale = Utils.getScaleFactor(getContext());

        ViewGroup.LayoutParams params = view.getLayoutParams();
        if (params instanceof AbsoluteLayout.LayoutParams) {
            if (margin == null) {
                ((AbsoluteLayout.LayoutParams)params).x = (int)(x * scale);
                ((AbsoluteLayout.LayoutParams)params).y = (int)(y * scale);
            }
            else {
                ((AbsoluteLayout.LayoutParams)params).x = (int)((margin.left + x) * scale);
                ((AbsoluteLayout.LayoutParams)params).y = (int)((margin.top + y) * scale);
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
