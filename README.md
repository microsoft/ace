![Ace Logo](http://microsoft.github.io/ace/assets/images/logo/ace.png) Visit our [homepage](http://microsoft.github.io/ace/) & [get started](http://microsoft.github.io/ace/docs/getting-started/) in minutes!

## WHAT IS ACE?

An Apache Cordova plugin that enables you to easily add native UI and native code to your JavaScript and HTML.

* Mix native UI with HTML
* Use a cross-platform native UI framework
* Call native code without additional plugins

![Ace Diagram](http://microsoft.github.io/ace/assets/images/github/intro.png)

## QUICK START

### RUNNING THE EXAMPLES
**From a Command Prompt (Windows) or Terminal (Mac):**

* Install NPM, which is [included in the Node.js installation](https://nodejs.org/en/download/), if you haven't already
* Install Cordova using NPM (this might require executing with sudo on a Mac):
```
npm install -g cordova
```
* Go to the examples/AceExamples subfolder, then run:
```
cordova prepare
cordova run android
cordova run ios
```
**Or, Using Visual Studio:**

* Ensure you have [Tools for Apache Cordova](https://www.visualstudio.com/en-us/features/cordova-vs.aspx) installed
* Open examples/AceExamples/AceExamples.sln
* Deploy to either an Android emulator or device (KitKat or later, ideally Marshmallow), or an iOS remote device
* If you need a Marshmallow Android emulator, run the "Visual Studio Emulator for Android" program from the Start menu to download one.

### ADDING TO A NEW OR EXISTING CORDOVA PROJECT
**Just add the plugin to your Cordova project.** Whether you use Visual Studio or command-line tools, Windows or Mac, you can add this plugin the standard way.  For example:
```
cordova plugin add cordova-plugin-ace
```
or, in Visual Studio, open **config.xml** then add the plugin under **Plugins**, **Custom**. You can point it at https://github.com/microsoft/ace.git or a local copy that you download.

Then follow the examples and docs. You can find examples in the examples folder of this repository.

## COMMUNITY

* Have a question that's not a feature request or bug report? [Discuss on Stack Overflow](https://stackoverflow.com/questions/tagged/ace-plugin)
* Have a feature request or find a bug? [Submit an issue](https://github.com/microsoft/ace/issues)
* Please [contribute](https://github.com/microsoft/ace/blob/master/CONTRIBUTING.md) to the source code!

## DEVELOPMENT

The easiest way to test plugin code changes is to copy the examples/AceExamples folder *outside of* the plugin folder, 
remove the Ace plugin from the project, and then add it back using a path to your local ace folder with your code changes.

Just remember to copy any enhancements you make to the AceExamples project back to the original location!

## LICENSE

Ace is licensed under the MIT Open Source license.
