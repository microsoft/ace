---
layout: doc
title: Navigation
category: docs
permalink: /docs/navigation/
---

Your app can navigate from the page hosting the Cordova WebView to additional all-native pages (and back). 
These pages can be constructed programmatically in JavaScript, or they can be defined in markup. 
You have three markup options:

* Using Android XML. (This only works on Android.)
* Using a .xib file created from Xcode's Interface Builder. (This only works on iOS.)
* Using a XAML file. (This works everywhere.)

When using XAML, you gain the option of using elements from the [cross-platform UI framework](/ace/docs/ref) 
in addition to (or instead of) raw platform-specific elements.

<br/>

## Navigating with &lt;a>
If your target page is defined in markup, you can use a hyperlink:

<pre style="color:blue">&lt;<span class="xaml-tag">a</span> <span class="xaml-attr">href</span>="<b>native://page.xaml</b>"&gt;
<span class="xaml-content">&nbsp;&nbsp;Go to an all-native page</span>
&lt;/<span class="xaml-tag">a</span>&gt;
&lt;<span class="xaml-tag">a</span> <span class="xaml-attr">href</span>="<b>android://page.xml</b>"&gt;
<span class="xaml-content">&nbsp;&nbsp;Go to an Android XML page</span>
&lt;/<span class="xaml-tag">a</span>&gt;
&lt;<span class="xaml-tag">a</span> <span class="xaml-attr">href</span>="<b>ios://page.xib</b>"&gt;
&nbsp;&nbsp;<span class="xaml-content">Go to an Interface Builder page</span>
&lt;/<span class="xaml-tag">a</span>&gt;
</pre>

Clicking the hyperlink triggers a native navigation, complete with a purely-native animated transition. 
(On Android, the new content opens in a child activity. On iOS, the new content opens in a new view controller hosted inside a navigation controller.)

The original page with the Cordova WebView remains intact, and the WebView's internal history remains unaffected. You can navigate back to it with the <b>ace.goBack()</b> API. 
If you use XAML markup, this can even be attached inline:

<pre>
&lt;Button <b>ace:On.Click="ace.goBack()"</b>>Back&lt;/Button>
</pre>

<br/>

## Navigating with document.location
If your target page is defined in markup, you can also change the document's location in JavaScript:

<pre>
<span class="js-comment">// Three options:</span>
document.location.href = "native://page.xaml";
document.location.href = "android://page.xml";
document.location.href = "ios://page.xib";
</pre>

This behaves just like following a hyperlink.

<br/>

## Navigating with the <b>navigate</b> API

You can also use a navigate API, which enables you to navigate to markup <b>or any UI object constructed programmatically</b>:

<b>Navigate to a markup file:</b>

<pre>
<span class="js-comment">// Three options:</span>
ace.navigate("native://page.xaml");
ace.navigate("android://page.xml");
ace.navigate("ios://page.xib");
</pre>

<b>Navigate to an arbitrary UI object:</b>

<pre>
<span class="js-comment">// Navigate to a Page constructed dynamically:</span>
var page = new ace.Page();
...
ace.navigate(page);
</pre>
<pre>
<span class="js-comment">// You aren't required to use a Page object:</span>
var button = new ace.Button();
...
ace.navigate(button);
</pre>

Notice that you're not required to use a Page object. (But Page is useful if you want to show app bars or control the navigation bar.)

You don't need to use the cross-platform UI framework, either. Here's an example that navigates to a raw 
iOS control, which occupies the whole screen upon navigation:

<pre>
if (ace.platform == "iOS") {
    // Create a UISegmentedControl
    var uiSegmentedControl = new ace.NativeObject("UISegmentedControl");

    // Add two segments
    uiSegmentedControl.invoke("insertSegmentWithTitle:atIndex:animated:", "One", 0, false);
    uiSegmentedControl.invoke("insertSegmentWithTitle:atIndex:animated:", "Two", 1, false);

    // Select the last segment
    uiSegmentedControl.invoke("setSelectedSegmentIndex", 1);

    // Navigate to the single control
    ace.navigate(uiSegmentedControl,
        // Just so we have a way to get back:
        function () { ace.Frame.showNavigationBar(); },
        function () { ace.Frame.hideNavigationBar(); });
}
</pre>

