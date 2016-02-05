//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

import java.util.HashMap;

public class Dictionary extends HashMap<Object,Object> {
	public Dictionary(android.content.Context context) {
		super();
	}

	public void Add(Object key, Object value) {
        super.put(key, value);
	}

	public void Remove(Object key) {
		super.remove(key);
	}

	public void Clear() {
		super.clear();
	}
}
