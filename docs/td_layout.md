---
layout: doc
title: Native UI Layout
category: docs
permalink: /docs/layout/
section1: Panels
section2: Properties
---

<div style="background-color:#3399FF;color:white;foreground:bold;padding:20px">
<b>SUMMARY</b>
<br/>
<ul>
<li><i>Layout</i> refers to the placement and sizing of UI elements.</li>
<li>HTML content can use normal HTML layout (div, table, etc.).</li>
<li>Native content can take advantage of <i>layout panels</i> and <i>layout properties</i> from either XAML or JavaScript.</li>
<li>The current built-in layout panels are Canvas, StackPanel, and Grid.</li>
</ul>

</div>

<br/>

For the **HTML** in your app, you use the same HTML/CSS layout mechanisms as you've always used. However, 
this topic discusses how you apply layout to **native controls**. The two main concepts are <a href="#one">layout panels</a> 
and <a href="#two">layout properties</a>.

<a name="one"/>

## Layout Panels
There are currently three cross-platform panels available:

* <b>Canvas</b> for absolute positioning
* <b>StackPanel</b> for horizontal or vertical stacking
* <b>Grid</b> for complex layout

### Canvas
In a Canvas, you position children with explicit **Left** and/or **Top** coordinates. Each child renders at its natural size by default.

In XAML, you set these coordinates as "attached properties," e.g.:

<pre>
&lt;Canvas>
    &lt;!-- The default position is 0,0: -->
    &lt;Button                                    Background="Red"    />
    &lt;Button <b>Canvas.Left="100"                 </b> Background="Orange" />
    &lt;Button <b>                  Canvas.Top="150"</b> Background="Yellow" />
    &lt;Button <b>Canvas.Left="150" Canvas.Top="200"</b> Background="Green"  />
&lt;/Canvas>
</pre>

In JavaScript, you set the coordinates via static methods on Canvas to get the same results:

<pre>
var canvas = new ace.Canvas();

var b1 = new ace.Button();
b1.setBackground("Red");
canvas.getChildren().add(b1);
    
var b2 = new ace.Button();
b2.setBackground("Orange");
<b>ace.Canvas.setLeft(b2, 100);</b>
canvas.getChildren().add(b2);

var b3 = new ace.Button();
b3.setBackground("Yellow");
<b>ace.Canvas.setTop(b3, 150);</b>
canvas.getChildren().add(b3);

var b4 = new ace.Button();
b4.setBackground("Green");
<b>ace.Canvas.setLeft(b4, 150);
ace.Canvas.setTop(b4, 200);</b>
canvas.getChildren().add(b4);

// Navigate to this Canvas
ace.navigate(canvas);
</pre>

Here is the result of using either approach, shown on iOS:

<img width="50%" src="/ace/assets/images/docs/layout/canvas-ios.png"/>

### StackPanel
StackPanel doesn't provide any attached properties for controlling the layout of its children. You just add children, and they get 
stacked (vertically by default). You can set StackPanel's Orientation property to either "vertical" or "horizontal".

By default, children are given their natural size in the direction of stacking, and they are stretched to fill the perpendicular direction. 
You can change this with the HorizontalAlignment/VerticalAlignment properties discussed later in this topic.

### Grid
Grid enables you to define rows and columns, then place each child in specific rows/columns. There are many options 
for configuring how rows and columns are sized. They can be auto-sized, given explicit sizes, or given proportional 
sizes. For now, you can find more documentation about this toward the bottom of <a href="https://msdn.microsoft.com/en-us/library/system.windows.controls.grid(v=vs.110).aspx">this page</a>.

Here's an example that uses a Grid in XAML:

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
    &lt;Button                                     Background="Red"       />
    &lt;Button                     Grid.Column="1" Background="Orange"    />
    &lt;Button                     Grid.Column="2" Background="Yellow"    />
    &lt;!-- Row 1 -->
    &lt;Button        Grid.Row="1"                 Background="Green"     />
    &lt;Button        Grid.Row="1" Grid.Column="1" Background="Aqua"      />
    &lt;Button        Grid.Row="1" Grid.Column="2" Background="SteelBlue" />
    &lt;!-- Row 2 -->
    &lt;Button        Grid.Row="2"                 Background="Purple"    />
    &lt;Button        Grid.Row="2" Grid.Column="1" Background="Brown"     />
    &lt;Button        Grid.Row="2" Grid.Column="2" Background="Gray"      />
&lt;/Grid>
</pre>

If you navigate to this markup file, you get the following result, which stretches to fill the screen regardless of size/orientation:

<img width="50%" src="/ace/assets/images/docs/layout/grid-android.png"/>

Here's the same example purely in JavaScript, which produces the identical result with no markup involved:

<pre>
var grid = new ace.Grid();

grid.getRowDefinitions().add(new ace.RowDefinition());
grid.getRowDefinitions().add(new ace.RowDefinition("2*"));
grid.getRowDefinitions().add(new ace.RowDefinition());

grid.getColumnDefinitions().add(new ace.ColumnDefinition());
grid.getColumnDefinitions().add(new ace.ColumnDefinition("2*"));
grid.getColumnDefinitions().add(new ace.ColumnDefinition());

var b1 = new ace.Button();
b1.setBackground("Red");
grid.getChildren().add(b1);

