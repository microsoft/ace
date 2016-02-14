//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package run.ace;

import android.app.Activity;
import android.content.Context;
import android.content.Intent;
import android.view.View;
import android.view.ViewGroup;
import android.widget.TextView;
import java.lang.IllegalAccessException;
import java.lang.InstantiationException;
import java.lang.NoSuchMethodException;
import java.lang.reflect.InvocationTargetException;
import org.apache.cordova.CordovaWebView;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import Windows.UI.Xaml.Controls.*;

// Handles all incoming messages
public class IncomingMessages {
	public static final int MSG_CREATE = 0;
	public static final int MSG_SET = 1;
	public static final int MSG_INVOKE = 2;
	public static final int MSG_EVENTADD = 3;
	public static final int MSG_EVENTREMOVE = 4;
	public static final int MSG_STATICINVOKE = 5;
	public static final int MSG_FIELDGET = 6;
	public static final int MSG_STATICFIELDGET = 7;
	public static final int MSG_GETINSTANCE = 8;
	public static final int MSG_NAVIGATE = 9;
	public static final int MSG_FIELDSET = 10;
	public static final int MSG_PRIVATEFIELDGET = 11;

    // Holds the content during a navigation
    public static View frameContent;

	// Create an object instance
	public static Object create(JSONArray message, Activity activity) throws JSONException
	{
		String fullTypeName = message.getString(2);
		Class c = null;
		Object instance = null;
		try {
				c = Class.forName(fullTypeName);
		} catch (ClassNotFoundException e) {
				throw new RuntimeException("Unable to find a class named '" + fullTypeName + "'");
		}

        if (message.length() == 4) {
            // Parameterized constructor
            JSONArray constructorArgs = message.getJSONArray(3);
            Object[] args = Utils.convertJSONArrayToArray(constructorArgs);
            instance = Utils.invokeConstructorWithBestParameterMatch(c, args);
        }
        else {
            // Default constructor
            try {
                // Expect the Context constructor
                try {
                    instance = c.getConstructor(new Class[]{Context.class}).newInstance(activity);
                }
                catch (NoSuchMethodException ex) {
                    // Try the default constructor instead
                    instance = c.getConstructor().newInstance();
                }
            }
            catch (NoSuchMethodException ex) {
                throw new RuntimeException(fullTypeName + " does not have a public default constructor, or a public constructor with a single Context parameter");
            }
            catch (InvocationTargetException ex) {
                throw new RuntimeException("Error in " + fullTypeName + " constructor: " + ex.getTargetException().toString());
            }
            catch (IllegalAccessException ex) {
                throw new RuntimeException(fullTypeName + ", or its relevant constructor, isn't public");
            }
            catch (InstantiationException ex) {
                throw new RuntimeException("Error instantiating " + fullTypeName + ": " + ex.toString());
            }
        }

		return instance;
	}

	// Get an existing well-known object instance
	public static Object getInstance(JSONArray message, Activity activity, CordovaWebView webView) throws JSONException {
		String fullTypeName = message.getString(2);

		if (fullTypeName.equals("android.content.Context")) {
			return activity.getApplicationContext();
		}
		else if (fullTypeName.equals("android.app.Activity")) {
			return activity;
		}
		else if (fullTypeName.equals("android.content.Intent")) {
			return NativeHost.intent;
		}
		else if (fullTypeName.equals("HostPage")) {
            return activity.findViewById(android.R.id.content);
		}
		else if (fullTypeName.equals("HostWebView")) {
            return webView.getView();
		}
        else if (fullTypeName.equals("PluginManager")) {
            return webView.getPluginManager();
        }

		throw new RuntimeException(fullTypeName + " is not a valid choice for getting an existing instance");
	}

