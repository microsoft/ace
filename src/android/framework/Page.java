//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

import android.graphics.Color;
import android.view.ViewGroup;
import android.view.Window;
import android.widget.AbsoluteLayout;
import run.ace.NativeHost;
import run.ace.TabBar;

public class Page extends AbsoluteLayout implements IHaveProperties {

    public TabBar tabBar;
    public CommandBar menuBar;
    public String frameTitle;

	public Page(android.content.Context context) {
		super(context);

        // Fill the area provided by the parent
		this.setLayoutParams(new AbsoluteLayout.LayoutParams(
			ViewGroup.LayoutParams.MATCH_PARENT,
			ViewGroup.LayoutParams.MATCH_PARENT, 0, 0));
	}

	// IHaveProperties.setProperty
	public void setProperty(String propertyName, Object propertyValue)
	{
        if (propertyName.endsWith(".BottomAppBar")) {
            // TODO: Need to handle this being set after already inside activity,
            //       and also handling invalidations inside buttons, etc.
            if (propertyValue instanceof TabBar) {
                tabBar = (TabBar)propertyValue;
            }
            else if (propertyValue instanceof CommandBar) {
                menuBar = (CommandBar)propertyValue;
            }
            else if (propertyValue == null) {
                tabBar = null;
                menuBar = null;
            }
            else {
    			throw new RuntimeException("Unhandled value for BottomAppBar: " + propertyValue);
            }
        }
        else if (propertyName.endsWith(".TopAppBar")) {
            // TODO: Need to handle this being set after already inside activity,
            //       and also handling invalidations inside buttons, etc.
            menuBar = (CommandBar)propertyValue;
        }
        else if (propertyName.endsWith(".Title")) {
            frameTitle = (String)propertyValue;
            // If this is the currently-visible page, update the title now:
            // TODO: This only handles the main activity
            if (this.getParent() == NativeHost.getRootView()) {
                updateTitle(NativeHost.getMainActivity());
            }
        }
        else if (propertyName.endsWith(".BarTintColor")) {
            if (this.getParent() == NativeHost.getRootView()) {
                Window mainWindow = NativeHost.getMainActivity().getWindow();
                mainWindow.setNavigationBarColor(Color.parseColor((String) propertyValue));
            }
        }
        else if (propertyName.endsWith(".TintColor")) {

        }
		else if (!ViewGroupHelper.setProperty(this, propertyName, propertyValue)) {
			throw new RuntimeException("Unhandled property for " + this.getClass().getSimpleName() + ": " + propertyName);
		}
	}

    void updateTitle(android.app.Activity activity) {
        if (this.tabBar != null) {
            this.tabBar.setTitle(this.frameTitle == null ? "" : this.frameTitle, activity);
        }
        if (this.menuBar != null) {
            this.menuBar.setTitle(this.frameTitle == null ? "" : this.frameTitle, activity);
        }
    }

    public void processBars(android.app.Activity activity, android.view.Menu menu) {
        updateTitle(activity);
        if (this.tabBar != null) {
            this.tabBar.show(activity);
        }
        if (this.menuBar != null) {
            this.menuBar.show(activity, menu);
        }
    }
}
