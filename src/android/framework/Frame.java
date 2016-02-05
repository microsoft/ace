//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.graphics.Color;
import android.os.Bundle;
import android.view.ViewGroup;
import android.widget.AbsoluteLayout;
import java.util.Stack;
import run.ace.AceActivity;

public class Frame extends AbsoluteLayout implements IHaveProperties, Application.ActivityLifecycleCallbacks {
    static Stack<Activity> _activities = new Stack<Activity>();
    static Application _application;

	public Frame(Context context) {
		super(context);

        if (_application == null) {
            // Initialization for the host's main frame
            _application = (Application)context.getApplicationContext();
            _application.registerActivityLifecycleCallbacks(this);
        }

        // Fill the area provided by the parent
		this.setLayoutParams(new AbsoluteLayout.LayoutParams(
			ViewGroup.LayoutParams.MATCH_PARENT,
			ViewGroup.LayoutParams.MATCH_PARENT, 0, 0));
	}

    public void onActivityCreated(Activity activity, Bundle savedInstanceState) {
    }
    public void onActivityDestroyed(Activity activity) {
    }
    public void onActivityPaused(Activity activity) {
    }
    public void onActivityResumed(Activity activity) {
    }
    public void onActivitySaveInstanceState(Activity activity, Bundle outState) {
    }
    public void onActivityStarted(Activity activity) {
        // In a back navigation, this activity is the one before the top of the stack
        if (_activities.size() <= 1 || _activities.get(_activities.size() - 2) != activity) {
            // Navigate forward
            _activities.push(activity);
            // TODO: Need to raise navigating and navigated events, but need URL and root.
            //       So probably need to store URL with each activity
        }
        else {
            // Navigate back
            _activities.pop();
            // TODO: Need to raise navigating and navigated events, but need URL and root.
            //       So probably need to store URL with each activity
        }
    }
    public void onActivityStopped(Activity activity) {
    }

    public static void GoBack() {
        // Trigger the onActivityStarted of the previous activity by finishing this one
        Activity a = _activities.peek();
        a.finish();
    }

    public static Activity getTopmostActivity() {
        return _activities.peek();
    }

	// IHaveProperties.setProperty
	public void setProperty(String propertyName, Object propertyValue)
	{
		if (!ViewGroupHelper.setProperty(this, propertyName, propertyValue)) {
			throw new RuntimeException("Unhandled property for " + this.getClass().getSimpleName() + ": " + propertyName);
		}
	}
}
