//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

import android.view.View;
import android.view.ViewGroup;
import android.widget.LinearLayout;
import run.ace.*;

public class StackPanel extends LinearLayout implements IHaveProperties, IRecieveCollectionChanges {
	UIElementCollection _children;

	public StackPanel(android.content.Context context) {
		super(context);

		// The default orientation is vertical
		this.setOrientation(LinearLayout.VERTICAL);
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
            else if (propertyName.equals("StackPanel.Orientation")) {
                if (((String)propertyValue).toLowerCase().equals("horizontal")) {
            		this.setOrientation(LinearLayout.HORIZONTAL);
                }
                else {
            		this.setOrientation(LinearLayout.VERTICAL);
                }
            }
			else {
				throw new RuntimeException("Unhandled property for " + this.getClass().getSimpleName() + ": " + propertyName);
			}
		}
	}
    
    @Override
    protected void onLayout(boolean changed, int left, int top, int right, int bottom) {
        for (int i = 0; i < _children.size(); i++) {
            positionChild((View)_children.get(i));
        }
        super.onLayout(changed, left, top, right, bottom);
    }
    
    void positionChild(View view) {
        Object margin = Utils.getTag(view, "ace_margin", null);

        ViewGroup.LayoutParams params = view.getLayoutParams();
        if (params instanceof ViewGroup.MarginLayoutParams) {
            if (margin == null) {
                ((ViewGroup.MarginLayoutParams)params).setMargins(0,0,0,0);
            }
            else {
                Thickness t = Thickness.fromObject(margin);
                // Get the scale of screen content
                float scale = Utils.getScaleFactor(getContext());
                ((ViewGroup.MarginLayoutParams)params).setMargins(
                    (int)(t.left * scale),  (int)(t.top * scale),
                    (int)(t.right * scale), (int)(t.bottom * scale));
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
