---
layout: doc
title: Security
category: docs
permalink: /docs/security/
---

Ace gives your Cordova app the power of native code. Not just the ability to use specific native UI controls, but the ability to invoke any native APIs.

Therefore, when you use Ace in your Cordova app, you are really building a **native app** that happens to use a WebView for some UI and for JavaScript code execution. 
The capabilities granted to your app are no different than the capabilities granted to any native app. The fact that you're writing code in JavaScript rather than (or in addition to) 
Java/Objective C/Swift is an implementation detail.

As a developer, you have some control over the capabilities granted to your app. This is independent from Ace and Cordova. In Android, for example, you control this with an **AndroidManifest.xml** file. 
A typical Cordova project uses an auto-generated version of this file (found in the platforms/android subfolder), but you can modify this file. 
And because the platforms folder is typically excluded from source control, Ace projects typically place the master copy of the modified file in the native/android subfolder, which will get copied to the right spot at build time. 
The [AceExamples project](https://github.com/Microsoft/ace/tree/master/examples/AceExamples) does this in order to override the app theme and to request permission for the vibration capability:
<pre>
    &lt;uses-permission android:name="android.permission.VIBRATE" />
</pre>

This enables the app's vibration code to succeed: 
<pre>
if (ace.platform == "Android") {
    // This only works when &lt;uses-permission android:name="android.permission.VIBRATE" />
    // is placed in AndroidManifest.xml.
    var pattern = [0, 500, 110, 500, 110, 450, 110, 200];

    // The JavaScript below is equivalent to the following Java:
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

Although this security model is standard for native apps, it can require a slight change of mindset for developers used to typical Cordova apps. 
Whether you write code in a platform-specific native language or in JavaScript, you should take precautions to not download/execute untrusted code. 
You don't want native APIs to be invoked maliciously. Malicious code injected into the previous example would have the power to trigger unwanted vibrations, 
but obviously much worse is possible.

If the advice of "Don't execute untrusted code" is universally true, why is it even worth pointing out here? Well, when building a native app with other technologies, you need to go out of your way to load arbitrary, untrusted Web content in a context that gives it more 
power than a typical Web browser. When building an app with Cordova, however, it's much easier to load arbitrary, untrusted Web content.

Fortunately, Cordova has protections in place to help you avoid loading untrusted Web content. It uses [domain whitelisting](https://cordova.apache.org/docs/en/latest/guide/appdev/whitelist/index.html) 
to restict access to external domains. It also uses the [W3C Content Security Policy (CSP)](http://taco.visualstudio.com/en-us/docs/cordova-5-security/) to tightly control a number of things, such as eval() and inline script. 
Make sure to use these mechanisms properly to avoid exposing the native power of *any* Cordova plugin (Ace being just one example) improperly.
