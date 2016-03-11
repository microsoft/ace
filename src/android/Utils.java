//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
package run.ace;

import android.content.res.AssetManager;
import android.graphics.Bitmap;
import android.graphics.BitmapFactory;
import java.lang.reflect.Constructor;
import java.lang.reflect.Field;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.io.InputStream;
import java.io.IOException;
import java.net.URL;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;
import Windows.UI.Xaml.Controls.Handle;
import Windows.UI.Xaml.Controls.Thickness;
import Windows.UI.Xaml.Controls.GridLength;

public class Utils {
	public static boolean isBoxedNumberOrString(Object obj) {
		return (
			obj instanceof String ||
			obj instanceof Integer ||
			obj instanceof Boolean ||
			obj instanceof Double ||
			obj instanceof Float ||
			obj instanceof Long ||
			obj instanceof Short ||
			obj instanceof Byte ||
			obj instanceof Character
		);
	}

	public static int getInt(Object obj) {
		if (obj instanceof Double) {
			return (int)(double)(Double)obj;
		}
		if (obj instanceof Integer) {
			return (Integer)obj;
		}
		if (obj instanceof Float) {
			return (int)(float)(Float)obj;
		}
		throw new RuntimeException("Could not get an int value from a " + obj.getClass().getSimpleName());
	}

	public static double getDouble(Object obj) {
		if (obj instanceof Double) {
			return (Double)obj;
		}
		if (obj instanceof Integer) {
			return (double)(int)(Integer)obj;
		}
		if (obj instanceof Float) {
			return (double)(float)(Float)obj;
		}
		throw new RuntimeException("Could not get a double value from a " + obj.getClass().getSimpleName());
	}

    // Get the scale of screen content
    public static float getScaleFactor(android.content.Context context) {
        android.util.DisplayMetrics metrics = new android.util.DisplayMetrics();
        ((android.view.WindowManager)context.getSystemService(android.content.Context.WINDOW_SERVICE)).getDefaultDisplay().getMetrics(metrics);
        return metrics.scaledDensity;
    }

    public static Object deserializeObjectOrStruct(JSONObject obj) {
        try {
			String type = obj.getString("_t");
            if (type.equals("H")) {
                return Handle.deserialize(obj);
            }
            else if (type.equals("Thickness")) {
                return Thickness.deserialize(obj);
            }
            else if (type.equals("GridLength")) {
                return GridLength.deserialize(obj);
            }
            else {
                throw new RuntimeException("Unhandled struct type: " + obj.getClass());
            }
		}
		catch (JSONException ex) {
			throw new RuntimeException(ex);
		}
    }

	public static Object getField(Class c, Object instance, String fieldName) {
		try {
			Field f = c.getField(fieldName);
			return f.get(instance);
		}
		catch (NoSuchFieldException ex) {
			throw new RuntimeException(c.getSimpleName() + " does not have a " + fieldName + " field");
		}
		catch (IllegalAccessException ex) {
			throw new RuntimeException(c.getSimpleName() + "'s " + fieldName + " field is inaccessible");
		}
	}

	public static Object getPrivateField(Class c, Object instance, String fieldName) {
		try {
            Field f = c.getDeclaredField(fieldName);
            f.setAccessible(true);
            return f.get(instance);
		}
		catch (NoSuchFieldException ex) {
            throw new RuntimeException(c.getSimpleName() + " does not have a " + fieldName + " field");
		}
		catch (IllegalAccessException ex) {
            throw new RuntimeException(c.getSimpleName() + "'s " + fieldName + " field is inaccessible");
		}
	}

	public static void setField(Class c, Object instance, String fieldName, Object fieldValue) {
		try {
			Field f = c.getField(fieldName);
			f.set(instance, fieldValue);
		}
		catch (NoSuchFieldException ex) {
			throw new RuntimeException(c.getSimpleName() + " does not have a matching " + fieldName + " field");
		}
		catch (IllegalAccessException ex) {
			throw new RuntimeException(c.getSimpleName() + "'s " + fieldName + " field is inaccessible");
		}
	}

    public static Bitmap getBitmapAsset(android.content.Context context, String url) {
        InputStream inputStream = null;
        Bitmap b = null;

        try {
            if (url.contains("{platform}")) {
                url = url.replace("{platform}", "android");
            }

            AssetManager assetManager = context.getAssets();
            inputStream = assetManager.open(url);
        }
        catch (IOException ex) {
        }

        if (inputStream != null) {
            b = BitmapFactory.decodeStream(inputStream);
            try {
                inputStream.close();
            }
            catch (IOException ex) {
            }
        }
        return b;
    }

