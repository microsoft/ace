//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package run.ace;

import android.app.Activity;
import android.app.Application;
import android.content.Context;
import android.content.Intent;
import android.content.res.AssetManager;
import android.content.res.Resources;
import android.view.Menu;
import android.view.View;
import java.io.ByteArrayOutputStream;
import java.io.InputStream;
import java.io.IOException;
import java.io.PrintStream;
import java.lang.reflect.Field;
import org.apache.cordova.CallbackContext;
import org.apache.cordova.CordovaActivity;
import org.apache.cordova.CordovaInterface;
import org.apache.cordova.CordovaPlugin;
import org.apache.cordova.CordovaWebView;
import org.apache.cordova.PluginResult;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import Windows.UI.Xaml.Controls.Handle;
import Windows.UI.Xaml.Controls.Frame;
import Windows.UI.Xaml.Controls.Primitives.Popup;

public class NativeHost extends CordovaPlugin {
    public static Intent intent;
    static Application _application;
	static CordovaActivity _activity;
    static Menu _menu;
    CordovaWebView _webView;
    Frame _mainFrame;
    //TODO: byte[] _startupMarkup;

    boolean _setting_PopupsCloseOnHtmlNavigation;

	public NativeHost() {
	}

    public static Application getApplication() {
        return _application;
    }

    public static Activity getMainActivity() {
        return _activity;
    }

    public static View getRootView() {
        return _activity.findViewById(android.R.id.content);
    }

    public static Menu getRootMenu() {
        return _menu;
    }

    // Used by third-party Java code to dynamically get R.type.name
    public static int getResourceId(String name, String type, Context context) {
        String packageName = ((Application)context.getApplicationContext()).getPackageName();
        Resources resources = ((Application)context.getApplicationContext()).getResources();
        int id = resources.getIdentifier(name, type, packageName);
        if (id == 0) {
            throw new RuntimeException("Resource '" + packageName + ":" + type + "/" + name + "' not found");
        }
        return id;
    }

    public static void startActivity(String name) {
        Class c = null;
        try {
                c = Class.forName(name);
        } catch (ClassNotFoundException e) {
                throw new RuntimeException("Unable to find a class named '" + name + "'");
        }
        android.content.Intent intent = new android.content.Intent(_activity, c);
        _activity.startActivity(intent);
    }

	@Override
	public void initialize(CordovaInterface cordova, CordovaWebView webView) {
		super.initialize(cordova, webView);
        _activity = (CordovaActivity)cordova.getActivity();
        _application = _activity.getApplication();
        _webView = webView;
        _mainFrame = new Frame(_activity);
        this.intent = _activity.getIntent();

        /* TODO: No point unless XBF parsing is also done in native host
                 and instances can be retrieved on managed side without
                 caching of property values
        try {
            _startupMarkup = readXbf("www/xbf/startup.xbf");
            // Since a startup markup file exists, detach the WebView
            ((android.view.ViewGroup)_webView.getView().getParent()).removeView(_webView.getView());
		}
		catch (IOException ex) {
            // A startup markup file doesn't exist
		}
        */

		// TODO: Remove the hiding here, or do it off of some setting
		final android.app.ActionBar actionBar = _activity.getActionBar();
		if (actionBar != null) {
			Runnable runnable = new Runnable() {
				public void run() {
					actionBar.hide();
				};
			};
			_activity.runOnUiThread(runnable);
		}
	}

    public void onNewIntent(Intent intent) {
        // This is important when we were launched by a widget item click
        this.intent = intent;
        OutgoingMessages.raiseEvent("ace.android.intentchanged", null, null);
    }

    // Called when the URL of the webview changes.
    // TODO: Unlike iOS, this does not detect back navigation
    @Override
    public boolean onOverrideUrlLoading(String url) {
        if (url.startsWith("native://") || url.startsWith("android://")) {
            OutgoingMessages.raiseEvent("ace.navigate", null, url);
            return false;
        }
        else if (_setting_PopupsCloseOnHtmlNavigation) {
            // This is an HTML navigation.
            // Close all popups since this has been requested.
            Popup.CloseAll();
        }
        return super.onOverrideUrlLoading(url);
    }

    @Override
    public Object onMessage(String id, Object data) {
        if (id.equals("onCreateOptionsMenu")) {
            // For CommandBars attached onto the root activity
            _menu = (Menu)data;
        }
        else if (id.equals("onOptionsItemSelected")) {
            // For CommandBars attached onto the root activity
            int index = ((android.view.MenuItem)data).getItemId();
            android.view.ViewGroup root = (android.view.ViewGroup)NativeHost.getRootView();
            if (root.getChildCount() > 0 && root.getChildAt(0) instanceof Windows.UI.Xaml.Controls.Page) {
                Windows.UI.Xaml.Controls.Page p = (Windows.UI.Xaml.Controls.Page)root.getChildAt(0);
                if (p.menuBar != null) {
                    p.menuBar.onMenuItemClicked(index);
                }
            }
        }
        return null;
    }

