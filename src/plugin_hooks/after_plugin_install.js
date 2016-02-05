//-------------------------------------------------------------------------------------------------------
// Copyright (C) Microsoft. All rights reserved.
// Licensed under the MIT license. See LICENSE.txt file in the project root for full license information.
//-------------------------------------------------------------------------------------------------------
var path = require('path');
var fs = require('fs');

//
// The user's project should contain a native folder, which is a place
// for them to add native code and resources.
//
// This creates the folder, with ios and android subfolders.
//
// On Android, the (empty) subfolders demonstrate where code and assets
// need to go in order to be compiled into the final result.
//
// On iOS, the header file explains how to #import custom native code
// so it will get compiled into the final result. The Resources subfolder
// is where any .xib files should go.
//
function copyInitialFiles () {
    var fsextra = require('fs-extra');
    var projectFolder = path.join(__dirname, '../../../..');

    try {
        // Place initial native folders
        fsextra.ensureDirSync(path.join(projectFolder, "native/android/src"));
        fsextra.ensureDirSync(path.join(projectFolder, "native/android/res"));
        fsextra.ensureDirSync(path.join(projectFolder, "native/android/libs"));
        fsextra.ensureDirSync(path.join(projectFolder, "native/ios"));
        fsextra.ensureDirSync(path.join(projectFolder, "native/ios/resources"));

        // Place initial iOS header file
        var iosHeaderDestFile = path.join(projectFolder, 'native/ios/CustomCode.h');

        try {
            fsextra.accessSync(iosHeaderDestFile, fsextra.R_OK);
            // The file already exists, so do nothing
        }
        catch (ex1) {
            // The file must not exist, so copy it
            var iosHeaderSrcFile = path.join(projectFolder, 'plugins/cordova-plugin-ace/src/ios/build/CustomCode.h');
            fsextra.copySync(iosHeaderSrcFile, iosHeaderDestFile);
        }
    }
    catch (ex2) {
        // This is for convenience, so it's not a problem if it fails.
    }
}

module.exports = function (context) {
    // Install the plugin's dependencies (fs-extra, used by the function above),
    // because this doesn't happen automatically outside of Visual Studio.
    //
    // This is done by executing 'npm install' on dependencies mentioned in the
    // plugin's package.json.
    var Q = context.requireCordovaModule('q');
    var npm = context.requireCordovaModule('npm');

    var pkg = JSON.parse(fs.readFileSync(path.join(__dirname, '../../package.json'), 'utf-8'));

    // First check if the dependency required by this script, fs-extra,
    // is already installed.
    try {
        var stats1 = fs.statSync(path.join(__dirname, '../../../../node_modules/fs-extra/package.json'));
        var stats2 = fs.statSync(path.join(__dirname, '../../../../node_modules/xcode/package.json'));
        // fs-extra and xcode are already installed.
        // Just do the initial copy then exit, because attempting to install
        // it again can report (harmless) errors, such as when installing
        // multiple platforms simultaneously.
        copyInitialFiles();
        return;
    }
    catch (err) {
        // A dependency is not yet installed, so proceed.
    }

    // Load npm
    return Q.ninvoke(npm, 'load', {
        loaded: false
    }).then(function() {
        // Invoke npm install on each key@value
        return Q.ninvoke(npm.commands, 'install', Object.keys(pkg.dependencies).map(function(p) {
            return p + '@' + pkg.dependencies[p];
        }));
    }).then(function() {
        // Now that fs-extra is installed, we can do the copying
        copyInitialFiles();
    });
};
