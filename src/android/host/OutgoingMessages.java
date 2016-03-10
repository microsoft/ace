//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package run.ace;

import org.apache.cordova.CallbackContext;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import Windows.UI.Xaml.Controls.Handle;

// Used for sending data back (raising events)
public class OutgoingMessages {
	static CallbackContext _callbackContext = null;

	public static void setCallbackContext(CallbackContext context) {
		_callbackContext = context;
	}

	public static void raiseEvent(String eventName, Object instance, Object eventData) {
		send(new Object[]{instance == null ? null : Handle.fromObject(instance).toJSONObject(), eventName, eventData});
	}

	public static void raiseEvent(String eventName, Handle handle, Object eventData) {
		send(new Object[]{handle == null ? null : handle.toJSONObject(), eventName, eventData});
	}

	public static void raiseEvent(String eventName, Object instance, Object eventData1, Object eventData2) {
		send(new Object[]{instance == null ? null : Handle.fromObject(instance).toJSONObject(), eventName, eventData1, eventData2});
	}

	public static void raiseEvent(String eventName, Handle handle, Object eventData1, Object eventData2) {
		send(new Object[]{handle == null ? null : handle.toJSONObject(), eventName, eventData1, eventData2});
	}

	static void send(Object[] data) {
		PluginResult r = null;
		try {
			r = new PluginResult(PluginResult.Status.OK, new JSONArray(data));
		}
		catch (JSONException ex) {
			r = new PluginResult(PluginResult.Status.ERROR, "Could not send back native data " + data + ": " + ex.toString());
		}
		r.setKeepCallback(true);
		_callbackContext.sendPluginResult(r);
	}
}
