function invoke_code_init() {
    document.getElementById("codeBattery").addEventListener('click', invokeBattery, false);
    document.getElementById("codeDevice").addEventListener('click', invokeDeviceInfo, false);
    document.getElementById("codeMisc").addEventListener('click', invokeMisc, false);
}

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

function invokeDeviceInfo() {
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
    else if (ace.platform == "iOS") {
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
}

function invokeMisc() {
    if (ace.platform == "Android") {
        // This only works when <uses-permission android:name="android.permission.VIBRATE" />
        // is placed in AndroidManifest.xml.
        var pattern = [0, 500, 110, 500, 110, 450, 110, 200];

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
    else if (ace.platform == "iOS") {
        //
        // UIDevice* device = [UIDevice currentDevice];
        // [device setProximityMonitoringEnabled:true];
        // BOOL isClose = [device proximityState];
        //
        ace.NativeObject.invoke("UIDevice", "currentDevice", function (device) {
            if (proximityHandle == null) {
                document.getElementById("spotForProximityOutput").innerHTML = "<h2>Monitoring proximity...</h2>";

                // Turn on proximity monitoring
                device.invoke("setProximityMonitoringEnabled", true);

                // Check the status once a second
                proximityHandle = setInterval(function () {
                    device.invoke("proximityState", function (isClose) {
                        if (isClose) {
                            // The user is close
                            document.getElementById("spotForProximityOutput").innerHTML += "<h2>CLOSE!</h2>";
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

                document.getElementById("spotForProximityOutput").innerHTML = "";
            }
        });
    }
}