    public static Bitmap getBitmapHttp(android.content.Context context, String url) {
        InputStream inputStream = null;
        Bitmap b = null;

        try {
            if (url.contains("{platform}")) {
                url = url.replace("{platform}", "android");
            }
            
            inputStream = (InputStream)new URL(url).getContent();
        }
        catch (IOException ex) {
        }

        if (inputStream != null) {
            b = BitmapFactory.decodeStream(inputStream);
            try {
                inputStream.close();
            }
            catch (IOException ex) {
            }
        }
        return b;
    }

    public static Object[] convertJSONArrayToArray(JSONArray array) throws JSONException {
		int length = array.length();
        Object[] args = new Object[length];
        for (int i = 0; i < length; i++) {
            Object arg = array.get(i);
            // Convert non-array non-primitives
            if (arg instanceof JSONObject) {
                arg = Utils.deserializeObjectOrStruct((JSONObject)arg);
            }
            // null appears as a special object
            else if (arg == JSONObject.NULL) {
                arg = null;
            }
            // Arrays appear as JSONArray
            else if (arg instanceof JSONArray) {

                JSONArray a = (JSONArray)arg;
                Object[] newArray = new Object[a.length()];
                for (int j = 0; j < newArray.length; j++) {
                    Object item = a.get(j);
                    if (item instanceof JSONObject) {
                        newArray[j] = Utils.deserializeObjectOrStruct((JSONObject)item);
                    }
                    else if (item == JSONObject.NULL) {
                        newArray[j] = null;
                    }
                    else {
                        newArray[j] = item;
                    }
                }

                // Make sure it's the right type of array
                if (true) { // TODO: parameterTypes[i] == (long[]).getClass()) {
                    long[] typedArray = new long[newArray.length];
                    for (int j = 0; j < newArray.length; j++) {
                        typedArray[j] = (long)(int)(Integer)newArray[j];
                    }
                    arg = typedArray;
                }
                else {
                    arg = newArray;
                }
            }
            args[i] = arg;
        }
        return args;
    }

	public static Object invokeMethod(Class c, Object instance, String methodName, JSONArray array) throws JSONException {
		Object returnValue = null;
		int length = array.length();

        if (length == 0) {
            try {
                Method m = c.getMethod(methodName);
                returnValue = m.invoke(instance);
            }
            catch (NoSuchMethodException ex) {
                    throw new RuntimeException(c.getSimpleName() + " does not have a parameterless " + methodName + " method");
            }
            catch (IllegalAccessException ex) {
                throw new RuntimeException(c.getSimpleName() + "'s matching " + methodName + " method is inaccessible");
            }
            catch (InvocationTargetException ex) {
                    throw new RuntimeException("Error in " + c.getSimpleName() + "." + methodName + ": " + ex.getTargetException().toString());
            }
        }
        else {
            Object[] args = Utils.convertJSONArrayToArray(array);
            returnValue = Utils.invokeMethodWithBestParameterMatch(c, methodName, instance, args, false);
        }

		return returnValue;
	}