    // The entry point
	public boolean execute(String action, JSONArray args, CallbackContext callbackContext) throws JSONException {
		// Don't run any of these if the current activity is finishing.
		if(_activity.isFinishing()) return true;

		if (action.equals("send")) {
			this.send(args, callbackContext);
		}
		else if (action.equals("loadXbf")) {
			this.loadXbf(args.getString(0), callbackContext);
		}
		else if (action.equals("initialize")) {
            //
            // Do not initialize unsupported android versions
            //
            if (android.os.Build.VERSION.SDK_INT < android.os.Build.VERSION_CODES.KITKAT) {
                return true;
            }
                        
			OutgoingMessages.setCallbackContext(callbackContext);
            /* TODO: No startup markup
            if (_startupMarkup != null) {
                // Send the bytes back to the managed side.
                // Do it directly instead of using OutgoingMessages.raiseEvent
                // Because otherwise it gets marshaled as an array instead of an ArrayBuffer
        		PluginResult r = new PluginResult(PluginResult.Status.OK, _startupMarkup);
        		r.setKeepCallback(true);
                callbackContext.sendPluginResult(r);
                _startupMarkup = null;
            }
            */
		}
		else if (action.equals("loadPlatformSpecificMarkup")) {
			this.loadPlatformSpecificMarkup(args.getString(0), callbackContext);
		}
		else if (action.equals("getAndroidId")) {
			this.getAndroidId(args.getString(0), callbackContext);
		}
		else if (action.equals("startAndroidActivity")) {
			this.startAndroidActivity(args.getString(0), callbackContext);
		}
		else if (action.equals("setPopupsCloseOnHtmlNavigation")) {
			this.setPopupsCloseOnHtmlNavigation(args.getBoolean(0), callbackContext);
		}
		else if (action.equals("isSupported")) {
			boolean supported = android.os.Build.VERSION.SDK_INT >= android.os.Build.VERSION_CODES.KITKAT;
			callbackContext.sendPluginResult(new PluginResult(PluginResult.Status.OK, supported));
		}
		else {
			return false;
		}

		return true;
	}

	void send(final JSONArray messages, final CallbackContext callbackContext) {
		final Activity activity = _activity;
		Runnable runnable = new Runnable() {
			public void run() {
				try {
					Object returnValue = null;
					boolean hasReturnValue = false; // Needed because null can be a valid return value
					int numMessages = messages.length();

					for (int i = 0; i < numMessages; i++)
					{
						Object instance = null;
						Handle handle;
						JSONArray message = messages.getJSONArray(i);
						//android.util.Log.d("Ace", "TODO: MSG: " + message);
						int messageType = message.getInt(0);

						switch (messageType) {
							case IncomingMessages.MSG_CREATE:
								instance = IncomingMessages.create(message, activity);
								handle = Handle.fromJSONObject(message.getJSONObject(1));
								handle.register(instance);
								break;
							case IncomingMessages.MSG_SET:
								IncomingMessages.set(message);
								break;
							case IncomingMessages.MSG_INVOKE:
								returnValue = IncomingMessages.invoke(message);
								hasReturnValue = true;
								break;
							case IncomingMessages.MSG_EVENTADD:
								IncomingMessages.eventAdd(message);
								break;
							case IncomingMessages.MSG_EVENTREMOVE:
								IncomingMessages.eventRemove(message);
								break;
							case IncomingMessages.MSG_STATICINVOKE:
								returnValue = IncomingMessages.staticInvoke(message);
								hasReturnValue = true;
								break;
							case IncomingMessages.MSG_FIELDGET:
								returnValue = IncomingMessages.fieldGet(message);
								hasReturnValue = true;
								break;
							case IncomingMessages.MSG_STATICFIELDGET:
								returnValue = IncomingMessages.staticFieldGet(message);
								hasReturnValue = true;
								break;
							case IncomingMessages.MSG_GETINSTANCE:
								instance = IncomingMessages.getInstance(message, activity, _webView);
								handle = Handle.fromJSONObject(message.getJSONObject(1));
								handle.register(instance);
								break;
							case IncomingMessages.MSG_NAVIGATE:
                                IncomingMessages.navigate((View)Handle.deserialize(message.getJSONObject(1)), activity);
								break;
							case IncomingMessages.MSG_FIELDSET:
								IncomingMessages.fieldSet(message);
								break;
							case IncomingMessages.MSG_PRIVATEFIELDGET:
								returnValue = IncomingMessages.privateFieldGet(message);
								hasReturnValue = true;
								break;
							default:
								throw new RuntimeException("Unknown message type: " + messageType);
						}
					}

					if (numMessages == 1 && hasReturnValue) {
						// This is a single (non-batched) invoke with a return value
						// (or a field get).
						// Send it.
						// TODO: Need to handle arrays of primitives/objects as well
						if (Utils.isBoxedNumberOrString(returnValue) || returnValue == null) {
							// Send the primitive value
							JSONArray primitive = new JSONArray();
							primitive.put(returnValue);
							callbackContext.success(primitive);
						}
						else {
							// Send the object as a handle
                            // Use existing handle if this object already has one
                            Handle handle = Handle.fromObject(returnValue);
                            if (handle == null) {
							     handle = new Handle();
							     handle.register(returnValue);
                            }
							callbackContext.success(handle.toJSONObject());
						}
					}
					else {
						callbackContext.success();
					}
				}
				catch (Exception ex) {
					android.util.Log.d("Ace", "Caught exception: " + exceptionWithStackTrace(ex));
					callbackContext.error(exceptionWithStackTrace(ex));
				}
			};
		};
		activity.runOnUiThread(runnable);
	}