Here's a similar example, but with raw Android controls constructed entirely in JavaScript (no Android XML):
<pre onclick="document.getElementById('androidExpand').style.display='block'; this.style.display='none'">
<b>Click here to expand example</b>
</pre>
<pre id="androidExpand" style="display:none">
if (ace.platform == "Android") {
    // Create all the views
    var relativeLayout = new ace.NativeObject("android.widget.RelativeLayout");
    var radioGroup = new ace.NativeObject("android.widget.RadioGroup");
    var radioButton1 = new ace.NativeObject("android.widget.RadioButton");
    var radioButton2 = new ace.NativeObject("android.widget.RadioButton");
    var radioButton3 = new ace.NativeObject("android.widget.RadioButton");
    var colorWheel = new ace.NativeObject("com.larswerkman.holocolorpicker.ColorPicker");
    var seekBar = new ace.NativeObject("android.widget.SeekBar");
    var editText = new ace.NativeObject("android.widget.EditText");

    // Set ids to be used by RelativePanel
    var radioGroupId = 100;
    var colorWheelId = 200;
    var seekBarId = 300;
    radioGroup.invoke("setId", radioGroupId);
    colorWheel.invoke("setId", colorWheelId);
    seekBar.invoke("setId", seekBarId);

    // Set up the RadioGroup and its RadioButtons
    radioButton1.invoke("setText", "Choice 1");
    radioButton2.invoke("setText", "Choice 2");
    radioButton3.invoke("setText", "Choice 3");
    radioGroup.invoke("addView", radioButton1);
    radioGroup.invoke("addView", radioButton2);
    radioGroup.invoke("addView", radioButton3);
    relativeLayout.invoke("addView", radioGroup);

    // Set the background to yellow
    ace.NativeObject.getField("android.graphics.Color", "YELLOW", function (color) {
        relativeLayout.invoke("setBackgroundColor", color);
    });

    // Retrieve four constants
    ace.NativeObject.getField("android.view.ViewGroup$LayoutParams", "MATCH_PARENT", function (match_parent) {
        ace.NativeObject.getField("android.view.ViewGroup$LayoutParams", "WRAP_CONTENT", function (wrap_content) {
            ace.NativeObject.getField("android.widget.RelativeLayout", "RIGHT_OF", function (right_of) {
                ace.NativeObject.getField("android.widget.RelativeLayout", "BELOW", function (below) {

                    // Add colorWheel to the right of radioGroup
                    var p = new ace.NativeObject("android.widget.RelativeLayout$LayoutParams", match_parent, wrap_content);
                    p.invoke("addRule", right_of, radioGroupId);
                    colorWheel.invoke("setLayoutParams", p);
                    relativeLayout.invoke("addView", colorWheel);

                    // Add seekBar below colorWheel
                    p = new ace.NativeObject("android.widget.RelativeLayout$LayoutParams", match_parent, wrap_content);
                    p.invoke("addRule", below, colorWheelId);
                    seekBar.invoke("setLayoutParams", p);
                    relativeLayout.invoke("addView", seekBar);

                    // Add editText below seekBar
                    p = new ace.NativeObject("android.widget.RelativeLayout$LayoutParams", match_parent, wrap_content);
                    p.invoke("addRule", below, seekBarId);
                    editText.invoke("setLayoutParams", p);
                    relativeLayout.invoke("addView", editText);

                    // Navigate to the root instance
                    ace.navigate(relativeLayout);
                });
            });
        });
    });
}
</pre>

And here's a complete example of navigating to cross-platform UI constructed entirely in JavaScript (no XAML):
<pre onclick="document.getElementById('crossPlatExpand').style.display='block'; this.style.display='none'">
<b>Click here to expand example</b>
</pre>
<pre id="crossPlatExpand" style="display:none">
// Create all the UI elements
var stackPanel = new ace.StackPanel();
var datePicker = new ace.DatePicker();
var timePicker = new ace.TimePicker();
var textBlock = new ace.TextBlock();
var toggleSwitch = new ace.ToggleSwitch();
var button1 = new ace.Button();
var button2 = new ace.Button();
var button3 = new ace.Button();
var button4 = new ace.Button();
var canvas = new ace.Canvas();
var hyperlinkButton = new ace.HyperlinkButton();

// Add elements to the root StackPanel
stackPanel.getChildren().add(datePicker);
stackPanel.getChildren().add(timePicker);
stackPanel.getChildren().add(textBlock);
stackPanel.getChildren().add(toggleSwitch);
stackPanel.getChildren().add(button1);
stackPanel.getChildren().add(canvas);

// Add elements to the Canvas
canvas.setMargin(15);
canvas.getChildren().add(button2);
canvas.getChildren().add(button3);
canvas.getChildren().add(button4);
canvas.getChildren().add(hyperlinkButton);

// Set properties on DatePicker and attach an event
datePicker.setPadding(15);
datePicker.setHeader("Choose a date");
datePicker.addEventListener("datechanged", function () { onDateChanged(datePicker); });

// Set properties on TimePicker and attach an event
timePicker.setPadding(15);
timePicker.setHeader("Choose a time");
timePicker.addEventListener("timechanged", function () { onTimeChanged(timePicker); });

