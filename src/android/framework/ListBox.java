//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

import android.content.Context;
import android.view.View;
import android.view.ViewGroup;
import android.widget.AdapterView;
import android.widget.ArrayAdapter;
import android.widget.ListView;
import java.util.ArrayList;
import run.ace.*;

public class ListBox extends ListView implements IHaveProperties, IFireEvents, IRecieveCollectionChanges {
	int _selectionChangedHandlers = 0;
	ObservableCollection _items;
	ListBoxItemAdapter _adapter;

	public ListBox(Context context) {
		super(context);
	}

	// IHaveProperties.setProperty
	public void setProperty(String propertyName, Object propertyValue)
	{
		if (!ViewHelper.setProperty(this, propertyName, propertyValue, false)) {
			if (propertyName.equals("ItemsControl.Items")) {
				_items = (ObservableCollection)propertyValue;
				_adapter = new ListBoxItemAdapter(getContext(), _items);
                setAdapter(_adapter);

				// Listen to collection changes
				_items.addListener(this);
			}
			else {
				throw new RuntimeException("Unhandled property for " + this.getClass().getSimpleName() + ": " + propertyName);
			}
		}
	}

	// IRecieveCollectionChanges.add
	public void add(Object collection, Object item) {
		assert collection == _items;
		_adapter.notifyDataSetChanged();
	}

	// IRecieveCollectionChanges.removeAt
	public void removeAt(Object collection, int index) {
		assert collection == _items;
		_adapter.notifyDataSetChanged();
	}

	// IFireEvents.addEventHandler
	public void addEventHandler(final String eventName, final Handle handle) {
		if (eventName.equals("selectionchanged")) {
			if (_selectionChangedHandlers == 0) {
				// Set up the message sending, which goes to all handlers
				this.setOnItemClickListener(new ListView.OnItemClickListener() {
					public void onItemClick(AdapterView<?> adapter, View v, int position, long arg3) {
						Object selection = adapter.getItemAtPosition(position);
						OutgoingMessages.raiseEvent(eventName, handle, selection, position);
					}
				});
			}
			_selectionChangedHandlers++;
		}
	}

	// IFireEvents.removeEventHandler
	public void removeEventHandler(String eventName) {
		if (eventName.equals("selectionchanged")) {
			_selectionChangedHandlers--;
			if (_selectionChangedHandlers == 0) {
				// Stop sending messages because nobody is listening
				this.setOnItemClickListener(null);
			}
		}
	}

	// Produces the view for each item in the list
	class ListBoxItemAdapter extends ArrayAdapter<Object>
	{
	    ArrayList _list;

	    public ListBoxItemAdapter(Context context, ArrayList list) {
	        super(context, android.R.layout.simple_list_item_activated_1 /*unused*/, list);
	        _list = list;
	    }

	    public View getView(int position, View convertView, ViewGroup parent) {
				Object item = _list.get(position);

				if (item instanceof View) {
					// The item in the list is already a View, so just use it.
					return (View)item;
				}

				// Wrap the item in a container
				ListBoxItem container = null;
				if (false) { //TODO: Reuse causing problems: if (convertView instanceof ListBoxItem) {
					// Reuse an existing container
					container = (ListBoxItem)convertView;
				}
				else {
					// Create a new container
					container = new ListBoxItem(getContext());
				}
				container.setContent(item);
				return container;
	    }
	}
}
