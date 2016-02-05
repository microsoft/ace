//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

import android.view.View;
import java.util.ArrayList;

public class ObservableCollection extends ArrayList {

	ArrayList<IRecieveCollectionChanges> _listeners;

	public ObservableCollection(android.content.Context context) {
		super();
	}

	public void addListener(IRecieveCollectionChanges listener) {
		if (_listeners == null)
			_listeners = new ArrayList<IRecieveCollectionChanges>();

		_listeners.add(listener);

		// Notify listener about any items added before listening
		if (super.size() > 0) {
			for (int i = 0; i < super.size(); i++) {
				listener.add(this, super.get(i));
			}
		}
	}

	public void removeListener(IRecieveCollectionChanges listener) {
		if (_listeners != null)
			_listeners.remove(listener);
	}

	public boolean Add(Object item) {
		boolean success = super.add(item);
		if (success && _listeners != null) {
			// Notify any listeners
			for (int i = 0; i < _listeners.size(); i++) {
				_listeners.get(i).add(this, item);
			}
		}
		return success;
	}

	public void RemoveAt(int index) {
		super.remove(index);
		if (_listeners != null) {
			// Notify any listeners
			for (int i = 0; i < _listeners.size(); i++) {
				_listeners.get(i).removeAt(this, index);
			}
		}
	}

	public void Clear() {
		super.clear();
        //TODO: Need to notify listeners!
	}
}
