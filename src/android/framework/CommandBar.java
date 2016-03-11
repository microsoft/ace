//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

//import android.support.v7.app.ActionBar;
//import android.support.v7.app.ActionBarActivity;
import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import run.ace.*;

// This derived from android.widget.Toolbar, but (a) that's not needed
// and (b) Toolbar is only for Lollipop or later
public class CommandBar extends android.widget.LinearLayout implements IHaveProperties {
    ObservableCollection _primaryCommands;
    ObservableCollection _secondaryCommands;

	public CommandBar(Context context) {
		super(context);
    }

    public void setTitle(String title, android.app.Activity activity) {
        //if (!(activity instanceof ActionBarActivity)) {
            android.app.ActionBar actionBar = activity.getActionBar();
            if (actionBar == null) {
                throw new RuntimeException(
                    "Cannot set title on the main page in Android unless you set <preference name=\"ShowTitle\" value=\"true\"/> in config.xml.");
            }
            actionBar.setTitle(title);
        //}
        //else {
        //    ActionBar actionBar = ((ActionBarActivity)activity).getSupportActionBar();
        //    if (actionBar != null) {
        //        actionBar.setTitle(title);
        //    }
        //}
    }

    public void onMenuItemClicked(int index) {
        OutgoingMessages.raiseEvent("click", _primaryCommands.get(index), null);
    }

    public void show(android.app.Activity activity, android.view.Menu menu) {
        //if (!(activity instanceof ActionBarActivity)) {
            android.app.ActionBar mainActionBar = activity.getActionBar();
            if (mainActionBar != null) {
                mainActionBar.show();
                if (_primaryCommands != null) {
                    for (int i = 0; i < _primaryCommands.size(); i++) {
                        menu.add(0, i, 0, ((AppBarButton)_primaryCommands.get(i)).label);
                        menu.getItem(i).setShowAsAction(android.view.MenuItem.SHOW_AS_ACTION_ALWAYS);
                    }
                }
                return;
            }
            throw new RuntimeException(
                "Cannot use TabBar on the main page in Android unless you set <preference name=\"ShowTitle\" value=\"true\"/> in config.xml.");
        //}
        //else {
        //    ActionBar actionBar = ((ActionBarActivity)activity).getSupportActionBar();
        //    if (actionBar != null) {
        //        actionBar.show();
        //        for (int i = 0; i < _primaryCommands.size(); i++) {
        //            menu.add(0, i, 0, ((AppBarButton)_primaryCommands.get(i)).label);
        //            menu.getItem(i).setShowAsAction(android.view.MenuItem.SHOW_AS_ACTION_ALWAYS);
        //        }
        //        return;
        //    }
        //    throw new RuntimeException(
        //        "Unable to get the action bar from the current activity.");
        //}
	}

    public static void remove(android.app.Activity activity, android.view.Menu menu) {
        //if (!(activity instanceof ActionBarActivity)) {
            android.app.ActionBar mainActionBar = activity.getActionBar();
            if (mainActionBar != null) {
                mainActionBar.hide();
                mainActionBar.setTitle(null);
                menu.clear();
                return;
            }
        //}
        //else {
        //    ActionBar actionBar = ((ActionBarActivity)activity).getSupportActionBar();
        //    if (actionBar != null) {
        //        actionBar.hide();
        //        actionBar.setTitle(null);
        //        menu.clear();
        //        return;
        //    }
        //}
	}

/*
	public void onTabSelected(ActionBar.Tab tab, android.support.v4.app.FragmentTransaction fragmentTransaction) {
 	}
	public void onTabUnselected(ActionBar.Tab tab, android.support.v4.app.FragmentTransaction fragmentTransaction) {
 	}
	public void onTabReselected(ActionBar.Tab tab, android.support.v4.app.FragmentTransaction fragmentTransaction) {
 	}
*/

	// IHaveProperties.setProperty
	public void setProperty(String propertyName, Object propertyValue)
	{
        if (propertyName.endsWith(".PrimaryCommands")) {
            _primaryCommands = (ObservableCollection)propertyValue;
        }
        else if (propertyName.endsWith(".SecondaryCommands")) {
            _secondaryCommands = (ObservableCollection)propertyValue;
        }
		else if (!ViewGroupHelper.setProperty(this, propertyName, propertyValue)) {
			throw new RuntimeException("Unhandled property for " + this.getClass().getSimpleName() + ": " + propertyName);
		}
	}
}
