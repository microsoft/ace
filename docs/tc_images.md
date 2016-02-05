---
layout: doc
title: Working with Images
category: docs
permalink: /docs/images/
---

Ace provides a cross-platform [<b>Image</b>](/ace/docs/ref/#Image) class that be used to place an image (PNG, JPG, and so on) inside 
your user interface. This is like using ImageView on Android and UIImageView on iOS. (In fact, that is exactly what happens behind the scenes.)

You can set Image's <b>Source</b> to an image URL, such as <b>www/images/icon.png</b>.

[<b>Image</b>](/ace/docs/ref/#Image) has a few extra smarts, however, that are convenient for tweaking per-platform behavior without having 
to write per-platform code.

### Consolidating Multiple Images Into One URL

There are three features you can take advantage of when specifying an image source:

* Customizing per-platform
* Customizing for "on" and "off" states
* Customizing for device resolutions or screen density

#### Customizing Per-Platform
If your URL contains the string <b>{platform}</b>, it will be replaced with the platform name at runtime. So <b>icon-{platform}.png</b> 
becomes <b>icon-ios.png</b> on iOS and <b>icon-android.png</b> on Android. This enables you to supply images that better match the styling 
of each platform.

#### Customizing For "On" and "Off" States
In addition, sometimes you might want to supply multiple images representing different states. This currently applies to 
[<b>AppBarButton</b>](/ace/docs/ref/#AppBarButton)s inside a [<b>TabBar</b>](/ace/docs/ref/#TabBar). iOS supports a separate *selectedImage* in addition to the main image. To make this seamless, 
Ace will look for two separate images, one with an <b>ios-on</b> platform identifier and another with an <b>ios-off</b> identifier.

#### Customizing For Device Resolution or Screen Density
On iOS, you can supply multiple sizes of an image and add suffixes to your image files like @2x, @3x, and @4x to 
tell the operating system which image to use. This happens automatically, so you leave the suffix out of your [<b>Image</b>](/ace/docs/ref/#Image) source.

#### Example
Therefore, you can specify a single icon:

<pre>
&lt;AppBarButton <b>Icon="www/img/tabs/calendar-{platform}.png"</b> 
              Label="Schedule" 
              ace:On.Click="onTabClick(this, 0)" />
</pre>

And supply many separate images:

* <b>www/img/tabs/calendar-android.png</b>: Used in all cases on Android
* <b>www/img/tabs/calendar-ios-on@2x.png</b>: Used as the selected image on iOS (2x scale)
* <b>www/img/tabs/calendar-ios-off@2x.png</b>: Used as the default image on iOS (2x scale)
* <b>www/img/tabs/calendar-ios-on@3x.png</b>: Used as the selected image on iOS (3x scale)
* <b>www/img/tabs/calendar-ios-off@3x.png</b>: Used as the default image on iOS (3x scale)
* <b>www/img/tabs/calendar-ios-on@4x.png</b>: Used as the selected image on iOS (4x scale)
* <b>www/img/tabs/calendar-ios-off@4x.png</b>: Used as the default image on iOS (4x scale)

You can see this in action in the source code for the [PhoneGapDay app](/ace/apps). 

<table>
<tr colspan="2">
<td style="padding:10px;font-size:small">calendar-android.png</td>
</tr>
<tr colspan="2">
<td><img src="/ace/assets/images/docs/calendar-android.png"/></td>
</tr>
<tr>
<td style="padding:10px;font-size:small">calendar-ios-on@2x.png</td>
<td style="padding:10px;font-size:small">calendar-ios-off@2x.png</td>
</tr>
<tr>
<td><img src="/ace/assets/images/docs/calendar-ios-on@2x.png"/></td>
<td><img src="/ace/assets/images/docs/calendar-ios-off@2x.png"/></td>
</tr>
<tr>
<td style="padding:10px;font-size:small">calendar-ios-on@3x.png</td>
<td style="padding:10px;font-size:small">calendar-ios-off@3x.png</td>
</tr>
<tr>
<td><img src="/ace/assets/images/docs/calendar-ios-on@3x.png"/></td>
<td><img src="/ace/assets/images/docs/calendar-ios-off@3x.png"/></td>
</tr>
<tr>
<td style="padding:10px;font-size:small">calendar-ios-on@4x.png</td>
<td style="padding:10px;font-size:small">calendar-ios-off@4x.png</td>
</tr>
<tr>
<td><img src="/ace/assets/images/docs/calendar-ios-on@4x.png"/></td>
<td><img src="/ace/assets/images/docs/calendar-ios-off@4x.png"/></td>
</tr>
</table>

