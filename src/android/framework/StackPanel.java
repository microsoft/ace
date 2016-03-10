//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

import android.view.Gravity;
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
        if (_children != null) {
            for (int i = 0; i < _children.size(); i++) {
                positionChild((View)_children.get(i));
            }
        }
        super.onLayout(changed, left, top, right, bottom);
    }
    
    void positionChild(View view) {
        Thickness margin = (Thickness)Utils.getTag(view, "ace_margin", null);

        ViewGroup.LayoutParams params = view.getLayoutParams();
        if (params instanceof ViewGroup.MarginLayoutParams) {
            if (margin == null) {
                ((ViewGroup.MarginLayoutParams)params).setMargins(0,0,0,0);
            }
            else {
                // Get the scale of screen content
                float scale = Utils.getScaleFactor(getContext());
                ((ViewGroup.MarginLayoutParams)params).setMargins(
                    (int)(margin.left * scale),  (int)(margin.top * scale),
                    (int)(margin.right * scale), (int)(margin.bottom * scale));
            }
        }
        
        if (params instanceof LinearLayout.LayoutParams) {
            LinearLayout.LayoutParams llp = (LinearLayout.LayoutParams)params;
            
            if (this.getOrientation() == LinearLayout.VERTICAL) {
                String halign = (String)Utils.getTag(view, "ace_horizontalalignment", null);
                if (halign != null) {
                    if (halign.equals("center")) {
                        llp.gravity = Gravity.CENTER_HORIZONTAL;
                        llp.width = ViewGroup.LayoutParams.WRAP_CONTENT;
                    }
                    else if (halign.equals("left")) {
                        llp.gravity = Gravity.LEFT;
                        llp.width = ViewGroup.LayoutParams.WRAP_CONTENT;
                    }
                    else if (halign.equals("right")) {
                        llp.gravity = Gravity.RIGHT;
                        llp.width = ViewGroup.LayoutParams.WRAP_CONTENT;
                    }
                    else if (halign.equals("stretch")) {
                        llp.gravity = Gravity.FILL_HORIZONTAL;
                        llp.width = ViewGroup.LayoutParams.MATCH_PARENT;
                    }
                    else {
                        throw new RuntimeException("Unknown HorizontalAlignment: " + halign);
                    }
                }
                else {
                    // Stretch by default
                    llp.gravity = Gravity.FILL_HORIZONTAL;
                    llp.width = ViewGroup.LayoutParams.MATCH_PARENT;
                }
            }
            else {
                String valign = (String)Utils.getTag(view, "ace_verticalalignment", null);
                if (valign != null) {
                    if (valign.equals("center")) {
                        llp.gravity = Gravity.CENTER_VERTICAL;
                        llp.height = ViewGroup.LayoutParams.WRAP_CONTENT;
                    }
                    else if (valign.equals("top")) {
                        llp.gravity = Gravity.TOP;
                        llp.height = ViewGroup.LayoutParams.WRAP_CONTENT;
                    }
                    else if (valign.equals("bottom")) {
                        llp.gravity = Gravity.BOTTOM;
                        llp.height = ViewGroup.LayoutParams.WRAP_CONTENT;
                    }
                    else if (valign.equals("stretch")) {
                        llp.gravity = Gravity.FILL_VERTICAL;
                        llp.height = ViewGroup.LayoutParams.MATCH_PARENT;
                    }
                    else {
                        throw new RuntimeException("Unknown VerticalAlignment: " + valign);
                    }
                }
                else {
                    // Stretch by default
                    llp.gravity = Gravity.FILL_VERTICAL;
                    llp.height = ViewGroup.LayoutParams.MATCH_PARENT;
                }
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
