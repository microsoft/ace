//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package run.ace;

import android.appwidget.AppWidgetManager;
import java.util.ArrayList;

public class AppWidgetData {
    static ArrayList<String> _items = new ArrayList<String>(); //TODO be lazy
    static ArrayList<UpdateEntry> _entries = new ArrayList<UpdateEntry>(); //TODO be lazy

	public static void add(String item, android.content.Context context) {
		_items.add(item);
        AppWidgetManager mgr = AppWidgetManager.getInstance(context);
		for (int i = 0; i < _entries.size(); i++) {
			mgr.notifyAppWidgetViewDataChanged(_entries.get(i).widgetId, _entries.get(i).viewId);
		}
	}

	public static void addWidget(int widgetId, int viewId) {
		_entries.add(new UpdateEntry(widgetId, viewId));
	}

	public static String get(int index) {
		if (index >= _items.size())
			return "";
		else
			return _items.get(index);
	}

	public static void clear() {
		_items.clear();
	}

	public static int getCount() {
		if (_items == null)
			return 0;
		else
			return _items.size();
	}
}

class UpdateEntry {
	public UpdateEntry(int widgetId, int viewId) {
		this.widgetId = widgetId;
		this.viewId = viewId;
	}

	public int widgetId;
	public int viewId;
}
