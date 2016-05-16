//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package run.ace;

import android.content.Context;
import android.graphics.Bitmap;
import android.graphics.Color;
import android.graphics.Typeface;
import android.graphics.drawable.ColorDrawable;
import android.graphics.drawable.Drawable;
import android.graphics.drawable.LayerDrawable;
import android.graphics.drawable.ShapeDrawable;
//import android.support.v7.app.ActionBar;
//import android.support.v7.app.ActionBarActivity;
import android.view.Gravity;
import android.view.View;
import android.view.ViewGroup;
import android.view.Window;
import android.util.TypedValue;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;
import Windows.UI.Xaml.Controls.*;

// This derived from android.widget.Toolbar, but (a) that's not needed
// and (b) Toolbar is only for Lollipop or later
public class TabBar extends android.widget.LinearLayout implements
    //ActionBar.TabListener,
    android.app.ActionBar.TabListener,
    IHaveProperties, IRecieveCollectionChanges {

    ObservableCollection _primaryCommands;
    ObservableCollection _secondaryCommands;

    int barTintColor;
    int tintColor;
    boolean overwriteBarTintColor;
    boolean overwriteTintColor;

	public TabBar(Context context) {
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

    public void show(android.app.Activity activity) {
        //if (!(activity instanceof ActionBarActivity)) {
            android.app.ActionBar mainActionBar = activity.getActionBar();
            if (mainActionBar != null) {
                mainActionBar.show();
                mainActionBar.setNavigationMode(android.app.ActionBar.NAVIGATION_MODE_TABS);

                if (overwriteBarTintColor) {
                    mainActionBar.setStackedBackgroundDrawable(
                        new ColorDrawable(barTintColor)
                    );
                    mainActionBar.setBackgroundDrawable(
                        new ColorDrawable(barTintColor)
                    );

                    Window mainWindow = activity.getWindow();
                    mainWindow.setStatusBarColor(barTintColor);
                }

                if (_primaryCommands != null) {
                    for (int i = 0; i < _primaryCommands.size(); i++) {
                        android.app.ActionBar.Tab tab = mainActionBar.newTab();
                        AppBarButton abb = (AppBarButton)_primaryCommands.get(i);

                        if (abb.icon != null) {
                            tab.setCustomView(getCustomTabView(abb, mainActionBar.getThemedContext()));
                            tab.setTabListener(this);
                            mainActionBar.addTab(tab, i == 0);

                            final View parent = (View) tab.getCustomView().getParent();
                            parent.setPadding(0, 0, 0, 0);
                        }
                        else {
                            tab.setText(abb.label);
                            tab.setTabListener(this);
                            mainActionBar.addTab(tab, i == 0);
                        }
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
        //        actionBar.setNavigationMode(ActionBar.NAVIGATION_MODE_TABS);
        //        for (int i = 0; i < _primaryCommands.size(); i++) {
        //            ActionBar.Tab tab = actionBar.newTab();
        //            AppBarButton abb = (AppBarButton)_primaryCommands.get(i);
        //            if (abb.icon != null) {
        //                tab.setCustomView(getCustomTabView(abb, actionBar.getThemedContext()));
        //            }
        //            else {
        //                tab.setText(abb.label);
        //            }
        //            tab.setTabListener(this);
        //            actionBar.addTab(tab);
        //        }
        //        return;
        //    }
        //    throw new RuntimeException(
        //        "Unable to get TabBar from the current activity.");
        //}
	}

    public static void remove(android.app.Activity activity) {
        //if (!(activity instanceof ActionBarActivity)) {
            android.app.ActionBar mainActionBar = activity.getActionBar();
            if (mainActionBar != null) {
                mainActionBar.hide();
                mainActionBar.setTitle(null);
                mainActionBar.removeAllTabs();
                return;
            }
        //}
        //else {
        //    ActionBar actionBar = ((ActionBarActivity)activity).getSupportActionBar();
        //    if (actionBar != null) {
        //        actionBar.hide();
        //        actionBar.setTitle(null);
        //        actionBar.removeAllTabs();
        //        return;
        //    }
        //}
	}

    View getCustomTabView(AppBarButton abb, Context themedContext) {
        float scaleFactor = Utils.getScaleFactor(themedContext);
        final int IMAGEHEIGHT = (int)(17 * scaleFactor);
        final int TEXTSIZE = 12;
        final int ICON_ONLY_MARGIN = 12;

        LinearLayout ll = new LinearLayout(themedContext);
        LinearLayout.LayoutParams llp = new LinearLayout.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
        llp.gravity = Gravity.CENTER_HORIZONTAL;
        ll.setLayoutParams(llp);
        ll.setOrientation(LinearLayout.VERTICAL);
        ll.setPadding(0, 0, 0, 0);

        if (overwriteBarTintColor) {
            ll.setBackgroundColor(barTintColor);
        }

        if (abb.icon != null) {
            ImageView iv = new ImageView(themedContext);
            if (abb.label != null) {
                LinearLayout.LayoutParams p = new LinearLayout.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT, IMAGEHEIGHT);
                p.topMargin = (int)(4 * scaleFactor);
                p.bottomMargin = (int)(3 * scaleFactor);
                p.gravity = Gravity.CENTER_HORIZONTAL;
                iv.setLayoutParams(p);
            } else {
                LinearLayout.LayoutParams p = new LinearLayout.LayoutParams(
                    ViewGroup.LayoutParams.MATCH_PARENT, ViewGroup.LayoutParams.MATCH_PARENT);
                p.gravity = Gravity.CENTER_HORIZONTAL;
                float d = themedContext.getResources().getDisplayMetrics().density;
                int margin = (int)(ICON_ONLY_MARGIN * d);
                p.topMargin = margin;
                p.bottomMargin = margin;
                iv.setLayoutParams(p);
            }
            Bitmap bitmap = Utils.getBitmapAsset(themedContext, abb.icon.toString());
            iv.setImageDrawable(new android.graphics.drawable.BitmapDrawable(bitmap));

            if (overwriteTintColor) {
                iv.setColorFilter(tintColor);
            }

            ll.addView(iv);
        }

        if (abb.label != null) {
            TextView tv = new TextView(themedContext);
            LinearLayout.LayoutParams tvp = new LinearLayout.LayoutParams(
                ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT);
            tvp.gravity = Gravity.CENTER_HORIZONTAL;
            tv.setLayoutParams(tvp);
            tv.setTypeface(null, Typeface.BOLD);
            tv.setTextSize(TEXTSIZE);
            tv.setText(abb.label.toUpperCase());
            ll.addView(tv);
        }

        return ll;
    }

	public void onTabSelected(android.app.ActionBar.Tab tab, android.app.FragmentTransaction fragmentTransaction) {
        if (overwriteBarTintColor && overwriteTintColor) {
            LinearLayout tabLayout = (LinearLayout) tab.getCustomView();
            ShapeDrawable background = new ShapeDrawable();
            background.getPaint().setColor(tintColor);

            ShapeDrawable border = new ShapeDrawable();
            border.getPaint().setColor(barTintColor);

            Drawable[] layers = {background, border};
            LayerDrawable layerDrawable = new LayerDrawable(layers);

            layerDrawable.setLayerInset(0, 0, 0, 0, 0);
            layerDrawable.setLayerInset(1, 0, 0, 0, 5);

            tabLayout.setBackgroundDrawable(layerDrawable);
            tab.setCustomView(tabLayout);
        }
        int index = tab.getPosition();
        OutgoingMessages.raiseEvent("click", _primaryCommands.get(index), null);
 	}

	public void onTabUnselected(android.app.ActionBar.Tab tab, android.app.FragmentTransaction fragmentTransaction) {
        if (overwriteBarTintColor) {
            LinearLayout tabLayout = (LinearLayout) tab.getCustomView();
            tabLayout.setBackgroundColor(barTintColor);
        }
 	}

	public void onTabReselected(android.app.ActionBar.Tab tab, android.app.FragmentTransaction fragmentTransaction) {
        int index = tab.getPosition();
        OutgoingMessages.raiseEvent("click", _primaryCommands.get(index), null);
 	}

/*
	public void onTabSelected(ActionBar.Tab tab, android.support.v4.app.FragmentTransaction fragmentTransaction) {
        int index = tab.getPosition();
        OutgoingMessages.raiseEvent("click", _primaryCommands.get(index), null);
 	}
	public void onTabUnselected(ActionBar.Tab tab, android.support.v4.app.FragmentTransaction fragmentTransaction) {
 	}
	public void onTabReselected(ActionBar.Tab tab, android.support.v4.app.FragmentTransaction fragmentTransaction) {
        int index = tab.getPosition();
        OutgoingMessages.raiseEvent("click", _primaryCommands.get(index), null);
 	}
*/

	// IHaveProperties.setProperty
	public void setProperty(String propertyName, Object propertyValue)
	{
        if (propertyName.endsWith(".PrimaryCommands") ||
            propertyName.endsWith(".Children")) {
            if (propertyValue == null && _primaryCommands != null) {
                _primaryCommands.removeListener(this);
                _primaryCommands = null;
            }
            else {
                _primaryCommands = (ObservableCollection)propertyValue;
                // Listen to collection changes
                _primaryCommands.addListener(this);
            }
        }
        else if (propertyName.endsWith(".SecondaryCommands") ||
            propertyName.endsWith(".Children")) {
            if (propertyValue == null && _secondaryCommands != null) {
                _secondaryCommands.removeListener(this);
                _secondaryCommands = null;
            }
            else {
                _secondaryCommands = (ObservableCollection)propertyValue;
                // Listen to collection changes
                _secondaryCommands.addListener(this);
            }
        }
        else if (propertyName.endsWith(".BarTintColor")) {
            barTintColor = Color.parseColor((String) propertyValue);
            overwriteBarTintColor = true;
        }
        else if (propertyName.endsWith(".TintColor")) {
            tintColor = Color.parseColor((String) propertyValue);
            overwriteTintColor = true;
        }
		else if (!ViewGroupHelper.setProperty(this, propertyName, propertyValue)) {
			throw new RuntimeException("Unhandled property for " + this.getClass().getSimpleName() + ": " + propertyName);
		}
	}

	// IRecieveCollectionChanges.add
	public void add(Object collection, Object item) {
        if (collection == _primaryCommands) {
            // TODO: Update items
        }
        else if (collection == _secondaryCommands) {
            // TODO: Update items
        }
	}

	// IRecieveCollectionChanges.removeAt
	public void removeAt(Object collection, int index) {
        if (collection == _primaryCommands) {
            // TODO: Update items
        }
        else if (collection == _secondaryCommands) {
            // TODO: Update items
        }
	}
}
