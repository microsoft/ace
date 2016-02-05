//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package run.ace;

import android.os.Bundle;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AbsoluteLayout;
import Windows.UI.Xaml.Controls.Frame;
import Windows.UI.Xaml.Controls.Page;

// The activity used when navigating to a new native frame.
public class AceActivity extends android.app.Activity {
    View _content;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

		android.app.ActionBar actionBar = this.getActionBar();
		if (actionBar != null) {
            // Only show it if CommandBar is used
            actionBar.hide();
		}

        // TODO: Content must be passed through Bundle/extras (as handle).
        //       Bug once there are two pages and you rotate.
        _content = IncomingMessages.frameContent;
        if (_content != null) {
            // For when this gets re-invoked:
            ViewGroup vg = (ViewGroup)_content.getParent();
            if (vg != null) {
                vg.removeView(_content);
            }

            this.addContentView(_content, new AbsoluteLayout.LayoutParams(
                ViewGroup.LayoutParams.MATCH_PARENT,
                ViewGroup.LayoutParams.MATCH_PARENT, 0, 0));
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        if (_content != null) {
            // Now check for CommandBars/Title
            if (_content instanceof Page) {
                ((Page)_content).processBars(this, menu);
            }
        }

        return true;
    }

    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // The action bar automatically handles clicks on the Home/Up button if
        // you specify a parent activity in AndroidManifest.xml.
        int index = item.getItemId();

        if (_content instanceof Page) {
            Page p = (Page)_content;
            if (p.menuBar != null) {
                p.menuBar.onMenuItemClicked(index);
            }
        }

        return super.onOptionsItemSelected(item);
    }
}
