![Ace Logo](http://ace.run/assets/images/logo/ace.png) Visit our [homepage](http://ace.run/) & [get started](http://ace.run/docs/getting-started/) in minutes!

## WHAT IS ACE?

An Apache Cordova plugin that enables you to easily add native UI and native code to your JavaScript and HTML.

* Mix native UI with HTML
* Use a cross-platform native UI framework
* Call native code without additional plugins

![Ace Diagram](http://ace.run/assets/images/github/intro.png)

## QUICK START

**Just add the plugin to your Cordova project.** Whether you use Visual Studio or command-line tools, Windows or Mac, you can add this plugin the standard way.  For example:
```
cordova plugin add cordova-plugin-ace
```
or, in Visual Studio, open **config.xml** then add the plugin under **Plugins**, **Custom**. You can point it at https://github.com/adnathan/ace.git or a local copy that you download.

Then follow the examples and docs. You can find examples in the examples folder of this repository.

## RUNNING THE EXAMPLES
Go to the examples/AceExamples subfolder, then run:
```
cordova prepare
cordova run android
cordova run ios
```
Or, using Visual Studio, open examples/AceExamples/AceExamples.sln, and then either deploy to an Android emulator, Android device, or iOS remote device.

## COMMUNITY

* Have a question that's not a feature request or bug report? [Discuss on Stack Overflow](https://stackoverflow.com/questions/tagged/ace-plugin)
* Have a feature request or find a bug? [Submit an issue](https://github.com/adnathan/ace/issues)
* Please [contribute](https://github.com/adnathan/ace/blob/master/CONTRIBUTING.md) to the source code!

## DEVELOPMENT

The easiest way to test plugin code changes is to copy the examples/AceExamples folder *outside of* the plugin folder, 
remove the Ace plugin from the project, and then add it back using a path to your local ace folder with your code changes.

Just remember to copy any enhancements you make to the AceExamples project back to the original location!

## LICENSE

Ace is licensed under the MIT Open Source license.