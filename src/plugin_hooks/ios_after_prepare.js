//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
var path = require('path');
var fs = require('fs');

if (!String.prototype.endsWith) {
    String.prototype.endsWith = function (substring) {
        return (this.slice(substring.length * -1) == substring);
    };
}

function copyiOSResources() {
    var xcode = require('xcode');
    var fsextra = require('fs-extra');

    var hasResources = false;

	var iosAppResourcesFolder = null;
    try {
        iosAppResourcesFolder = path.join(__dirname, '../../../../native/ios/resources');
        var resources = fsextra.readdirSync(iosAppResourcesFolder);
        if (resources.length > 0) {
            hasResources = true;
        }
    }
    catch (error) {
        // The native/ios/resources folder doesn't exist
    }

    if (!hasResources) {
        // There are no custom resources, so there's nothing to do
        return;
    }

	var iosFolder = path.join(__dirname, '../../../../platforms/ios');

    // Find the path to the generated .xcodeproj folder
    var projectFolder = null;
    var items = fsextra.readdirSync(iosFolder);
    for (var i in items) {
        if (items[i].toLowerCase().endsWith(".xcodeproj")) {
            projectFolder = path.join(iosFolder, items[i]);
            break;
        }
    }

    if (projectFolder == null) {
        console.warn("Unable to find .xcodeproj");
        return;
    }

    // The folder with the code is next to the .xcodeproj folder, without the suffix
    var codeFolder = projectFolder.substring(0, projectFolder.length - ".xcodeproj".length);
    var targetResourcesFolder = path.join(codeFolder, "Resources");

    // Copy any resources to the Resources folder in the project
    fsextra.copySync(iosAppResourcesFolder, targetResourcesFolder);

    // Now edit the .pbxproj file inside the project folder
    var pbxFilePath = path.join(projectFolder, 'project.pbxproj');
    var project = new xcode.project(pbxFilePath);

    project.parse(function(error) {
       if (error) {
           console.warn("Unable to parse xcode project in order to add iOS resources:");
           console.warn(error);
       }
       else {
           // Add each custom resource
           var resources = fsextra.readdirSync(iosAppResourcesFolder);
           for (var i in resources) {
               project.addResourceFile(resources[i]);
           }

           // Replace the file
           fsextra.writeFileSync(pbxFilePath, project.writeSync());
       }
    });
}

module.exports = function (context) {
    // Make sure the dependencies are installed
    try {
        var stats1 = fs.statSync(path.join(__dirname, '../../../../node_modules/fs-extra/package.json'));
        var stats2 = fs.statSync(path.join(__dirname, '../../../../node_modules/xcode/package.json'));

        // We're good.
        copyiOSResources();
        return;
    }
    catch (err) {
        // A dependency is not yet installed, so proceed.
    }

    // Execute 'npm install' on dependencies mentioned in the plugin's package.json.
    var Q = context.requireCordovaModule('q');
    var npm = context.requireCordovaModule('npm');

    var pkg = JSON.parse(fs.readFileSync(path.join(__dirname, '../../package.json'), 'utf-8'));

    // Load npm
    return Q.ninvoke(npm, 'load', {
        loaded: false
    }).then(function() {
        // Invoke npm install on each key@value
        return Q.ninvoke(npm.commands, 'install', Object.keys(pkg.dependencies).map(function(p) {
            return p + '@' + pkg.dependencies[p];
        }));
    }).then(function() {
        // We're good.
        copyiOSResources();
    });
};
