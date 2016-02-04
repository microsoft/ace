---
layout: doc
title: Invoking Native Code
category: docs
permalink: /docs/native-code/
section1: Include in Your Project
section2: NativeObject
section3: Platform-Specific
section4: Real-World Examples
---

> Be sure to check out [the sample code](https://github.com/adnathan/ace/tree/master/examples) to see this in action

You can invoke native code from JavaScript using <b>NativeObject</b>, whether it's platform APIs, third-party code, 
or your own custom native code. For the latter two cases, you need to include the code in your project.

<a name="one"/>

## Include Native Code in Your Project
Cordova apps with Ace installed can include any native code and resources in the project's <b>native</b> folder. Code and resources 
placed here gets compiled into your project:

<img width="50%" src="/assets/images/docs/native-folder.png"/>

<a name="two"/>

## Using NativeObject to Invoke Native Code

Here are the ways to do it:

<pre>
<span class="js-comment">// Instantiate a native class with its default constructor</span>
var obj = new ace.NativeObject("NameOfNativeClass");

<span class="js-comment">// Instantiate a native class with a parameterized constructor</span>
var obj = new ace.NativeObject("NameOfNativeClass", 5);

<span class="js-comment">// Invoke an <b>instance</b> method</span>
obj.invoke("Method1");

<span class="js-comment">// Invoke an <b>instance</b> method with two parameters</span>
obj.invoke("Method2", 12, 24);

<span class="js-comment">// Invoke an <b>instance</b> method and retrieve its return value</span>
obj.invoke("Method1", function(returnValue) { /* ... */ });

<span class="js-comment">// Invoke an <b>instance</b> method with one parameter and retrieve its return value</span>
obj.invoke("Method1", "param", function(returnValue) { /* ... */ });

<span class="js-comment">// Get an <b>instance</b> field value (doesn't apply to iOS)</span>
obj.getField("Field1", function(value) { /* ... */ });

<span class="js-comment">// Set an <b>instance</b> field value (doesn't apply to iOS)</span>
obj.setField("Field1", 7);

<span class="js-comment">// Invoke a <b>static</b> method</span>
ace.NativeObject.invoke("NameOfNativeClass", "Method1");

<span class="js-comment">// Invoke a <b>static</b> method with two parameters</span>
ace.NativeObject.invoke("NameOfNativeClass", "Method2", 12, 24);

<span class="js-comment">// Invoke a <b>static</b> method and retrieve its return value</span>
ace.NativeObject.invoke("NameOfNativeClass", "Method1", function(returnValue) { /* ... */ });

<span class="js-comment">// Invoke a <b>static</b> method with one parameter and retrieve its return value</span>
ace.NativeObject.invoke("NameOfNativeClass", "Method1", "param", function(returnValue) { /* ... */ });

<span class="js-comment">// Get a <b>static</b> field value (doesn't apply to iOS)</span>
ace.NativeObject.getField("NameOfNativeClass", "Field1", function(value) { /* ... */ });

<span class="js-comment">// Set a <b>static</b> field value (doesn't apply to iOS)</span>
ace.NativeObject.setField("NameOfNativeClass", "Field1", 7);
</pre>

<br/>

<a name="three"/>

## Writing Platform-Specific Code

When you directly invoke native APIs, the code you write will be platform-specific. You can handle this 
by simply checking the current platform and invoking the appropriate code for that platform:

<pre>
if (ace.platform == "iOS") {
    ...
}
else if (ace.platform == "Android") {
    ...
}
else {
    ...
}
</pre>

<br/>

## The valueOn Helper

Sometimes you just need a single value to be different depending on the platform. Rather than writing a 
cumbersome if/else statement, you can use <b>ace.valueOn</b>. You give this method a set of values, one 
per platform, and it returns the correct result for the current platform.

<pre>
var text = ace.valueOn({ ios: "string for iOS", android: "string for Android" });
var margin = ace.valueOn({ ios: 12, android: 20 });
</pre>

This can be handy when instantiating a native class. Even if you write your own custom native class and give 
it the same API in Objective-C (for iOS) and Java (for Android), you still should use per-platform class names 
in JavaScript because the Java class name must be qualified by its package name:

<pre>
<span class="js-comment">// On iOS, instantiate MyClass, written in Objective-C</span>
<span class="js-comment">// On Android, instantiate my.package.MyClass, written in Java</span>
var obj = new ace.NativeObject({ ios: "MyClass", android: "my.package.MyClass" });
</pre>

However, for this case, Ace helpfully ignores the package prefix on iOS so you actually *can* get away with using 
the same string for both platforms:

<pre>
<span class="js-comment">// On iOS, ignore "my.package." and instantiate MyClass, written in Objective-C</span>
<span class="js-comment">// On Android, instantiate my.package.MyClass, written in Java</span>
var obj = new ace.NativeObject("my.package.MyClass");
</pre>

<br/>

<a name="four"/>

## Real-World Examples

<br/>

<b>Showing the battery level on iOS and Android</b>

<pre>
function invokeBattery() {
    if (ace.platform == "iOS") {
        // Objective-C code:
        // UIDevice* device = [UIDevice currentDevice];
        // [device setBatteryMonitoringEnabled:true];
        // double capacity = [device batteryLevel] * 100;

        // Invoke a static currentDevice method on UIDevice
        ace.NativeObject.invoke("UIDevice", "currentDevice", function (device) {
            // On the returned instance, call an instance method with no return value
            device.invoke("setBatteryMonitoringEnabled", true);
            // Call another instance method that returns a double
            device.invoke("batteryLevel", function (level) {
                alert("capacity = " + (level * 100) + "%");
            });
        });
    }
    else if (ace.platform == "Android") {
        // Java code:
        // BatteryManager batteryManager = getContext().getSystemService(Context.BATTERY_SERVICE);
        // int capacity = batteryManager.getIntProperty(BatteryManager.BATTERY_PROPERTY_CAPACITY);

        // Get the value of the string constant Context.BATTERY_SERVICE
        ace.NativeObject.getField("android.content.Context", "BATTERY_SERVICE", function (constant) {
            // Invoke an instance method on the Android context object to get a BatteryManager instance
            ace.android.getContext().invoke("getSystemService", constant, function (batteryManager) {
                ace.NativeObject.getField("android.os.BatteryManager", "BATTERY_PROPERTY_CAPACITY", function (constant) {
                    batteryManager.invoke("getIntProperty", constant, function (value) {
                        alert("capacity = " + value + "%");
                    });
                });
            });
        });
    }
}
</pre>

<br/>

<b>Showing the current screen's width, height, and DPI on Android</b>

<pre>
if (ace.platform == "Android") {
    //
    // WindowManager windowManager = getContext().getSystemService(Context.WINDOW_SERVICE);
    // Display display = windowManager.getDefaultDisplay();
    // Display metrics = new DisplayMetrics();
    // display.getMetrics(metrics);
    // int dpi = metrics.densityDpi;
    // int w = metrics.widthPixels;
    // int h = metrics.heightPixels;
    //
    ace.NativeObject.getField("android.content.Context", "WINDOW_SERVICE", function (constant) {
        ace.android.getContext().invoke("getSystemService", constant, function (windowManager) {
            windowManager.invoke("getDefaultDisplay", function (display) {
                var metrics = new ace.NativeObject("android.util.DisplayMetrics");
                display.invoke("getMetrics", metrics);
                metrics.getField("densityDpi", function (dpi) {
                    metrics.getField("widthPixels", function (w) {
                        metrics.getField("heightPixels", function (h) {
                            alert(dpi + " DPI, and " + w + "px by " + h + "px");
                        });
                    });
                });
            });
        });
    });
}
</pre>

<br/>

<b>Showing device info on iOS</b>

<pre>
if (ace.platform == "iOS") {
    //
    // UIDevice* device = [UIDevice currentDevice];
    // NSString* name = [device name];
    // NSString* systemName = [device systemName];
    // NSString* systemVersion = [device systemVersion];
    //
    ace.NativeObject.invoke("UIDevice", "currentDevice", function (device) {
        device.invoke("name", function (value) { alert("name = " + value) });
        device.invoke("systemName", function (value) { alert("systemName = " + value) });
        device.invoke("systemVersion", function (value) { alert("systemVersion = " + value) });
    });
}
</pre>

<br/>

<b>Vibrating in a pattern on Android</b>

You must add <i>&lt;uses-permission android:name="android.permission.VIBRATE" /></i> to your AndroidManifest.xml for this to work.

<pre>
if (ace.platform == "Android") {

    var pattern = [0, 500, 110, 500, 110, 450, 110, 200, 110, 170, 40, 450, 110, 200, 110, 170, 40, 500];

    // The shorter way:
    //
    // Vibrator vibrator = getContext().getSystemService("vibrator");
    // vibrator.vibrate(pattern, -1);
    //
    ace.android.getContext().invoke("getSystemService", "vibrator", function (vibrator) {
        vibrator.invoke("vibrate", pattern, -1);
    });

    // The longer way:
    //
    // Vibrator vibrator = getContext().getSystemService(Context.VIBRATOR_SERVICE);
    // vibrator.vibrate(pattern, -1);
    //
    ace.NativeObject.getField("android.content.Context", "VIBRATOR_SERVICE", function (constant) {
        ace.android.getContext().invoke("getSystemService", constant, function (vibrator) {
            vibrator.invoke("vibrate", pattern, -1);
        });
    });
}
</pre>

<br/>

<b>Having fun with proximity monitoring on iOS</b>

<pre>
if (ace.platform == "iOS") {
    //
    // UIDevice* device = [UIDevice currentDevice];
    // [device setProximityMonitoringEnabled:true];
    // BOOL isClose = [device proximityState];
    //
    ace.NativeObject.invoke("UIDevice", "currentDevice", function (device) {
        if (proximityHandle == null) {
            $("#spotForProximityOutput").html("&lt;h2>Monitoring proximity...&lt;/h2>");

            // Turn on proximity monitoring
            device.invoke("setProximityMonitoringEnabled", true);

            // Check the status once a second
            proximityHandle = setInterval(function () {
                device.invoke("proximityState", function (isClose) {
                    if (isClose) {
                        // The user is close
                        $("&lt;h2>CLOSE!&lt;/h2>").appendTo($("#spotForProximityOutput"));
                    }
                });
            }, 1000);
        }
        else {
            // Stop checking the status
            clearInterval(proximityHandle);
            proximityHandle = null;

            // Turn off proximity monitoring
            device.invoke("setProximityMonitoringEnabled", false);

            $("&lt;h2>Monitoring stopped.&lt;/h2>").appendTo($("#spotForProximityOutput"));
        }
    });
}
</pre>

<br/>

<b>Using the Android Palette API to detect colors in an image</b>

For this to work, you must add a reference to the com.android.support:palette-v7 library.

<pre>
function usePalette() {
    // Set up a spot for showing palette results
    var popup = new ace.Popup();
    popup.setContent(new ace.StackPanel());
    popup.show();

    if (ace.platform == "Android") {
        //
        // AssetManager assetManager = getContext().getAssets();
        // InputStream inputStream = assetManager.open("www/images/poster.jpg");
        // Bitmap bitmap = BitmapFactory.decodeStream(inputStream);
        // Palette.Builder paletteBuilder = Palette.from(bitmap);
        // Palette palette = paletteBuilder.generate();
        // showPaletteButton(...);
        //
        ace.android.getContext().invoke("getAssets", function (assetManager) {
            assetManager.invoke("open", "www/images/poster.jpg", function (inputStream) {
                ace.NativeObject.invoke("android.graphics.BitmapFactory", "decodeStream", inputStream, function (bitmap) {
                    ace.NativeObject.invoke("android.support.v7.graphics.Palette", "from", bitmap, function (paletteBuilder) {
                        paletteBuilder.invoke("generate", function (palette) {
                            showPaletteButton("getVibrantSwatch", palette, popup);
                            showPaletteButton("getMutedSwatch", palette, popup);
                            showPaletteButton("getLightVibrantSwatch", palette, popup);
                            showPaletteButton("getLightMutedSwatch", palette, popup);
                            showPaletteButton("getDarkVibrantSwatch", palette, popup);
                            showPaletteButton("getDarkMutedSwatch", palette, popup);
                        });
                    });
                });
            });
        });
    }
}

function showPaletteButton(methodName, palette, popup) {
    //
    // Swatch swatch = palette.<methodName>();
    // int color = swatch.getRgb();
    // int textColor = swatch.getBodyTextColor();
    //
    palette.invoke(methodName, function (swatch) {
        if (swatch) {
            swatch.invoke("getRgb", function (color) {
                swatch.invoke("getBodyTextColor", function (textColor) {
                    // Add a button using the two colors
                    var button = new ace.Button();
                    button.setBackground(color);
                    button.setForeground(textColor);
                    button.setContent(methodName);
                    button.addEventListener("click", function () { popup.hide(); });
                    popup.getContent().getChildren().add(button);
                });
            });
        }
    });
}
</pre>
