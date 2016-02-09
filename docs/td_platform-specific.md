---
layout: doc
title: Writing Platform-Specific Code
category: docs
permalink: /docs/platform-specific/
---

Ace's goal is for you to write as much cross-platform code/UI as possible, whether it's interacting with HTML or native UI. However, 
sometimes you can't avoid writing platform-specific code or using platform-specific UI. Ace provides several mechanisms to make this 
as easy as possible:

## Conditional Logic

At any spot in your code, you can check the current platform and act accordingly:

<pre><b><span class="js-id">if</span> (ace.platform == <span class="js-string">"iOS"</span>)</b> {
  <span class="js-id">var</span> control = <span class="js-id">new</span> ace.NativeObject(<span class="js-string">"UISegmentedControl"</span>);
  ...
}
<span class="js-id">else <b>if</b></span> <b>(ace.platform == </b><span class="js-string"><b>"Android"</b></span><b>)</b> {
  <span class="js-id">var</span> control = <span class="js-id">new</span> ace.NativeObject(<span class="js-string">"android.widget.RatingBar"</span>);
  ...
}
<span class="js-id">else</span> {
    ...
}
</pre>

With logic like this, you could load different markup files, programmatically construct different UI, and so on.

## Conditional Markup

Perhaps you have a XAML file that defines an entire page in a cross-platform way, but you have a couple of spots that need to differ based 
on the current platform. You don't need to construct separate markup files. Instead, you can use conditional XAML where needed:

<pre>
&lt;Page>
  &lt;ListBox ... />
  ...
  <b>&lt;if.iOS></b>
    &lt;ios:UISegmentedControl Name="platformSpecificControl" />
  <b>&lt;/if.iOS>
  &lt;if.Android></b>
    &lt;android:RatingBar Name="platformSpecificControl" />
  <b>&lt;/if.Android></b>
  ...
  &lt;Button ... />
&lt;/Page>
</pre>

## A Shortcut for Platform-Specific Values

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

## Platform Helpers

Currently, there are only platform-specific helpers for Android. These can be accessed via <b>ace.android</b>, and you can 
see all the APIs [here](/ace/docs/ref/#four). The helpers give your code access to the current context, activity, and intent. 
There are also app widget APIs, and event raised when the intent changes, and a helper for retrieving resource IDs.
