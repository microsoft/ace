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

Another way is to *navigate* to a new all-native page. See [the Navigation topic](/docs/navigation) for all the ways to perform navigation.

<br/>

<a name="four"/>

## Creating an Android Widget

Check out the <a href="/apps">PhoneGap Day app</a> for an example of this. Because Ace enables you to 
include arbitrary Java and resources in your app, you can build completely-custom widgets the same way 
you would in a pure native app. However, Ace provides some standard widget functionality that makes this 
even easier.

### 1. Define Widget(s) in AndroidManifest.xml.

Copy the already-produced AndroidManifest.xml from your project's platforms/android folder to the native/android/res 
folder so you can overwrite it with your custom entries.

Add the following under the &lt;application> element to get a list-based widget:

<pre>
&lt;receiver android:label="List" android:name="<i>your.package.name</i>.ListWidgetProvider">
  &lt;intent-filter>
    &lt;action android:name="android.appwidget.action.APPWIDGET_UPDATE" />
  &lt;/intent-filter>
  &lt;meta-data android:name="android.appwidget.provider" android:resource="@xml/list_widget_info" />
&lt;/receiver>
&lt;service android:exported="false" android:name="run.ace.AppWidgetService" android:permission="android.permission.BIND_REMOTEVIEWS" />
</pre>

### 2. Add the Necessary Android Resources

Add a native/android/res/xml/list_widget_info.xml file with the following content:

<pre>
&lt;?xml version="1.0" encoding="utf-8"?>
&lt;appwidget-provider
  xmlns:android="http://schemas.android.com/apk/res/android"
  android:minWidth="180dip"
  android:minHeight="180dip"
  android:updatePeriodMillis="3600000"
  android:previewImage="@drawable/list_widget_preview"
  android:initialLayout="@layout/list_widget_layout">
&lt;/appwidget-provider>
</pre>

Add an appropriate preview image as native/android/res/drawable/list_widget_preview.png.

Add a native/android/res/layout/list_widget_layout file defining the widget layout:

<pre>
&lt;?xml version="1.0" encoding="utf-8"?>
&lt;ListView xmlns:android="http://schemas.android.com/apk/res/android"
    android:id="@+id/list_widget_view"
    android:layout_width="match_parent"
    android:layout_height="match_parent"
    android:gravity="center"
    android:loopViews="true" />
</pre>

Add a native/android/res/layout/list_widget_view file defining the layout of each widget item:

<pre>
&lt;?xml version="1.0" encoding="utf-8"?>
&lt;FrameLayout xmlns:android="http://schemas.android.com/apk/res/android"
    android:id="@+id/list_widget_item"
    android:layout_width="match_parent"
    android:layout_height="match_parent">
  &lt;TextView 
    android:id="@+id/list_widget_item_text"
    android:layout_width="match_parent"
    android:layout_height="wrap_content"
    android:layout_margin="10dp"
    android:textColor="#ffffff"
    android:textSize="40px" />
&lt;/FrameLayout>
</pre>

### 3. Add a WidgetProvider Java Class

Place this anywhere under native/android/src. The class and package name must match what you specified 
in AndroidManifest.xml. This class tells Ace about the resources you've defined.

<pre>
package <i>your.package.name</i>;

public class ListWidgetProvider extends run.ace.AppWidgetProvider {
  @Override protected int getLayoutResourceId(android.content.Context context) {
    return run.ace.NativeHost.getResourceId("list_widget_layout", "layout", context);
  }

  @Override protected int getViewResourceId(android.content.Context context) {
    return run.ace.NativeHost.getResourceId("list_widget_view", "id", context);
  }

  @Override protected int getItemResourceId(android.content.Context context) {
    return run.ace.NativeHost.getResourceId("list_widget_item", "id", context);
  }

  @Override protected int getItemTextResourceId(android.content.Context context) {
    return run.ace.NativeHost.getResourceId("list_widget_item_text", "id", context);
  }

  @Override protected int getItemLayoutResourceId(android.content.Context context) {
    return run.ace.NativeHost.getResourceId("list_widget_item", "layout", context);
  }
}
</pre>

### 3. Populate Widget Data in JavaScript

When your app runs, you can populate your widget:

<pre>
if (ace.platform == "Android") {
  setupWidget();
}

function setupWidget() {
  // Handle the app being resumed by a widget click:
  ace.addEventListener("android.intentchanged", checkForWidgetActivation);

  ace.android.appWidget.clear();
  
  for (var i = 0; i < 10; i++) {
    ace.android.appWidget.add("Item with index " + i);
  }
}
</pre>

### 4. Handle Widget Item Clicks in JavaScript

When an item in a list-based widget is clicked, its index is stored in the Android activity's <i>intent</i>. The code below shows how to 
retrieve this index. To handle your app being activated by a widget click, you should check for this data 
as your app initializes. However, to also handle your app being <i>resumed</i> by a widget click, you should 
attach an event handler to the global <b>android.intentchanged</b> event:
<pre>
ace.addEventListener("android.intentchanged", checkForWidgetActivation);
</pre>

<pre>
function checkForWidgetActivation() {
  if (ace.platform != "Android") {
    return;
  }

  ace.android.getIntent().invoke("getIntExtra", "widgetSelectionIndex", -1, function (value) {
    // value is the index of the item clicked
    // or -1 if no item has been clicked
  });
}
</pre>

<br/>

<a name="five"/>

## Creating Floating UI on Android

Documentation coming soon.
