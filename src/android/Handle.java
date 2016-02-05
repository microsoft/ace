//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package Windows.UI.Xaml.Controls;

import org.json.JSONException;
import org.json.JSONObject;

public class Handle {

	public int value;
	public boolean fromNative;

	//TODO: Lifetime
    // Can't really do weak references without cumbersome client API for keeping things alive.
    // Need to expose reasonable destruction APIs, some automatic with trees of UI objects.
	static java.util.ArrayList<Object> _objectsAssignedOnManagedSide = new java.util.ArrayList<Object>();
	static java.util.ArrayList<Object> _objectsAssignedOnNativeSide = new java.util.ArrayList<Object>();

	static java.util.HashMap<Object, Integer> _managedHandleLookup = new java.util.HashMap<Object, Integer>();
	static java.util.HashMap<Object, Integer> _nativeHandleLookup = new java.util.HashMap<Object, Integer>();

	// Create a handle from the native side
	public Handle() {
		this.value = _objectsAssignedOnNativeSide.size();
		this.fromNative = true;
	}

	// Create a handle from the managed side,
	// using the already-chosen value
	public Handle(int value) {
		this.value = value;
		this.fromNative = false;
	}

	Handle(int value, boolean fromNative) {
		this.value = value;
		this.fromNative = fromNative;
	}

	public static Object toObject(Handle handle) {
		if (handle.fromNative) {
			return _objectsAssignedOnNativeSide.get(handle.value);
		}
		else {
			return _objectsAssignedOnManagedSide.get(handle.value);
		}
	}

	public static Handle fromObject(Object obj) {
        Integer value = _managedHandleLookup.get(obj);
        if (value != null) {
            return new Handle((int)value, false);
        }
        value = _nativeHandleLookup.get(obj);
        if (value != null) {
            return new Handle((int)value, true);
        }
        return null;
    }

	public static Handle fromJSONObject(JSONObject obj) {
		try {
			int value = obj.getInt("value");
			boolean fromNative = obj.optBoolean("fromNative");
			return new Handle(value, fromNative);
		}
		catch (JSONException ex) {
			throw new RuntimeException(ex);
		}
	}

	public JSONObject toJSONObject() {
		try {
			JSONObject obj = new JSONObject();
			obj.put("_t", "H");
			obj.put("value", this.value);
			if (this.fromNative) {
				obj.put("fromNative", true);
			}
			return obj;
		}
		catch (JSONException ex) {
			throw new RuntimeException(ex);
		}
	}

	public static Object deserialize(JSONObject obj) {
		Handle handle = Handle.fromJSONObject(obj);
		return Handle.toObject(handle);
	}

	public void register(Object instance) {
		if (this.fromNative) {
			assign(instance, _objectsAssignedOnNativeSide);
            _nativeHandleLookup.put(instance, this.value);
		}
		else {
			assign(instance, _objectsAssignedOnManagedSide);
            _managedHandleLookup.put(instance, this.value);
		}
	}

	void assign(Object instance, java.util.ArrayList<Object> list) {
		if (list.size() == this.value) {
			list.add(instance);
        }
		else if (list.size() > this.value) {
			list.set(this.value, instance);
        }
		else {
            // Just fill with nulls up to this point.
            // This would have been caused by an earlier instantiation exception,
            // but cascading errors simply from unexpected handles are annoying.
            while (list.size() < this.value) {
                list.add(null);
            }
			list.add(instance);
        }
	}
}
