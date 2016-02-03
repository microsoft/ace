---
layout: doc
title: Troubleshooting Errors
category: hidden
permalink: /docs/errors/
---

## Failure to load/navigate to .xaml file
**Symptoms:**

On iOS: "Compiled markup file *filename*.xbf does not exist."

On Android: "java.io.FileNotFoundException: www/xbf/*filename*.xbf"

**Resolution:**

In order for a .xaml file to be found at runtime, it had to have been compiled to an .xbf file at build-time 
then placed in the www/xbf folder. This happens automatically in Visual Studio if you add the custom build task 
as described in [Getting Started](/docs/getting-started).

If you don't use the Visual Studio support, you can instead compile your XAML from a command prompt by running markupcompiler.exe from the plugin's markupcompiler subfolder, then copy the .xbf files to the www/xbf folder.

Currently, XAML compilation is Windows-only, so if you do your development on a Mac, you'd need to generate the .xbf 
files on Windows and then copy them over to your Mac. Of course, the use of XAML is optional. Everything you declare in XAML 
can be expressed in JavaScript by instantiating the same objects and setting the same properties, which appear as set*PropertyName* methods.
