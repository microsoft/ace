---
layout: doc
title: Getting Started
category: docs
permalink: /docs/getting-started/
---

# Running the Examples

**From a Command Prompt (Windows) or Terminal (Mac):**

* Install NPM, which is [included in the Node.js installation](https://nodejs.org/en/download/), if you haven't already
* Install Cordova using NPM (this might require executing with sudo on a Mac):

    <pre>npm install -g cordova</pre>

* Go to the examples/AceExamples subfolder, then run:

    <pre>cordova prepare
cordova run android
cordova run ios</pre>

**Or, Using Visual Studio:**

* Ensure you have [Tools for Apache Cordova](https://www.visualstudio.com/en-us/features/cordova-vs.aspx) installed
* Open examples/AceExamples/AceExamples.sln
* Deploy to either an Android emulator or device (**Lollipop or later, ideally Marshmallow**), or an iOS remote device
* If you need a Marshmallow Android emulator, run the "Visual Studio Emulator for Android" program from the Start menu to download one.

<br/>

# Adding Ace to a New or Existing Cordova Project

<br/>

## 1. Start a Cordova Project
There are many options for getting started with Cordova:

* Create a new **Blank App (Apache Cordova)** project in Visual Studio

* or use the [Cordova command-line interface](http://cordova.apache.org/#getstarted)

* or use the [TACO command-line interface](http://taco.tools/docs/getting-started.html)

* or use the [Ionic command-line interface](http://ionicframework.com/getting-started/)
    
<br/>

## 2. Add the Ace Plugin to Your Project
In Visual Studio, open **config.xml** then add the plugin under **Plugins**, **Custom**. You can point it at **https://github.com/microsoft/ace** or a local copy that you download (to a path with no spaces).

<img width="50%" src="/ace/assets/images/docs/getting-started/vsconfig.png"/>

If you're using a command-line interface, do one of the following:

<pre style="width:300px">
 cordova plugin add cordova-plugin-ace

 taco    plugin add cordova-plugin-ace

 ionic   plugin add cordova-plugin-ace
</pre>

This will retrieve the latest version of the plugin [from npm](https://www.npmjs.com/package/cordova-plugin-ace).

<i class="fa fa-warning"></i> 

> If you switch from a command-line interface to Visual Studio after installing any plugins, you should delete your platform and plugin folders, remove then reinstall your plugins inside Visual Studio, and then rebuild.

<br/>

## 3. (Optional) Add XAML Compilation Support to Your Project
You can leverage all the features of Ace without using XAML markup, but it's a very handy feature.

If you'd like to use XAML markup, you can enable seamless support inside Visual Studio by doing the following:

* Copy **Ace.targets** and **Ace.BuildTasks.dll** from [the plugin's markupcompiler subfolder](https://github.com/microsoft/ace/tree/master/markupcompiler) 
to the root of your project.

* Add the following line as a child of the root &lt;Project&gt; element in your project file:

    <pre>&lt;Import Project="Ace.targets" /></pre>

With this in place, any .xaml files in your project get compiled to a binary file placed in the www\xbf folder every time you build. 
This enables you to leverage the markup in your app.

<i class="fa fa-warning"></i> 

> XAML compilation currently must be done on Windows. However, Visual Studio is not a requirement. You can compile your XAML from a command prompt by running **markupcompiler.exe** from [the plugin's markupcompiler subfolder](https://github.com/microsoft/ace/tree/master/markupcompiler) then 
manually copying the .xbf files to the www\xbf folder. You can then add these to source control so you can do the rest of your development on a Mac.

<br/>

## 4. Create Your App
With Ace added to your project, you can now leverage its features. Read the rest of the docs to understand what you can do, and refer to the example projects in [the plugin's examples folder](https://github.com/microsoft/ace/tree/master/examples).