    static Object[] tryToMakeArgsMatch(Object[] args, Class<?>[] parameterTypes, boolean looseMatching) {
        boolean matches = true;
        Object[] matchingArgs = new Object[args.length];
        java.lang.System.arraycopy(args, 0, matchingArgs, 0, args.length);

        for (int i = 0; i < parameterTypes.length; i++) {
            Class p = parameterTypes[i];

            if (matchingArgs[i] == null) {
                if (p.isPrimitive()) {
                    matches = false;
                    break;
                }
                else {
                    // null is fine to pass for a non-primitive
                    continue;
                }
            }

            Class a = matchingArgs[i].getClass();
            if (p.isPrimitive()) {
                if (p == int.class) {
                    if (a != Integer.class) {
                        matches = false;
                        break;
                    }
                }
                else if (p == boolean.class) {
                    if (a != Boolean.class) {
                        if (looseMatching && a == String.class) {
                            matchingArgs[i] = ((String)matchingArgs[i]).toLowerCase().trim().equals("true");
                        }
                        else {
                            matches = false;
                        }
                        break;
                    }
                }
                else if (p == double.class) {
                    if (a != Double.class) {
                        // Allow ints to be passed as doubles
                        if (a == Integer.class) {
                            matchingArgs[i] = (double)(Integer)matchingArgs[i];
                        }
                        else {
                            matches = false;
                        }
                        break;
                    }
                }
                else if (p == float.class) {
                    if (a != Float.class) {
                        // Allow ints and doubles to be passed as floats
                        if (a == Integer.class) {
                            matchingArgs[i] = (float)(Integer)matchingArgs[i];
                        }
                        else if (a == Double.class) {
                            matchingArgs[i] = (float)(double)(Double)matchingArgs[i];
                        }
                        else {
                            matches = false;
                        }
                        break;
                    }
                }
                else if (p == long.class) {
                    if (a != Long.class) {
                        matches = false;
                        break;
                    }
                }
                else if (p == short.class) {
                    if (a != Short.class) {
                        matches = false;
                        break;
                    }
                }
                else if (p == byte.class) {
                    if (a != Byte.class) {
                        matches = false;
                        break;
                    }
                }
                else if (p == char.class) {
                    if (a != Character.class) {
                        matches = false;
                        break;
                    }
                }
            }
            else if (!p.isAssignableFrom(a)) {
                matches = false;
                break;
            }
        }

        return matches ? matchingArgs : null;
    }

	public static Object invokeMethodWithBestParameterMatch(Class c, String methodName, Object instance, Object[] args, boolean looseMatching) {
		Method[] methods = c.getMethods();
		int numArgs = args.length;
		// Look at all methods
		for (Method method : methods) {
            // Does the name match?
            if (method.getName().equals(methodName)) {
                Class<?>[] parameterTypes = method.getParameterTypes();
                // Does it have the right number of parameters?
                if (parameterTypes.length == numArgs) {
                    // Are all the parameters types that will work?
                    Object[] matchingArgs = tryToMakeArgsMatch(args, parameterTypes, looseMatching);
                    if (matchingArgs != null) {
                        try {
                            return method.invoke(instance, matchingArgs);
                        }
                        catch (IllegalAccessException ex) {
                            throw new RuntimeException(c.getSimpleName() + "'s matching " + methodName + " method is inaccessible");
                        }
                        catch (InvocationTargetException ex) {
                                throw new RuntimeException("Error in " + c.getSimpleName() + "." + methodName + ": " + ex.getTargetException().toString());
                        }
                    }
                }
            }
		}
		throw new RuntimeException(c + " does not have a public method named " + methodName + " with " + numArgs + " matching parameter type(s).");
	}

	public static Object invokeConstructorWithBestParameterMatch(Class c, Object[] args) {
		Constructor[] constructors = c.getConstructors();
		int numArgs = args.length;
		// Look at all constructors
		for (Constructor constructor : constructors) {
            Class<?>[] parameterTypes = constructor.getParameterTypes();
            // Does it have the right number of parameters?
            if (parameterTypes.length == numArgs) {
                // Are all the parameters types that will work?
                Object[] matchingArgs = tryToMakeArgsMatch(args, parameterTypes, false);
                if (matchingArgs != null) {
                    try {
				        return constructor.newInstance(matchingArgs);
                    }
                    catch (InstantiationException ex) {
                        throw new RuntimeException("Error instantiating " + c.getSimpleName() + ": " + ex.toString());
                    }
                    catch (IllegalAccessException ex) {
                        throw new RuntimeException(c.getSimpleName() + "'s matching constructor is inaccessible");
                    }
                    catch (InvocationTargetException ex) {
                        throw new RuntimeException("Error in " + c.getSimpleName() + "'s constructor: " + ex.getTargetException().toString());
                    }
                }
            }
		}
		throw new RuntimeException(c + " does not have a public constructor with " + numArgs + " matching parameter type(s).");
	}
    
    public static Object getTag(android.view.View view, String name, Object defaultValue) {
        int id = run.ace.NativeHost.getResourceId(name, "integer", view.getContext());
        Object obj = view.getTag(id);
        if (obj == null) {
            return defaultValue;
        }
        else {
            return obj;
        }
    }
    
    public static void setTag(android.view.View view, String name, Object value) {
        int id = run.ace.NativeHost.getResourceId(name, "integer", view.getContext());
        view.setTag(id, value);
    }
}
