//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package run.ace;

import android.appwidget.AppWidgetManager;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.widget.RemoteViews;
import android.widget.RemoteViewsService;

public class AppWidgetService extends RemoteViewsService {
    @Override
    public RemoteViewsFactory onGetViewFactory(Intent intent) {
        return new SampleRemoteViewsFactory(this.getApplicationContext(), intent);
    }
}

class SampleRemoteViewsFactory implements RemoteViewsService.RemoteViewsFactory {
    Context _context;
	int _appWidgetId;
	int _itemResourceId;
	int _itemTextResourceId;
	int _itemLayoutResourceId;

    public SampleRemoteViewsFactory(Context context, Intent intent) {
        _context = context;
        _appWidgetId = intent.getIntExtra(AppWidgetManager.EXTRA_APPWIDGET_ID, AppWidgetManager.INVALID_APPWIDGET_ID);
        _itemResourceId = intent.getIntExtra("widgetItemId", -1);
        _itemTextResourceId = intent.getIntExtra("widgetItemTextId", -1);
        _itemLayoutResourceId = intent.getIntExtra("widgetItemLayoutId", -1);
    }

    public void onCreate() {
		AppWidgetData.add("Run the app to populate this widget.", _context);
		// TODO: Should we refresh data on app resume in some cases?
    }

    public void onDestroy() {
        AppWidgetData.clear();
    }

    public int getCount() {
        return AppWidgetData.getCount();
    }

    public RemoteViews getViewAt(int position) {
        RemoteViews rv = new RemoteViews(_context.getPackageName(), _itemLayoutResourceId);
        rv.setTextViewText(_itemTextResourceId, AppWidgetData.get(position));

        Bundle extras = new Bundle();
        extras.putInt(AppWidgetProvider.EXTRA_ITEM, position);
        Intent fillInIntent = new Intent();
        fillInIntent.putExtras(extras);
        rv.setOnClickFillInIntent(_itemResourceId, fillInIntent);

        return rv;
    }

    public RemoteViews getLoadingView() {
		// A custom loading view
        return null;
    }

    public int getViewTypeCount() {
        return 1;
    }

    public long getItemId(int position) {
        return position;
    }

    public boolean hasStableIds() {
        return true;
    }

    public void onDataSetChanged() {
        // For when AppWidgetManager.notifyAppWidgetViewDataChanged is called
    }
}
