---
layout: doc
title: Using Native UI
category: docs
permalink: /docs/native-ui/
section1: Docking
section2: Overlaying
section3: Fullscreen
section4: Widget
section5: Floating
---

<br/>

> Be sure to check out [the sample code](https://github.com/adnathan/ace/tree/master/examples) to see this in action

There are many options for adding native UI into your app.

* You can use markup, or create it all from JavaScript, or a bit of both.
* You can use Ace's cross-platform controls, or use raw platform-specific controls, or a bit of both.
* You can dock native UI, overlay it on top of HTML, navigate to full-native pages, or all of these.
* On Android, you can create widgets or even have floating UI in a transparent activity.

<br/>

<a name="one"/>

## Docking Native UI

<table>
    <tr>
        <td align="center" style="padding-left:4px;padding-right:4px"><img class="img-responsive;height:218px" src="/assets/images/home/docked1.png" height="218" width="105"/></td>
        <td align="center" style="padding-left:4px;padding-right:4px"><img class="img-responsive;height:218px" src="/assets/images/home/docked2.png" height="218" width="105"/></td>
        <td align="center" style="padding-left:4px;padding-right:4px"><img class="img-responsive;height:218px" src="/assets/images/home/docked3.png" height="218" width="105"/></td>
    </tr>
</table>

<br/>

To set this up, you reparent the Cordova WebView inside arbitrary UI. The layout of your native UI dictates the layout of your page:

<pre>
// Surround the WebView with native UI
ace.load("native://app.xaml", function (page) {
    // Replace the root UI with the loaded native page
    ace.getHostPage().setContent(page);

    // Reparent the WebView inside the native page
    page.setContent(ace.getHostWebView());
});
</pre>

This assumes the app.xaml file defines a page.  It could be one like the following that adds native tabs, plus a native action bar / navigation bar 
to show the page titile:

<pre>
&lt;Page xmlns:ace="using:run.ace" ace:Frame.Title="Schedule">
    &lt;!-- A tab bar -->
    &lt;Page.BottomAppBar>
        &lt;ace:TabBar>
            &lt;AppBarButton Icon="www/img/tabs/calendar-{platform}.png" 
                          Label="Schedule" 
                          ace:On.Click="onTabClick(this, 0)" />
            &lt;AppBarButton Icon="www/img/tabs/people-{platform}.png" 
                          Label="Speakers" 
                          ace:On.Click="onTabClick(this, 1)" />
            &lt;AppBarButton Icon="www/img/tabs/map-{platform}.png" 
                          Label="Map" 
                          ace:On.Click="onTabClick(this, 2)" />
            &lt;AppBarButton Icon="www/img/tabs/info-{platform}.png" 
                          Label="About" 
                          ace:On.Click="onTabClick(this, 3)" />
        &lt;/ace:TabBar>
    &lt;/Page.BottomAppBar>
&lt;/Page>
</pre>

Instead, the app.xaml file could define a 3x3 Grid:

<pre>
&lt;Grid>
    &lt;!-- Define a 3x3 grid with a center cell twice the size -->
    &lt;Grid.RowDefinitions>
        &lt;RowDefinition />
        &lt;RowDefinition Height="2*" />
        &lt;RowDefinition />
    &lt;/Grid.RowDefinitions>
    &lt;Grid.ColumnDefinitions>
        &lt;ColumnDefinition />
        &lt;ColumnDefinition Width="2*" />
        &lt;ColumnDefinition />
    &lt;/Grid.ColumnDefinitions>

    &lt;!-- Row 0 -->
    &lt;Button                                     Background="Red"    />
    &lt;Button                     Grid.Column="1" Background="Orange" />
    &lt;Button                     Grid.Column="2" Background="Yellow" />
    &lt;!-- Row 1 -->
    &lt;Button        Grid.Row="1"                 Background="Green"  />
    &lt;Button        Grid.Row="1" Grid.Column="2" Background="Aqua"   />
    &lt;!-- Row 2 -->
    &lt;Button        Grid.Row="2"                 Background="Purple" />
    &lt;Button        Grid.Row="2" Grid.Column="1" Background="Brown"  />
    &lt;Button        Grid.Row="2" Grid.Column="2" Background="Gray"   />
&lt;/Grid>
</pre>

In this case, the JavaScript could plop the WebView into the center cell, surrounded by the colorful buttons:

<pre>
ace.load("native://Grid.xaml", function (root) {
    // Replace the WebView with a Grid
    ace.getHostPage().setContent(root);
    
    var webView = ace.getHostWebView();

    // Place the WebView inside the Grid
    ace.Grid.setRow(webView, 1);
    ace.Grid.setColumn(webView, 1);
    root.getChildren().add(webView);
});
</pre>

As always, this could all be done without XAML:

<pre>
var grid = new ace.Grid();
grid.getRowDefintions().add(new ace.RowDefinition());
...
var button2 = new ace.Button();
ace.Grid.setColumn(button2, 1);
button2.setBackground("orange");
grid.getChildren().add(button2);
...

// Replace the WebView with a Grid
ace.getHostPage().setContent(grid);

var webView = ace.getHostWebView();

// Place the WebView inside the Grid
ace.Grid.setRow(webView, 1);
ace.Grid.setColumn(webView, 1);
root.getChildren().add(webView);
</pre>

<a name="two"/>

## Overlaying Native UI

<img class="img-responsive;height:218px" src="/assets/images/home/overlay.png" height="218"/>

You accomplish this with the <b>Popup</b> class. You can create a popup, set its content to any UI object, and show/hide it.

By default, popups are fullscreen, but they have methods for sizing and positioning them.

<pre>
ace.load("native://content.xaml", function (root) {
    var popup = new ace.Popup();
    popup.setContent(root);
    popup.show();

    root.addEventListener("click", function () {
        popup.hide();
    });
});
</pre>

Here's an example that uses raw Android UI objects:

<pre>
ace.load("android://vector_graphics.xml", function (root) {
    var popup = new ace.Popup();
    popup.setContent(root);
    popup.show();

    root.addEventListener("setOnClickListener", function () {
        popup.hide();
    });
});
</pre>

<br/>

<a name="three"/>

## Fullscreen Native UI

<img class="img-responsive;height:218px" src="/assets/images/home/fullscreen.png" height="218"/>

One way to accomplish fullscreen native UI is to replace the WebView, as shown in the <b>Docking Native UI</b> section, 
but then keeping the WebView hidden.

Another way is to *navigate* to a new all-native page.  If your page is defined in markup, you can use a hyperlink:

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

or you can change the document's location in JavaScript:

<pre>
document.location.href = "native://page.xaml";
document.location.href = "android://page.xml";
document.location.href = "ios://page.xib";
</pre>

or you can call a navigate API:

<pre>
ace.navigate("native://page.xaml");
</pre>

and take advantage of the fact that navigate returns the root UI object from the new page:

<pre>
ace.navigate("native://page.xaml", function (root) {
    // Navigation done
    root.setBackground("Salmon");
});
</pre>

and handle a navigating-away event:

<pre>
ace.navigate("native://page.xaml", function (root) {
    // Navigation done
    root.setBackground("Salmon");
    root.findName("someControlOnThePage").setForeground("LemonChiffon");
}, function (root) {
    // Navigating away
});
</pre>

> Whether you get a cross-platform UI object from XAML or programmatically, you can retrieve sub-objects 
> by name with the findName API.

You can use the navigate API with programmatically-created UI. You just pass navigate the root UI object instead of a URL:

<b>Navigate to Cross-Platform Programmatically-Created Content</b>

<pre>
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
button1.addEventListener("click", function () { ace.Frame.goBack(); });
button2.setContent("A");
button3.setContent("B");
ace.Canvas.setLeft(button3, 150);
button4.setContent("C");
button4.setWidth(100);
button4.setHeight(100);
ace.Canvas.setTop(button4, 110);

// Create a Style
var style = new ace.Style();
style.setTargetType("Button");

var setter1 = new ace.Setter();
setter1.setProperty("FontSize");
setter1.setValue(60);
style.getSetters().add(setter1);

var setter2 = new ace.Setter();
setter2.setProperty("FontWeight");
setter2.setValue("Bold");
style.getSetters().add(setter2);

var setter3 = new ace.Setter();
setter3.setProperty("Foreground");
setter3.setValue("Violet");
style.getSetters().add(setter3);

var setter4 = new ace.Setter();
setter4.setProperty("Background");
setter4.setValue("SteelBlue");
style.getSetters().add(setter4);

var setter5 = new ace.Setter();
setter5.setProperty("Width");
setter5.setValue(100);
style.getSetters().add(setter5);

var setter6 = new ace.Setter();
setter6.setProperty("Height");
setter6.setValue(100);
style.getSetters().add(setter6);

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

<b>Navigate to Raw Android-Specific Programmatically-Created Content</b>

<pre>
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

<b>Navigate to Raw iOS-Specific Programmatically-Created Content</b>

<pre>
if (ace.platform == "iOS") {
    // Create a UISegmentedControl
    var uiSegmentedControl = new ace.NativeObject("UISegmentedControl");

    // Add four segments
    uiSegmentedControl.invoke("insertSegmentWithTitle:atIndex:animated:", "One", 0, false);
    uiSegmentedControl.invoke("insertSegmentWithTitle:atIndex:animated:", "Two", 1, false);
    uiSegmentedControl.invoke("insertSegmentWithTitle:atIndex:animated:", "Three", 2, false);
    uiSegmentedControl.invoke("insertSegmentWithTitle:atIndex:animated:", "Four", 3, false);

    // Select the last segment
    uiSegmentedControl.invoke("setSelectedSegmentIndex", 3);

    // Navigate to the single control
    ace.navigate(uiSegmentedControl,
        // Just so we have a way to get back:
        function () { ace.Frame.showNavigationBar(); },
        function () { ace.Frame.hideNavigationBar(); });
}
</pre>

<br/>

<a name="four"/>

## Creating an Android Widget

Check out the <a href="/apps">PhoneGap Day app</a> for an example of this.

<a name="five"/>

<br/>

<br/>

## Creating Floating UI on Android

Documentation coming soon.