	public static void set(JSONArray message) throws JSONException
	{
		Object instance = Handle.deserialize(message.getJSONObject(1));
		String propertyName = message.getString(2);
		Object propertyValue = message.get(3);

        // Convert non-primitives (TODO arrays)
        if (propertyValue instanceof JSONObject) {
            propertyValue = Utils.deserializeObjectOrStruct((JSONObject)propertyValue);
        }
        else if (propertyValue == JSONObject.NULL) {
            propertyValue = null;
        }

		try {
			if (instance instanceof IHaveProperties) {
				((IHaveProperties)instance).setProperty(propertyName, propertyValue);
			}
            else {
                // Try reflection. So XXX.YYY maps to a setYYY method.
                try {
                    String setterName = "set";
                    if (propertyName.contains(".")) {
                        setterName += propertyName.substring(propertyName.lastIndexOf(".") + 1);
                    }
                    else {
                        setterName += propertyName;
                    }

                    //TODO: Need to do more permissive parameter matching in this case since everything will be strings.
                    // Started to add this with looseMatching param. Continue.
                    try {
                        Integer value = Integer.parseInt(propertyValue.toString());
                        propertyValue = value;
                    }
                    catch (java.lang.NumberFormatException nfe)
                    {
                        try {
                            Double value = Double.parseDouble(propertyValue.toString());
                            propertyValue = value;
                        }
                        catch (java.lang.NumberFormatException nfe2)
                        {
                            // Keep as string
                        }
                    }

                    // TODO: Enable marshaling of things like "red" to Drawable...

                    Utils.invokeMethodWithBestParameterMatch(instance.getClass(), setterName, instance, new Object[]{propertyValue}, true);
                }
                catch (Exception ex) {
                    //
                    // Translate standard cross-platform (XAML) properties for well-known base types
                    //
                    if (instance instanceof TextView) {

                        if (propertyName.endsWith(".Children") && propertyValue instanceof ItemCollection) {
                            // This is from XAML compilation of a custom content property, which always gives an ItemCollection.
                            propertyName = "ContentControl.Content";
                            if (((ItemCollection)propertyValue).size() == 1) {
                                propertyValue = ((ItemCollection)propertyValue).get(0);
                            }
                        }

                        if (!TextViewHelper.setProperty((TextView)instance, propertyName, propertyValue)) {
                            throw new RuntimeException("Unhandled property for a custom TextView: " + propertyName + ". Implement IHaveProperties to support this.");
                        }
                    }
                    else if (instance instanceof ViewGroup) {
                        if (propertyName.endsWith(".Children") && propertyValue instanceof ItemCollection) {
                            // This is from XAML compilation of a custom content property, which always gives an ItemCollection.
                            ItemCollection children = (ItemCollection)propertyValue;
                            for (int i = 0; i < children.size(); i++) {
                           		((ViewGroup)instance).addView((View)children.get(i));
                            }
                        }
                        else if (!ViewGroupHelper.setProperty((ViewGroup)instance, propertyName, propertyValue)) {
                            throw new RuntimeException("Unhandled property for a custom ViewGroup: " + propertyName + ". Implement IHaveProperties to support this.");
                        }
                    }
                    else if (instance instanceof View) {
                        if (!ViewHelper.setProperty((View)instance, propertyName, propertyValue, true)) {
                            throw new RuntimeException("Unhandled property for a custom View: " + propertyName + ". Implement IHaveProperties to support this.");
                        }
                    }
                    else {
                        throw new RuntimeException("Either there must be a set" + propertyName + " method, or IHaveProperties must be implemented.");
                    }
                }
            }
		} catch (Exception ex) {
			throw new RuntimeException("Error setting " + instance.getClass().getSimpleName() + "'s " + propertyName + " to " + propertyValue, ex);
		}
	}

	public static Object invoke(JSONArray message) throws JSONException {
		Object instance = Handle.deserialize(message.getJSONObject(1));
		String methodName = message.getString(2);
		JSONArray array = message.getJSONArray(3);
		return Utils.invokeMethod(instance.getClass(), instance, methodName, array);
	}

	public static Object staticInvoke(JSONArray message) throws JSONException
	{
		String fullTypeName = message.getString(1);
		String methodName = message.getString(2);
		JSONArray array = message.getJSONArray(3);

		Class c = null;
		try {
				c = Class.forName(fullTypeName);
		} catch (ClassNotFoundException e) {
				throw new RuntimeException("Unable to find a class named '" + fullTypeName + "'");
		}

		return Utils.invokeMethod(c, null, methodName, array);
	}

	public static Object fieldGet(JSONArray message) throws JSONException
	{
		Object instance = Handle.deserialize(message.getJSONObject(1));
		String fieldName = message.getString(2);
		return Utils.getField(instance.getClass(), instance, fieldName);
	}

	public static Object privateFieldGet(JSONArray message) throws JSONException
	{
		Object instance = Handle.deserialize(message.getJSONObject(1));
		String fieldName = message.getString(2);
		return Utils.getPrivateField(instance.getClass(), instance, fieldName);
	}

	public static Object staticFieldGet(JSONArray message) throws JSONException
	{
		String fullTypeName = message.getString(1);
		String fieldName = message.getString(2);

		Class c = null;
		try {
				c = Class.forName(fullTypeName);
		} catch (ClassNotFoundException e) {
				throw new RuntimeException("Unable to find a class named '" + fullTypeName + "'");
		}

		return Utils.getField(c, null, fieldName);
	}

	public static void fieldSet(JSONArray message) throws JSONException
	{
		Object instance = Handle.deserialize(message.getJSONObject(1));
		String fieldName = message.getString(2);
        Object fieldValue = message.get(3);

        // Convert non-primitives
        if (fieldValue instanceof JSONObject) {
            fieldValue = Utils.deserializeObjectOrStruct((JSONObject)fieldValue);
        }
        else if (fieldValue == JSONObject.NULL) {
            fieldValue = null;
        }

		Utils.setField(instance.getClass(), instance, fieldName, fieldValue);
	}

	public static void eventAdd(JSONArray message) throws JSONException
	{
		Handle handle = Handle.fromJSONObject(message.getJSONObject(1));
		Object instance = Handle.toObject(handle);
		String eventName = message.getString(2);
		if (instance instanceof IFireEvents) {
			((IFireEvents)instance).addEventHandler(eventName, handle);
		}
		else if (!NativeEventAttacher.attach(instance, eventName, handle)) {
			throw new RuntimeException("Attaching handler for " + eventName + ", but it's not recognized and " + instance + " doesn't support IFireEvents.");
		}
	}

	public static void eventRemove(JSONArray message) throws JSONException
	{
		Object instance = Handle.deserialize(message.getJSONObject(1));
		String eventName = message.getString(2);
		if (instance instanceof IFireEvents) {
			((IFireEvents)instance).removeEventHandler(eventName);
		}
		else if (!NativeEventAttacher.detach(instance, eventName)) {
			throw new RuntimeException("Removing handler for " + eventName + ", but it's not recognized and " + instance + " doesn't support IFireEvents.");
		}
	}

    public static void navigate(View root, Activity activity) {
        frameContent = root;
        Intent intent = new Intent(activity, AceActivity.class);
        activity.startActivity(intent);
    }
}