// Set properties on TextBlock
textBlock.setName("textBlock");
textBlock.setFontSize(20);
textBlock.setPadding(15);
textBlock.setForeground("Green");
textBlock.setText("Text");

// Set properties on ToggleSwitch
toggleSwitch.setHeader("ToggleSwitch");
toggleSwitch.setIsOn(true);
toggleSwitch.setPadding(15);

// Set properties (and an event handler) on 4 Buttons
button1.setBackground("Red");
button1.setContent("Back");
button1.addEventListener("click", function () { ace.goBack(); });
button2.setContent("A");
button3.setContent("B");
ace.Canvas.setLeft(button3, 150);
button4.setContent("C");
button4.setWidth(100);
button4.setHeight(100);
ace.Canvas.setTop(button4, 110);

// Create a Style
var style = {
    FontSize: 60,
    FontWeight: "Bold",
    Foreground: "Violet",
    Background: "SteelBlue",
    Width: 100,
    Height: 100
};

// Apply the Style to buttons 2 and 3
button2.setStyle(style);
button3.setStyle(style);

// Set properties on HyperlinkButton
hyperlinkButton.setBackground("Lime");
hyperlinkButton.setNavigateUri("native://Native2.xaml");
hyperlinkButton.setContent("Another Page");
hyperlinkButton.setWidth(150);
hyperlinkButton.setHeight(100);
ace.Canvas.setLeft(hyperlinkButton, 150);
ace.Canvas.setTop(hyperlinkButton, 110);

// Set the background to a unique color
stackPanel.setBackground("Moccasin");

// Navigate to the root instance
ace.navigate(stackPanel);
</pre>

### Interacting with the New Native Content

A key feature of the navigate API, compared to the other navigation approaches, is that it returns 
the root UI object that you just navigated to. This enables you to manipulate the UI, attach event handlers, 
and so on.

<pre>
ace.navigate("native://page.xaml", function (root) {
    <span class="js-comment">// Navigation done</span>
    root.setBackground("Salmon");
});
</pre>

<pre>
ace.navigate("native://page.xaml", function (root) {
    <span class="js-comment">// Attach event handler</span>
    root.doneButton.addEventListener("click", function() { ... });
});
</pre>

### Retrieving Subelements

If you're using XAML markup, you can mark elements with a Name attribute. You can then access 
elements by name directly from the root element, e.g.:

<pre>
ace.navigate("native://page.xaml", function (root) {
    <span class="js-comment">// There is an element with Name="doneButton"</span>
    <b>root.doneButton</b>.addEventListener("click", function() { ... });
});
</pre>

Or, from any element in the same scope (not just the root), you can use a findName API:

<pre>
ace.navigate("native://page.xaml", function (root) {
    <span class="js-comment">// There is an element with Name="doneButton"</span>
    <b>root.findName("doneButton")</b>.addEventListener("click", function() { ... });
});
</pre>

> Whether you get a cross-platform UI object from XAML or programmatically, you can retrieve sub-objects 
> by name with the findName API.

If you're using Android XML, you can set ids as you normally would, and programmatically leverage 
those ids in JavaScript the same way you would in Java.

<br/>

## Navigating Backward

To go back from a native navigation, call <b>ace.goBack()</b>.

<br/>

## Navigation Events

If you use the navigate API, you can pass an extra callback that acts like a "navigating away from" event:

<pre>
ace.navigate("native://page.xaml", function (root) {
    <span class="js-comment">// Navigated to</span>
    root.doneButton.addEventListener("click", function() { ... });
}, function (root) {
    <b><span class="js-comment">// Navigating away</span></b>
    root.doneButton.removeEventListener("click", function() { ... });
});
</pre>

<b>Global Navigation Events</b>

You can handle global <b>Navigating</b> and <b>Navigated</b> events, which is especially useful when 
navigation is done via hyperlinks rather than the navigate API:

<pre>
ace.addEventListener(<b>"navigating"</b>, function (oldContent, newContent) {
  console.log("NAVIGATING: " + oldContent + " -> " + newContent);
});

ace.addEventListener(<b>"navigated"</b>, function (root, url) {
  <span class="js-comment">// There's no url in the case of navigating to a live object</span>
  console.log("NAVIGATED: " + url);
});
</pre>

<br/>

## Controlling the Navigation Bar

<b>Frame</b> has exposes <b>showNavigationBar</b> and <b>hideNavigationBar</b> APIs. A previous example demonstrated 
these in conjunction with the navigate API callbacks:

<pre>
ace.navigate(uiSegmentedControl,
    // Just so we have a way to get back:
    function () { <b>ace.Frame.showNavigationBar();</b> },
    function () { <b>ace.Frame.hideNavigationBar();</b> });
}
</pre>