var b2 = new ace.Button();
ace.Grid.setColumn(b2, 1);
b2.setBackground("Orange");
grid.getChildren().add(b2);

var b3 = new ace.Button();
ace.Grid.setColumn(b3, 2);
b3.setBackground("Yellow");
grid.getChildren().add(b3);

var b4 = new ace.Button();
ace.Grid.setRow(b4, 1);
b4.setBackground("Green");
grid.getChildren().add(b4);

var b5 = new ace.Button();
ace.Grid.setRow(b5, 1);
ace.Grid.setColumn(b5, 1);
b5.setBackground("Aqua");
grid.getChildren().add(b5);

var b6 = new ace.Button();
ace.Grid.setRow(b6, 1);
ace.Grid.setColumn(b6, 2);
b6.setBackground("SteelBlue");
grid.getChildren().add(b6);

var b7 = new ace.Button();
ace.Grid.setRow(b7, 2);
b7.setBackground("Purple");
grid.getChildren().add(b7);

var b8 = new ace.Button();
ace.Grid.setRow(b8, 2);
ace.Grid.setColumn(b8, 1);
b8.setBackground("Brown");
grid.getChildren().add(b8);

var b9 = new ace.Button();
ace.Grid.setRow(b9, 2);
ace.Grid.setColumn(b9, 2);
b9.setBackground("Gray");
grid.getChildren().add(b9);

// Navigate to the Grid
ace.navigate(grid);
</pre>

Children can span multiple rows/columns with the <b>Grid.RowSpan</b> and <b>Grid.ColumnSpan</b> properties, whose default value is 1. The following Grid produces 
the result below:

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
    &lt;Button        <b>Grid.ColumnSpan="2"</b>                              Background="Red"       />
    &lt;Button                                         Grid.Column="2" Background="Yellow"    />
    &lt;!-- Row 1 -->
    &lt;Button                            Grid.Row="1"                 Background="Green"     />
    &lt;Button                            Grid.Row="1" Grid.Column="1" Background="Aqua"      />
    &lt;Button        <b>Grid.RowSpan="2"</b>    Grid.Row="1" Grid.Column="2" Background="SteelBlue" />
    &lt;!-- Row 2 -->
    &lt;Button                            Grid.Row="2"                 Background="Purple"    />
    &lt;Button                            Grid.Row="2" Grid.Column="1" Background="Brown"     />
&lt;/Grid>
</pre>

<img width="50%" src="/ace/assets/images/docs/layout/grid-span-android.png"/>

In JavaScript, you can set these properties as follows:

<pre>
...
ace.Grid.setColumnSpan(b1, 2);
...
ace.Grid.setRowSpan(b6, 2);
...
</pre>

<a name="two"/>

## Layout Properties

Besides panel-specific properties that can be attached to any UI object (like Canvas.Top or Grid.Row), all 
UI objects can be marked with properties that affect layout, such as Margin. Here's a description of each one:

### Margin

Can be set to a "thickness" value, which is one, two, or four comma-delimited numbers. For example:

* A Margin of 20 adds a 20-unit margin around all four sides
* A Margin of "20,10" adds a 20-unit margin to the left and right sides, and a 10-unit margin to the top and bottom sides
* A Margin of "10,20,30,40" adds different margin values to the left, top, right, and bottom sides, in that order.

### Padding

Padding is an "inner margin" that is only supported on specific controls, such as Button. The Grid and StackPanel layout panels also support padding.

Padding can be set to a "thickness" value, just like with Margin.

### Width and Height

All UI elements can be given explicit widths and heights, which override their natural size.

### HorizontalAlignment and VerticalAlignment

If a layout panel gives a child element more space than it needs, you can use these properties to customize how the child element fills that space.

**HorizontalAlignment** can be set to **Left**, **Right**, **Center**, or **Stretch**

**VerticalAlignment** can be set to **Top**, **Bottom**, **Center**, or **Stretch**

In a Grid, each element is stretched both horizontally and vertically by default in order to fill the "cell" given to it. The image below demonstrates 
what happens if each Button in the earlier Grid example (the one leveraging RowSpan and ColumnSpan) is marked with either the following in XAML:
<pre>
&lt;Button ... HorizontalAlignment="Right" VerticalAlignment="Bottom" />
</pre>
or the following in JavaScript:
<pre>
...
b1.setHorizontalAlignment("Right");
b1.setVerticalAlignment("Bottom");
...
</pre>

Examples are also given with values of "Left" and "Top" as well as "Center" and "Center".

The original Button layout is shown faded in the background just to make the cell sizes more obvious. In reality, the smaller buttons, now given their natural non-stretched size, 
are on top of a plain white background.

**HorizontalAlignment=Right, VerticalAlignment=Bottom (Android)**

<img width="50%" src="/ace/assets/images/docs/layout/grid-span-bottomright-android.png"/>

**HorizontalAlignment=Left, VerticalAlignment=Top (Android)**

<img width="50%" src="/ace/assets/images/docs/layout/grid-span-topleft-android.png"/>

**HorizontalAlignment=Center, VerticalAlignment=Center (iOS)**

<img width="50%" src="/ace/assets/images/docs/layout/grid-span-centercenter-ios.png"/>

### HorizontalContentAlignment and VerticalContentAlignment

These two properties can be set on some controls, such as TextBlock and Button, to control the alignment of its inner content. They accept the same values as 
HorizontalAlignment and VerticalAlignment.
