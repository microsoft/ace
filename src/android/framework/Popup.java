//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls.Primitives;

import android.app.Activity;
import android.content.Context;
import android.graphics.Color;
import android.view.ViewGroup;
import android.widget.AbsoluteLayout;
import run.ace.Utils;
import Windows.UI.Xaml.Controls.*;

public class Popup extends AbsoluteLayout implements IHaveProperties {
    // An implicit root view that holds all popups
    static android.view.ViewGroup _rootView = null;

    static AbsoluteLayout.LayoutParams _fullScreenParams =
        new AbsoluteLayout.LayoutParams(
            ViewGroup.LayoutParams.MATCH_PARENT,
            ViewGroup.LayoutParams.MATCH_PARENT, 0, 0);

    static double _scale = 0;

    public Popup(Context context) {
        super(context);

        if (context instanceof run.ace.AceActivity) {
            // Nothing to do here
        }
        else {
            // This is the default Cordova activity
            if (_rootView == null) {
                // This is the first Popup. Create the parent _rootView.
                _rootView = new AbsoluteLayout(context);
                ((Activity)context).addContentView(_rootView, _fullScreenParams);
            }
        }

        if (_scale == 0) {
            // Get the scale of screen content so popups can be placed as expected
            _scale = Utils.getScaleFactor(context);
        }

        // Fullscreen by default
        this.Maximize();
    }

    // IHaveProperties.setProperty
    public void setProperty(String propertyName, Object propertyValue)
    {
        if (!ViewGroupHelper.setProperty(this, propertyName, propertyValue)) {
            throw new RuntimeException("Unhandled property for " + this.getClass().getSimpleName() + ": " + propertyName);
        }
    }

    public static void CloseAll() {
        // TODO: release all references, too
        if (_rootView != null) {
            _rootView.removeAllViews();
        }
    }

    public void Show() {
        _rootView.addView(this);
    }

    public void Hide() {
        _rootView.removeView(this);
        if (_rootView.getChildCount() == 0) {
            // So any new popup is likely to be on top of all views due to _rootView recreation
            _rootView = null;
        }
    }

    public void SetPosition(double x, double y) {
        int left = (int)(x * _scale);
        int top = (int)(y * _scale);

        this.setLayoutParams(new AbsoluteLayout.LayoutParams(
            ViewGroup.LayoutParams.WRAP_CONTENT, ViewGroup.LayoutParams.WRAP_CONTENT, left, top));
    }

    public void SetRect(int x, int y, int width, int height) {
        this.setLayoutParams(new AbsoluteLayout.LayoutParams((int)(width * _scale), (int)(height * _scale),
            (int)(x * _scale), (int)(y * _scale)));
    }

    public void Maximize() {
        this.setLayoutParams(_fullScreenParams);
    }
}