	void loadXbf(String uri, CallbackContext callbackContext) {
		try {
            callbackContext.success(readXbf(uri));
		}
		catch (IOException ex) {
            android.util.Log.d("Ace", "Caught exception: " + exceptionWithStackTrace(ex));
            callbackContext.error(exceptionWithStackTrace(ex));
		}
	}

    byte[] readXbf(String uri) throws IOException {
        Context context = _activity.getApplicationContext();
        AssetManager am = context.getAssets();
        InputStream is = am.open(uri);

        ByteArrayOutputStream buffer = new ByteArrayOutputStream();

        int numRead;
        byte[] data = new byte[16384];
        while ((numRead = is.read(data, 0, data.length)) != -1) {
            buffer.write(data, 0, numRead);
        }
        buffer.flush();

        return buffer.toByteArray();
    }

    // Loads an Android XML file
	void loadPlatformSpecificMarkup(String uri, CallbackContext callbackContext) {
		try {
            View content = readAndroidXml(uri);
            if (content == null) {
                throw new RuntimeException("Loading " + uri + " returned null.");
            }
            // Send the object as a handle
            Handle handle = new Handle();
            handle.register(content);
            callbackContext.success(handle.toJSONObject());
		}
		catch (Exception ex) {
            android.util.Log.d("Ace", "Caught exception: " + exceptionWithStackTrace(ex));
            callbackContext.error(exceptionWithStackTrace(ex));
		}
	}

    View readAndroidXml(String layoutName) {
		Class c = null;
		try {
            c = Class.forName(_activity.getPackageName() + ".R$layout");
		} catch (ClassNotFoundException e) {
            throw new RuntimeException("Unable to find the R.layout class in package '" + _activity.getPackageName() + "'");
		}

        int id;
        try {
			Field f = c.getField(layoutName);
			id = (Integer)f.get(null);
		}
		catch (NoSuchFieldException ex) {
			throw new RuntimeException(c.getSimpleName() + " does not have a " + layoutName + " field");
		}
		catch (IllegalAccessException ex) {
			throw new RuntimeException(c.getSimpleName() + "'s " + layoutName + " field is inaccessible");
		}

        return android.view.LayoutInflater.from(_activity).inflate(id, null);
    }

	void getAndroidId(String name, CallbackContext callbackContext) {
		Class c = null;
		try {
            c = Class.forName(_activity.getPackageName() + ".R$id");
		} catch (ClassNotFoundException e) {
            throw new RuntimeException("Unable to find the R.id class in package '" + _activity.getPackageName() + "'");
		}

        int id;
        try {
			Field f = c.getField(name);
			id = (Integer)f.get(null);
		}
		catch (NoSuchFieldException ex) {
			throw new RuntimeException(c.getSimpleName() + " does not have a " + name + " field");
		}
		catch (IllegalAccessException ex) {
			throw new RuntimeException(c.getSimpleName() + "'s " + name + " field is inaccessible");
		}

        callbackContext.success(id);
	}

    // Exposed to JavaScript
    public void startAndroidActivity(String name, CallbackContext callbackContext) {
		NativeHost.startActivity(name);
		callbackContext.success();
    }

    void setPopupsCloseOnHtmlNavigation(boolean value, CallbackContext callbackContext) {
        _setting_PopupsCloseOnHtmlNavigation = value;
        callbackContext.success();
	}

	static String exceptionWithStackTrace(Exception ex) {
		ByteArrayOutputStream buffer = new ByteArrayOutputStream();
		PrintStream ps = new PrintStream(buffer);
		ex.printStackTrace(ps);
		ps.close();
		return buffer.toString();
	}
}
