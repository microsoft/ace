var path = require('path');
var fs = require('fs-extra');
var xcode = require('xcode');

if (!String.prototype.endsWith) {
    String.prototype.endsWith = function (substring) {
        return (this.slice(substring.length * -1) == substring);
    };
}

module.exports = function (context) {
    var hasResources = false;
    
	var iosAppResourcesFolder = null;
    try {
        iosAppResourcesFolder = path.join(__dirname, '../../../../native/ios/resources');
        var resources = fs.readdirSync(iosAppResourcesFolder);
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
    var items = fs.readdirSync(iosFolder);
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
    fs.copySync(iosAppResourcesFolder, targetResourcesFolder);

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
           var resources = fs.readdirSync(iosAppResourcesFolder);
           for (var i in resources) {
               project.addResourceFile(resources[i]);
           }

           // Replace the file
           fs.writeFileSync(pbxFilePath, project.writeSync());
       }
    });
};
