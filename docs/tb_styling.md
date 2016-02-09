---
layout: doc
title: Styling Native Controls
category: docs
permalink: /docs/styling/
---

<div style="background-color:#3399FF;color:white;foreground:bold;padding:20px">
<b>SUMMARY</b>
<br/>
<ul>
<li>A <i>style</i> is a collection of properties and their values.</li>
<li>HTML content can be styled with CSS, as always.</li>
<li>Native content can be styled with Style objects that can be defined in XAML or JavaScript.</li>
<li>In JavaScript, you can use JSON, such as:</li>
<pre>
{
  FontWeight: "Bold",
  Foreground: "Violet",
  Background: "SteelBlue"
}</pre>
</ul>

</div>

<br/>

For the **HTML** in your app, you style it the same ways as always, such as using **CSS**. However, 
this topic discusses how you style **native controls**.

## Setting Properties Directly

You can set visual properties directly on UI objects. Here's how it looks in XAML:
<pre>
&lt;Button <b>FontWeight</b>="Bold" <b>Foreground</b>="Violet" <b>Background</b>="SteelBlue" />
</pre>
In JavaScript, you can call set*PropertyName* functions:
<pre>
var b = new ace.Button();
b.<b>setFontWeight</b>("Bold");
b.<b>setForeground</b>("Violet");
b.<b>setBackground</b>("SteelBlue");
</pre>

Common visual properties include:

* Background
* FontSize
* FontWeight
* Foreground
* Height
* Margin
* Padding
* Width

These cross-platform properties can not only be set on objects in the [cross-platform UI framework](/ace/docs/ref), but they can be set 
on raw platform-specific controls as well. For example:
<pre>
&lt;if.iOS>
  &lt;ios:UISegmentedControl <b>Background</b>="LemonChiffon" />
&lt;/if.iOS>
&lt;if.Android>
  &lt;android:RatingBar <b>Background</b>="LemonChiffon" />
&lt;/if.Android>
</pre>
Ace maps these properties (and others, such as Content) to their most natural native counterparts.

## Conslidating Properties Into a Style

A *style* is a simple object that consolidates properties and their values. In XAML, you can define and apply 
a style to a single button as follows:
<pre>
&lt;Button>
  &lt;Button.Style><b>
    &lt;Style TargetType="Button">
      &lt;Setter Property="FontWeight" Value="Bold" />
      &lt;Setter Property="Foreground" Value="Violet" />
      &lt;Setter Property="Background" Value="SteelBlue" />
    &lt;/Style></b>
  &lt;/Button.Style>
&lt;/Button>
</pre>
As all XAML can be naturally expressed in JavaScript instead, you could build up a style programmatically as follows:
<pre>
<b>// Don't actually do this. There's a better way about to be shown:</b>
var b = new ace.Button();
var style = new ace.Style();
style.setTargetType("Button");

var setter1 = new ace.Setter();
setter1.setProperty("FontWeight");
setter1.setValue("Bold");
style.getSetters().add(setter1);

var setter2 = new ace.Setter();
setter2.setProperty("Foreground");
setter2.setValue("Violet");
style.getSetters().add(setter2);

var setter3 = new ace.Setter();
setter3.setProperty("Background");
setter3.setValue("SteelBlue");
style.getSetters().add(setter3);

b.setStyle(style);
</pre>

However, as a shortcut, you can instead use JSON syntax:
<pre>
var b = new ace.Button();
<b>b.setStyle(
{
  FontWeight: "Bold",
  Foreground: "Violet",
  Background: "SteelBlue"
});</b>
</pre>

## Sharing Styles

Usually, the purpose of defining a style is to share it among multiple objects. You can do this in XAML by 
adding it to a parent element's Resources collection then referencing it with {StaticResource *resourceName*} syntax:
<pre>
&lt;StackPanel xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml">
  &lt;StackPanel.Resources>
    <b>&lt;Style x:Key="MyStyle" TargetType="Button">
      &lt;Setter Property="FontWeight" Value="Bold"/>
      &lt;Setter Property="Foreground" Value="Violet"/>
      &lt;Setter Property="Background" Value="SteelBlue"/>
    &lt;/Style></b>
  &lt;/StackPanel.Resources>

  &lt;Button <b>Style="{StaticResource MyStyle}"</b>>A&lt;/Button>
  &lt;Button <b>Style="{StaticResource MyStyle}"</b>>B&lt;/Button>
  &lt;Button <b>Style="{StaticResource MyStyle}"</b>>C&lt;/Button>    
&lt;/StackPanel>
</pre>
In JavaScript, you can just reapply the same style instance:
<pre>
<b>var style = {
  FontWeight: "Bold",
  Foreground: "Violet",
  Background: "SteelBlue"
};</b>

var b1 = new ace.Button();
<b>b1.setStyle(style);</b>
b1.setContent("A");

var b2 = new ace.Button();
<b>b2.setStyle(style);</b>
b2.setContent("B");

var b3 = new ace.Button();
<b>b3.setStyle(style);</b>
b3.setContent("C");
</pre>
